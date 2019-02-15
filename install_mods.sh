#!/bin/bash

export INSTALL_DIR=$1
export MODS_DIR=$INSTALL_DIR/Mods-Available

[[ -z $1 ]] && echo "Please provide your 7DTD game server installation directory as an argument to this script."

# Create Bash Function to handle any Google Drive Links
function gdrive_download () {
  CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $2
  rm -rf /tmp/cookies.txt
}

# Create git_clone function
function git_clone () {
  export AUTHOR=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f2 | rev | sed 's|/||g'`
  export CLONED_INTO=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f1 | rev`
  echo "GIT Cloning $AUTHOR's $CLONED_INTO.."
  # Delete the directory if it currently exists
  [[ -d $CLONED_INFO ]] && rm -rf $CLONED_INTO
  git_clone $1  
  echo "$AUTHOR" > $CLONED_INTO/ModAUTHOR.txt
  echo "$1" > $CLONED_INTO/ModURL.txt 
}

echo "Please note that it is intended you run this script as the user that your 7dtd game server runs under. Sleeping 5 seconds.." && sleep 5

# Install the Server & Mod-Management PHP Portal
[[ ! -d $INSTALL_DIR/html ]] && mkdir $INSTALL_DIR/html
cp index.php $INSTALL_DIR/html/

# Creating "Mods-Available" folder
echo "Creating the Mods-Available folder to install the mods into" && (rm -rf $MODS_DIR; mkdir $MODS_DIR)

# Botman
echo "Installing Botman_Mods_A17 (Allocs Mod + Bad Company Mod)"
cd $MODS_DIR; wget -O Allocs_Bad_Company.zip http://botman.nz/Botman_Mods_A17.zip && unzip -o Allocs_Bad_Company.zip

# CSMM Patrons
wget -O CSMM_Patrons.zip https://confluence.catalysm.net/download/attachments/1114182/CSMM_Patrons_9.1.1.zip?api=v2 && unzip -o CSMM_Patrons.zip
# CSMM Map Addon for Allocs WebAndMapRendering
wget -O map.js "https://confluence.catalysm.net/download/attachments/1114446/map.js?version=1&modificationDate=1548000113141&api=v2&download=true" && \
mv map.js $MODS_DIR/Allocs_WebAndMapRendering/webserver/js

# djkrose ScriptingMod
git_clone https://github.com/djkrose/7DTD-ScriptingMod

# COMPOPACK
curl -L "https://www.dropbox.com/s/bzn1pozsg9qae9l/COMPOPACK_35%28for%20Alpha17exp_b233%29.zip?dl=0" > COMPOPACK.zip && unzip -o COMPOPACK.zip && \
cp COMPOPACK*/data/Prefabs/* $INSTALL_DIR/Data/Prefabs/ && yes | cp -f COMPOPACK*/data/Config/rwgmixer.xml $INSTALL_DIR/Data/Config/

# Just Survive + Better RWG
git_clone https://github.com/mjrice/7DaysModlets.git

# Red Eagle's Modlet Collection
# https://7daystodie.com/forums/showthread.php?94219-Red-Eagle-LXIX-s-A17-Modlet-Collection-(UI-Blocks-Quests)
curl -L "https://www.dropbox.com/s/v1eyx3qnrmr7f2p/Red%20Eagle%20LXIX%27s%20A17%20Modlet%20Collection.zip?dl=1" > Red_Eagle_Modlets.zip && unzip -o Red_Eagle_Modlets.zip && \

# Vanilla+
gdrive_download 1ZH9YtemlSBsXEAfMUz5F0nKZJ7E2CLQU VanillaPlus.rar && unrar x -o+ VanillaPlus.rar
# Fix Vanilla+ not having capitalization correct
find . -name modinfo.xml -exec bash -c 'mv "$0" "${0/modinfo/ModInfo}"' {} \;

# Auto-Reveal Map
git_clone https://github.com/XelaNull/7dtd-auto-reveal-map.git && yes | cp -f 7dtd-auto-reveal-map/loop_start_autoreveal.sh / && chmod a+x /*.sh
(/usr/bin/crontab -l 2>/dev/null; echo '* * * * * /loop_start_autoreveal.sh') | /usr/bin/crontab -

# Firearms Modlet
git_clone https://github.com/Jayick/Firearms-1.2
git_clone https://github.com/Jayick/Modlets.git
git_clone https://github.com/Jayick/Farming.git

# stasis8 Modlets (FarmLifeMod)
git_clone https://github.com/stasis78/7dtd-mods.git

# A ton of other Modlets
git_clone https://github.com/stedman420/S420s_Other_Modlets.git
git_clone https://github.com/stedman420/Simple_UI_Modlets.git
git_clone https://github.com/manux32/7d2d_A17_modlets.git
git_clone https://github.com/Khelldon/7d2dModlets.git
git_clone https://github.com/SnappyYoungGuns/SnappysModlets.git
git_clone https://github.com/dorensnow/DSServer-MOD.git
git_clone https://github.com/rewtgr/7D2D_A17_Modlets.git
git_clone https://github.com/LatheosMod/Craftworx-Modlets.git
git_clone https://github.com/Satissis/7D2D_Modlets.git
git_clone https://github.com/Elysium-81/A17Modlets.git
git_clone https://github.com/NerdScurvy/7DTD-Modlets.git
git_clone https://github.com/KhaineGB/KhainesModlets.git
git_clone https://github.com/banhmr/7DaysToDie-Modlets.git
git_clone https://github.com/n4bb12/7d2d-balance.git
git_clone https://github.com/DukeW74/7DaysModlets.git
git_clone https://github.com/totles/z4lab-7d2d-modlets.git
git_clone https://github.com/Donovan522/donovan-7d2d-modlets.git
git_clone https://github.com/Russiandood/RussianDoods-Sweet-and-Juicy-Modlets.git
git_clone https://github.com/Sirillion/SMXmenu.git
git_clone https://github.com/Sirillion/SMXhud.git
git_clone https://github.com/weelillad/7D2D-CloneModSchematics.git
git_clone https://github.com/Sirillion/7DXMLfix.git
git_clone https://github.com/Sixxgunz/7d2d_Modlets.git
git_clone https://github.com/Sixxgunz/7D2D-QualityOfDeath-All-In-One-Modlet-Pack.git

#ServerTools
wget -O ServerTools.zip https://github.com/dmustanger/7dtd-ServerTools/releases/download/12.7/7dtd-ServerTools-12.7.zip && unzip ServerTools.zip
# Sqlite support is broke in ServerTools at the moment, so we have to manually compile the Sqlite 
# Interop Assembly package. Below is a one-liner compatible with Ubuntu & CentOS to accomplish this.
cd $INSTALL_DIR
([[ -f /etc/redhat-release ]] && yum install gcc-c++ git -y || apt-get install g++ git -y) && rm -rf System.Data.SQLite && git_clone https://github.com/moneymanagerex/System.Data.SQLite && cd System.Data.SQLite/Setup && /bin/bash ./compile-interop-assembly-release.sh && yes | cp -f ../SQLite.Interop/src/generic/libSQLite.Interop.so ../../7DaysToDieServer_Data/Mono/x86_64 && cd ../.. && echo "yes" && echo "libSQLite.Interop.so successfully copied into ../../7DaysToDieServer_Data/Mono/x86_64";

echo "Applying CUSTOM CONFIGS against application default files" && chmod a+x 7dtd-APPLY-CONFIG.sh && ./7dtd-APPLY-CONFIG.sh