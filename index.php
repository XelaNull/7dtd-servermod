<html>
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

<body>
<?php
if($_GET['editFile']=='') $_GET['editFile']='serverconfig.xml';
if($_GET['editFile']=='serverconfig.xml') $fullPath='/data/7DTD/serverconfig.xml';
if($_GET['editFile']=='rwgmixer.xml') $fullPath='/data/7DTD/Data/Config/rwgmixer.xml';
?>
<div>
<div style="width:20%; float:left;">
<b>Click a file to edit:</b>
<p><a href=index.php?editFile=serverconfig.xml>serverconfig.xml</a></p>
<p><a href=index.php?editFile=rwgmixer.xml>rwgmixer.xml</a></p>
<hr><center>
<b>SERVER STATUS:</b><br>
<?php
$SERVER_PID=exec("ps awwux | grep 7DaysToDieServer | grep -v sudo | grep -v grep | awk '{print \$2}'");
$PORT_DETAIL=exec("netstat -anptu | grep LISTEN | grep 26900");
if($SERVER_PID!='' && $PORT_DETAIL!='') $status="UP"; else $status="DOWN";

if($_GET['control']!='')
{
        if($_GET['control']=='STOP') { exec("/stop_7dtd.sh &"); $status="STOPPING"; }
        if($_GET['control']=='FORCE_STOP') { exec("echo 'force_stop' > /data/7DTD/server.expected_status"); $status="FORCEFUL STOPPING"; }
        if($_GET['control']=='START') { exec("/start_7dtd.sh &"); $status="STARTING"; }
        if($_GET['control']=='START_AUTOEXPLORE') { exec("rm -rf /startloop.touch; echo start > /data/7DTD/auto-reveal.status"); $status="STARTING"; }
        if($_GET['control']=='STOP_AUTOEXPLORE') { exec("echo stop > /data/7DTD/auto-reveal.status"); $status="STARTING"; }
        echo $status;
}
else
{
        echo $status."<br><br>";
        switch($status)
        {
        case "UP":
        echo "<a href=?control=STOP>STOP SERVER</a><br>";
        echo "<a href=?control=FORCE_STOP>FORCE STOP SERVER</a>";
        break;

        case "DOWN":
        echo "<a href=?control=START>START SERVER</a>";
        break;
        }
}

echo "<br><a href=?control=START_AUTOEXPLORE>START AUTOEXPLORE</a><br>";
echo "<a href=?control=STOP_AUTOEXPLORE>STOP AUTOEXPLORE</a>";
?>
<br>
<br><Br>
<a href=index.php>refresh</a>
</center>
</div>
<div style="float:left;width:80%;"><br>
<form method=post action="?editFile=<?php echo $_GET['editFile']; ?>">
 <textarea style="width:100%;height:90%" name=fileContents><?php
if($_POST['Submit'] && $_POST['fileContents']!='')
        {
        $fp=fopen($fullPath,"w");
        fputs($fp,$_POST['fileContents']);
        fclose($fp);
        }
$fp=fopen($fullPath,"r");
while(!feof($fp)) echo fgets($fp, 2048);
fclose($fp);

        ?></textarea><br><input type=submit name=Submit value="SAVE FILE" style="height: 30px;"> <b><?php echo $fullPath; ?></b>
</form>
</div>
<div style="clear:both;"></div>
</div>


</body>
</html>