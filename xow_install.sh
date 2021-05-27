#!/usr/bin/env bash

XOW_REPO=https://github.com/medusalix/xow.git

if grep -qs "ubuntu" /etc/os-release; then
    os="ubuntu"
elif [[ -e /etc/os_release ]]; then
	os="pop"
elif [[ -e /etc/os-release ]]; then
	os="solus"
elif [[ -e /etc/debian_version ]]; then
	os="debian"
else [[ -e /etc/fedora-release ]];
	os="fedora"
fi

install_prereqs () {
    if [[ $os == "ubuntu" || $os == "pop" || $os == "debian" ]]; then
        sudo apt update && sudo apt -y install build-essential curl cabextract libusb-1.0-0-dev
    elif [[ $os == "solus" ]]; then
        sudo eopkg install -y -c system.devel curl cabextract libusb-compat-devel
    else [[ $os == "fedora" ]];
        sudo dnf install -y make automake gcc gcc-c++ kernel-devel curl cabextract libusb-devel
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
    read -p "Install complete, would you like to reboot now? (yes|no)" reboot
    if [[ $reboot == yes ]]; then
        shutdown -r now
    elif [[ $reboot == no ]]; then
        exit 0
    else
        echo "Please provide a valid response"
    fi
}

install_prereqs
clone_xow
build_xow
install_xow
optional_reboot

