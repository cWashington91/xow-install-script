#!/usr/bin/env bash

XOW_REPO = https://github.com/medusalix/xow

check_dependencies () {

}

clone_xow_repo () {
    git clone $XOW_REPO
}

build_xow () {
    sudo make install
    sudo systemctl enable xow
    sudo systemctl start xow
}

optional_reboot () {    
    read -p "Install complete, would you like to reboot now? y|n" reboot
    if [ $reboot == y ]; then
      shutdown -r -t 3
      echo "rebooting"
    elif [ $reboot == n ]; then
      break
    else
      echo "Please provide a valid response"
    fi
}