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

[[ -f /etc/redhat-release ]] && yum install gcc-c++ git curl -y > /dev/null 2>&1 || apt-get install g++ git curl p7zip-full -y > /dev/null 2>&1

# Install the Server & Mod-Management PHP Portal
[[ ! -d $INSTALL_DIR/html ]] && mkdir $INSTALL_DIR/html
[[ -f $INSTALL_DIR/html/GeneratedWorlds ]] || ln -s /data/7DTD/.local/share/7DaysToDie/GeneratedWorlds $INSTALL_DIR/html/GeneratedWorlds
[[ -f $INSTALL_DIR/html/index.php ]] || ln -s $INSTALL_DIR/7dtd-servermod/index.php $INSTALL_DIR/html/index.php
[[ -f $INSTALL_DIR/html/modmgr.inc.php ]] || ln -s $INSTALL_DIR/7dtd-servermod/modmgr.inc.php $INSTALL_DIR/html/modmgr.inc.php
[[ -f $INSTALL_DIR/html/servercontrol.inc.php ]] || ln -s $INSTALL_DIR/7dtd-servermod/servercontrol.inc.php $INSTALL_DIR/html/servercontrol.inc.php
[[ -f $INSTALL_DIR/html/rwganalyzer.inc.php ]] || ln -s $INSTALL_DIR/7dtd-servermod/rwganalyzer.inc.php $INSTALL_DIR/html/rwganalyzer.inc.php
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

# STATIC INSTALLS: Auto-Reveal, ServerTools, Allocs Bad Company, CSMM Patrons, CSMM Patrons Allocs Map Addon, COMPOPack
#1: Auto-Reveal
git_clone https://github.com/XelaNull/7dtd-auto-reveal-map.git > /dev/null 2>&1 && chmod a+x $MODS_DIR/$MODCOUNT/7dtd-auto-reveal-map/*.sh && \
yes | cp -f $MODCOUNT/7dtd-auto-reveal-map/loop_start_autoreveal.sh / && chmod a+x /*.sh
ln -s $MODS_DIR/1/7dtd-auto-reveal-map $INSTALL_DIR/7dtd-auto-reveal-map
CRONTEST=`crontab -l | grep 'loop_start_autoreveal' | wc -l`
if [[ $CRONTEST == "0" ]]; then
  (/usr/bin/crontab -l 2>/dev/null; echo '* * * * * /loop_start_autoreveal.sh') | /usr/bin/crontab -
fi


# All oher Mods we should gather from a URL-downloaded file
cd $INSTALL_DIR/7dtd-servermod
#rm -rf install_mods.list.cmd
#wget --no-cache https://raw.githubusercontent.com/XelaNull/7dtd-servermod/master/install_mods.list.cmd > /dev/null 2>&1
chmod a+x install_mods.list.cmd && ./install_mods.list.cmd

# Sqlite support is broke in ServerTools at the moment, so we have to manually compile the Sqlite 
# Interop Assembly package. Below is a one-liner compatible with Ubuntu & CentOS to accomplish this.
#if [[ ! -f /data/7DTD/7DaysToDieServer_Data/MonoBleedingEdge/x86_64/libSQLite.Interop.so ]]; then
#  rm -rf System.Data.SQLite $INSTALL_DIR/7DaysToDieServer_Data/Mono/x86_64/libSQLite.Interop.so && git clone https://github.com/moneymanagerex/System.Data.SQLite && \
#  cd System.Data.SQLite/Setup && \
#  /bin/bash ./compile-interop-assembly-release.sh && \
#  ln -s $MODS_DIR/System.Data.SQLite/SQLite.Interop/src/generic/libSQLite.Interop.so $INSTALL_DIR/7DaysToDieServer_Data/Mono/x86_64/libSQLite.Interop.so && \
#  echo "yes" && cd ../.. && echo "./7DaysToDieServer_Data/Mono/x86_64/libSQLite.Interop.so Sym-Linked to this custom compiled file";
#fi

echo "Applying CUSTOM CONFIGS to combat default server files... ${MYDIR}" && cd $MYDIR && chmod a+x *.sh
./7dtd-APPLY-CONFIG.sh
chown $USER $INSTALL_DIR -R
echo "Applying DEFAULT MODS" && ./default_mods.sh
