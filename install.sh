#!/bin/bash

# USB prep
# Setup live usb#1 with Rufus in DD mode with newest kali
# Install from usb#1 to usb#2 using live boot from usb#1

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#Exit on failure - not working properly :(
#set -e

##### (Cosmetic) Colour output
RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal


STAGE=0                                                         # Where are we up to
TOTAL=$( grep '(${STAGE}/${TOTAL})' $0 | wc -l );(( TOTAL-- ))  # How many things have we got todo

# Upgrade distro
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Update package list 1${RESET} Apt update 1"
apt-get -y update
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Upgrade distro - new version${RESET} Apt dist-upgrade"
apt-get -y dist-upgrade
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Update package list 2${RESET} Apt update 2"
apt-get -y update
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Upgrade all packages${RESET} Apt upgrade"
apt-get -y upgrade



#### Add custom symbolic links
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Symlinks${RESET} Adding custom symlinks to /opt"
ln -s /usr/share/wordlists /opt/
ln -s /usr/share/john /opt/john_assist
ln -s /usr/share/hashcat_utils /opt/
ln -s /usr/share/webshells /opt/

#--- Start services
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Metasploit${RESET} fix services and update"
systemctl stop postgresql
systemctl start postgresql
msfdb reinit
sleep 5s

curdir=`pwd`

##### Install go
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}go${RESET} ~ programming language"
apt -y -qq install golang \
  || echo -e ''${RED}'[!] Issue with apt install'${RESET} 1>&2
echo 'export GOROOT=/usr/lib/go' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bashrc


## Wordlist
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}wordlists${RESET}"
cd /opt
git clone https://github.com/danielmiessler/SecLists.git || echo -e ''${RED}'[!] Issue with cloning seclists'${RESET} 1>&2
wget https://gist.githubusercontent.com/jhaddix/b80ea67d85c13206125806f0828f4d10/raw/c81a34fe84731430741e0463eb6076129c20c4c0/content_discovery_all.txt || echo -e ''${RED}'[!] Issue with getting content_discovery'${RESET} 1>&2
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt || echo -e ''${RED}'[!] Issue with getting worlist all'${RESET} 1>&2

## impacket
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}impacket${RESET}"
cd /opt
git clone https://github.com/SecureAuthCorp/impacket.git || echo -e ''${RED}'[!] Issue with cloning impacted'${RESET} 1>&2
cd impacket
pip install . || echo -e ''${RED}'[!] Issue with pip install'${RESET} 1>&2

## Gitrob
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}gitrob${RESET}"
go get github.com/michenriksen/gitrob || echo -e ''${RED}'[!] Issue with go install'${RESET} 1>&2
#echo 'export GITROB_ACCESS_TOKEN=' >> ~/.bashrc

## Bloodhound
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Bloodhound${RESET}"
apt-get install -y bloodhound || echo -e ''${RED}'[!] Issue with apt install'${RESET} 1>&2
    ##Neo4j - change password
    ##neo4j console

## Crackmapexec - Dev version
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}crackmap${RESET} ~ Dev version"
apt-get install -y libssl-dev libffi-dev python-dev build-essential || echo -e ''${RED}'[!] Issue with apt support libs install'${RESET} 1>&2
apt install -y pipenv || echo -e ''${RED}'[!] Issue with apt install of pipenv'${RESET} 1>&2
cd /opt/
git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec || echo -e ''${RED}'[!] Issue with cloning repo'${RESET} 1>&2
cd CrackMapExec && pipenv install || echo -e ''${RED}'[!] Issue with pipenv install'${RESET} 1>&2
pipenv shell 
python setup.py install || echo -e ''${RED}'[!] Issue with python install'${RESET} 1>&2

##### Install gobuster
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}gobuster${RESET} ~ Directory/File/DNS busting tool"
apt -y -qq install git gobuster \
  || echo -e ''${RED}'[!] Issue with apt install'${RESET} 1>&2

  ##### Install MinGW ~ cross compiling suite
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}MinGW${RESET} ~ cross compiling suite"
for FILE in mingw-w64 binutils-mingw-w64 gcc-mingw-w64 cmake   mingw-w64-dev mingw-w64-tools   gcc-mingw-w64-i686 gcc-mingw-w64-x86-64   mingw32; do
  apt -y -qq install "${FILE}" 2>/dev/null 
done


