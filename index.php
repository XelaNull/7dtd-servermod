<?php 

if(@$_POST['editFile']) { $_GET['do']='editFile'; @$_GET['editFile']=$_POST['editFile']; }
if(@$_GET['editFile']) { $_GET['do']='editFile'; }
switch(@$_GET['do'])
{
  default:
  case "modmgr":
  $main=SDD_ModMgr();
  break;
  
  case "editFile":
  if($_GET['editFile']!='../serverconfig.xml' && $_GET['editFile']!='../7dtd.log') $_GET['editFile']="../Data/Config/".$_GET['editFile'];
  $main="<form method=post action=\"?do=editFile&editFile=".$_GET['editFile']."\">
   <textarea style=\"width:100%;height:90%\" name=fileContents>";
  if(@$_POST['Submit'] && $_POST['fileContents']!='')
          {
          $fp=fopen($_GET['editFile'],"w");
          fputs($fp,$_POST['fileContents']);
          fclose($fp);
          }
  $main.=file_get_contents($_GET['editFile']);
  $main.="</textarea><br><input type=submit name=Submit value=\"SAVE FILE\" style=\"height: 30px;\"> <b>$_GET[editFile]</b>
  </form>";
  break;
  
}

function extractValue($line)
{
  $pieces=explode('"',$line);
  return($pieces[1]);  
}

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

function is_mod_enabled($INSTALL_DIR, $SymLinkString)
{
  $result=exec("ls -l $INSTALL_DIR/Mods | grep \"$SymLinkString\"");
  if(strlen($result)>1) return true;
  else return false;  
}

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
  $MODS_DIR="/data/7DTD/Mods-Available/";
  // Build array of ModInfo.xml instances installed
  $it = new RecursiveDirectoryIterator($MODS_DIR);
  foreach(new RecursiveIteratorIterator($it) as $file)
    {
      if(basename($file)=='ModInfo.xml') $MOD_ARRAY[]=$file;
    }
  
  // Show as a table
  $rtn="<table width=100% border=1 cellspacing=0>

  <tr><th>Enabled?</th><th>PkgNum</th><th>Name</th><th>Description</th><th>Author</th></tr>
  ";
  //sort($MOD_ARRAY);
  
  $modcnt=0;
  // Loop through all the mods
  foreach($MOD_ARRAY as $ModPath)
  {
    $modcnt++;
    $FullModPath_ModInfoXML=$ModPath; 
    $FullModDir=str_replace('/ModInfo.xml','',$ModPath);
    $modInfo_Array=readModInfo($FullModPath_ModInfoXML);
    $ShortModPath=str_replace($MODS_DIR,'',$ModPath); // Strip off the MODS_DIR path prefix
    $modPath_Pieces=explode('/',$ShortModPath);
    $SymLinkString='../Mods-Available/'.dirname($ShortModPath);
    if(is_mod_enabled('/data/7DTD',$SymLinkString)) 
      {
        $checkTXT='checked';
        if(@$_POST['ModIDNum']==$modcnt && @$_POST["modID$modcnt"]!='on') { disable_mod('/data/7DTD',$FullModDir); $checkTXT=''; }
      }
    else 
      {
        $checkTXT='';  
        if(@$_POST['ModIDNum']==$modcnt && @$_POST["modID$modcnt"]=='on') { enable_mod('/data/7DTD',$FullModDir); $checkTXT='checked'; }
      }
    if(@$modInfo_Array['Website']!='') $Author="<a href=$modInfo_Array[Website]>$modInfo_Array[Author]</a>";
    else $Author="$modInfo_Array[Author]";
    
    // Collect the URL that we downloaded this mod from
    @$URL=file_get_contents($MODS_DIR.$modPath_Pieces[0].'/ModURL.txt');
    if($URL!='')$PkgNum="<a href=$URL>$modPath_Pieces[0]</a>";
    else $PkgNum=$modPath_Pieces[0];
    
    $rtn.="<tr><form method=post><input type=hidden name=ModIDNum value=$modcnt>
    <td align=center><input $checkTXT name=modID$modcnt type=checkbox onChange=\"this.form.submit();\"></td>
    <td align=center>$PkgNum</td>
    <td><font size=2><b>$modInfo_Array[Name]</b> $modInfo_Array[Version]</font></td>
    <td><font size=2>$modInfo_Array[Description]</font></td>
    <td align=center>$Author</td>
    </form></tr>";
  }
  
  $rtn.="</table>";
  
  $rtn.="<br>Total Modlets: ".number_format(count($MOD_ARRAY));
  
  return($rtn);
}


