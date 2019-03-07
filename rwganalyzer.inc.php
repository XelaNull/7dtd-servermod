<?php 

function rwganalyzer() 
{
global $memory_db;  
  
session_start();
$INSTALL_DIR='/data/7DTD';
$LOG_FILE="$INSTALL_DIR/7dtd.log";

// Create an in-memory database
$memory_db = new PDO('sqlite::memory:');
// Wrap your code in a try statement and catch PDOException
try {    
  // Creating a table
  $memory_db->exec(
  "CREATE TABLE IF NOT EXISTS Prefabs (
    id INTEGER PRIMARY KEY, 
    Name TEXT, 
    GroupName TEXT,
    Position TEXT,
    Occurrences TEXT)"
  );
  
  $memory_db->exec(
    "CREATE TABLE IF NOT EXISTS Groups (
      id INTEGER PRIMARY KEY,
      GroupName TEXT,
      PlacedPrefabs TEXT,
      UniqPrefabs TEXT)"
    );

  $memory_db->exec(
    "CREATE TABLE IF NOT EXISTS PrefabGroups (
      id INTEGER PRIMARY KEY,
      Name TEXT,
      GroupName TEXT)"
    );

} catch(PDOException $e) {
    $rtn.=$e->getMessage();
}

//if($_POST['WorldName']) { if(is_dir("$INSTALL_DIR/Data/Worlds/$_POST[WorldName]")) $_SESSION['WorldName']=$_POST['WorldName']; }
if($_GET['WorldName']) { if(is_dir("$INSTALL_DIR/Data/Worlds/$_GET[WorldName]")) $_SESSION['WorldName']=$_GET['WorldName']; }
if($_SESSION['WorldName']=='') $_SESSION['WorldName']='Navezgane';
if($_SESSION['WorldName']!='' && $_GET['WorldName']=='') $_GET['WorldName']=$_SESSION['WorldName'];
//if($_GET['WorldName']=='') $_GET['WorldName']='Navezgane';
$WORLD_NAME=$_SESSION['WorldName'];
if($_GET['type']=='biomes') $_SESSION['type']='biomes';
if($_GET['type']=='splat3') $_SESSION['type']='splat3';
if($_GET['type']=='radiation') $_SESSION['type']='radiation';
if($_SESSION['type']=='') $_SESSION['type']='biomes';

// Automatically determine the world name
$WORLD_DIR="$INSTALL_DIR/Data/Worlds/$WORLD_NAME";
$PREFAB_FILE="$WORLD_DIR/prefabs.xml";
$MAP_FILE="$WORLD_DIR/map_info.xml";
$WORLD_CREATION_DATE=date ("F d Y H:i:s", filemtime($WORLD_DIR));

$MAP_SIZE=shell_exec("grep Height \"$MAP_FILE\" | awk '{print $3}' | cut -d= -f2 | sed 's|\"||g' | sed 's|,|x|g'");

$RWG_PREFABS=shell_exec("cat \"$PREFAB_FILE\" | grep model");
$FILE_PREFAB_ARRAY=explode("\n",$RWG_PREFABS);
$total_Prefabs=count($FILE_PREFAB_ARRAY)-1;

$prefabGroupArray=buildPrefabGroupArray("/data/7DTD/Data/Config/rwgmixer.xml","/data/7DTD/html/7dtd-RWG_prefab/Config/rwgmixer.xml");

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
      findPrefabGroup("$INSTALL_DIR/Mods/7dtd-RWG_prefab/Config/rwgmixer.xml", $Name, $memory_db);
      findPrefabGroup("$INSTALL_DIR/Data/Config/rwgmixer.xml", $Name, $memory_db);
      $memory_db->exec("INSERT INTO Prefabs (Name,Position) VALUES ('$Name','$Position')");
    } catch(PDOException $e) { $rtn.=$e->getMessage(); }
  }
}

$results = $memory_db->query('SELECT count(DISTINCT Name) as count FROM Prefabs ORDER by Name');
foreach ($results as $result) { $unique_prefabs=$result['count']; }

