<?php 
session_start();
$INSTALL_DIR='/data/7DTD';
$LOG_FILE="$INSTALL_DIR/7dtd.log";

// Create an in-memory database
$memory_db = new PDO('sqlite::memory:');
// Wrap your code in a try statement and catch PDOException
try {    
  // Creating a table
  $memory_db->exec(
  "CREATE TABLE IF PREFABS DO NOT EXIST (
    id INTEGER PRIMARY KEY, 
    Name TEXT, 
    GroupName TEXT,
    Position TEXT)"
  );

} catch(PDOException $e) {
    echo $e->getMessage();
}

if($_GET['WorldName']) { if(is_dir("$INSTALL_DIR/Data/Worlds/$_POST[WorldName]")) $_SESSION['WorldName']=$_GET['WorldName']; }
if($_SESSION['WorldName']=='') $_SESSION['WorldName']='Navezgane';
if($_GET['WorldName']=='') $_GET['WorldName']='Navezgane';
$WORLD_NAME=$_SESSION['WorldName'];

// Automatically determine the world name
$WORLD_DIR="$INSTALL_DIR/Data/Worlds/$WORLD_NAME";
$PREFAB_FILE="$WORLD_DIR/prefabs.xml";
$MAP_FILE="$WORLD_DIR/map_info.xml";
$WORLD_CREATION_DATE=date ("F d Y H:i:s", filemtime($WORLD_DIR));

$MAP_SIZE=shell_exec("grep Height \"$MAP_FILE\" | awk '{print $3}' | cut -d= -f2 | sed 's|\"||g' | sed 's|,|x|g'");

$RWG_PREFABS=shell_exec("cat \"$PREFAB_FILE\" | grep model");
$FILE_PREFAB_ARRAY=explode("\n",$RWG_PREFABS);
$total_Prefabs=count($FILE_PREFAB_ARRAY)-1;

foreach($FILE_PREFAB_ARRAY as $line)
{
$lineArray=explode(' ',$line);

$Name=''; $Position='';
foreach($lineArray as $linePiece)
  {
  if(strpos($linePiece, 'name=')!==FALSE) { $Name=str_replace('name=','',$linePiece); $Name=str_replace('"','',$Name); }
  if(strpos($linePiece, 'position=')!==FALSE) { $Position=str_replace('position="','',$linePiece); $Position=str_replace('"','',$Position); }
  }
if($Name!='') 
  {
    try {    
      $Group_Name=findPrefabGroup("$INSTALL_DIR/Data/Config/rwgmixer.xml", $Name);
      $memory_db->exec("INSERT INTO Prefabs (Name,GroupName,Position) VALUES ('$Name','$Group_Name','$Position')");
    } catch(PDOException $e) { echo $e->getMessage(); }
  }
}

$results = $memory_db->query('SELECT count(DISTINCT Name) as count FROM Prefabs ORDER by Name');
foreach ($results as $result) { $unique_prefabs=$result['count']; }

$traders=shell_exec("grep model \"$WORLD_DIR/prefabs.xml\" | grep trader | wc -l");
$spawn_points=shell_exec("grep position \"$WORLD_DIR/spawnpoints.xml\" | wc -l");
$water_bodies=shell_exec("grep pos \"$WORLD_DIR/water_info.xml\" | awk '{print $2}' | sort | uniq | wc -l");

echo "<form method=get>";
$WORLDHTML="<select name=WorldName onChange=\"this.form.submit();\">";

if (is_dir("$INSTALL_DIR/Data/Worlds")) {
    if ($dh = opendir("$INSTALL_DIR/Data/Worlds")) {
        while (($file = readdir($dh)) !== false) {
          if($file=='.' || $file=='..' || is_file($file)) continue;
          $WORLDHTML.="<option ";
          if(basename($file)==$_SESSION['WorldName']) $WORLDHTML.='selected ';
          $WORLDHTML.="value=\"".basename($file)."\">".basename($file)."</option>";
        }
        closedir($dh);
    }
}

$WORLDHTML.="
</select>
";