mainscreen(left_side(), $main);

/***********************************/
/***********************************/

function mainscreen($left, $main)
{
?>
<html>
  <head>
    <title>7DTD ServerMod Manager (7DTD-SMM)</title>
    <style type="text/css">
    textarea
    {
      width:100%;
    }
    .textwrapper
    {
      border:1px solid #999999;
      margin:5px 0;
      padding:3px;
    } 
    </style> 
  </head>
  
<body>
  
  <div>
    <div style="width:20%; float:left;"><?php echo $left; ?></div>
    <div style="float:left;width:80%;"><?php echo $main; ?></div>
  </div>
</body>
</html>
<?php

}




function left_side()
{
$left="<center>
<p><a href=index.php?do=modmgr><b>Enable/Disable Modlets</b></a></p>
<hr><!--
<b>Click a file to edit:</b>
<p><a href=index.php?editFile=serverconfig.xml>serverconfig.xml</a></p>
<p><a href=index.php?editFile=rwgmixer.xml>rwgmixer.xml</a></p>-->";

$it = new RecursiveDirectoryIterator('../Data/Config');
foreach(new RecursiveIteratorIterator($it) as $file) if(basename($file)!='.' && basename($file)!='..') $XML_ARRAY[]=$file;


$left.="
<b>serverconfig.xml & 7dtd.log:</b><br>
<form method=post><select size=2 onChange=\"this.form.submit();\" name=editFile>
<option value=\"../serverconfig.xml\">serverconfig.xml</option>
<option value=\"../7dtd.log\">7dtd.log</option>
</select>
</form>
<br>

<b>Data/Config XML Files:</b> <br><form method=post><select size=10 onChange=\"this.form.submit();\" name=editFile>";
foreach($XML_ARRAY as $file) $left.="<option value=".str_replace('../Data/Config/','',$file).">".str_replace('../Data/Config/','',$file)."</option>";
$left.="</select></form>";

$left.="
<hr>
<center>
<b>SERVER STATUS:</b><br>";
$SERVER_PID=exec("ps awwux | grep 7DaysToDieServer | grep -v sudo | grep -v grep | awk '{print \$2}'");
$PORT_DETAIL=exec("netstat -anptu | grep LISTEN | grep 26900");
if($SERVER_PID!=''/* && $PORT_DETAIL!=''*/) $status="UP"; else $status="DOWN";
if(@$_GET['control']!='')
  {
    if($_GET['control']=='STOP') { exec("/stop_7dtd.sh &"); $status="STOPPING"; }
    if($_GET['control']=='FORCE_STOP') { exec("echo 'force_stop' > /data/7DTD/server.expected_status"); $status="FORCEFUL STOPPING"; }
    if($_GET['control']=='START') { exec("/start_7dtd.sh &"); $status="STARTING"; }
    if($_GET['control']=='START_AUTOEXPLORE') { exec("rm -rf /startloop.touch; echo start > /data/7DTD/auto-reveal.status"); $status="STARTING"; }
    if($_GET['control']=='STOP_AUTOEXPLORE') { exec("echo stop > /data/7DTD/auto-reveal.status"); $status="STARTING"; }
    $left.=$status;
  }
else
  {
    $left.=$status."<br><br>";
    switch($status)
    {
      case "UP":
      $left.="<a href=?control=STOP>STOP SERVER</a><br>";
      $left.="<a href=?control=FORCE_STOP>FORCE STOP SERVER</a>";
      break;

      case "DOWN":
      $left.="<a href=?control=START>START SERVER</a>";
      break;
    }
  }
  // Starting dedicated server
  // GameServer.Init successful

$left.="<hr><b>Auto-Exploration</b><Br>
This will make first player to login an admin and then teleport them repeatedly to discover the entire map.<br>
<br>
<b>Status: </b> Stopped<br>
<br>
<a href=?control=START_AUTOEXPLORE>Start Auto-Explore</a><br>
<a href=?control=STOP_AUTOEXPLORE>Stop Auto-Explore</a>

<br><br><Br>
<a href=index.php>refresh page</a>
</center>";
return $left;
}




?>