##### Install Empire
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Empire${RESET} ~ PowerShell post-exploitation"
apt -y -qq install git \
  || echo -e ''${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone -q -b master https://github.com/PowerShellEmpire/Empire.git /opt/empire-git/ \
  || echo -e ''${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/empire-git/ >/dev/null
git pull -q
popd >/dev/null


##### Install NoSQLMap
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}NoSQLMap${RESET} ~ A automated pentesting toolset for MongoDB database servers and web applications."
git clone https://github.com/tcstool/NoSQLMap.git /opt/NoSQLMap \
  || echo -e ''${RED}'[!] Issue when git cloning'${RESET} 1>&2


#### Install pwntools
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Pwntools${RESET} ~ A toolsuite for ctfs."
### Py2
apt-get -y install python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential || echo -e ''${RED}'[!] Issue when installing dependencies (apt)'${RESET} 1>&2
pip install --upgrade pip || echo -e ''${RED}'[!] Issue when updating pip'${RESET} 1>&2
pip install --upgrade pwntools || echo -e ''${RED}'[!] Issue when installing with pip'${RESET} 1>&2

### Py3
apt-get -y install python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential || echo -e ''${RED}'[!] Issue when installing dependencies (apt)'${RESET} 1>&2
python3 -m pip install --upgrade pip || echo -e ''${RED}'[!] Issue when updating pip3'${RESET} 1>&2
python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev3 || echo -e ''${RED}'[!] Issue when installing with pip3'${RESET} 1>&2


#### Install steghide
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}steghide${RESET} ~ Steganography tool."
apt-get -y install steghide || echo -e ''${RED}'[!] Issue when installing (apt)'${RESET} 1>&2

#### Install keepassxc
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}KeePass${RESET} ~ PW Manager."
apt-get -y install keepassxc || echo -e ''${RED}'[!] Issue when installing (apt)'${RESET} 1>&2


#### Install stegsolve
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}stegsolve${RESET} ~ Steganography tool."
cd /opt
mkdir stegsolve && cd stegsolve
wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar || echo -e ''${RED}'[!] Issue when downloading'${RESET} 1>&2
chmod +x stegsolve.jar || echo -e ''${RED}'[!] Issue when making executable'${RESET} 1>&2


#### Install exiftool
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Exiftool${RESET} ~ Exif tool."
apt-get -y install exiftool || echo -e ''${RED}'[!] Issue when installing (apt)'${RESET} 1>&2


#### Install unicorn
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Unicorn${RESET} ~ Powershell degrade attack."
cd /opt/
git clone https://github.com/trustedsec/unicorn.git || echo -e ''${RED}'[!] Issue when cloning repo'${RESET} 1>&2


#### Install Ghidra
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Ghidra${RESET} ~ RE tool."
cd /opt/
mkdir ghidra && cd ghidra
wget https://ghidra-sre.org/ghidra_9.2.2_PUBLIC_20201229.zip || echo -e ''${RED}'[!] Issue when getting zipfile'${RESET} 1>&2
unzip ghidra_9.2.2_PUBLIC_20201229.zip || echo -e ''${RED}'[!] Error when extracting archive'${RESET} 1>&2
rm ghidra_9.2.2_PUBLIC_20201229.zip
mv ghidra_9.2.2 /opt
cd /opt
rmdir ghidra
ln -s /opt/ghidra_9.2.2/ghidraRun /usr/bin/ghidra || echo -e ''${RED}'[!] Error when creating symbolic link.'${RESET} 1>&2


#### Install Reverse Shell Generator
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Ghidra${RESET} ~ RE tool."
cd /opt
git clone https://github.com/mthbernardes/rsg.git || echo -e ''${RED}'[!] Issue when cloning repo'${RESET} 1>&2
cd rsg
./install.sh || echo -e ''${RED}'[!] Issue when running install script'${RESET} 1>&2


#### Install ZSH & Terminal
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}ZSH${RESET} ~ CMD."
#Install zsh
apt-get -y install zsh || echo -e ''${RED}'[!] Issue when installing (apt)'${RESET} 1>&2

#Add .zshrc
cp /opt/Kali_setup/zshrc ~/.zshrc
cp /opt/Kali_setup/zshrc /root/.zshrc

#Add antigen
cd /opt/
mkdir antigen && cd antigen
curl -L git.io/antigen > /opt/antigen/antigen.zsh  || echo -e ''${RED}'[!] Issue when getting antigen with curl'${RESET} 1>&2

#Add syntax highlights
cd /opt
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git || echo -e ''${RED}'[!] Issue when cloning zsh-syntax-highlighting from git'${RESET} 1>&2

#Add auto complete
cd /opt
git clone https://github.com/zsh-users/zsh-autosuggestions.git || echo -e ''${RED}'[!] Issue when cloning zsh-autosuggestions from git'${RESET} 1>&2

# Add font
# https://medium.com/source-words/how-to-manually-install-update-and-uninstall-fonts-on-linux-a8d09a3853b0
cd curdir
mkdir -p /usr/share/fonts/truetype/FiraCode
cp Fira*.ttf /usr/share/fonts/truetype/FiraCode
mkdir -p /usr/share/fonts/truetype/MesloLGS
cp Meslo*.ttf /usr/share/fonts/truetype/MesloLGS
fc-cache -f -v || echo -e ''${RED}'[!] Issue when updating font cache'${RESET} 1>&2

#Add terminal Terminal Emulator (xfce4-terminal)
apt-get install xfce4-terminal || echo -e ''${RED}'[!] Issue when installing xfce4 from apt'${RESET} 1>&2

