<?php 
function servercontrol() {
  $savedCommand=file("/data/7DTD/server.expected_status");
  $savedCommand=trim($savedCommand[0]);  
  
  // Determine if the 7DTD Server is STARTED or STOPPED
  $SERVER_PID=exec("ps awwux | grep 7DaysToDieServer | grep -v sudo | grep -v grep");
  if(strlen($SERVER_PID)>2) 
    {
      $server_started=str_replace("\n","",exec("grep 'GameServer.Init successful' /data/7DTD/7dtd.log | wc -l"));
      if($server_started==1) 
        {
          $status="STARTED";   
          // Print how many WRN and ERR there were, if the $status=STARTED
          $WRN=exec("grep WRN /data/7DTD/7dtd.log | wc -l");
          $ERR=exec("grep ERR /data/7DTD/7dtd.log | wc -l");
          $serverWarningsErrors="<br><font color=yellow>warnings</font>: $WRN | <font color=red>errors</b>: $ERR";
        }
      else $status="STARTING";
    }
  else $status="STOPPED";
/*  
  echo "GET-CONTROL: $_GET[control]<br>";
  echo "savedCommand: $savedCommand<br>";
*/
  
  if(@$_GET['control']!='')
    {
      if($_GET['control']=='FORCE_STOP'/* && ($savedCommand=='stop' || $savedCommand=='')*/) 
        { exec("echo 'force_stop' > /data/7DTD/server.expected_status"); $status="FORCEFUL STOPPING"; }
    
      if($_GET['control']=='STOP') { exec("/stop_7dtd.sh &"); $status="STOPPING"; }
    
      if($_GET['control']=='START') 
        { exec("/start_7dtd.sh &"); $status="STARTING"; $status_link="<a href=?do=serverstatus&control=FORCE_STOP><img border=0 width=40 src=force-stop.png></a>"; }
      $serverStatus=$status;
    }
  else
    {
      if($savedCommand=='stop' && $status=="STARTED") $status='STOPPING';
      $serverStatus="$status ";
      switch($status)
      {
        case "STARTED":
          if($savedCommand!='stop') $status_link="<a href=?do=serverstatus&control=STOP><img border=0 width=40 src=stop.jpg></a>";
          else $status_link="<a href=?do=serverstatus&control=FORCE_STOP><img border=0 width=40 src=force-stop.png></a>";
        break;
        case "STARTING": $status_link="<a href=?do=serverstatus&control=FORCE_STOP><img border=0 width=40 src=force-stop.png></a>"; break;
        case "STOPPED": $status_link="<a href=?do=serverstatus&control=START><img border=0 width=40 src=start.png></a>"; break;
      }
    }

  
$rtn="
<html>
<head>
  <script type = \"text/JavaScript\">
    <!--
    function AutoRefresh( t ) { setTimeout(\"window.location.replace('http://".$_SERVER['SERVER_NAME'].":".$_SERVER['SERVER_PORT']."/7dtd/index.php?do=serverstatus')\", t); }  
    //-->
  </script>    
  <style type=\"text/css\">
  body, td {
    font: 12px Arial, Sans-serif;
    margin: 2px;
  }
  </style>
</head> 
<body onload = \"JavaScript:AutoRefresh(5000);\" BGCOLOR=\"#525252\" TEXT=white>
<table cellspacing=0 cellpadding=0 width=280>
  <tr>
    <td valign=top>
      <b>Server Status:</b>
      $serverStatus ".date("H:i:s")."<br>
      $serverWarningsErrors
    </td>
    <td align=right>$status_link</td>
  </tr>
</table>
</body>
</html>";
echo $rtn;
}

?>