<?php 

include "modmgr.inc.php";

session_start();

// Pull the server's telnet password.
$server_password=exec("grep -i TelnetPassword /data/7DTD/serverconfig.xml | cut -d= -f3 | cut -d'\"' -f2");
if($_POST['Password']!='' && $_POST['Submit']!='' && $server_password==$_POST['Password']) 
  {
  $_SESSION['password']=$_POST['Password'];   
  setcookie('password',$_POST['Password']);
  }
// If there is not a PHP session saved with a good password in it to match the telnet password, then we should bomb out to the login page
if($_COOKIE['password']!=$server_password && $_SESSION['password']!=$server_password)
  {
  $main="<form method=post>
  Password:<br>
  <input type=password name=Password autofocus><br><br>
  <input type=Submit value=Login name=Submit>
  </form>";
  mainscreen("<center><h3><img src=7dtd_logo.png width=260><br><b>SERVERMOD MANAGER</b></h3>".$main, '');
  exit;
  }

/* FORM PROCESSING CODE */
if(@$_POST['editFile']) { $_GET['do']='editFile'; @$_GET['editFile']=$_POST['editFile']; }
if(@$_GET['editFile']=='../7dtd.log' && $_GET['full']!=1) { $_GET['do']='logviewer'; }

// Determine if the 7DTD Server is UP or DOWN
$SERVER_PID=exec("ps awwux | grep 7DaysToDieServer | grep -v sudo | grep -v grep");
if(strlen($SERVER_PID)>2) $status="UP"; else $status="DOWN";

