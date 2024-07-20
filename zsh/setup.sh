#!/bin/bash

# Function to install necessary packages
install_packages() {
    if [ -f /etc/debian_version ]; then
        echo "Detected Debian-based system"
        sudo apt update
        sudo apt install -y zsh curl git net-tools iputils-ping
    elif [ -f /etc/fedora-release ]; then
        echo "Detected Fedora-based system"
        sudo dnf update -y
        sudo dnf install -y zsh curl git net-tools iputils
    else
        echo "Unsupported OS"
        exit 1
    fi
}

# Function to install Zsh and Oh My Zsh for a specified user
install_zsh() {
    local user=$1

    # Install Oh My Zsh
    sudo -u $user sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Set the default shell to Zsh
    sudo chsh -s $(which zsh) $user

    # Set Zsh theme to agnoster
    sudo -u $user sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' /home/$user/.zshrc
}

# Function to install plugins for a specified user
install_plugins() {
    local user=$1
    local zsh_custom="/home/$user/.oh-my-zsh/custom"

    # Install zsh-autosuggestions
    sudo -u $user git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_custom/plugins/zsh-autosuggestions

    # Install zsh-syntax-highlighting
    sudo -u $user git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_custom/plugins/zsh-syntax-highlighting

    # Install z
    sudo -u $user git clone https://github.com/rupa/z.git $zsh_custom/plugins/z

    # Add plugins to .zshrc
    sudo -u $user sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)/' /home/$user/.zshrc

    # Apply changes
    sudo -u $user zsh -c "source /home/$user/.zshrc"
}

# Main function
main() {
    local user="ansible"

    install_packages
    install_zsh $user
    install_plugins $user
    echo "Zsh setup complete. Please restart your terminal."
}

main
