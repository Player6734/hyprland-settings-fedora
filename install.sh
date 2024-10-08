#!/bin/bash
clear

# Check if package is installed
_isInstalledDNF() {
    package="$1";
    check="$(sudo dnf list installed "${package}" 2>/dev/null | grep "${package} ")"; # Prevent error output if package is not found
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Install required packages
_installPackagesDNF() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledDNF "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;

        # Special case for 'gum', add Charm repo and install gum if not found
        if [[ "${pkg}" == "gum" ]]; then
            echo "gum is not installed. Adding Charm repository..."
            echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
            sudo rpm --import https://repo.charm.sh/yum/gpg.key
            sudo dnf install gum -y
            continue;
        fi

        toInstall+=("${pkg}");
    done;
    
    if [[ "${toInstall[@]}" == "" ]] ; then
        return;
    fi;

    printf "Installing packages:\n%s\n" "${toInstall[@]}";
    sudo dnf install "${toInstall[@]}" -y;
}

# Required packages for the installer
packages=(
    "wget"
    "unzip"
    "gum"
    "jq"
    "fuse" 
    "gtk4" 
    "libadwaita" 
    "python3"
    "python-gobject"

)

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 ___           _        _ _           
|_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 | || '_ \/ __| __/ _` | | |/ _ \ '__|
 | || | | \__ \ || (_| | | |  __/ |   
|___|_| |_|___/\__\__,_|_|_|\___|_|   
                                      
EOF
echo "for ML4W Hyprland Settings App"
echo
echo -e "${NONE}"
echo "This script will support you to download and install the ML4W Hyprland Settings App."
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

# Synchronizing package databases
sudo dnf refresh
echo

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackagesPacman "${packages[@]}";
echo

# Decide on installation directory
echo ":: Installation started"
if [ ! -d $HOME/.local/share/applications/ ] ;then
    mkdir -p $HOME/.local/share/applications/
    echo ":: $HOME/.local/share/applications/ created"
fi
if [ ! -d ~/apps ] ;then
    mkdir ~/apps
    echo ":: apps folder created in $HOME"
fi
cp release/ML4W_Hyprland_Settings-x86_64.AppImage ~/apps
cp icon.png ~/.local/share/applications/ml4w-hyprland-settings.png
cp ml4w-hyprland-settings.desktop ~/.local/share/applications

APPIMAGE="$HOME/apps/ML4W_Hyprland_Settings-x86_64.AppImage"
ICON="$HOME/.local/share/applications/ml4w-hyprland-settings.png"
sed -i "s|HOME|${APPIMAGE}|g" $HOME/.local/share/applications/ml4w-hyprland-settings.desktop
sed -i "s|icon|${ICON}|g" $HOME/.local/share/applications/ml4w-hyprland-settings.desktop
echo ":: Desktop file and icon installed successfully in ~/.local/share/applications"

echo 
echo "DONE!" 
echo "Please add the following command to your hyprland.conf of you want to restore the changes after logging in."
echo "exec-once = ~/.config/ml4w-hyprland-settings/hyprctl.sh"
echo 
echo "You can start the app from your application launcher or with the terminal from the folder apps with:"
echo "./ML4W_Hyprland_Settings-x86_64.AppImage"
