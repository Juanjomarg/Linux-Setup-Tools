#!/bin/bash

exit_script()
{
    exit
}

pause_script()
{
    read -p 'Press enter to exit terminal...'
}

update_linux_packages()
{
    echo $'\n####\nUpdating linux packages...\n####\n '
    echo $'\nUpdating apt-get\n '
    sudo apt-get update -y && sudo apt-get upgrade -y
    echo $'\nUpdating apt\n '
    sudo apt update -y && sudo apt upgrade -y
    echo $'\nCleaning up\n '
    pause_script
}

install_curl()
{
    echo $'\n####\nInstalling Curl utility\n####\n '
    sudo apt install curl -y
    echo $'\nCleaning up\n '
    pause_script
}

install_wget()
{
    echo $'\n####\nInstalling Wget utility\n####\n '
    sudo apt-get install wget -y
    echo $'\nCleaning up\n '
    pause_script
}

install_unzip()
{
    echo $'\n####\nInstalling Zip utility\n####\n '
    sudo apt-get install unzip -y
    echo $'\nCleaning up\n '
    pause_script
}

install_xclip()
{
    echo $'\n####\nInstalling Xclip utility\n####\n '
    sudo apt-get install xclip -y
    echo $'\nCleaning up\n '
    pause_script
}

install_screenfetch()
{
    echo $'\n####\nInstalling Screenfetch utility\n####\n '
    sudo apt-get install screenfetch -y
    echo $'\nCleaning up\n '
    pause_script
}

remove_git()
{
    echo $'\n####\nRemoving old version of git\n####\n '
    sudo apt remove git -y || sudo apt autoremove -y
    echo $'\nCleaning up\n '
    pause_script
}

add_git()
{
    echo $'\n####\nInstalling git\n####\n '
    echo $'\nAdding repository\n '
    sudo add-apt-repository ppa:git-core/ppa -y
    echo $'\nInstalling git\n '
    sudo apt-get install git -y
    echo $'\nGetting git version\n '
    git --version
    echo $'\nCleaning up\n '
    pause_script
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
    cat < ~/.ssh/id_ed25519.pub && xclip

    echo $'\nCleaning up\n '
    pause_script
}

install_zsh()
{
    echo $'\n####\nInstalling SZH...\n####\n '
    echo $'\nAttempting to install zsh\n '
    sudo apt install zsh -y
    echo $'\nChanging shell\n '
    chsh -s $(which zsh)
    echo $'\nCleaning up\n '
    pause_script
    echo $'\n##########################\nCLOSE THE TERMINAL\n##########################\n '
    exit_script
}

install_oh_my_zsh()
{
    echo $'\n####\nInstalling Ohmyszh...\n####\n '
    echo $'\nObtaining script\n '
    sh -c  "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y
    echo $'\nUpdating .zshrc\n '
    source ~/.zshrc
    echo $'\nCleaning up\n '
    pause_script
    echo $'\n##########################\nCLOSE THE TERMINAL\n##########################\n '
    exit_script
}

clone_fonts()
{
    echo $'\nCreating folder on ~/Powerlevel10kfonts\n '
    mkdir ~/Powerlevel10kfonts
    echo $'\n####\nCloning font 4: Bold Italic\n####\n '
    wget -P ~/Powerlevel10kfonts https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Bold%20Italic.ttf
    echo $'\n####\nCloning font 4: Bold\n####\n '
    wget -P ~/Powerlevel10kfonts https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Bold.ttf
    echo $'\n####\nCloning font 4: Italic\n####\n '
    wget -P ~/Powerlevel10kfonts https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Italic.ttf
    echo $'\n####\nCloning font 4: Regular\n####\n '
    wget -P ~/Powerlevel10kfonts https://github.com/Juanjomarg/setup/raw/main/fonts/MesloLGS%20NF%20Regular.ttf
}

install_powerlevel_10k()
{
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

install_python_pip_ipython()
{
    echo $'\n####\nInstalling python3,pip and ipython...\n####\n '
    sudo apt install python3 python3-pip ipython3 -y
    echo $'\nCleaning up\n '
    pause_script
}

install_pyenv()
{
    echo $'\n####\nInstalling pyenv...\n####\n '
    curl https://pyenv.run | zsh
    echo $'\nAttempting to add pyenv to PATH\n '
    add_pyenv_to_path
    echo $'\nCleaning up\n '
    pause_script
    exit_script
}

add_pyenv_to_path()
{
    echo $'\n####\nAdding pyenv to PATH...\n####\n '
    echo '#Added pyenv to PATH' >> ~/.zshrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    echo $'\nUpdating .zshrc\n '
    source ~/.zshrc
    echo $'\nAttempting to install build components\n '
    install_pyenv_build_components
    echo $'\nCleaning up\n '
    exec "$SHELL"
    pause_script
}

install_pyenv_build_components()
{
    echo $'\n####\nAttempting to install pyenv build components\n####\n '
    sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    echo $'\nCleaning up\n '
    pause_script
}

install_ssh_server()
{
    echo $'\n####\nInstalling SSH server\n####\n '
    sudo apt-get install openssh-server -y
    echo $'\nCleaning up\n '
    pause_script
}

basic_commands()
{
    echo $'\n####\nBasic commands\n####\n '
    install_curl
    install_wget
    install_unzip
    install_screenfetch
    echo $'\n '
    screenfetch
    pause_script
}

menu()
{
    echo $'\n####\nMain Menu\n####\n '
    PS3=$'\nSelect an option from the menu: '

    items=(
"Update Linux"
"Basic utils"
"remove Git"
"update Git"
"configure Git"
"Install Zsh"
"Install OhMySzh"
"Install Powerlevel10k"
"Install Python"
"Install Pyenv"
"SSH")

    while true; do
        select item in "${items[@]}" Quit
        do
            case $REPLY in
                1) echo "Selected #$REPLY: $item";update_linux_packages; break;;
                2) echo "Selected #$REPLY: $item";basic_commands; break;;
                3) echo "Selected #$REPLY: $item";remove_git; break;;
                4) echo "Selected #$REPLY: $item";add_git; break;;
                5) echo "Selected #$REPLY: $item";configure_git; break;;
                6) echo "Selected #$REPLY: $item";install_zsh; break;;
                7) echo "Selected #$REPLY: $item";install_oh_my_zsh; break;;
                8) echo "Selected #$REPLY: $item";install_powerlevel_10k; break;;
                9) echo "Selected #$REPLY: $item";install_python_pip_ipython; break;;
                10) echo "Selected #$REPLY: $item";install_pyenv; break;;
                10) echo "Selected #$REPLY: $item";install_ssh_server; break;;
                $((${#items[@]}+1))) echo $'\nYou have decided to exit the script!!!, Good Bye\n '; break 2;;
                *) echo "Ooops - unknown choice $REPLY"; break;
            esac
        done
    done
}

menu
