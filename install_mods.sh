#!/bin/bash

export INSTALL_DIR=$1
export MODS_DIR=$INSTALL_DIR/Mods-Available
export USER=steam

[[ -z $1 ]] && echo "Please provide your 7DTD game server installation directory as an argument to this script."

# Create Bash Function to handle the different downloads
function gdrive_download () {
  CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$1" -O $2
  rm -rf /tmp/cookies.txt
}
function git_clone () {
  export AUTHOR=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f2 | rev | sed 's|/||g'`
  export CLONED_INTO=`echo $1 | sed 's|.git||g' | rev | cut -d'/' -f1 | rev`
  echo "GIT Cloning $AUTHOR's $CLONED_INTO.."
  # Delete the directory if it currently exists
  [[ -d $CLONED_INFO ]] && rm -rf $CLONED_INTO
  git clone $1  
  echo "$AUTHOR" > $CLONED_INTO/ModAUTHOR.txt
  echo "$1" > $CLONED_INTO/ModURL.txt 
}
function dropbox_download () {
  echo "Using CURL to download $1 and save as $2"
  curl -L "$1" > $2
}
function wget_download () {
  echo "Using WGET to download $1 and save as $2"
  wget -O $2 "$1"  
}

#export USER=`whoami`
#echo "You are running this script under user $USER"
#echo "Please note that it is intended you run this script as the user that your 7dtd game server runs under. Sleeping 5 seconds.." && sleep 5
[[ -f /etc/redhat-release ]] && yum install gcc-c++ git curl -y || apt-get install g++ git curl -y

# Install the Server & Mod-Management PHP Portal
[[ ! -d $INSTALL_DIR/html ]] && mkdir $INSTALL_DIR/html
cp index.php $INSTALL_DIR/html/

# Creating "Mods-Available" folder
echo "Creating the Mods-Available folder to install the mods into" && (rm -rf $MODS_DIR; mkdir $MODS_DIR)

# Botman
echo "Installing Botman_Mods_A17 (Allocs Mod + Bad Company Mod)"
cd $MODS_DIR; wget -O Allocs_Bad_Company.zip http://botman.nz/Botman_Mods_A17.zip && unzip -o Allocs_Bad_Company.zip

# CSMM Patrons
wget_download "https://confluence.catalysm.net/download/attachments/1114182/CSMM_Patrons_9.1.1.zip?api=v2" CSMM_Patrons.zip && unzip -o CSMM_Patrons.zip
# CSMM Map Addon for Allocs WebAndMapRendering
wget_download "https://confluence.catalysm.net/download/attachments/1114446/map.js?version=1&modificationDate=1548000113141&api=v2&download=true" map.js && \
mv map.js $MODS_DIR/Allocs_WebAndMapRendering/webserver/js

# djkrose ScriptingMod
git_clone https://github.com/djkrose/7DTD-ScriptingMod

# COMPOPACK
dropbox_download "https://www.dropbox.com/s/bzn1pozsg9qae9l/COMPOPACK_35%28for%20Alpha17exp_b233%29.zip?dl=0" COMPOPACK.zip && unzip -o COMPOPACK.zip && \
cp COMPOPACK*/data/Prefabs/* $INSTALL_DIR/Data/Prefabs/ && yes | cp -f COMPOPACK*/data/Config/rwgmixer.xml $INSTALL_DIR/Data/Config/

# ACP Fishing
# https://7daystodie.com/forums/showthread.php?68123-ACP-Fishing
dropbox_download "https://www.dropbox.com/s/azdarhfitn91p2e/ACP%20Fishing-A17.rar?dl=0" ACP_Fishing.zip && unzip -o ACP_Fishing.zip

# Just Survive + Better RWG
git_clone https://github.com/mjrice/7DaysModlets.git

# Red Eagle's Modlet Collection
# https://7daystodie.com/forums/showthread.php?94219-Red-Eagle-LXIX-s-A17-Modlet-Collection-(UI-Blocks-Quests)
dropbox_download "https://www.dropbox.com/s/v1eyx3qnrmr7f2p/Red%20Eagle%20LXIX%27s%20A17%20Modlet%20Collection.zip?dl=1" Red_Eagle_Modlets.zip && unzip -o Red_Eagle_Modlets.zip

# Xajar's Mod Collection
# https://7daystodie.com/forums/showthread.php?100868-Xajar-s-Mod-Collection
dropbox_download "https://www.dropbox.com/s/3wdpql2hfwo05ee/xModlets%20A17.1%20B9.zip?dl=0" Xajar.zip && unzip -o Xajar.zip

# https://7daystodie.com/forums/showthread.php?104228-Alpha-17-More-Lights-(Craftable-and-Working)
gdrive_download 1pZdwB7Hu3zshTmHR2tstlObzmKW-xqWD More_Lights.zip && unzip -o More_Lights.zip

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
git_clone https://github.com/JaxTeller718/JaxModlets.git
git_clone https://github.com/GlobalGamer2015/7D2D_A17.git
git_clone https://github.com/digital-play/7dtd-a17-mods-sol.git
git_clone https://github.com/DelStryker/Delmod-7D2D-A17-Mods.git
git_clone https://github.com/guppycur/GuppyMods
# https://7daystodie.com/forums/showthread.php?86145-HDHQ-Textures-Lighting-Environment
git_clone https://gitlab.com/DUST2DEATH/hdhqmodlets.git

# Origin UI
# https://7daystodie.com/forums/showthread.php?40023-Origin-UI-MOD
# wget_download "http://cryados.net/7dtd/A17/7DTD_origin_A17.1b9_v102.rar" Origin_UI.rar && unrar x -o+ Origin_UI.rar

# https://7daystodie.com/forums/showthread.php?109893-Highope-s-Modlets
wget_download "https://7d2dservers.com/7D/A17/1.0/HH_Nude_Players.zip" HH_Nude_Players.zip && unzip -o HH_Nude_Players.zip
wget_download "https://7d2dservers.com/7D/A17/2.0/HH_35_New_Dyes_Workstation.zip" HH_35_New_Dyes_Workstation.zip && unzip -o HH_35_New_Dyes_Workstation.zip
wget_download "https://7d2dservers.com/7D/A17/1.0/HH_Starter_Items.zip" HH_Starter_Items.zip && unzip -o HH_Starter_Items.zip
wget_download "https://7d2dservers.com/7D/A17/1.0/HH_All_Types_Of_Trees_Respawn.zip" HH_All_Types_Of_Trees_Respawn.zip && unzip -o HH_All_Types_Of_Trees_Respawn.zip

# Telrics Archaeology
dropbox_download "https://www.dropbox.com/s/ey5ebmy3dhsku9q/Telric%20Archaeology.zip?dl=0" Telric_Archaeology.zip && unzip -o Telric_Archaeology.zip
dropbox_download "https://www.dropbox.com/s/a90inl25zwvftdf/Telrics%20Decorations.zip?dl=0" Telric_Decorations.zip && unzip -o Telric_Decorations.zip
dropbox_download "https://7daystodie.com/forums/showthread.php?99228-Thumper-System&highlight=thumper"

# https://7daystodie.com/forums/showthread.php?102559-DK-KS-Doors-blocks-and-others-A17
dropbox_download "https://www.dropbox.com/s/cz0kf7go3sx72xs/EN_Doors%20And%20Blocks%20AMK.rar?dl=1" Doors_and_Blocks.rar && unrar x -o+ Doors_and_Blocks.rar
dropbox_download "https://www.dropbox.com/s/056y5vmt2zkpnki/Barrels%20and%20Alcohol.rar?dl=1" Barrels_and_Alcohol.rar && unrar x -o+ Barrels_and_Alcohol.rar
dropbox_download "https://www.dropbox.com/s/2o5b7i5vqkco88a/Colors%20Everywhere.rar?dl=1" Colors_Everywhere.rar && unrar x -o+ Colors_Everywhere.rar
dropbox_download "https://www.dropbox.com/s/tw6ykjv0isl55go/Climate%20change.rar?dl=0" Climate_Change.rar && unrar x -o+ Climate_Change.rar

# Luc's
# https://7daystodie.com/forums/showthread.php?96954-Luc-s-Modlet-Collection-(Quality-Bonuses-better-stamina-terrain-mv-spd-etc-)
wget_download "http://cdgroup.org/files/7dtd/Arrow-XbowConversion.zip" Arrow-XbowConversion.zip && unzip -o Arrow-XbowConversion.zip
wget_download "http://cdgroup.org/files/7dtd/QualityDamageBonuses.zip" QualityDamageBonuses.zip && unzip -o QualityDamageBonuses.zip
wget_download "http://cdgroup.org/files/7dtd/QualityEffectivenessBonuses.zip" QualityEffectivenessBonuses.zip && unzip -o QualityEffectivenessBonuses.zip
wget_download "http://cdgroup.org/files/7dtd/ReducedStaminaUsagebyQualityLevel.zip" ReducedStaminaUsagebyQualityLevel.zip && unzip -o ReducedStaminaUsagebyQualityLevel.zip
wget_download "http://cdgroup.org/files/7dtd/TerrainBasedMovementSpeed.zip" TerrainBasedMovementSpeed.zip && unzip -o TerrainBasedMovementSpeed.zip

#ServerTools
wget_download "https://github.com/dmustanger/7dtd-ServerTools/releases/download/12.7/7dtd-ServerTools-12.7.zip" ServerTools.zip && unzip -o ServerTools.zip
# Sqlite support is broke in ServerTools at the moment, so we have to manually compile the Sqlite 
# Interop Assembly package. Below is a one-liner compatible with Ubuntu & CentOS to accomplish this.
cd $INSTALL_DIR
rm -rf System.Data.SQLite && git_clone https://github.com/moneymanagerex/System.Data.SQLite && cd System.Data.SQLite/Setup && /bin/bash ./compile-interop-assembly-release.sh && yes | cp -f ../SQLite.Interop/src/generic/libSQLite.Interop.so ../../7DaysToDieServer_Data/Mono/x86_64 && cd ../.. && echo "yes" && echo "libSQLite.Interop.so successfully copied into ../../7DaysToDieServer_Data/Mono/x86_64";

echo "Applying CUSTOM CONFIGS against application default files" && chmod a+x 7dtd-APPLY-CONFIG.sh && ./7dtd-APPLY-CONFIG.sh

chown $USER $INSTALL_DIR -R