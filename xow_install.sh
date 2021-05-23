#!/usr/bin/env bash

XOW_REPO=https://github.com/medusalix/xow.git

if grep -qs "ubuntu" /etc/os-release; then
    os="ubuntu"
elif [[ -e /etc/os_release ]]; then
	os="pop"
else [[ -e /etc/debian_version ]]; then
	os="debian"
fi

install_prereqs () {
    if [[ $os == "ubuntu" || $os == "pop" || $os == "debian" ]]; then
        sudo apt update && sudo apt -y install build-essential curl cabextract libusb-1.0-0-dev
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

install_prereqs
clone_xow
build_xow
install_xow
optional_reboot