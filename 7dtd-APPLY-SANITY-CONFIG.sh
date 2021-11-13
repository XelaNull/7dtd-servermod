#!/bin/bash
#
# This file is called by install_7dtd.sh after an installation or upgrade of the 7DTD application software
export INSTALL_DIR=/data/7DTD
# Syntax: /replace.sh <file to modify> <old value> <new value> <search string #1 to find the correct line> <optional line search string #2>
#

./replace.sh $INSTALL_DIR/serverconfig.xml "My Game Host" "SANITYS EDGE 8K [PvE] 150% Heavily-Modded 9/7" ServerName
./replace.sh $INSTALL_DIR/serverconfig.xml "A 7 Days to Die server" "Noob Friendly! 150% XP/Loot | 3 Land Claims\n\n60+ Server Mods:\nQuests, Tools/Weapons/Armor, Magazine Skillpoints, Zombies" ServerDescription
./replace.sh $INSTALL_DIR/serverconfig.xml 'value=""' "value='As you step closer to your Sanity\'s Edge, you may like to know more of what you are getting into:\n\nThis is a Noob-friendly server with 150% XP and 150% Loot. Unlimited durability land claims.\n\nWe do have an underground community horde base with /lobby and free resources you can help yourself to. Be kind and don\'t take all of anything. Use the /lobby command to teleport there.\n\nWe have over 60 custom mods installed on this server. Check the Esc menu for a listing of some.\n\'Read\' a Magazine to gain a Skillpoint; \'Use\' a Magazine to learn it.\nPress \'E\' to pickup plants or hit to use Living off the Land.\n\nThe FOUR Rules:\n- Be respectful\n- No griefing of any kind will be tolerated\n- Looting other players\' bags not allowed\n- Glitching, cheating, and using exploits are not permitted.\n  * All actions on this server are logged.'" ServerLoginConfirmationText

./replace.sh $INSTALL_DIR/serverconfig.xml "8" "48" ServerMaxPlayerCount
./replace.sh $INSTALL_DIR/serverconfig.xml "0" "2" 'name="ServerAdminSlots"'
./replace.sh $INSTALL_DIR/serverconfig.xml "Navezgane" "SANITYSEDGE" GameWorld
./replace.sh $INSTALL_DIR/serverconfig.xml "My Game" "SANITYSEDGE" GameName
./replace.sh $INSTALL_DIR/serverconfig.xml "asdf" "SANITYSEDGE" 'name="WorldGenSeed"'
./replace.sh $INSTALL_DIR/serverconfig.xml "4096" "8192" 'name="WorldGenSize"'
./replace.sh $INSTALL_DIR/serverconfig.xml "2" "4" GameDifficulty
./replace.sh $INSTALL_DIR/serverconfig.xml "3" "2" ZombieMoveNight
./replace.sh $INSTALL_DIR/serverconfig.xml "CHANGEME" "$TELNET_PW" ControlPanelPassword
./replace.sh $INSTALL_DIR/serverconfig.xml 'value=""' "value=\"$TELNET_PW\"" TelnetPassword
./replace.sh $INSTALL_DIR/serverconfig.xml "72" "31" AirDropFrequency
./replace.sh $INSTALL_DIR/serverconfig.xml "60" "90" 'name="MaxSpawnedZombies"'
./replace.sh $INSTALL_DIR/serverconfig.xml "50" "75" MaxSpawnedAnimals
