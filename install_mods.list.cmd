#!/bin/bash
. install_mods.func.sh

# Last Updated: 2020-01-24_0
# For A18.3

wget_download "http://botman.nz/Botman_Mods_A18.zip" Allocs_Bad_Company.zip extract_file # Botman
wget_download "https://github.com/7days2mod/BadCompanySM/releases/download/v4.2.1/BCManager.zip" BCManager.zip extract_file # Bad Company Manager
wget_download "https://github.com/Prisma501/CSMM-Patrons-Mod/archive/13.5.1.zip" CSMM_Patrons.zip extract_file # CSMM PatronsFor A18.2
wget_download "https://raw.githubusercontent.com/Prisma501/Allocs-Webmap-for-CPM/master/map.js" map.js && mv $MODCOUNT/map.js $MODS_DIR/2/Mods/Allocs_WebAndMapRendering/webserver/js
git_clone https://github.com/DelStryker/Delmod.git #Delmod Modlets
rm -rf $MODCOUNT/Delmod/ModInfo.xml $MODCOUNT/Delmod/Delmod_Decorations $MODCOUNT/Delmod/Delmod_Kitchen $MODCOUNT/Delmod/Delmod_Double_Door $MODCOUNT/Delmod/Delmod_Electronics $MODCOUNT/Delmod/Delmod_Tools $MODCOUNT/Delmod/Delmod_Recipes* $MODCOUNT/Delmod/Delmod_Archetypes $MODCOUNT/Delmod/Delmod_Startup*
git_clone https://github.com/XelaNull/7dtd-Origin-UI.git # Origin UI