#Add framer theme
cd curdir
mkdir -p  /home/robin/.local/share/xfce4/terminal/colorschemes
mkdir -p /root/.local/share/xfce4/terminal/colorschemes
cp *.theme /home/robin/.local/share/xfce4/terminal/colorschemes
cp *.theme /root/.local/share/xfce4/terminal/colorschemes

cp terminalrc /home/robin/.config/xfce4/terminal/
cp terminalrc /root/.config/xfce4/terminal/

#Set ZSH as default
chsh /bin/zsh || echo -e ''${RED}'[!] Issue when setting zsh as default'${RESET} 1>&2
chsh -s /usr/bin/zsh robin || echo -e ''${RED}'[!] Issue when setting zsh as default for Robin'${RESET} 1>&2
chsh -s /usr/bin/zsh root || echo -e ''${RED}'[!] Issue when setting zsh as default for Robin'${RESET} 1>&2

# Install Tmux Plugin manager
git clone https://github.com/tmux-plugins/tpm /opt/.tmux/plugins/tpm || echo -e ''${RED}'[!] Issue when pulling tmp from git'${RESET} 1>&2

# Install tmux config
cp /opt/Kali_setup/tmux.conf ~/.tmux.conf
cp /opt/Kali_setup/tmux.conf /root/.tmux.conf

# Install vimrc
cp /opt/Kali_setup/vimrc ~/.vimrc
cp /opt/Kali_setup/vimrc /root/.vimrc

#Add instructions
echo "Set terminal to XFC4, Set theme to Framer, Add FiraCode as font, Doublecheck that zsh is the default shell"


#### Install priv keys and config
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}keys and ssh config${RESET} ~ Shell env."

cd /opt
git clone git@github.com:Robiq/Keys.git || echo -e ''${RED}'[!] Issue when pulling keys from git'${RESET} 1>&2
cd Keys
mkdir /home/robin/.ssh || echo -e ''${RED}'[!] Issue when creating .ssh folder - may already exist'${RESET} 1>&2
cp * /home/robin/.ssh/
chmod 600 /home/robin/.ssh/*.priv || echo -e ''${RED}'[!] Issue when changing file permissions'${RESET} 1>&2
eval "$(ssh-agent -s)"
ssh-add /home/robin/.ssh/*.priv || echo -e ''${RED}'[!] Issue when adding keys to agent'${RESET} 1>&2
rm -rf /opt/Keys


# Install bytecode-viwer
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) zshInstalling ${GREEN}Bytecode Viewer${RESET} ~ HexEditor."
cd /opt
wget https://github.com/Konloch/bytecode-viewer/releases/download/v2.9.22/Bytecode-Viewer-2.9.22.jar || echo -e ''${RED}'[!] Issue when pulling jarfile'${RESET} 1>&2


# Install bat
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}BAT${RESET} ~ cat with syntax highlighting."
apt install -y bat || echo -e ''${RED}'[!] Issue when installing bat from apt'${RESET} 1>&2
mkdir -p ~/.local/bin || echo -e ''${RED}'[!] Issue when making directory for symbolic link'${RESET} 1>&2
ln -s /usr/bin/batcat ~/.local/bin/bat || echo -e ''${RED}'[!] Issue when creating symbolic link'${RESET} 1>&2

# Install xxh
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}xxh${RESET} ~ Shell env for any remote host."
pip3 install -y xxh-xxh || echo -e ''${RED}'[!] Issue when installing xxh from pip'${RESET} 1>&2
xxh +RI xxh-plugin-zsh-robin+git+https://github.com/pwnpanda/xxh-plugin-zsh-robin || echo -e ''${RED}'[!] Issue when grabbing own config from git'${RESET} 1>&2

# Install vscodium
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}VSCodium${RESET} ~ Text editor."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
  | gpg --dearmor \
  | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg || echo -e ''${RED}'[!] Issue when adding keys for apt repository'${RESET} 1>&2
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium main' \
  | sudo tee /etc/apt/sources.list.d/vscodium.list || echo -e ''${RED}'[!] Issue when grabbing apt package resources'${RESET} 1>&2
sudo apt update || echo -e ''${RED}'[!] Issue when running apt update'${RESET} 1>&2
sudo apt install codium || echo -e ''${RED}'[!] Issue when installing codium from apt'${RESET} 1>&2

# Install feroxbuster
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Feroxbuster${RESET} ~ Faster Gobuster."
sudo apt install -y feroxbuster || echo -e ''${RED}'[!] Issue when installing feroxbuster from apt'${RESET} 1>&2

 ##### Clean the system
(( STAGE++ )); echo -e "\n\n${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) ${GREEN}Cleaning${RESET} the system"
#--- Clean package manager
for FILE in clean autoremove; do apt -y -qq "${FILE}"; done
apt -y -qq purge $(dpkg -l | tail -n +6 | egrep -v '^(h|i)i' | awk '{print $2}')   # Purged packages
#--- Update slocate database
updatedb
#--- Reset folder location
cd ~/ &>/dev/null
# change ownership
chown -R robin:robin /opt

exit
