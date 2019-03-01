<?php 

include "modmgr.inc.php";
include "rwganalyzer.inc.php";

session_start();

// Pull the server's telnet password.
$server_password=exec("grep -i TelnetPassword /data/7DTD/serverconfig.xml | cut -d= -f3 | cut -d'\"' -f2");
if($_POST['Password']!='' && $_POST['Submit']!='' && $server_password==$_POST['Password']) $_SESSION['password']=$_POST['Password']; 
if($_SESSION['password']!=$server_password)
  {
  $main="<form method=post>
  Password:<br>
  <input type=password name=Password><br><br>
  <input type=Submit value=Login name=Submit>
  </form>";
  mainscreen("<center><h3><img src=7dtd_logo.png width=260><br><b>SERVERMOD MANAGER</b></h3>".$main, '');
  exit;
  }

/* FORM PROCESSING CODE */
if(@$_POST['editFile']) { $_GET['do']='editFile'; @$_GET['editFile']=$_POST['editFile']; }
if(@$_GET['editFile']) { $_GET['do']='editFile'; }
switch(@$_GET['do'])
{
  default:
  case "modmgr":
  $main="<h3>Activate/Deactivate Modlets</h3>Select the Modlets that you would like to enable by simple checking the box next to it. You will need to stop and start your server for any changes to this list to activate.<br><br>".SDD_ModMgr();
  break;
  
  case "rwgAnalyzer":
  $main="<h3>Random World Generator World Analyzer</h3>This page show you statistics about Worlds that your server has generated. It can help you better understand how prefabs were placed into a map before you even play it. Carefully examining this can help you determine if you have a seed and world generated that is worth playing.".rwganalyzer();
  //phpinfo();
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
<h3><img src=7dtd_logo.png width=260><br>
<b>SERVERMOD MANAGER</b></h3>
<p><a href=index.php?do=modmgr><b>Enable/Disable Modlets</b></a></p>
<p><a href=index.php?do=rwgAnalyzer><b>RWG World Analyzer</b></a></p>
";



$left.="
<hr>
<center>
<b>SERVER STATUS:</b><br>";
$SERVER_PID=exec("ps awwux | grep 7DaysToDieServer | grep -v sudo | grep -v grep");
//$PORT_DETAIL=exec("netstat -anptu | grep LISTEN | grep 26900");
if(strlen($SERVER_PID)>2) $status="UP"; else $status="DOWN";

$AUTOEXPLORE_PID=exec("ps awwux | grep -e expect -e 7dtd-run-after-initial-start | grep -v grep");
if($AUTOEXPLORE_PID!='' && $AUTOEXPLORE_STATUS=='') $AUTOEXPLORE_STATUS='STARTED';
else $AUTOEXPLORE_STATUS='STOPPED';
if(@$_GET['autoexplore_control']!='')
  {
    if($_GET['autoexplore_control']=='START_AUTOEXPLORE') { exec("rm -rf /startloop.touch; echo start > /data/7DTD/auto-reveal.status"); $AUTOEXPLORE_STATUS="STARTING"; }
    if($_GET['autoexplore_control']=='STOP_AUTOEXPLORE') { exec("echo stop > /data/7DTD/auto-reveal.status"); $AUTOEXPLORE_STATUS="STOPPING"; }
  }
  
if(@$_GET['control']!='')
  {
    if($_GET['control']=='STOP') { exec("/stop_7dtd.sh &"); $status="STOPPING"; }
    if($_GET['control']=='FORCE_STOP') { exec("echo 'force_stop' > /data/7DTD/server.expected_status"); $status="FORCEFUL STOPPING"; }
    if($_GET['control']=='START') { exec("/start_7dtd.sh &"); $status="STARTING"; }
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

  $it = new RecursiveDirectoryIterator('../Data/Config');
  foreach(new RecursiveIteratorIterator($it) as $file) if(basename($file)!='.' && basename($file)!='..') $XML_ARRAY[]=$file;
  $left.="<hr>
  <b>serverconfig.xml & 7dtd.log:</b><br>
  <form method=post><select size=2 onChange=\"this.form.submit();\" name=editFile>
  <option value=\"../serverconfig.xml\">serverconfig.xml</option>
  <option value=\"../7dtd.log\">7dtd.log</option>
  </select>
  </form>
  <br>

  <b>Data/Config XML Files:</b> <br><form method=post><select size=10 onChange=\"this.form.submit();\" name=editFile>";
  foreach($XML_ARRAY as $file) $left.="<option value=".str_replace('../Data/Config/','',$file).">".str_replace('../Data/Config/','',$file)."</option>\n";
  $left.="</select></form>";

if($status=='UP')
{
$left.="<hr><b>Auto-Exploration</b><Br>
This will make the first player to login, an admin, then will teleport them repeatedly to discover the entire map.<br>
<br>
<b>Status: </b> $AUTOEXPLORE_STATUS<br>
<br>";

if($AUTOEXPLORE_STATUS=='STOPPED') $left.="<a href=?autoexplore_control=START_AUTOEXPLORE>Start Auto-Explore</a><br>";
else $left.="<a href=?autoexplore_control=STOP_AUTOEXPLORE>Stop Auto-Explore</a>";
}


$left.="<br><a target=_new href=http://$_SERVER[HTTP_HOST]:8082>7 Days to Die Map</a>";

$left.="
<hr><br>
<a href=index.php>refresh page</a>
</center>";
return $left;
}




?>