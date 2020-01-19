#!/bin/bash
. install_mods.func.sh

# Last Updated: 2020-01-19_0

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

wget_download "https://github.com/dmustanger/7dtd-ServerTools/releases/download/18.2.4/7dtd-ServerTools-18.2.4.zip" ServerTools.zip extract_file # ServerTools
cd $MODCOUNT && cp -r 7DaysToDieServer_Data $INSTALL_DIR/ && tar zxvf ServerTools-Linux-SQLite-Fix.tgz > /dev/null 2>&1 && cp ServerTools-Linux-SQLite-Fix/centos7/libSQLite.Interop.so ../../7DaysToDieServer_Data/Mono/x86_64/ && cd ..
git_clone https://github.com/XelaNull/XelaNull-7dtd-Modlets # WhiteRiver Tools of Citizenship
git_clone https://github.com/XelaNull/7dtd-Modlets.git # Pickup_Plants_A18

git_clone https://github.com/XelaNull/COMPOPACK_Modlet.git
cp $MODS_DIR/$MODCOUNT/COMPOPACK*/Data/Prefabs/* $INSTALL_DIR/Data/Prefabs/ 
#git_clone https://github.com/mjrice/7DaysModlets.git # Just Survive + Better RWG
#sed -i 's|<!-- <prefab rule="COMPOPACK"/>  -->|<prefab rule="COMPOPACK"/>|g' $MODS_DIR/$MODCOUNT/7DaysModlets/TheWildLand/Config/rwgmixer.xml
git_clone https://github.com/XelaNull/7DaysModlets.git # Just Surviva Somehow
rm -rf $MODCOUNT/7DaysModlets/TheWildLand

#gdrive_download 1ZH9YtemlSBsXEAfMUz5F0nKZJ7E2CLQU VanillaPlus.rar extract_file && find . -name modinfo.xml -exec bash -c 'mv "$0" "${0/modinfo/ModInfo}"' {} \;
#rm -rf $MODCOUNT/*_UIMENU_*






# https://7daystodie.com/forums/showthread.php?100868-Xajar-s-Mod-Collection
# dropbox_download "https://www.dropbox.com/s/3wdpql2hfwo05ee/xModlets%20A17.1%20B9.zip?dl=0" Xajar.zip extract_file # Xajar's Mod Collection
#dropbox_download "https://7daystodie.com/forums/showthread.php?99228-Thumper-System&highlight=thumper"
# https://7daystodie.com/forums/showthread.php?102559-DK-KS-Doors-blocks-and-others-A17
#dropbox_download "https://www.dropbox.com/s/cz0kf7go3sx72xs/EN_Doors%20And%20Blocks%20AMK.rar?dl=1" Doors_and_Blocks.rar extract_file
#dropbox_download "https://www.dropbox.com/s/056y5vmt2zkpnki/Barrels%20and%20Alcohol.rar?dl=1" Barrels_and_Alcohol.rar extract_file
#dropbox_download "https://www.dropbox.com/s/2o5b7i5vqkco88a/Colors%20Everywhere.rar?dl=1" Colors_Everywhere.rar extract_file
#dropbox_download "https://www.dropbox.com/s/tw6ykjv0isl55go/Climate%20change.rar?dl=0" Climate_Change.rar extract_file

# https://7daystodie.com/forums/showthread.php?104228-Alpha-17-More-Lights-(Craftable-and-Working)
#gdrive_download 1pZdwB7Hu3zshTmHR2tstlObzmKW-xqWD More_Lights.zip extract_file
# Vanilla+ & Fix Vanilla+ not having capitalization correct
#gdrive_download 1ADm8EcJv942SOBjnvtX4EGoUE-gL6xbi SnappySolarPower.zip extract_file # SnappSolarPower v2.5

#git_clone https://github.com/djkrose/7DTD-ScriptingMod # ScriptingMod
#git_clone https://github.com/Jayick/Firearms-1.2.git
#git_clone https://github.com/Jayick/Modlets.git
#git_clone https://github.com/Jayick/Farming.git

#git_clone https://github.com/stedman420/S420s_Other_Modlets.git
#git_clone https://github.com/stedman420/Simple_UI_Modlets.git
#git_clone https://github.com/manux32/7d2d_A17_modlets.git
#git_clone https://github.com/Khelldon/7d2dModlets.git
#git_clone https://github.com/SnappyYoungGuns/SnappysModlets.git
#git_clone https://github.com/rewtgr/7D2D_A17_Modlets.git
#git_clone https://github.com/LatheosMod/Craftworx-Modlets.git
#git_clone https://github.com/Satissis/7D2D_Modlets.git
#git_clone https://github.com/Elysium-81/A17Modlets.git
#git_clone https://github.com/KhaineGB/KhainesModlets.git
#git_clone https://github.com/banhmr/7DaysToDie-Modlets.git
#git_clone https://github.com/n4bb12/7d2d-balance.git
#git_clone https://github.com/DukeW74/7DaysModlets.git
#git_clone https://github.com/totles/z4lab-7d2d-modlets.git
#git_clone https://github.com/Donovan522/donovan-7d2d-modlets.git
#git_clone https://github.com/Russiandood/RussianDoods-Sweet-and-Juicy-Modlets.git
#git_clone https://github.com/weelillad/7D2D-CloneModSchematics.git
#git_clone https://github.com/Sirillion/7DXMLfix.git
#git_clone https://github.com/Sixxgunz/7d2d_Modlets.git
#git_clone https://github.com/Sixxgunz/7D2D-QualityOfDeath-All-In-One-Modlet-Pack.git
#git_clone https://github.com/JaxTeller718/JaxModlets.git
#git_clone https://github.com/GlobalGamer2015/7D2D_A17.git
#git_clone https://github.com/digital-play/7dtd-a17-mods-sol.git
#git_clone https://github.com/guppycur/GuppyMods
# https://7daystodie.com/forums/showthread.php?86145-HDHQ-Textures-Lighting-Environment
# git_clone https://gitlab.com/DUST2DEATH/hdhqmodlets.git
# git_clone https://github.com/Ragsy2145/Ragsy-Get-Real
#git_clone https://github.com/stasis78/7dtd-mods.git # stasis8 Modlets (FarmLifeMod)
#ln -s $MODCOUNT/7dtd-mods/FarmLifeMod_Models/Resources $MODCOUNT/7dtd-mods/FarmLifeMod/Resources