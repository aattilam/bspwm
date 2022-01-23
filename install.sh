#!/bin/bash


mkdir workdir
cd workdir

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install git curl -y

echo "cloning config files."
curl https://raw.githubusercontent.com/Predikhel/bspwm-conf/main/debian/bspwmrc -o bspwmrc
curl https://raw.githubusercontent.com/Predikhel/bspwm-conf/main/debian/sxhkdrc -o sxhkdrc
curl https://raw.githubusercontent.com/Predikhel/bspwm-conf/main/debian/polybarconfig -o polybarconfig
curl https://raw.githubusercontent.com/Predikhel/bspwm-conf/main/debian/polybarlaunch.sh -o polybarlaunch.sh
mv polybarconfig config
  
sudo apt-get install -y xorg lightdm slick-greeter light-locker feh polybar bc papirus-icon-theme xorg-dev imagemagick build-essential xdg-utils xdg-user-dirs neofetch bspwm sxhkd sakura picom lxappearance nemo arandr pavucontrol arc-theme
mkdir -p ~/.config/{bspwm,sxhkd,polybar,bg}

git clone https://git.suckless.org/dmenu
cd dmenu
sudo make clean install
sudo rm -r dmenu

echo "installing config files."

install -Dm755 bspwmrc ~/.config/bspwm/bspwmrc
install -Dm644 sxhkdrc ~/.config/sxhkd/sxhkdrc
install -Dm644 config ~/.config/polybar/config
mv polybarlaunch.sh ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/launch.sh
curl "https://pbs.twimg.com/media/FGLPzkhVkAMWcsV?format=jpg&name=4096x4096" > /home/user/.config/bg/bground.png
curl "https://pbs.twimg.com/media/FGLPxMFUYAMls6B?format=jpg&name=4096x4096" > /home/user/.config/bg/lock.png

if grep -q neofetch "$HOME/.bashrc"; then
        echo " "
else
        echo "neofetch" >> $HOME/.bashrc
fi

while true; do
    read -p "Do you want to install additional packages? " yn
    case $yn in
        [Yy]* ) read packages; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer (Yy) yes or (Nn) no.";;
    esac
done

sudo apt install $packages -y

echo "Cleaning up..."
sudo rm -r workdir
sudo apt-get autoremove -y && sudo apt-get autoclean -y

sudo systemctl enable lightdm

echo "Done!"
echo "Edit lightdm conf (greeter=slick-greeter)"
