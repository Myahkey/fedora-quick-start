#!/bin/bash
source vars.sh;

pwdless_sudo () {
    echo -e "\n$USER ALL = (ALL) NOPASSWD: ALL\n" | sudo tee -a /etc/sudoers
}

import_repos () {
    echo "Installing dependencies...";
    sudo dnf -y install dnf-plugins-core distribution-gpg-keys;
    echo "Installing repositories...";
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm";
    sudo dnf config-manager --enable fedora-cisco-openh264;
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc;
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo';
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo dnf copr enable emanuelec/k9s;
    sudo dnf copr enable taw/joplin;
    sudo dnf copr enable zhullyb/v2rayA;
    sudo dnf copr enable atim/lazygit;
    sudo dnf check-update;
}

configure_flatpak () {
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo;
}

install_dnf_packages () {
    sudo dnf update -y;
    sudo dnf install -y $packages;
    sudo dnf install -y $docker_packages;
    sudo dnf install -y $gnome_shell_packages;
}

install_flatpak_packages () {
    flatpak install -y --noninteractive flathub $flatpak_flathub_packages;
}

configure_docker () {
    sudo systemctl enable --now docker;
    sudo groupadd docker;
    sudo usermod -aG docker $USER;
}

configure_v2ray () {
    sudo systemctl enable --now v2raya.service;
}

configure_git () {
    git config --global user.name "Nikita Lomaev";
    git config --global user.email "nikita.lomaev@rktv.ru"
}

install_nccm () {
    git clone https://github.com/flyingrhinonz/nccm nccm.git;
    cd nccm.git/nccm/ || return;
    sudo install -m 755 nccm -t /usr/local/bin/;
}

install_python_packages () {
    pip3 install --user $python_packages;
}

zsh_4_humans () {
    if command -v curl >/dev/null 2>&1; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    else
        sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
    fi
}
