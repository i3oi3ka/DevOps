#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

. /etc/os-release

echo "System: $PRETTY_NAME"

# Docker

install_docker() {
    if command -v docker &> /dev/null; then
        echo "Docker is already installed. Skipping installation."
        return
    fi

    echo "Installing Docker..."
    apt-get update -qq
    apt-get install -qq -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/${ID}/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${ID} \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -qq
    apt-get install -qq -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Docker installation completed."
}

# docker-compose

install_docker_compose() {
    if command -v docker compose &> /dev/null; then
        echo "Docker Compose is already installed. Skipping installation."
        return
    fi

    echo "Installing Docker Compose..."
    apt-get update -qq
    apt-get install -qq -y docker-compose-plugin

    echo "Docker Compose installation completed."
}   

# python3

install_python3() {
    if command -v python3 &> /dev/null; then
        echo "Python 3 is already installed. Skipping installation."
        if ! python3 -m pip --version &> /dev/null; then
            echo "pip is not installed. Installing pip..."
            apt-get update -qq
            apt-get install -qq -y python3-pip
            echo "pip installation completed."
        fi
        return
    fi

    echo "Installing Python 3..."
    apt-get update -qq
    apt-get install -qq -y python3 python3-pip python3-venv pip

    echo "Python 3 installation completed."
}

# django

install_django() {
    if python3 -m django --version &> /dev/null; then
        echo "Django is already installed. Skipping installation."
        return
    fi

    echo "Installing Django..."
    python3 -m pip install django --break-system-packages

    echo "Django installation completed."
}

main() {
    install_docker
    install_docker_compose
    install_python3
    install_django

    echo "All development tools have been installed successfully."

    echo "Installed versions:"
    docker --version
    docker compose version
    python3 --version
    echo "django-admin version: $(django-admin --version)"

}

main