$traders=shell_exec("grep model \"$WORLD_DIR/prefabs.xml\" | grep trader | wc -l");
$spawn_points=shell_exec("grep position \"$WORLD_DIR/spawnpoints.xml\" | wc -l");
$water_bodies=shell_exec("grep pos \"$WORLD_DIR/water_info.xml\" | awk '{print $2}' | sort | uniq | wc -l");

$rtn.="<form method=GET action=\"index.php\"><input type=hidden name=do value=rwgAnalyzer>";
$WORLDHTML="<select name=WorldName style=\"font-size: 24px\" onChange=\"this.form.submit();\">";

if (is_dir("$INSTALL_DIR/Data/Worlds")) {
    if ($dh = opendir("$INSTALL_DIR/Data/Worlds")) {
        while (($file = readdir($dh)) !== false) {
          if($file=='.' || $file=='..' || is_file($file)) continue;
          if(filesize("$INSTALL_DIR/Data/Worlds/".basename($file)."/prefabs.xml")>100)
            {
              $WORLDHTML.="<option ";
              if(basename($file)==$_SESSION['WorldName']) $WORLDHTML.='selected ';
              $WORLDHTML.="value=\"".basename($file)."\">".basename($file)."</option>\n";
            }
        }
        closedir($dh);
    }
}

$WORLDHTML.="
</select>
";

$SEED_NAME=file_get_contents("$WORLD_DIR/WorldName.txt");
$mapPieces=explode('x',$MAP_SIZE); $MAP_SIZE=$mapPieces[0];

$rtn.="<br><table><tr><Td width=50% valign=top><font size=5>World: $WORLDHTML</font><br>
<font size=5>Seed Name: $SEED_NAME</font><br><font size=4>Map Size: $MAP_SIZE</font><br><font size=4>Created: $WORLD_CREATION_DATE</font></form><br><br>";
$rtn.="There are <font size=5>".number_format($total_Prefabs)." total</font> and <font size=5>".number_format($unique_prefabs)." unique prefabs</font> placed into the world <br>";
$rtn.="There are $spawn_points player spawn points and $traders traders.<br>";
$rtn.="There are ".number_format($water_bodies)." water bodies.<br>";
$rtn.="<br><br>";

if($_GET['PERC_COUNT']>0 && $_GET['PERC_COUNT']<=100) $PERC_COUNT=$_GET['PERC_COUNT'];
if($PERC_COUNT=='') $PERC_COUNT=15;


$top_prefab_count=0;
$results = $memory_db->query("SELECT Name, count(*) as count FROM Prefabs GROUP by Name ORDER by count desc LIMIT $PERC_COUNT");
foreach ($results as $result) 
  { 
    $memory_db->exec("Update Prefabs SET Occurrences='".$result['count']."' WHERE Name='$Name'");
    $tablerows.="<tr><td><font size=2>".$result['Name']."</td><td><font size=2>".$result['count']."</td></tr>"; 
    $top_prefab_count+=$result['count']; 
  }
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

$rtn.="<form method=get action=\"index.php\">
<input type=hidden name=do value=rwgAnalyzer> <input type=hidden name=WorldName value=\"".htmlentities($_GET[WorldName])."\">
The $PERC_HTML most commonly duplicated prefabs account for $TOP_PERC% of the placed prefabs.<br>
</form>
<table cellpadding=2 cellspacing=0>
<tr><th>Prefab</th><th>Occurrences</td></tr>
$tablerows
</table><br>
<br>";







$totalPlacedCount=0; $totalUniqueCount=0;
$results = $memory_db->query('SELECT GroupName, count(*) as count FROM Prefabs GROUP by GroupName ORDER by count desc');
//$Group_Count=sizeof($results);
$Group_Count=0;
foreach ($results as $result) 
  { 
  $Group_Count++;  
  }