echo "World: $WORLDHTML, an $MAP_SIZE map, created: $WORLD_CREATION_DATE</form><br>";
echo "There are ".number_format($unique_prefabs)." unique prefabs placed into the world ".number_format($total_Prefabs)." times.<br>";
echo "There are $spawn_points player spawn points and $traders traders on map.<br>";
echo "There are ".number_format($water_bodies)." bodies of water on map.<br>";
echo "<br><br>";

if($_GET['PERC_COUNT']>0 && $_GET['PERC_COUNT']<=100) $PERC_COUNT=$_GET['PERC_COUNT'];
if($PERC_COUNT=='') $PERC_COUNT=15;


$top_prefab_count=0;
$results = $memory_db->query("SELECT Name, count(*) as count FROM Prefabs WHERE GroupName != 'crop_Feilds' GROUP by Name ORDER by count desc LIMIT $PERC_COUNT");
foreach ($results as $result) { $tablerows.="<tr><td><font size=2>".$result['Name']."</td><td><font size=2>".$result['count']."</td></tr>"; $top_prefab_count+=$result['count']; }
$TOP_PERC=round($top_prefab_count/$total_Prefabs*100,2);

$PERC_HTML="<select name=PERC_COUNT onChange=\"this.form.submit();\">";
for($z=10;$z<=100;$z+=10)
  {
    $PERC_HTML.="<option ";
    if($PERC_COUNT==$z) $PERC_HTML.="selected ";
    $PERC_HTML.="value=$z>$z</option>";
  }
$PERC_HTML.="
</select>
";

echo "<form method=get action=\"?WorldName=".htmlentities($_GET[WorldName])."\">The $PERC_HTML most commonly duplicated prefabs (that are not a member of crop_Fields) account for $TOP_PERC% of the placed prefabs.<br>
</form>
<table cellpadding=2 cellspacing=0>
<tr><th>Prefab</th><th>Occurrences</td></tr>
$tablerows
</table><br>
<br>
<b>Summary of placed Prefab groups:</b><br>
<table cellpadding=2 cellspacing=0>
<tr><th>Prefab Group</th><th>Placed Prefabs</td><th>Unique Prefabs</th></tr>
";

$totalPlacedCount=0; $totalUniqueCount=0;
$results = $memory_db->query('SELECT GroupName, count(*) as count FROM Prefabs GROUP by GroupName ORDER by count desc');
foreach ($results as $result) 
  { 
    $placed_counts = $memory_db->query("SELECT count(*) as count FROM Prefabs WHERE GroupName='".$result['GroupName']."'");
    foreach ($placed_counts as $placed_count) { $placedCount=$placed_count['count']; }
    $totalPlacedCount=$totalPlacedCount+$placedCount;
    
    $groupsArray=array(); $uniqPrefabCount=0;
    $uniq_counts = $memory_db->query("SELECT DISTINCT Name FROM Prefabs WHERE GroupName='".$result['GroupName']."'");
    foreach ($uniq_counts as $uniq_count) {$uniqPrefabCount++;}
    $totalUniqueCount=$totalUniqueCount+$uniqPrefabCount;

    // Calculate Perc
    $calcPerc=round($placedCount/$total_Prefabs*100,2);
    
    echo "<tr><td><font size=2>".$result['GroupName']."</td><td><font size=2>".$placedCount." ($calcPerc%)</td><td><font size=2>$uniqPrefabCount (".ratio($placedCount,$uniqPrefabCount).")</td></tr>"; 
  }

echo "<tr><td align=right><b>Sub-Totals:</b></td><td>".number_format($totalPlacedCount)."</td><td>".number_format($totalUniqueCount)."</td></table>";


function findPrefabGroup($RWGMIXER_PATH, $PREFAB_NAME)
{
  $fileArray=file($RWGMIXER_PATH);
  foreach($fileArray as $line)
    {
      if(strpos($line,'<prefab_rule name=')!==FALSE) $rule_name_line=$line;
      if(strpos($line,$PREFAB_NAME)!==FALSE) break;
    }
  
  $nameArray=explode('"',$rule_name_line);
  return(str_replace('"','',$nameArray[1]));
}

function ratio ($arg1, $arg2) { $diff=round($arg1/$arg2,1); return("$diff:1"); }
?>
