<?php 



// Read in the information from the ModInfo.xml file
function readModInfo($fullPathToModInfoXML)
{
$fileArray=file($fullPathToModInfoXML);
foreach($fileArray as $line)
  {
    if(strpos($line,'Name value')!==FALSE) $rtn['Name']=extractValue($line);
    if(strpos($line,'Description value')!==FALSE) $rtn['Description']=extractValue($line);
    if(strpos($line,'Author value')!==FALSE) $rtn['Author']=extractValue($line);
    if(strpos($line,'Version value')!==FALSE) $rtn['Version']=extractValue($line);   
    if(strpos($line,'Website value')!==FALSE) $rtn['Website']=extractValue($line); 
  }
  return($rtn);
}
// Return only what is after the double-quote
// This is used in the readModInfo function
function extractValue($line)
{ $pieces=explode('"',$line); return($pieces[1]); }

// Returns True if the mod is enabled
function is_mod_enabled($INSTALL_DIR, $SymLinkString)
{
  $result=exec("ls -l $INSTALL_DIR/Mods | grep \"$SymLinkString\"");
  if(strlen($result)>1) return true;
  else return false;  
}

// Create the SymLink to enable a mod
function enable_mod($INSTALL_DIR, $MOD_DIR_PATH)
{
  $name_Pieces=explode('/',$MOD_DIR_PATH);
  $name_Position=count($name_Pieces)-1;
  $ModName=$name_Pieces[$name_Position];
  if(!is_dir("$INSTALL_DIR/Mods/$ModName"))
    {
      //echo "SymLink: $INSTALL_DIR/Mods/$ModName --> $MOD_DIR_PATH";
      symlink($MOD_DIR_PATH,"$INSTALL_DIR/Mods/".$ModName);
    }
}

// Remove the SymLink to disable a mod
function disable_mod($INSTALL_DIR, $MOD_DIR_PATH)
{
  $name_Pieces=explode('/',$MOD_DIR_PATH);
  $name_Position=count($name_Pieces)-1;
  $ModName=$name_Pieces[$name_Position];
  if(is_dir("$INSTALL_DIR/Mods/$ModName")) 
    {
    //  echo "REMOVING SYMLINK: $INSTALL_DIR/Mods/$ModName";
      unlink("$INSTALL_DIR/Mods/$ModName");  
    }
}

