#!/bin/bash
SYSINFO=$(uname -a)
PKG="optimus-manager"
# APICALL = "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=optimus-manager"
APICALL="https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=$PKG"
# TESTAP=$(curl -s "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=optimus-manager")

# PKG="chromium"



function ChooseGPU()
{
    echo "What GPU you wanna use?"
    select ynm in "Nvidia" "Integrated" "Hybrid"; do
    case $ynm in
        Nvidia ) OPTMODE="nvidia";;
        Integrated ) OPTMODE="integrated";;
        Hybrid ) OPTMODE="hybrid";;
    esac
    done
}

function CheckPackageUpdate() 
{
    LATEST_PKG_VERSION = $APICALL | grep -o '"Version":"[^"]*' | grep -o '[^"]*$'
}

function CheckPackageInstalled() # Check out if package is installed
{
    if pacman -Qi $PKG &>/dev/null; then 
        CheckPackageUpdate
        ChooseGPU
    else
        while true; do
        read -p "It seems you do not have $PKG installed, would you like to install it? (Y/n)" yn
        case $yn in
            [Yy]* ) echo "OK"; yay $PKG; break;;
            [Nn]* ) echo "NOP"; exit;;
            * ) echo "Please answer yes or no.";;
        esac
        done
    fi
}

function CheckUserDistribution() # Check if you are under Arch
{
    shopt -s nocasematch
    if [[ "$SYSINFO" != *"arch"* ]]; then 
        echo "This script is compatible only with Arch-based distro and seems that you're not under it!"
        exit 0
    else
        echo "You're under arch"
        CheckPackageInstalled
    fi
}



CheckUserDistribution


######

# curl -s "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=optimus-manager"



echo "Finished"

