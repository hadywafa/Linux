#!/bin/bash

# Function to install necessary packages for Debian-based systems
install_debian_packages() {
    echo "Detected Debian-based system"
    apt update
    apt install -y zsh curl git net-tools iputils-ping
}

# Function to install necessary packages for Fedora-based systems
install_fedora_packages() {
    echo "Detected Fedora-based system"
    dnf update -y
    dnf install -y zsh curl git net-tools iputils
}

# Function to install Zsh and Oh My Zsh
install_zsh() {
    # Clean any existing installation
    rm -rf ~/.oh-my-zsh

    # Install Oh My Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Set the default shell to Zsh
    chsh -s $(which zsh)

    # Set Zsh theme to agnoster
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
}

# Function to install plugins
install_plugins() {
    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

    # Clean any existing plugins
    rm -rf $ZSH_CUSTOM/plugins/zsh-autosuggestions
    rm -rf $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    rm -rf $ZSH_CUSTOM/plugins/z

    # Install zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

    # Install zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

    # Install z
    git clone https://github.com/rupa/z.git $ZSH_CUSTOM/plugins/z

    # Add plugins to .zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)/' ~/.zshrc

    # Apply changes
    source ~/.zshrc
}

# Main function
main() {
    # Detect OS and install necessary packages
    if [ -f /etc/debian_version ]; then
        install_debian_packages
    elif [ -f /etc/fedora-release ]; then
        install_fedora_packages
    else
        echo "Unsupported OS"
        exit 1
    fi

    install_zsh
    install_plugins
    echo "Zsh setup complete. Please restart your terminal."
}

main
