#!/bin/bash

exit_script()
{
    exit
}

pause_script()
{
    read -p 'Press enter...'
}

install_curl_and_wget() {
    echo $'\n####\nChecking and installing curl and wget...\n####\n '

    # Check if curl is installed
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Installing..."
        sudo apt install curl -y
    else
        echo "curl is already installed."
    fi

    # Check if wget is installed
    if ! command -v wget &> /dev/null; then
        echo "wget is not installed. Installing..."
        sudo apt install wget -y
    else
        echo "wget is already installed."
    fi
}

update_linux_packages()
{
    echo $'\n####\nUpdating Linux Packages\n####\n '
    install_curl_and_wget
    PS3=$'\nChoose package manager for update: '
    options=("Update using apt" "Update using apt-get" "Quit")

    select option in "${options[@]}"; do
        case $REPLY in
            1)
                echo $'\nUpdating with apt\n '
                sudo apt update -y
                sudo apt upgrade -y
                break
                ;;
            2)
                echo $'\nUpdating with apt-get\n '
                sudo apt-get update -y
                sudo apt-get upgrade -y
                break
                ;;
            3)
		echo $'\n##########################\nDid not perform any updates or upgrades\n##########################\n '
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

check_and_add_git_ppa()
{
    if ! grep -q "^deb .*git-core/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        echo $'\n####\nAdding Git PPA\n####\n '
        sudo add-apt-repository ppa:git-core/ppa
        sudo apt update
    else
        echo $'\n####\nGit PPA is already added\n####\n '
    fi
}

check_and_install_git()
{
    check_and_add_git_ppa

    if command -v git &> /dev/null; then
        echo $'\n####\nGit is already installed. Updating...\n####\n '
        sudo apt update
        sudo apt upgrade -y git
    else
        echo $'\n####\nGit is not installed. Installing...\n####\n '
        sudo apt install -y git
    fi
}

configure_git()
{
    echo $'\n####\nConfiguring git\n####\n '

    read -p "Provide Git username: " gitusername
    git config --global user.name $gitusername
    echo $'git username set: -> ' $gitusername
    echo $""

    read -p "Provide Git email: " gitemail
    git config --global user.email $gitemail
    echo $'git email set: -----> ' $gitemail
    echo $""

    echo $'\nCreating SSH Key\n '
    ssh-keygen -t ed25519 -C $gitemail
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo $'\n############# Copy and paste the following text onto the ssh textbox on github #############'
    cat < ~/.ssh/id_ed25519.pub

    echo $'\nCleaning up\n '
    pause_script
}

pick_and_customize_shell() {
    echo $'\n####\nShell Picker\n####\n '

    PS3=$'\nChoose a shell or customization option: '
    options=("Bash" "Customize Bash" "Zsh" "Customize Zsh" "Fish" "Customize Fish" "Quit")

    select option in "${options[@]}"; do
        case $REPLY in
            1)
                shell_to_install="bash"
                break
                ;;
            2)
                submenu_bash_customization
                break
                ;;
            3)
                shell_to_install="zsh"
                break
                ;;
            4)
                submenu_zsh_customization
                break
                ;;
            5)
                shell_to_install="fish"
                break
                ;;
            6)
                submenu_fish_customization
                break
                ;;
            7)
                echo $'\nExiting shell picker\n'
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done

    if [ "$shell_to_install" != "" ]; then
        if command -v "$shell_to_install" &> /dev/null; then
            echo $'\n####\nSetting up default shell\n####\n '
            chsh -s "$(which $shell_to_install)"
        else
            echo $'\n####\nInstalling selected shell\n####\n '
            sudo apt install -y "$shell_to_install"
            chsh -s "$(which $shell_to_install)"
        fi
    fi
    pause_script
    echo $'\n##########################\nCLOSE THE TERMINAL\n##########################\n '
    exit_script
}

submenu_bash_customization() {
    echo $'\n####\nBash Customization Submenu\n####\n '

    PS3=$'\nChoose an option for Bash customization: '
    bash_submenu_options=("Install Powerline for Bash" "Quit")

    select bash_submenu_option in "${bash_submenu_options[@]}"; do
        case $REPLY in
            1)
                echo $'\n####\nInstalling Powerline for Bash\n####\n '
                sudo apt install -y powerline
                # Add any additional customization steps for Powerline here
                echo $'\nCleaning up\n '
                pause_script
                break
                ;;
            2)
                echo $'\nExiting Bash customization submenu\n'
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

submenu_zsh_customization() {
    echo $'\n####\nZsh Submenu\n####\n '

    PS3=$'\nChoose an option for Zsh: '
    submenu_options=("Install Oh My Zsh" "Install PowerLevel 10K" "Install Both" "Quit")

    select submenu_option in "${submenu_options[@]}"; do
        case $REPLY in
            1)
                echo $'\n####\nInstalling Oh My Zsh\n####\n '
		install_zsh
                echo $'\nCleaning up'
                pause_script
                break
                ;;
            2)
                echo $'\n####\nInstalling Powerlevel 10k\n####\n '
		install_powerlevel_10k
                echo $'\nCleaning up'
                pause_script
                break
                ;;
            3)
                echo $'\n####\nInstalling Oh My Zsh and PowerShell\n####\n '
		install_zsh
		install_powerlevel_10k
                echo $'\nCleaning up'
                pause_script
                break
                ;;
            4)
                echo $'\nExiting Zsh submenu\n'
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

