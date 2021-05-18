#!/usr/bin/env bash

XOW_REPO = https://github.com/medusalix/xow

if grep -qs "ubuntu" /etc/os-release; then
    os="ubuntu"
elif [[ -e /etc/os_release ]]; then
	os="pop"
elif [[ -e /etc/debian_version ]]; then
	os="debian"
else [[ -e /etc/fedora-release ]]; then
	os="fedora"
fi

check_kernel () {
    if [[ $(uname -r | cut -d "." -f 1) -lt 4 ]]; then
        echo "Kernel 4.5 or higher is needed to install xow"
    else
        continue
    fi
}

check_systemd () {
    if [[ (systemd --version | cut -d " " -f 2) -lt 232]]; then
        echo "Systemd version 232 or higher is needed to install xow"
    fi
}

check_curl () {
    if [[ $os == "ubuntu" || $os == "pop" || $os == "debian" ]]; then
        dpkg --list | grep -s curl
        if [[ -e curl ]]; then
            continue
        else
            echo "curl is not installed. Installing..."
            sudo apt update && sudo apt upgrade
            sudo apt install -y curl
    fi
}

check_cabextract () {
    if [[ $os == "ubuntu" || $os == "pop" || $os == "debian" ]]; then
        dpkg --list | grep -s cabextract
        if [[ -e cabextract ]]; then
            continue
        else
            echo "cabextract is not installed. Installing..."
            sudo apt update && sudo apt upgrade
            sudo apt install -y cabextract
    fi
}

check_libusb () {
    if [[ $os == "ubuntu" || $os == "pop" || $os == "debian" ]]; then
        dpkg --list | grep -s libusb
        if [[ -e libusb ]]; then
            continue
        else
            echo "libusb is not installed. Installing..."
            sudo apt update && sudo apt upgrade
            sudo apt install -y libusb-1.0-0-dev
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
        break
    else
        echo "Please provide a valid response"
    fi
}