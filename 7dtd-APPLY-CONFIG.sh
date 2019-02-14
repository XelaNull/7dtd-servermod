#!/bin/bash
#
# This file is called by install_7dtd.sh after an installation or upgrade of the 7DTD application software
#
# Syntax: /replace.sh <file to modify> <old value> <new value> <search string #1 to find the correct line> <optional line search string #2>
#
/replace.sh $INSTALL_DIR/Data/Prefabs/skyscraper_01.xml downtown "commercial,downtown" Zoning
/replace.sh $INSTALL_DIR/Data/Prefabs/skyscraper_02.xml downtown "commercial,downtown" Zoning
/replace.sh $INSTALL_DIR/Data/Prefabs/skyscraper_03.xml downtown "commercial,downtown" Zoning
/replace.sh $INSTALL_DIR/Data/Prefabs/skyscraper_04.xml downtown "commercial,downtown" Zoning

/replace.sh $INSTALL_DIR/serverconfig.xml "My Game Host" "SANITYS EDGE . MODDED . CUSTOM 8K MAP . EXPERIMENTAL" ServerName
/replace.sh $INSTALL_DIR/serverconfig.xml "8" "24" ServerMaxPlayerCount
/replace.sh $INSTALL_DIR/serverconfig.xml "0" "2" 'name="ServerAdminSlots"'
/replace.sh $INSTALL_DIR/serverconfig.xml "A 7 Days to Die server" "An experimental heavily-modded 7DTD Server, using a custom RWG-tweaked map, and over 350 new buildings. ServerTools installed. Modlets: Vanilla+, Red Eagle, Just Survive. No client side installation needed." ServerDescription
/replace.sh $INSTALL_DIR/serverconfig.xml "Navezgane" "RWG" GameWorld
/replace.sh $INSTALL_DIR/serverconfig.xml "My Game" "Sanitys Edge" GameName
/replace.sh $INSTALL_DIR/serverconfig.xml "asdf" "Fuss Butt" 'name="WorldGenSeed"'
/replace.sh $INSTALL_DIR/serverconfig.xml "4096" "8192" 'name="WorldGenSize"'
/replace.sh $INSTALL_DIR/serverconfig.xml "2" "3" GameDifficulty
/replace.sh $INSTALL_DIR/serverconfig.xml "3" "2" ZombieMoveNight
/replace.sh $INSTALL_DIR/serverconfig.xml "false" "true" BuildCreate
#/replace.sh $INSTALL_DIR/serverconfig.xml "false" "true" ControlPanelEnabled
/replace.sh $INSTALL_DIR/serverconfig.xml "CHANGEME" "sanity" ControlPanelPassword
/replace.sh $INSTALL_DIR/serverconfig.xml 'value=""' 'value="sanity"' TelnetPassword
#/replace.sh $INSTALL_DIR/serverconfig.xml "100" "120" LootAbundance
/replace.sh $INSTALL_DIR/serverconfig.xml "30" "3" LootRespawnDays
/replace.sh $INSTALL_DIR/serverconfig.xml "72" "36" AirDropFrequency
#/replace.sh $INSTALL_DIR/serverconfig.xml "60" "90" MaxSpawnedZombies
#/replace.sh $INSTALL_DIR/serverconfig.xml "50" "80" MaxSpawnedAnimals
/replace.sh $INSTALL_DIR/serverconfig.xml "true" "false" EACEnabled
/replace.sh $INSTALL_DIR/serverconfig.xml 'value=""' 'value="This is an experimental server. Do not play here."' ServerLoginConfirmationText