function remap () {
rm -rf "$1"
echo "Setting Default for $1"
ln -s "`find /data/7DTD/Mods-Available -name \"ModInfo.xml\" | sed 's|/ModInfo.xml||g' | grep "$1" | tail -1`"
}

cd $INSTALL_DIR/Mods

remap Allocs_CommandExtensions
remap Allocs_CommonFunc
remap Allocs_WebAndMapRendering
remap Botman
remap 1CSMM_Patrons
remap ServerTools
