#!/usr/bin/env bash

XOW_REPO=https://github.com/medusalix/xow.git

if grep -qs "ubuntu" /etc/os-release; then
    os="ubuntu"
elif [[ -e /etc/os-release ]]; then
	os="pop"
elif [[ -e /etc/debian_version ]]; then
	os="debian"
elif [[ -e /etc/fedora-release ]]; then
	os="fedora"
elif [[ -e /etc/os-release ]]; then
	os="arch"
else [[ -e /etc/os-release ]];
	os="manjaro"
fi

# check_kernel () {
#     if [[ $(uname -r | cut -d "." -f 1) -lt 4 ]]; then
#         echo "Kernel 4.5 or higher is needed to install xow"
#     else
#         continue
#     fi
# }

# check_systemd () {
#     if [[ (systemd --version | cut -d " " -f 2) -lt 232 ]]; then
#         echo "Systemd version 232 or higher is needed to install xow"
#     fi
# }

install_prereqs () {
    if [[ $os == "ubuntu" || $os == "pop" || $os == "debian" ]]; then
        sudo apt update && sudo apt -y install build-essential curl cabextract libusb-1.0-0-dev
    elif [[ $os == "fedora" ]]; then
        sudo dnf install -y make automake gcc gcc-c++ kernel-devel curl cabextract libusb-devel
    else [[ $os == "manjaro" || $os == "arch" ]];
        sudo pacman -S --noconfirm make curl cabextract libusb-devel
    fi
}

clone_xow () {
    git clone $XOW_REPO
}

build_xow () {
    cd xow
    make BUILD=RELEASE
}

install_xow () {
    sudo make install
    sudo systemctl enable xow
    sudo systemctl start xow
}

optional_reboot () {    
    read -p "Install complete, would you like to reboot now? y|n" reboot
    if [[ $reboot == y ]]; then
        shutdown -r now
    elif [[ $reboot == n ]]; then
        exit 0
    else
        echo "Please provide a valid response"
    fi
}

# check_kernel
# check_systemd
install_prereqs
clone_xow
build_xow
install_xow
optional_reboot