#!/bin/bash

export INSTALL_DIR=$1
export MODS_DIR=$INSTALL_DIR/Mods-Available
export USER=steam
export MODCOUNT=0
export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ -z $1 ]]; then
  echo "Please provide your 7DTD server directory as an argument to this script as it is imperative to the instructions that follow."; exit 1;
fi

. install_mods.func.sh

# Install the Server & Mod-Management PHP Portal
[[ ! -d $INSTALL_DIR/html ]] && mkdir $INSTALL_DIR/html
[[ -f $INSTALL_DIR/html/index.php ]] || ln -s $INSTALL_DIR/7dtd-servermod/index.php $INSTALL_DIR/html/index.php
[[ -f $INSTALL_DIR/html/modmgr.inc.php ]] || ln -s $INSTALL_DIR/7dtd-servermod/modmgr.inc.php $INSTALL_DIR/html/modmgr.inc.php
[[ -f $INSTALL_DIR/html/servercontrol.inc.php ]] || ln -s $INSTALL_DIR/7dtd-servermod/servercontrol.inc.php $INSTALL_DIR/html/servercontrol.inc.php
[[ -f $INSTALL_DIR/html/7dtd_logo.png ]] || ln -s $INSTALL_DIR/7dtd-servermod/7dtd_logo.png $INSTALL_DIR/html/7dtd_logo.png
[[ -f $INSTALL_DIR/html/update.png ]] || ln -s $INSTALL_DIR/7dtd-servermod/update.png $INSTALL_DIR/html/update.png
[[ -f $INSTALL_DIR/html/zombie-hand.png ]] || ln -s $INSTALL_DIR/7dtd-servermod/zombie-hand.png $INSTALL_DIR/html/zombie-hand.png
[[ -f $INSTALL_DIR/html/direct-download.png ]] || ln -s $INSTALL_DIR/7dtd-servermod/direct-download.png $INSTALL_DIR/html/direct-download.png
[[ -f $INSTALL_DIR/html/start.png ]] || ln -s $INSTALL_DIR/7dtd-servermod/start.png $INSTALL_DIR/html/start.png
[[ -f $INSTALL_DIR/html/stop.jpg ]] || ln -s $INSTALL_DIR/7dtd-servermod/stop.jpg $INSTALL_DIR/html/stop.jpg
[[ -f $INSTALL_DIR/html/force-stop.png ]] || ln -s $INSTALL_DIR/7dtd-servermod/force-stop.png $INSTALL_DIR/html/force-stop.png

# Creating "Mods-Available" folder
echo "Creating the Mods-Available directory for mod/modlet installation..."
rm -rf $MODS_DIR && mkdir $MODS_DIR
cd $MODS_DIR

# All oher Mods we should gather from a URL-downloaded file
cd $INSTALL_DIR/7dtd-servermod
#rm -rf install_mods.list.cmd
#wget --no-cache https://raw.githubusercontent.com/XelaNull/7dtd-servermod/master/install_mods.list.cmd > /dev/null 2>&1
chmod a+x install_mods.list.cmd && ./install_mods.list.cmd

chown $USER $INSTALL_DIR -R
echo "Applying DEFAULT MODS" && ./default_mods.sh
