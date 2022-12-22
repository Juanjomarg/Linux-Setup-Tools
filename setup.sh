#!/bin/bash

salir()
{
    exec "$exit"
}

actualizar()
{
    echo '#Se actualiza'
    sudo apt-get update -y && sudo apt-get upgrade -y
    sudo apt update -y && sudo apt upgrade -y
}

instalar_aptitude_package_manager(){
    echo '#Se instala aptitude'
    sudo apt install aptitude
}

actualizar_git()
{
    echo '#Se actualiza git'
    sudo apt remove git -y
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get install git -y
    git --version
}

configurar_git(){
    echo '#Se configura git'
    git config --global user.name "Juanjomarg"
    echo '#Se configura el siguiente usuario como usuario de git:'
    git config --global user.name
    
    git config --global user.email "juanj.martinezg96@gmail.com"
    echo '#Se configura el siguiente correo como correo de git:'
    git config --global user.email

    echo '#Se crea una llave SSH para GitHub'
    ssh-keygen -t ed25519 -C "juanj.martinezg96@gmail.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo '############# Copie la siguiente clave y péguela en GitHub #############'
    cat < ~/.ssh/id_ed25519.pub
}

instalar_curl()
{
    echo '#Se instala CURL'
    sudo apt install curl
}

instalar_zsh()
{
    echo '#Se instala zsh'
    sudo apt install zsh -y
    chsh -s $(which zsh)
    salir
}

instalar_oh_my_zsh()
{
    echo '#Se instala oh my zsh'
    sh -c  "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y
    source ~/.zshrc
    salir
}

instalar_powerlevel_10k()
{
    echo '#Se instala powerlevel 10k'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i -e 's,ZSH_THEME="robbyrussell",ZSH_THEME="powerlevel10k/powerlevel10k",g' ~/.zshrc
    source ~/.zshrc
    exec "$SHELL"
    #p10k configure
}

instalar_screenfetch()
{
    echo '#Se instala Screenfetch'
    sudo apt-get install screenfetch -y
}

instalar_python_pip_ipython()
{
    echo '#Se instala pip'
    sudo apt install python3 python3-pip ipython3 -y
}

instalar_pyenv()
{
    echo '#Se instala pyenv'
    curl https://pyenv.run | zsh
    salir
}

anadir_pyenv_a_path()
{
    echo '#Añade pyenv a PATH'    
    echo '#Se añade pyenv a PATH' >> ~/.zshrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    instalar_pyenv_build_components
    source ~/.zshrc
    exec "$SHELL"
    
}

instalar_pyenv_build_components()
{
    echo '#Se instala pyenv build components'
    sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
}

instalar_ssh_server()
{
    echo '#Se instala SSH server'
    sudo apt-get install openssh-server -y
}

comandos_basicos()
{
    echo '#Se usan comandos básicos'
    actualizar
    instalar_curl
    instalar_screenfetch
    source ~/.bashrc
}

git()
{
    actualizar_git
    configurar_git
}

comandos_basicos
#git
#instalar_zsh
#instalar_oh_my_zsh
#instalar_powerlevel_10k
#instalar_pyenv
#anadir_pyenv_a_path
