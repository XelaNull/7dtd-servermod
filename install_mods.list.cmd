#!/bin/bash
. install_mods.func.sh

# Last Updated: 2021-11-12
# For A19.6

#((MODCOUNT++))
#mkdir $MODS_DIR/$MODCOUNT
#mv /data/7DTD/7dtd-servermod/best_mod.zip $MODS_DIR/$MODCOUNT
#cd $MODS_DIR/$MODCOUNT
#unzip best_mod.zip

wget_download https://github.com/Prisma501/CSMM-Patrons-Mod/releases/download/A19.6-v19.8.1/CPM_19.8.1.zip CPM.zip extract_file

wget_download "http://botman.nz/Botman_Mods_A19.zip" Allocs_Bad_Company.zip extract_file # Botman
wget_download "https://raw.githubusercontent.com/Prisma501/Allocs-Webmap-for-CPM/master/map.js" map.js && \
mv $MODCOUNT/map.js $MODS_DIR/3/Mods/Allocs_WebAndMapRendering/webserver/js

wget_download "https://github.com/dmustanger/7dtd-ServerTools/releases/download/19.6.5/7dtd-ServerTools-19.6.5.zip" ServerTools.zip extract_file # ServerTools


#wget_download "https://github.com/7days2mod/BadCompanySM/releases/download/v5.0.0/BCManager.zip" BCManager.zip extract_file # Bad Company Manager
#git_clone https://github.com/DelStryker/Delmod.git #Delmod Modlets
#rm -rf $MODCOUNT/Delmod/ModInfo.xml $MODCOUNT/Delmod/Delmod*Combiner $MODCOUNT/Delmod/Delmod_Pack_And_Store $MODCOUNT/Delmod/Delmod_Decorations $MODCOUNT/Delmod/Delmod_Kitchen $MODCOUNT/Delmod/Delmod_Double_Door $MODCOUNT/Delmod/Delmod_Electronics $MODCOUNT/Delmod/Delmod_Tools $MODCOUNT/Delmod/Delmod_Recipes* $MODCOUNT/Delmod/Delmod_Archetypes $MODCOUNT/Delmod/Delmod_Startup*
#git_clone https://github.com/XelaNull/7dtd-Origin-UI.git # Origin UI

# https://7daystodie.com/forums/showthread.php?94219-Red-Eagle-LXIX-s-A17-Modlet-Collection-(UI-Blocks-Quests)
#dropbox_download "https://www.dropbox.com/s/v1eyx3qnrmr7f2p/Red%20Eagle%20LXIX%27s%20A17%20Modlet%20Collection.zip?dl=1" Red_Eagle_Modlets.zip extract_file # Red Eagle's Modlet Collection
#rm -rf $MODCOUNT/*_UIMENU_* $MODCOUNT/*UI_SkillP* $MODCOUNT/RELXIX_Blocks_PickThisUp $MODCOUNT/RELXIX_UI_ToolbeltSlotNumbers $MODCOUNT/RELXIX_UI_PlayerStats $MODCOUNT/RELXIX_UI_MenuStats $MODCOUNT/RELXIX_UI_CompassStats $MODCOUNT/RELXIX_UI_ZDP1_ZombieKills $MODCOUNT/RELXIX_UI_ZDP2_ZombieKillsDeaths $MODCOUNT/RELXIX_UI_ZeeNoPlayerStatNumbers $MODCOUNT/RELXIX_UI_ZeeNoPlayerXPBar
#cd $MODCOUNT; grep Successfully -ri * | awk '{print $1}' | cut -d: -f1 > ToModify; while IFS= read -r line; do sed -i '/Successfully_Loaded/d' $line; done < ToModify; cd ..

#git_clone https://github.com/XelaNull/7DTD-WhiteRiver_ToC.git # WhiteRiver Tools of Citizenship
#git_clone https://github.com/XelaNull/7DTD-ZombieLootbag_Increase.git
#git_clone https://github.com/XelaNull/7DTD-Bag_Bellows_Headshot.git
#git_clone https://github.com/XelaNull/7DTD-Magazine_Plants_Trader.git
#git_clone https://github.com/XelaNull/7DTD-Combiner.git
#git_clone https://github.com/XelaNull/7DTD-SalvagedElectronics.git
#git_clone https://github.com/XelaNull/7dtd-FixedModlets.git

#git_clone "https://github.com/doughphunghus/Doughs-PunishingWeather-Core.git"
#git_clone "https://github.com/doughphunghus/Doughs-PunishingWeather-Effects-Medium"
#git_clone "https://github.com/doughphunghus/Doughs-PunishingWeather-Survival.git"

#git_clone "https://github.com/Donovan522/donovan-7d2d-modlets.git"
#rm -rf $MODCOUNT/donovan-7d2d-modlets/donovan-a* $MODCOUNT/donovan-7d2d-modlets/donovan-betterb* $MODCOUNT/donovan-7d2d-modlets/donovan-betterp* $MODCOUNT/donovan-7d2d-modlets/donovan-betters* $MODCOUNT/donovan-7d2d-modlets/donovan-betterv* $MODCOUNT/donovan-7d2d-modlets/donovan-c* $MODCOUNT/donovan-7d2d-modlets/donovan-l* $MODCOUNT/donovan-7d2d-modlets/donovan-m* $MODCOUNT/donovan-7d2d-modlets/donovan-n* $MODCOUNT/donovan-7d2d-modlets/donovan-p* $MODCOUNT/donovan-7d2d-modlets/donovan-u*

