#!/bin/bash

export INSTALL_DIR=$1
export MODS_DIR=$INSTALL_DIR/Mods-Available
export USER=steam


export MODCOUNT=0
export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ `whoami` != 'root' ]]; then
  echo "This script should be run as the root user.";
  exit;
fi
[[ -z $1 ]] && echo "Please provide your 7DTD game server installation directory as an argument to this script."

# Create Bash Function to handle the different downloads
function gdrive_download () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT
  CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $MODS_DIR/$MODCOUNT/$2
  rm -rf /tmp/cookies.txt
  echo "https://docs.google.com/uc?export=download&id=$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  [[ "$3" == "extract_file" ]] && extract_file $2

}

function git_clone () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT && cd $MODS_DIR/$MODCOUNT
#  export AUTHOR=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f2 | rev | sed 's|/||g'`
  export CLONED_INTO=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f1 | rev`
  echo "GIT Cloning $AUTHOR's $CLONED_INTO.."
  # Delete the directory if it currently exists
  [[ -d $CLONED_INFO ]] && rm -rf $CLONED_INTO
  git clone $1  
#  echo "$AUTHOR" > $CLONED_INTO/ModAUTHOR.txt
  echo "$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  cd $MODS_DIR
}
function dropbox_download () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT && cd $MODS_DIR/$MODCOUNT
  echo "Using CURL to download $1 and save as $2"
  curl -L "$1" > $2
  echo "$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  [[ "$3" == "extract_file" ]] && extract_file $2
  cd $MODS_DIR
}
function wget_download () {
  ((MODCOUNT++))
  mkdir $MODS_DIR/$MODCOUNT && cd $MODS_DIR/$MODCOUNT
  echo "Using WGET to download $1 and save as $2"
  wget -O $2 "$1" 
  echo "$1" > $MODS_DIR/$MODCOUNT/ModURL.txt
  [[ "$3" == "extract_file" ]] && extract_file $2
  cd $MODS_DIR 
}
function extract_file () {
  filename=$1
  extension="${filename##*.}"
  cd $MODS_DIR/$MODCOUNT
  if [[ "$extension" == "rar" ]]; then unrar x -o+ $1
  elif [[ "$extension" == "zip" ]]; then unzip -o $1
  elif [[ "$extension" == "7z"]]; then 7z x $1
  fi
  cd $MODS_DIR
}

[[ -f /etc/redhat-release ]] && yum install gcc-c++ git curl -y || apt-get install g++ git curl p7zip-full -y

# Install the Server & Mod-Management PHP Portal
[[ ! -d $INSTALL_DIR/html ]] && mkdir $INSTALL_DIR/html
cp index.php $INSTALL_DIR/html/

# Creating "Mods-Available" folder
echo "Creating the Mods-Available folder to install the mods into" && (rm -rf $MODS_DIR; mkdir $MODS_DIR)

echo "Installing Botman_Mods_A17 (Allocs Mod + Bad Company Mod), CSMM_Patrons, and CSMM+Alloc_map.js"
wget_download "http://botman.nz/Botman_Mods_A17.zip" Allocs_Bad_Company.zip extract_file
wget_download "https://confluence.catalysm.net/download/attachments/1114182/CSMM_Patrons_9.1.1.zip?api=v2" CSMM_Patrons.zip extract_file
wget_download "https://confluence.catalysm.net/download/attachments/1114446/map.js?version=1&modificationDate=1548000113141&api=v2&download=true" map.js && \
mv $MODCOUNT/map.js $MODS_DIR/1/Mods/Allocs_WebAndMapRendering/webserver/js

# COMPOPACK
dropbox_download "https://www.dropbox.com/s/4438pbzcwm69n0f/COMPOPACK_38%28for%20Alpha17.1_stable_b9%29.7z?dl=0" COMPOPACK.zip extract_file && \
#cp $MODS_DIR/$MODCOUNT/COMPOPACK*/data/Prefabs/* $INSTALL_DIR/Data/Prefabs/ 
#&& yes | cp -f $MODS_DIR/$MODCOUNT/COMPOPACK*/data/Config/rwgmixer.xml $INSTALL_DIR/Data/Config/
# https://7daystodie.com/forums/showthread.php?68123-ACP-Fishing
dropbox_download "https://www.dropbox.com/s/azdarhfitn91p2e/ACP%20Fishing-A17.rar?dl=0" ACP_Fishing.rar extract_file # ACP Fishing
# https://7daystodie.com/forums/showthread.php?94219-Red-Eagle-LXIX-s-A17-Modlet-Collection-(UI-Blocks-Quests)
dropbox_download "https://www.dropbox.com/s/v1eyx3qnrmr7f2p/Red%20Eagle%20LXIX%27s%20A17%20Modlet%20Collection.zip?dl=1" Red_Eagle_Modlets.zip extract_file # Red Eagle's Modlet Collection
# https://7daystodie.com/forums/showthread.php?100868-Xajar-s-Mod-Collection
dropbox_download "https://www.dropbox.com/s/3wdpql2hfwo05ee/xModlets%20A17.1%20B9.zip?dl=0" Xajar.zip extract_file # Xajar's Mod Collection
#dropbox_download "https://7daystodie.com/forums/showthread.php?99228-Thumper-System&highlight=thumper"
# https://7daystodie.com/forums/showthread.php?102559-DK-KS-Doors-blocks-and-others-A17
dropbox_download "https://www.dropbox.com/s/cz0kf7go3sx72xs/EN_Doors%20And%20Blocks%20AMK.rar?dl=1" Doors_and_Blocks.rar extract_file
dropbox_download "https://www.dropbox.com/s/056y5vmt2zkpnki/Barrels%20and%20Alcohol.rar?dl=1" Barrels_and_Alcohol.rar extract_file
dropbox_download "https://www.dropbox.com/s/2o5b7i5vqkco88a/Colors%20Everywhere.rar?dl=1" Colors_Everywhere.rar extract_file
dropbox_download "https://www.dropbox.com/s/tw6ykjv0isl55go/Climate%20change.rar?dl=0" Climate_Change.rar extract_file

# https://7daystodie.com/forums/showthread.php?104228-Alpha-17-More-Lights-(Craftable-and-Working)
gdrive_download 1pZdwB7Hu3zshTmHR2tstlObzmKW-xqWD More_Lights.zip extract_file
# Vanilla+ & Fix Vanilla+ not having capitalization correct
gdrive_download 1ZH9YtemlSBsXEAfMUz5F0nKZJ7E2CLQU VanillaPlus.rar extract_file && find . -name modinfo.xml -exec bash -c 'mv "$0" "${0/modinfo/ModInfo}"' {} \;
gdrive_download 1ADm8EcJv942SOBjnvtX4EGoUE-gL6xbi SnappySolarPower.zip extract_file # SnappSolarPower v2.5

# Auto-Reveal Map
git_clone https://github.com/XelaNull/7dtd-auto-reveal-map.git && \
yes | cp -f $MODCOUNT/7dtd-auto-reveal-map/loop_start_autoreveal.sh / && chmod a+x /*.sh
(/usr/bin/crontab -l 2>/dev/null; echo '* * * * * /loop_start_autoreveal.sh') | /usr/bin/crontab -
ln -s $MODS_DIR/17/7dtd-auto-reveal-map $INSTALL_DIR/7dtd-auto-reveal-map
# All other git cloned projects
git_clone https://github.com/djkrose/7DTD-ScriptingMod # ScriptingMod
git_clone https://github.com/mjrice/7DaysModlets.git # Just Survive + Better RWG
git_clone https://github.com/Jayick/Firearms-1.2.git
git_clone https://github.com/Jayick/Modlets.git
git_clone https://github.com/Jayick/Farming.git
git_clone https://github.com/stasis78/7dtd-mods.git # stasis8 Modlets (FarmLifeMod)
git_clone https://github.com/stedman420/S420s_Other_Modlets.git
git_clone https://github.com/stedman420/Simple_UI_Modlets.git
git_clone https://github.com/manux32/7d2d_A17_modlets.git
git_clone https://github.com/Khelldon/7d2dModlets.git
git_clone https://github.com/SnappyYoungGuns/SnappysModlets.git
git_clone https://github.com/rewtgr/7D2D_A17_Modlets.git
git_clone https://github.com/LatheosMod/Craftworx-Modlets.git
git_clone https://github.com/Satissis/7D2D_Modlets.git
git_clone https://github.com/Elysium-81/A17Modlets.git
git_clone https://github.com/KhaineGB/KhainesModlets.git
git_clone https://github.com/banhmr/7DaysToDie-Modlets.git
git_clone https://github.com/n4bb12/7d2d-balance.git
git_clone https://github.com/DukeW74/7DaysModlets.git
git_clone https://github.com/totles/z4lab-7d2d-modlets.git
git_clone https://github.com/Donovan522/donovan-7d2d-modlets.git
git_clone https://github.com/Russiandood/RussianDoods-Sweet-and-Juicy-Modlets.git
#git_clone https://github.com/Sirillion/SMXmenu.git
#git_clone https://github.com/Sirillion/SMXhud.git
git_clone https://github.com/weelillad/7D2D-CloneModSchematics.git
git_clone https://github.com/Sirillion/7DXMLfix.git
git_clone https://github.com/Sixxgunz/7d2d_Modlets.git
git_clone https://github.com/Sixxgunz/7D2D-QualityOfDeath-All-In-One-Modlet-Pack.git
git_clone https://github.com/JaxTeller718/JaxModlets.git
git_clone https://github.com/GlobalGamer2015/7D2D_A17.git
git_clone https://github.com/digital-play/7dtd-a17-mods-sol.git
git_clone https://github.com/DelStryker/Delmod-7D2D-A17-Mods.git
git_clone https://github.com/guppycur/GuppyMods
# https://7daystodie.com/forums/showthread.php?86145-HDHQ-Textures-Lighting-Environment
git_clone https://gitlab.com/DUST2DEATH/hdhqmodlets.git
git_clone https://github.com/Ragsy2145/Ragsy-Get-Real

# This seems to be a collection of modlets someone put together for a server and not original content
#git_clone https://github.com/dorensnow/DSServer-MOD.git
# This seems to be a collection of modleys someone put together for a server and not original content
#git_clone https://github.com/NerdScurvy/7DTD-Modlets.git
# Origin UI
# https://7daystodie.com/forums/showthread.php?40023-Origin-UI-MOD
# wget_download "http://cryados.net/7dtd/A17/7DTD_origin_A17.1b9_v102.rar" Origin_UI.rar && unrar x -o+ Origin_UI.rar

# https://7daystodie.com/forums/showthread.php?109893-Highope-s-Modlets
#wget_download "https://7d2dservers.com/7D/A17/1.0/HH_Nude_Players.zip" HH_Nude_Players.zip extract_file
wget_download "https://7d2dservers.com/7D/A17/2.0/HH_35_New_Dyes_Workstation.zip" HH_35_New_Dyes_Workstation.zip extract_file
wget_download "https://7d2dservers.com/7D/A17/1.0/HH_Starter_Items.zip" HH_Starter_Items.zip extract_file
wget_download "https://7d2dservers.com/7D/A17/1.0/HH_All_Types_Of_Trees_Respawn.zip" HH_All_Types_Of_Trees_Respawn.zip extract_file
# https://7daystodie.com/forums/showthread.php?96954-Luc-s-Modlet-Collection-(Quality-Bonuses-better-stamina-terrain-mv-spd-etc-)
wget_download "http://cdgroup.org/files/7dtd/Arrow-XbowConversion.zip" Arrow-XbowConversion.zip extract_file
wget_download "http://cdgroup.org/files/7dtd/QualityDamageBonuses.zip" QualityDamageBonuses.zip extract_file
wget_download "http://cdgroup.org/files/7dtd/QualityEffectivenessBonuses.zip" QualityEffectivenessBonuses.zip extract_file
wget_download "http://cdgroup.org/files/7dtd/ReducedStaminaUsagebyQualityLevel.zip" ReducedStaminaUsagebyQualityLevel.zip extract_file
wget_download "http://cdgroup.org/files/7dtd/TerrainBasedMovementSpeed.zip" TerrainBasedMovementSpeed.zip extract_file
#ServerTools
wget_download "https://github.com/dmustanger/7dtd-ServerTools/releases/download/12.7/7dtd-ServerTools-12.7.zip" ServerTools.zip extract_file
# Sqlite support is broke in ServerTools at the moment, so we have to manually compile the Sqlite 
# Interop Assembly package. Below is a one-liner compatible with Ubuntu & CentOS to accomplish this.
if [[ ! -f /data/7DTD/7DaysToDieServer_Data/Mono/x86_64/libSQLite.Interop.so ]]; then
  rm -rf System.Data.SQLite && git clone https://github.com/moneymanagerex/System.Data.SQLite && \
  cd System.Data.SQLite/Setup && \
  /bin/bash ./compile-interop-assembly-release.sh && ln -s ../SQLite.Interop/src/generic/libSQLite.Interop.so $INSTALL_DIR/7DaysToDieServer_Data/Mono/x86_64/libSQLite.Interop.so && \
  echo "yes" && cd ../.. && echo "./7DaysToDieServer_Data/Mono/x86_64/libSQLite.Interop.so Sym-Linked to this custom compiled file";
fi

echo "Applying CUSTOM CONFIGS against application default files ${MYDIR}" && cd $MYDIR && chmod a+x *.sh && ./7dtd-APPLY-CONFIG.sh

chown $USER $INSTALL_DIR -R