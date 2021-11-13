#!/bin/bash
export INSTALL_DIR=/data/7DTD
set -e

# Set up extra variables we will use, if they are present
[ -z "$STEAMCMD_NO_VALIDATE" ]   && validate="validate"
[ -n "$STEAMCMD_BETA" ]          && beta="-beta $STEAMCMD_BETA"
[ -n "$STEAMCMD_BETA_PASSWORD" ] && betapassword="-betapassword $STEAMCMD_BETA_PASSWORD"

echo "Starting Steam to perform application install"
su steam -c "/home/steam/steamcmd.sh +login anonymous \
  +force_install_dir $INSTALL_DIR +app_update 294420 \
  $beta $betapassword $validate +quit"
touch /7dtd.initialized;

# Create 7DTD ServerMod Manager Installer
rm -rf /data/7DTD/Mods/* /data/7DTD/Mods-Available/*
cd /data/7DTD/7dtd-servermod && chmod a+x install_mods.sh
./install_mods.sh $INSTALL_DIR

echo "Completed Upgrade.";