// Loop through group names and take a count of how many times the prefab is placed and how many different unique prefabs are using this Group
$results = $memory_db->query('SELECT GroupName FROM Groups ORDER by GroupName'); $Groupsfound=0;
foreach ($results as $result) 
  { 
    $placedCount=0; $uniqPrefabCount=0;
    $placed_counts = $memory_db->query("SELECT count(*) as count FROM PrefabGroups WHERE GroupName='".$result['GroupName']."'");
    foreach ($placed_counts as $placed_count) { $placedCount=$placed_count['count']; }
    $totalPlacedCount=$totalPlacedCount+$placedCount;
    
    $uniq_counts = $memory_db->query("SELECT DISTINCT Name FROM PrefabGroups WHERE GroupName='".$result['GroupName']."'");
    foreach ($uniq_counts as $uniq_count) {$uniqPrefabCount++;}
    $totalUniqueCount=$totalUniqueCount+$uniqPrefabCount;
    
    if($placedCount>0 || $uniqPrefabCount>0)
      {
      $Groupsfound++;
      $memory_db->query("UPDATE Groups SET PlacedPrefabs='$placedCount',UniqPrefabs='$uniqPrefabCount' WHERE GroupName='".$result['GroupName']."'");

      }
  }

$results = $memory_db->query('SELECT GroupName,PlacedPrefabs,UniqPrefabs FROM Groups WHERE PlacedPrefabs != \'\' ORDER by CAST(PlacedPrefabs as INTEGER) desc'); 
foreach ($results as $result) 
  {
    $rows.="<tr><td><font size=2>".$result['GroupName']."</td><td><font size=2>".$result['PlacedPrefabs']."</td><td><font size=2>".$result['UniqPrefabs']."</td></tr>";

  }
  

// Formulate a list of Prefab Group names
$rtn.="
<b>Summary of placed Prefab groups ($Groupsfound):</b><br><br>
<table cellpadding=2 cellspacing=0>
<tr><th>Prefab Group</th><th>Placed Prefabs</td><th>Unique Prefabs</th></tr>
$rows";

$rtn.="<tr><td align=right><b>Sub-Totals:</b></td><td>".number_format($totalPlacedCount)."</td><td>".number_format($totalUniqueCount)."</td></table>

</td><td valign=top align=center><a href=\"index.php?do=rwgAnalyzer&WorldName=$_GET[WorldName]&type=biomes\">biomes</a> | <a href=\"index.php?do=rwgAnalyzer&WorldName=$_GET[WorldName]&type=splat3\">splat3</a> | <a href=\"index.php?do=rwgAnalyzer&WorldName=$_GET[WorldName]&type=radiation\">radiation</a>
<img width=800 src=\"index.php?do=image&type=$_SESSION[type]&WorldName=".$_GET['WorldName']."\">
</td></tr></table>";





////////////////////////

return($rtn);
}

function buildPrefabGroupArray($RWGMIXER_PATH, $RWGMIXER_PATH_ALT)
{
  global $memory_db;
  exec('grep "prefab rule" "'.$RWGMIXER_PATH.'" | awk \'{print $2}\' | sort | uniq | cut -d\'"\' -f2', $array);
  foreach($array as $entry) if($entry!='') $GroupArray[]=$entry;
  exec('grep "prefab rule" "'.$RWGMIXER_PATH_ALT.'" | awk \'{print $2}\' | sort | uniq | cut -d\'"\' -f2', $array);
  foreach($array as $entry) if($entry!='') $GroupArray[]=$entry;
  $uniqArray=array_unique($GroupArray);
  foreach($uniqArray as $GroupName)
    {
      try {
      $memory_db->query("INSERT INTO Groups (GroupName) VALUES ('$GroupName')");
      
      } catch(PDOException $e) {
          exit($e->getMessage());
      }
      
    }
  return(array_unique($GroupArray));  
}





function findPrefabGroup($RWGMIXER_PATH, $PREFAB_NAME, $memory_db)
{
  global $memory_db;
  $fileArray=file($RWGMIXER_PATH);
  foreach($fileArray as $line)
    {
      if(strpos($line,'<prefab_rule name=')!==FALSE) 
        {
          $nameArray=explode('"',$line);
          $ruleName=str_replace('"','',$nameArray[1]);
        }
      if(strpos($line, $PREFAB_NAME)!==FALSE)
        {
          //echo "Found $PREFAB_NAME under $ruleName<br>";
          $memory_db->query("INSERT INTO PrefabGroups (Name,GroupName) VALUES ('$PREFAB_NAME','$ruleName')");
        }
    }
  return;
}

function ratio ($arg1, $arg2) { $diff=round($arg1/$arg2,1); return("$diff:1"); }
?>
