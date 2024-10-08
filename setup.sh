a#!/bin/bash
clear

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 ____       _               
/ ___|  ___| |_ _   _ _ __  
\___ \ / _ \ __| | | | '_ \ 
 ___) |  __/ |_| |_| | |_) |
|____/ \___|\__|\__,_| .__/ 
                     |_|    

EOF
echo "for ML4W Hyprland Settings App"
echo
echo -e "${NONE}"

echo "This script will download the ML4W Hyprland Settings App and start the installation."
echo
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
            echo
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Change into your Downloads directory
cd ~/Downloads

# Remove existing folder
if [ -d ml4w-hyprland-settings ] ;then
    rm -rf ml4w-hyprland-settings
fi

if [ -d hyprland-settings ] ;then
    rm -rf hyprland-settings
fi

# Clone the packages
git clone --depth 1 https://github.com/Player6734/hyprland-settings-fedora.git

# Change into the folder
cd hyprland-settings-fedora

# Start the script
./install.sh
