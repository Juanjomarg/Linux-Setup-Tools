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
	sudo apt update -y
	sudo apt upgrade -y
}

check_and_install_git()
{
    if command -v git &> /dev/null; then
        echo $'\n####\nGit is already installed. Updating...\n####\n '
        sudo apt update
        sudo apt upgrade -y git
	configure_git
    else
        echo $'\n####\nGit is not installed. Installing...\n####\n '
        sudo apt install -y git
	configure_git
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
    options=("Bash" "Zsh" "Fish" "Quit")

    select option in "${options[@]}"; do
        case $REPLY in
            1)
                shell_to_install="bash"
                break
                ;;
            2)
                shell_to_install="zsh"
                break
                ;;
            3)
                shell_to_install="fish"
                break
                ;;
            4)
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
	    sudo cp ./.zshrc ~/.zshrc
        else
            echo $'\n####\nInstalling selected shell\n####\n '
            sudo apt install -y "$shell_to_install"
            chsh -s "$(which $shell_to_install)"
	    sudo cp ./.zshrc ~/.zshrc
        fi
    fi
    pause_script
    echo $'\n##########################\nCLOSE THE TERMINAL\n##########################\n '
    exit_script
}


install_python_pip_ipython()
{
    echo $'\n####\nInstalling python3,pip and ipython...\n####\n '
    sudo apt install python3 python3-pip ipython3 -y
    install_pyenv
    echo $'\nCleaning up\n '
    pause_script
}

install_pyenv() {
    echo $'\n####\nInstalling pyenv...\n####\n '
    curl https://pyenv.run | $SHELL
    echo $'\nAttempting to add pyenv to PATH\n '
    add_pyenv_to_path
    echo $'\nAttempting to install build components\n '
    install_pyenv_build_components
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

    exec "$SHELL"
    pause_script
}

install_pyenv_build_components()
{
    echo $'\n####\nAttempting to install pyenv build components\n####\n '

    sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    pause_script
}

install_logiops()
{
    sudo apt install cmake libevdev-dev libudev-dev libconfig++-dev
    git clone https://github.com/PixlOne/logiops.git
    cd logiops
    mkdir build
    cd build
    cmake ..
    make
    sudo cp ./logid.cfg /etc/logid.cfg
}

install_flatpak()
{
    sudo apt install flatpak -y
    sudo apt install gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

menu()
{
    echo $'\n####\nMain Menu\n####\n '
    PS3=$'\nSelect an option from the menu: '

    items=(
"Update"
"Shell"
"Flatpak"
"GIT"
"Python and Pyenv"
"Logiops"
)

    while true; do
        select item in "${items[@]}" Quit
        do
            case $REPLY in
                1) echo "Selected #$REPLY: $item";update_linux_packages; break;;
                2) echo "Selected #$REPLY: $item";pick_and_customize_shell; break;;
                2) echo "Selected #$REPLY: $item";install_flatpak; break;;
                3) echo "Selected #$REPLY: $item";check_and_install_git; break;;
                4) echo "Selected #$REPLY: $item";install_python_pip_ipython; break;;
		5) echo "Selected #$REPLY: $item";install_logiops;break;;
                $((${#items[@]}+1))) echo $'\nYou have decided to exit the script!!!, Good Bye\n '; break 2;;
                *) echo "Ooops - unknown choice $REPLY"; break;
            esac
        done
    done
}

menu