#git_clone https://github.com/wtk34Mods/wtk34Mods_grenade_arrow.git

#git_clone "https://github.com/andrough/7D2DvA18.git"; rm -rf $MODCOUNT/7D2DvA18/ADV/androughDecoVariants
# androughYeahSolar

#svn_checkout "https://github.com/JaxTeller718/JaxModletsA182B5/trunk/JaxTeller718_EggsInFridges"
# EggsInFridges
#svn_checkout "https://github.com/JaxTeller718/A19ModletsJax/trunk/JaxTeller718_BiggerWanderingHordes"
#svn_checkout "https://github.com/JaxTeller718/A19ModletsJax/trunk/JaxTeller718_ZombieSightRange"

#wget_download "https://gitlab.com/guppycur/guppymods/-/archive/master/guppymods-master.zip?path=Guppycur%27s_Random_ZombieGetterUpper" guppymods-master.zip extract_file
# ZombieGetterUpper

#svn_checkout "https://github.com/stallionsden/Valmar-Modlets/trunk/Valmars%20Door%20Lock%20Smash"
# Lock Smash

#wget_download https://github.com/digital-play/7dtd-a18-mods-snow/releases/download/a18_barbedwire/Snow_BarbedWire.zip Snow_BarbedWire.zip extract_file
#wget_download https://github.com/digital-play/7dtd-a18-mods-snow/releases/download/a18_woodtocoal/Snow_WoodtoCoal.zip Snow_WoodtoCoal.zip extract_file
#wget_download https://github.com/digital-play/7dtd-a18-mods-snow/releases/download/a18_bladetraps/Snow_BladeTraps.zip Snow_BladeTraps.zip extract_file
#git_clone https://github.com/doughphunghus/Doughs-Buff-PipeBombs

#git_clone "https://github.com/stamplesmods/7d2dmodlets"
# Ghillie Suit

# Get The Herp & Bigger Buck and Doe
#git_clone https://github.com/doughphunghus/7d2dModlets
#rm -rf $MODCOUNT/7d2dModlets/Khelldon*Aww* $MODCOUNT/7d2dModlets/Khelldon*Baby* $MODCOUNT/7d2dModlets/Khelldon*Bad* $MODCOUNT/7d2dModlets/Khelldon*Chicken* $MODCOUNT/7d2dModlets/Khelldon*Complex* $MODCOUNT/7d2dModlets/Khelldon*Custom* $MODCOUNT/7d2dModlets/Khelldon*Framed* $MODCOUNT/7d2dModlets/Khelldon*Herp* $MODCOUNT/7d2dModlets/Khelldon*Greener* $MODCOUNT/7d2dModlets/Khelldon*Horny* $MODCOUNT/7d2dModlets/Khelldon*Nailed* $MODCOUNT/7d2dModlets/Khelldon*Piggy* $MODCOUNT/7d2dModlets/Khelldon*Grenade* $MODCOUNT/7d2dModlets/Khelldon*Rebar* $MODCOUNT/7d2dModlets/Khelldon*Screamer* $MODCOUNT/7d2dModlets/Khelldon*Starter* $MODCOUNT/7d2dModlets/Khelldon*Gullivers* $MODCOUNT/7d2dModlets/Khelldon*Benched* $MODCOUNT/7d2dModlets/zzz*

#git_clone "https://github.com/OrbitalBliss/HOME_DEPOT_7D2D_MOD"
# Present in my FixedModlets

#wget_download "http://cdgroup.org/files/7dtd/TerrainBasedMovementSpeed.zip" TerrainBasedMovementSpeed.zip extract_file

#gdrive_download 1q1MdS4kRRu94S22KXcDqfiiZbXW4ZTZs RilesFixes.zip extract_file
#gdrive_download 1KbjFknPKK6HWF8-ZmGW8bxTNzuRECACz RilesUI.zip extract_file

#wget_download "https://gitlab.com/KhaineGB/khaines-modlets-a19/-/archive/master/khaines-modlets-a19-master.zip?path=KHA19-ZombieStutterStop" Khaines-ZombieStutter.zip extract_file

#gdrive_download 1jHXXJWzyirKZfhw9CS0yTagPKYITCWUz RideShare.zip extract_file
#https://drive.google.com/file/d/1jHXXJWzyirKZfhw9CS0yTagPKYITCWUz/view?usp=sharing

#gdrive_download 1-Mr50D7r4yQVv8GhT_n5fiZnRuOSpCaI ShowMoreEffects.zip extract_file
#https://drive.google.com/file/d/1-Mr50D7r4yQVv8GhT_n5fiZnRuOSpCaI/view?usp=sharing



#https://drive.google.com/file/d/1CYBwDYo6wAVF3p8mSNuHjl_a82P1rz60/view?usp=sharing
#https://github.com/arramus/Pet-Animals-and-Guards-A19-2021Jan01
#https://github.com/TSBX-7D/VanillaExpanded-Storage/
#https://github.com/redbeardt/Downloads/blob/main/7%20Days%20To%20Die/A19/ActiveIngredients.zip