# https://7daystodie.com/forums/showthread.php?94219-Red-Eagle-LXIX-s-A17-Modlet-Collection-(UI-Blocks-Quests)
dropbox_download "https://www.dropbox.com/s/v1eyx3qnrmr7f2p/Red%20Eagle%20LXIX%27s%20A17%20Modlet%20Collection.zip?dl=1" Red_Eagle_Modlets.zip extract_file # Red Eagle's Modlet Collection
rm -rf $MODCOUNT/*_UIMENU_* $MODCOUNT/*UI_SkillP* $MODCOUNT/RELXIX_Blocks_PickThisUp $MODCOUNT/RELXIX_UI_ToolbeltSlotNumbers $MODCOUNT/RELXIX_UI_PlayerStats $MODCOUNT/RELXIX_UI_MenuStats $MODCOUNT/RELXIX_UI_CompassStats
cd $MODCOUNT; grep Successfully -ri * | awk '{print $1}' | cut -d: -f1 > ToModify; while IFS= read -r line; do sed -i '/Successfully_Loaded/d' $line; done < ToModify; cd ..

wget_download "https://github.com/dmustanger/7dtd-ServerTools/releases/download/18.2.4/7dtd-ServerTools-18.2.4.zip" ServerTools.zip extract_file # ServerTools
cd $MODCOUNT && cp -r 7DaysToDieServer_Data $INSTALL_DIR/ && tar zxvf ServerTools-Linux-SQLite-Fix.tgz > /dev/null 2>&1 && cp ServerTools-Linux-SQLite-Fix/centos7/libSQLite.Interop.so ../../7DaysToDieServer_Data/Mono/x86_64/ && cd ..
git_clone https://github.com/XelaNull/XelaNull-7dtd-Modlets # WhiteRiver Tools of Citizenship
git_clone https://github.com/XelaNull/7dtd-Modlets.git # Pickup_Plants_A18

git_clone https://github.com/XelaNull/COMPOPACK_Modlet.git
cp $MODS_DIR/$MODCOUNT/COMPOPACK*/Data/Prefabs/* $INSTALL_DIR/Data/Prefabs/ 


#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/TSBX-7D/Modlets/tree/master/TSBX_Headshot_25" TSBX_Headshot_25.zip extract_file
#git_clone "https://github.com/TSBX-7D/Modlets.git"
svn_checkout "https://github.com/TSBX-7D/Modlets/trunk/TSBX_Headshot_25"
git_clone "https://github.com/doughphunghus/Doughs-PunishingWeather-Core.git"
git_clone "https://github.com/doughphunghus/Doughs-PunishingWeather-Survival.git"

#git_clone "https://github.com/Donovan522/donovan-7d2d-modlets.git"
#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Donovan522/donovan-7d2d-modlets/tree/stable/donovan-pickmeup" donovan-pickmeup.zip extract_file
svn_checkout "https://github.com/Donovan522/donovan-7d2d-modlets/trunk/donovan-pickmeup"
#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Donovan522/donovan-7d2d-modlets/tree/stable/donovan-lootcleanup" donovan-lootcleanup.zip extract_file
svn_checkout "https://github.com/Donovan522/donovan-7d2d-modlets/trunk/donovan-lootcleanup"
#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Donovan522/donovan-7d2d-modlets/tree/stable/donovan-longerlootbags" donovan-longerlootbags.zip extract_file
svn_checkout "https://github.com/Donovan522/donovan-7d2d-modlets/trunk/donovan-longerlootbags"
#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/Donovan522/donovan-7d2d-modlets/tree/master/donovan-craftspikes" donovan-craftspikes.zip extract_file
svn_checkout "https://github.com/Donovan522/donovan-7d2d-modlets/trunk/donovan-craftspikes"

git_clone "https://github.com/andrough/7D2DvA18.git"

# git_clone "https://github.com/War3zuk/ModLets-Alpha-18.1-Stable.git"
# Starter Classes
# Kitchen Utils
# Insane Quests

#git_clone "https://github.com/JaxTeller718/JaxModletsA182B5.git"
#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/JaxTeller718/JaxModletsA182B5/tree/master/JaxTeller718_EggsInFridges" JaxTeller718_EggsInFridges.zip extract_file
svn_checkout "https://github.com/JaxTeller718/JaxModletsA182B5/tree/master/JaxTeller718_EggsInFridges"
# EggsInFridges

#git_clone "https://github.com/stallionsden/StallionModlets.git"
# Home Brewery

git_clone "https://github.com/xaliber/Mods_7DaystoDie"

# git_clone "https://gitlab.com/guppycur/guppymods.git"
wget_download "https://gitlab.com/guppycur/guppymods/-/archive/master/guppymods-master.zip?path=Guppycur%27s_Random_ZombieGetterUpper" guppymods-master.zip extract_file
# ZombieGetterUpper

#git_clone "https://github.com/7D2D/A18Mods.git"
#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/7D2D/A18Mods/tree/master/SteelBars" SteelBars.zip extract_file
svn_checkout "https://github.com/7D2D/A18Mods/trunk/SteelBars"
# SteelBars

#git_clone "https://github.com/stallionsden/Valmar-Modlets.git"
#wget_download "https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/stallionsden/Valmar-Modlets/tree/master/Valmars%20Door%20Lock%20Smash" Valmars_Lock_Smash.zip extract_file
svn_checkout "https://github.com/stallionsden/Valmar-Modlets/trunk/Valmars%20Door%20Lock%20Smash"
# Lock Smash

#git_clone "https://gitlab.com/oignonchaud/oignonchaud-7d2d-mods-a18.git"
# Hitmarkers



#git_clone https://github.com/mjrice/7DaysModlets.git # Just Survive + Better RWG
#sed -i 's|<!-- <prefab rule="COMPOPACK"/>  -->|<prefab rule="COMPOPACK"/>|g' $MODS_DIR/$MODCOUNT/7DaysModlets/TheWildLand/Config/rwgmixer.xml
#git_clone https://github.com/XelaNull/7DaysModlets.git # Just Surviva Somehow
#rm -rf $MODCOUNT/7DaysModlets/TheWildLand

#gdrive_download 1ZH9YtemlSBsXEAfMUz5F0nKZJ7E2CLQU VanillaPlus.rar extract_file && find . -name modinfo.xml -exec bash -c 'mv "$0" "${0/modinfo/ModInfo}"' {} \;
#rm -rf $MODCOUNT/*_UIMENU_*