// Main Switch to allow this single page to act as multiple pages
switch(@$_GET['do'])
{
  // The default page to show should be the Active/Deactivate Modlets page (aka the Mod Manager/ModMgr)
  default:
  case "modmgr":
  $main="<h3>Activate/Deactivate Modlets</h3>Select the Modlets that you would like to enable by simple checking the box next to it. 
  You will need to stop and start your server for any changes to this list to activate.<br><br>".SDD_ModMgr();
  break;
  
  case "logviewer":
  $main="<iframe src=index.php?do=logviewer-frame style=\"width:100%;height:100%\" frameborder=1></iframe>";
  break;
  
  // A better log viewer
  case "logviewer-frame":
  echo '
  <html>
  <head>
  <style type="text/css">
  .textareaContainer {
  width: auto;
  height: auto;
  padding: 20px;
  margin-bottom: 30px;
}

textarea {
  width: 100%;
  border: 0px;
}
  .border-box {
  box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  -o-box-sizing: border-box;
}

.content-box {
  box-sizing: content-box;
  -moz-box-sizing: content-box;
  -webkit-box-sizing: content-box;
  -o-box-sizing: content-box;
}
  </style>
  
  <script type="text/javascript">
    window.onload=function(){
    var textarea = document.getElementById(\'logviewer\');
    AutoRefresh(1000);
    setInterval(function(){ textarea.scrollTop = textarea.scrollHeight; }, 500);
    }

     <!-- 
     function AutoRefresh( t ) { setTimeout("window.location.replace(\'http://'.$_SERVER['SERVER_NAME'].':'.$_SERVER['SERVER_PORT'].'/7dtd/index.php?do=logviewer-frame\')", t); } 
     //-->
  </script>

  </head>
  <body><b>Log Watcher:</b><br>';
  
  $log=file_get_contents('../7dtd.log');
  $logLines=explode("\n",$log);
  $totalLines=count($logLines);
  for($z=($totalLines-45);$z<=$totalLines;$z++)
    $newLog.=$logLines[$z]."\n";
  $log=$newLog;
  
  echo '<Div class=textareaContainer>
  <textarea rows=50 cols=140 name=logviewer id=logviewer class="border-box">'.$log.'</textarea>
  * The full log can be viewed at: <A target=_MAIN href=index.php?do=editFile&editFile=../7dtd.log&full=1>Full 7dtd.log Log File</a></div>
  ';

  
  echo '</body></html>';
  exit;
  break;
  
  // The server status sub-page
  case "serverstatus":
  echo "
  <html>
  <head>
    <script type = \"text/JavaScript\">
           <!-- 
           function AutoRefresh( t ) { setTimeout(\"window.location.replace('http://".$_SERVER['SERVER_NAME'].":".$_SERVER['SERVER_PORT']."/7dtd/index.php?do=serverstatus')\", t); } 
           //-->
    </script>    
  </head> 
  <body onload = \"JavaScript:AutoRefresh(5000);\">  <center>
  <font size=4><b>SERVER STATUS:</b> ";

  $currentRequest=file("/data/7DTD/server.expected_status");
  if(@$_GET['control']!='')
    {
      if($_GET['control']=='STOP') { exec("/stop_7dtd.sh &"); $status="STOPPING<br><br>"; }
      if($_GET['control']=='FORCE_STOP' && $currentRequest=='stop') { exec("echo 'force_stop' > /data/7DTD/server.expected_status"); $status="FORCEFUL STOPPING<br><Br>"; }
      if($_GET['control']=='START') { exec("/start_7dtd.sh &"); $status="STARTING<br><br>"; }
      echo $status;
    }
  else
    {
      echo $status." (";
      switch($status)
      {
        case "UP":
        if($currentRequest!='stop')
          {
            echo "<a href=?do=serverstatus&control=STOP>STOP SERVER</a>)";
          }
        else echo "<a href=?do=serverstatus&control=FORCE_STOP>FORCE STOP SERVER</a>)";
        break;

        case "DOWN":
        echo "<a href=?do=serverstatus&control=START>START SERVER</a>)";
        break;
      }
    }
  echo "<br>".date("H:i:s")."</font></center></body></html>"; exit;
  break;
  
  case "editConfig":
  $main.="<form method=post><table>";
  
  $configArray=file("../serverconfig.xml");
  foreach($configArray as $line)
    {
      // Line contains the NAME
      if(strpos($line, 'name="')!==FALSE)
        {
          $namePos=strpos($line, 'property name=')+15;
          $endNamePos=strpos($line, '"', $namePos);
          $Name=substr($line,$namePos, ($endNamePos-$namePos));
        }
      // Try to also extract the value
      if (strpos($line, 'value="')!==FALSE)
        {
          $valuePos=strpos($line, 'value="')+7;
          $endValuePos=strpos($line, '"', $valuePos);
          $Value=substr($line,$valuePos, ($endValuePos-$valuePos));
        }
      if($Name!='')
        {
          //$main.="LINE: ".htmlentities($line)."<br>";
          if($Value!='false' && $Value!='true')$main.="<tr><td><b>$Name:</b></td><td><input type=text value=\"$Value\" size=".strlen($Value)."></td></tr>";
          else 
            {
                $main.="<tr><td><b>$Name</b></td><td><SELECT NAME=\"$Name\"><OPTION ";
                if($Value=='true') $main.="checked ";
                $main.="value=true>true<OPTION ";
                if($Value=='false') $main.="checked ";
                $main.="value=false>false</SELECT></td></tr>";
            }
        }
      $Name=''; $Value='';
    }
  
  $main.="</table></form>";
  
  break;

  case "editFile":
  if($_GET['editFile']!='../serverconfig.xml' && $_GET['editFile']!='../7dtd.log' && $_GET['editFile']!='../7dtd-servermod/install_mods.list.cmd') $_GET['editFile']="../Data/Config/".$_GET['editFile'];
  $main="<form method=post action=\"?do=editFile&editFile=".$_GET['editFile']."\">
   <textarea style=\"width:100%;height:90%\" name=fileContents>";
  if(@$_POST['Submit'] && $_POST['fileContents']!='')
          {
          $fp=fopen($_GET['editFile'],"w");
          fputs($fp,$_POST['fileContents']);
          fclose($fp);
          }
  $main.=file_get_contents($_GET['editFile']);
  $main.="</textarea><br>";
  if($_GET['editFile']!='../7dtd.log')$main.="<input type=submit name=Submit value=\"SAVE FILE\" style=\"height: 30px;\"> ";
  $main.="<b>$_GET[editFile]</b>
  </form>";
  break;
  
}

function readConfigValue($SearchName)
{
  $configArray=file("../serverconfig.xml");
  foreach($configArray as $line)
    {
      // Line contains the NAME
      if(strpos($line, 'name="')!==FALSE)
        {
          $namePos=strpos($line, 'property name=')+15;
          $endNamePos=strpos($line, '"', $namePos);
          $Name=substr($line,$namePos, ($endNamePos-$namePos));
        }
      // Try to also extract the value
      if (strpos($line, 'value="')!==FALSE)
        {
          $valuePos=strpos($line, 'value="')+7;
          $endValuePos=strpos($line, '"', $valuePos);
          $Value=substr($line,$valuePos, ($endValuePos-$valuePos));
        }
        
      if($Name==$SearchName && $Value!='') return($Value);
    }
  
}

mainscreen(top_row($status), $main);

/***********************************/
/***********************************/

function mainscreen($top, $main)
{
?>
<html>
  <head>
    <title>7DTD-SMM: <?php echo readConfigValue('ServerName'); ?></title>
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
    <div style="width:100%"><?php echo $top; ?></div>
    <div style="width:100%;"><?php echo $main; ?></div>

</body>
</html>
<?php
}

function top_row($status)
{
$top="
<table cellspacing=0 cellpadding=0 width=100%>
<tr>
  <td><h3><img src=7dtd_logo.png width=260></td>
  <td>".readConfigValue('ServerName')."<br>
      <iframe src=index.php?do=serverstatus width=280 height=150 frameborder=0></iframe>
  </td>
  
  <td><p><a href=index.php?do=modmgr><b>Enable/Disable Modlets</b></a></p></td>
  <td><p><a href=index.php?do=viewlog><b>View 7DTD Log</b></a></p></td>
  <td><p><a href=index.php?do=editConfig><b>Edit Configs</b></a></p></td>
  <td><p><a href=index.php?smmupdate=1>Update ServerMod Manager</a></p></td>
</tr>
</table>
";

// Display clickable links to serverconfig.xml and 7dtd.log
/*
$left.="<hr><h3><b>EDIT CONFIGS & VIEW LOG</b></h3>
<b>serverconfig.xml & 7dtd.log:</b><br>
<form method=post><select size=3 onChange=\"this.form.submit();\" name=editFile style=\"font-size: 12pt;\">
<option value=\"../serverconfig.xml\">serverconfig.xml</option>
<option value=\"../7dtd.log\">7dtd.log</option>
<option value=\"../7dtd-servermod/install_mods.list.cmd\">install_mods.list.cmd</option>
</select>
</form>
<br>";
// Display all XML files to edit
$it = new RecursiveDirectoryIterator('../Data/Config');
foreach(new RecursiveIteratorIterator($it) as $file) if(basename($file)!='.' && basename($file)!='..') $XML_ARRAY[]=$file;
$left.="<b>Data/Config XML Files:</b> <br><form method=post><select size=10 onChange=\"this.form.submit();\" name=editFile style=\"font-size: 12pt;\">";
foreach($XML_ARRAY as $file) $left.="<option value=".str_replace('../Data/Config/','',$file).">".str_replace('../Data/Config/','',$file)."</option>\n";
$left.="</select></form>";

$left.="<hr>
<a href=index.php?smmupdate=1>Update ServerMod Manager</a><br>
<a href=index.php?smmreset=1>Reset ServerMod Manager Mods</a><br>
<br>
<a href=index.php>refresh page</a>
</center>";*/
return $top;
}




?>