install_zsh()
{
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y
	source ~/.zshrc
}

install_powerlevel_10k()
{
        echo $'\n####\nInstalling Power Level 10k\n####\n '
	current=$(pwd)
	power_fonts=~/Powerlevel10kfonts
	echo $'\n####\nInstalling powerlevel 10k...\n####\n '
	echo $'\nCloning fonts\n '
	clone_fonts
	echo $'\nPlease install all fonts from the folder about to open\n '
	pause_script
	cd $power_fonts
	explorer.exe .
	cd $current
	pause_script
	echo $'\nGetting repo\n '
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	echo $'\nAdding to ~/.zshrc\n '
	sed -i -e 's,ZSH_THEME="robbyrussell",ZSH_THEME="powerlevel10k/powerlevel10k",g' ~/.zshrc
	echo $'\nUpdating .zshrc\n '
	source ~/.zshrc
	echo $'\nCleaning up\n '
	rm -rf $power_fonts
	exec "$SHELL"
	pause_script
	echo $'\n##########################\nCLOSE THE TERMINAL\n##########################\n '
	exit_script
	#p10k configure
}

clone_fonts() {
    echo $'\nCreating folder on ~/Powerlevel10kfonts\n '
    mkdir -p ~/Powerlevel10kfonts

    fonts=(
        "Bold Italic: https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Bold%20Italic.ttf"
        "Bold: https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Bold.ttf"
        "Italic: https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Italic.ttf"
        "Regular: https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Regular.ttf"
    )

    for font in "${fonts[@]}"; do
        IFS=":" read -r font_name font_url <<< "$font"
        echo $'\n####\nCloning font: '"$font_name"$'\n####\n '
        wget -P ~/Powerlevel10kfonts "$font_url"
    done
}

submenu_fish_customization() {
    echo $'\n####\nFish Customization Submenu\n####\n '

    PS3=$'\nChoose an option for Fish customization: '
    fish_submenu_options=("Install Oh My Fish" "Quit")

    select fish_submenu_option in "${fish_submenu_options[@]}"; do
        case $REPLY in
            1)
                echo $'\n####\nInstalling Oh My Fish\n####\n '
                curl -L https://get.oh-my.fish | fish
                # Add any additional customization steps for Oh My Fish here
                echo $'\nCleaning up\n '
                pause_script
                break
                ;;
            2)
                echo $'\nExiting Fish customization submenu\n'
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

install_python_pip_ipython()
{
    echo $'\n####\nInstalling python3,pip and ipython...\n####\n '
    sudo apt install python3 python3-pip ipython3 -y
    echo $'\nCleaning up\n '
    pause_script
}

install_pyenv() {
    echo $'\n####\nInstalling pyenv...\n####\n '
    curl https://pyenv.run | $SHELL
    echo $'\nAttempting to add pyenv to PATH\n '
    add_pyenv_to_path
    echo $'\nCleaning up\n '
    pause_script
    exit_script
}

add_pyenv_to_path() {
    echo $'\n####\nAdding pyenv to PATH...\n####\n '

    PYENV_INIT_SCRIPT='eval (pyenv init --path)'

    if [ -n "$BASH_VERSION" ]; then
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
	echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(pyenv init -)"' >> ~/.bashrc
        echo $'\nUpdating .bashrc\n '
        source ~/.bashrc
    elif [ -n "$ZSH_VERSION" ]; then
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
	echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
	echo 'eval "$(pyenv init -)"' >> ~/.zshrc
        echo $'\nUpdating .zshrc\n '
        source ~/.zshrc
    elif command -v fish &> /dev/null; then
	set -Ux PYENV_ROOT $HOME/.pyenv
	fish_add_path $PYENV_ROOT/bin
        echo $'\nUpdating config.fish\n '
        source ~/.config/fish/config.fish
    else
        echo "Unsupported shell. Please add the following lines to your shell configuration manually:"
        echo 'export PYENV_ROOT="$HOME/.pyenv"'
        echo 'export PATH="$PYENV_ROOT/bin:$PATH"'
        echo "$PYENV_INIT_SCRIPT"
    fi

    echo $'\nAttempting to install build components\n '
    install_pyenv_build_components
    echo $'\nCleaning up\n '
    exec "$SHELL"
    pause_script
}

install_pyenv_build_components()
{
    echo $'\n####\nAttempting to install pyenv build components\n####\n '

    sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    echo $'\nCleaning up\n '
    pause_script
}

menu()
{
    echo $'\n####\nMain Menu\n####\n '
    PS3=$'\nSelect an option from the menu: '

    items=(
"Update Linux"
"Install or update Git"
"Configure Git"
"Select or Customize shell"
"Install Python"
"Install Pyenv"
)

    while true; do
        select item in "${items[@]}" Quit
        do
            case $REPLY in
                1) echo "Selected #$REPLY: $item";update_linux_packages; break;;
                2) echo "Selected #$REPLY: $item";check_and_install_git; break;;
                3) echo "Selected #$REPLY: $item";configure_git; break;;
                4) echo "Selected #$REPLY: $item";pick_and_customize_shell; break;;
                5) echo "Selected #$REPLY: $item";install_python_pip_ipython; break;;
                6) echo "Selected #$REPLY: $item";install_pyenv; break;;
                $((${#items[@]}+1))) echo $'\nYou have decided to exit the script!!!, Good Bye\n '; break 2;;
                *) echo "Ooops - unknown choice $REPLY"; break;
            esac
        done
    done
}

menu
