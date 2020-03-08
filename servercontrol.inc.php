<?php 
function servercontrol() {
  
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
<table cellspacing=0 cellpadding=0 width=280><tr><td valign=top>
<b>Server Status:</b> ";



if(@$_GET['control']!='')
  {
    if($_GET['control']=='STOP') { exec("/stop_7dtd.sh &"); $status="STOPPING"; }
    if($_GET['control']=='FORCE_STOP' && ($currentRequest=='stop' || $currentRequest=='')) 
      { exec("echo 'force_stop' > /data/7DTD/server.expected_status"); $status="FORCEFUL STOPPING"; }
    if($_GET['control']=='START') 
      { exec("/start_7dtd.sh &"); $status="STARTING"; $status_link="<a href=?do=serverstatus&control=FORCE_STOP>img border=0 width=40 src=force-stop.png></a>"; }
    $rtn.=$status;
  }
else
  {
    if($currentRequest=='stop' && $status=="STARTED") $status='STOPPING';
    $rtn.="$status ";
    switch($status)
    {
      case "STARTED":
        if($currentRequest!='stop') $status_link="<a href=?do=serverstatus&control=STOP><img border=0 width=40 src=stop.jpg></a>";
        else $status_link="<a href=?do=serverstatus&control=FORCE_STOP><img border=0 width=40 src=force-stop.png></a>";
      break;
      case "STARTING": $status_link="<a href=?do=serverstatus&control=FORCE_STOP><img border=0 width=40 src=force-stop.png></a>"; break;
      case "STOPPED": $status_link="<a href=?do=serverstatus&control=START><img border=0 width=40 src=start.png></a>"; break;
    }
  }
$rtn.=" ".date("H:i:s")."</font>";
// Print how many WRN and ERR there were, if the $status=STARTED
if($status=='STARTED')
  {
    $WRN=exec("grep WRN /data/7DTD/7dtd.log | wc -l");
    $ERR=exec("grep ERR /data/7DTD/7dtd.log | wc -l");
    $rtn.="<br><font color=yellow>warnings</font>: $WRN | <font color=red>errors</b>: $ERR";
  }
$rtn.="</td><td align=right>$status_link</td></tr></table>
</body></html>"; exit;


?>