function SDD_ModMgr()
{
  $INSTALL_DIR="/data/7DTD";
  $MODS_DIR="$INSTALL_DIR/Mods-Available";
  
  // Build array of ModInfo.xml instances installed
  $it = new RecursiveDirectoryIterator($MODS_DIR);
  foreach(new RecursiveIteratorIterator($it) as $file)
    { if(basename($file)=='ModInfo.xml') $MOD_ARRAY[]=$file; }
  
  // Perform any Modlet Updating, so that we can display the outcome right here on the page
  if($_GET['update']!='')
    {
      $SUBDIRNAME=exec("cat $MODS_DIR/$_GET[update]/ModURL.txt | rev | cut -d/ -f1 | rev | sed 's|.git||g'");
      $GITDIRNAME="$MODS_DIR/$_GET[update]/$SUBDIRNAME";
      $command="cd $GITDIRNAME && /usr/bin/git pull";
      $command_output=exec($command);
      $rtn="<table cellspacing=0 border=1><tr><td><b>Update Command output:</b><br><font size=2><i>$command_output</i></font></td></tr></table><br>";
      
    }
    
  // Perform update of the ServerMod Manager
  if($_GET['smmupdate']==1)
    {
      $command="rm -rf $INSTALL_DIR/7dtd-servermod && cd $INSTALL_DIR && git clone https://github.com/XelaNull/7dtd-servermod.git && chmod a+x $INSTALL_DIR/7dtd-servermod/*.sh";
      $command_output=exec($command);
      $rtn="<table cellspacing=0 border=1><tr><td><b>Update Command output:</b><br><font size=2><i>$command_output</i></font></td></tr></table><br>";
    }
  if($_GET['smmreset']==1)
  {
    $command="rm -rf $INSTALL_DIR/Mods/* $INSTALL_DIR/Mods-Available/*; cd $INSTALL_DIR/7dtd-servermod && ./install_mods.sh $INSTALL_DIR && ./default_mods.sh";
    $command_output=exec($command);
    $rtn="<table cellspacing=0 border=1><tr><td><b>Reset Command output:</b><br><font size=2><i>$command_output</i></font></td></tr></table><br>";
  }
  // Show as a table
  $rtn.="<table width=100% border=1 cellspacing=0 cellpadding=2>
  <tr bgcolor=\"#ffb8ab\"><th>Name</th><th>DL / Update</th><th>Description</th><th>Author</th></tr>
  ";
  
  
  $modcnt=0;
  $ALTCOLOR="#fec5bb"; $ALT_count=0;
  // Loop through all the mods
  foreach($MOD_ARRAY as $ModPath)
  {
    $modcnt++; $ALT_count++;
    $FullModPath_ModInfoXML=$ModPath; 
    $FullModDir=str_replace('/ModInfo.xml','',$ModPath);
    $modInfo_Array=readModInfo($FullModPath_ModInfoXML);
    $ShortModPath=str_replace($MODS_DIR.'/','',$ModPath); // Strip off the MODS_DIR path prefix
    $modPath_Pieces=explode('/',$ShortModPath);
    $SymLinkString=$MODS_DIR.'/'.dirname($ShortModPath);
    if(is_mod_enabled('/data/7DTD',$SymLinkString)) 
      {
        $checkTXT='checked';
        if(@$_POST['ModIDNum']==$modcnt && @$_POST["modID$modcnt"]!='on') { disable_mod($INSTALL_DIR,$FullModDir); $checkTXT=''; }
      }
    else 
      {
        $checkTXT='';  
        if(@$_POST['ModIDNum']==$modcnt && @$_POST["modID$modcnt"]=='on') { enable_mod($INSTALL_DIR,$FullModDir); $checkTXT='checked'; }
      }
      
    if($_GET['disableall']==1)
      {
        disable_mod($INSTALL_DIR,$FullModDir); $checkTXT='';
      }
    elseif($_GET['enableall']==1)
      {
        enable_mod($INSTALL_DIR,$FullModDir); $checkTXT='checked';
      }  
    
    if(@$modInfo_Array['Website']!='') $Author="<a href=$modInfo_Array[Website]>$modInfo_Array[Author]</a>";
    else $Author="$modInfo_Array[Author]";
    
    // Collect the URL that we downloaded this mod from
    @$URL=file_get_contents($MODS_DIR.'/'.$modPath_Pieces[0].'/ModURL.txt');
    
    $PkgNum=$modPath_Pieces[0];
    if($URL!='') $download_Link="<td width=50 align=center><a href=$URL><img align=top height=38 src=zombie-hand.png alt=\"Download Modlet\"></a></td>";
    else $download_Link='<td>&nbsp;</td>';
    
    if(strpos($URL,'github')!==FALSE) $update_Link="<a href=\"index.php?update=$PkgNum\"><img align=top height=20 src=update.png ALT=\"Perform GIT Pull to UPDATE Modlet\"></a>";
    else $update_Link="";
    
    
    if($ALT_count==2) { $ALT_count=0; $ROW_COLOR=$ALTCOLOR; } else $ROW_COLOR='white';
    $rtn.="<tr bgcolor=$ROW_COLOR><form method=post action=?do=modmgr><input type=hidden name=ModIDNum value=$modcnt>
    $download_Link
    <td width=380>
    
    <div style=\"display:inline-block;\"><b>$modInfo_Array[Name]</b><br>
    Version: $modInfo_Array[Version] </font>
    </div>
    <div style=\"display:inline-block;\"><font size=2><input $checkTXT name=modID$modcnt type=checkbox onChange=\"this.form.submit();\"> $update_Link</div>
    
    </td>
    <td width=auto><font size=2>$modInfo_Array[Description]</font></td>
    <td align=center><font size=2>$Author</td>
    </form></tr>";
  }
  
  $rtn.="</table>";
  $rtn.="<A href=?enableall=1>enable all</a> . <a href=?disableall=1>disable all</a>";
  $rtn.="<br>Total Modlets: ".number_format(count($MOD_ARRAY));
  
  return($rtn);
}




?>