<?php 

include "modmgr.inc.php";
include "servercontrol.inc.php";

session_start();

// Pull the server's telnet password.
$server_password=exec("grep -i TelnetPassword /data/7DTD/serverconfig.xml | cut -d= -f3 | cut -d'\"' -f2");
if($_POST['Password']!='' && $_POST['Submit']!='' && $server_password==$_POST['Password']) 
  { $_SESSION['password']=$_POST['Password']; setcookie('password',$_POST['Password']); }
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

// Main Switch to allow this single page to act as multiple pages
switch(@$_GET['do'])
{
  // The default page to show should be the Active/Deactivate Modlets page (aka the Mod Manager/ModMgr)
  default:
  case "modmgr":
  $main="<h3>Activate/Deactivate Modlets</h3>Select the Modlets that you would like to enable by simple checking the box next to it. 
  You will need to stop and start your server for any changes to this list to activate.<br>".SDD_ModMgr();
  break;
  
  // The server status sub-page
  case "serverstatus": servercontrol(); exit; break;
  
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
   <textarea style=\"width:100%;height:80%\" name=fileContents>";
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

mainscreen(top_row(), $main);

/***********************************/
/***********************************/

function mainscreen($top, $main)
{
?>
<html>
  <head>
    <title>7DTD-SMM: <?php echo readConfigValue('ServerName'); ?></title>
    <style type="text/css">
    /*************
    Default Theme
    *************/
    /* overall */
    .tablesorter-default {
    	width: 100%;
    	font: 12px/18px Arial, Sans-serif;
    	color: #333;
    	background-color: #525252;
    	border-spacing: 0;
    	margin: 10px 0 15px;
    	text-align: left;
    }

    /* header */
    .tablesorter-default th {
      font-weight: bold;
    	color: #ffffff;
    	background-color: #615f5f;
    	border-collapse: collapse;
    	border-bottom: #ccc 2px solid;
    	padding: 0;
      font: 16px Arial, Sans-serif;      
    }
    .tablesorter-default thead td {
    	font-weight: bold;
    	color: #ffffff;
    	background-color: #615f5f;
    	border-collapse: collapse;
    	border-bottom: #ccc 2px solid;
    	padding: 0;
    }
    .tablesorter-default tfoot th,
    .tablesorter-default tfoot td {
    	border: 0;
    }
    .tablesorter-default .header,
    .tablesorter-default .tablesorter-header {
    	background-image: url(data:image/gif;base64,R0lGODlhFQAJAIAAACMtMP///yH5BAEAAAEALAAAAAAVAAkAAAIXjI+AywnaYnhUMoqt3gZXPmVg94yJVQAAOw==);
    	background-position: center right;
    	background-repeat: no-repeat;
    	cursor: pointer;
    	white-space: normal;
    	padding: 4px 20px 4px 4px;
    }
    .tablesorter-default thead .headerSortUp,
    .tablesorter-default thead .tablesorter-headerSortUp,
    .tablesorter-default thead .tablesorter-headerAsc {
    	background-image: url(data:image/gif;base64,R0lGODlhFQAEAIAAACMtMP///yH5BAEAAAEALAAAAAAVAAQAAAINjI8Bya2wnINUMopZAQA7);
    	border-bottom: #000 2px solid;
    }
    .tablesorter-default thead .headerSortDown,
    .tablesorter-default thead .tablesorter-headerSortDown,
    .tablesorter-default thead .tablesorter-headerDesc {
    	background-image: url(data:image/gif;base64,R0lGODlhFQAEAIAAACMtMP///yH5BAEAAAEALAAAAAAVAAQAAAINjB+gC+jP2ptn0WskLQA7);
    	border-bottom: #000 2px solid;
    }
    .tablesorter-default thead .sorter-false {
    	background-image: none;
    	cursor: default;
    	padding: 4px;
    }

    /* tfoot */
    .tablesorter-default tfoot .tablesorter-headerSortUp,
    .tablesorter-default tfoot .tablesorter-headerSortDown,
    .tablesorter-default tfoot .tablesorter-headerAsc,
    .tablesorter-default tfoot .tablesorter-headerDesc {
    	border-top: #000 2px solid;
    }

    /* tbody */
    .tablesorter-default td {
    	background-color: #fff;
    	border-bottom: #ccc 1px solid;
    	padding: 4px;
    	vertical-align: top;
    }

    /* hovered row colors */
    .tablesorter-default tbody > tr.hover > td,
    .tablesorter-default tbody > tr:hover > td,
    .tablesorter-default tbody > tr.even:hover > td,
    .tablesorter-default tbody > tr.odd:hover > td {
    	background-color: #fff;
    	color: #000;
    }

    /* table processing indicator */
    .tablesorter-default .tablesorter-processing {
    	background-position: center center !important;
    	background-repeat: no-repeat !important;
    	/* background-image: url(images/loading.gif) !important; */
    	background-image: url('data:image/gif;base64,R0lGODlhFAAUAKEAAO7u7lpaWgAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh+QQBCgACACwAAAAAFAAUAAACQZRvoIDtu1wLQUAlqKTVxqwhXIiBnDg6Y4eyx4lKW5XK7wrLeK3vbq8J2W4T4e1nMhpWrZCTt3xKZ8kgsggdJmUFACH5BAEKAAIALAcAAAALAAcAAAIUVB6ii7jajgCAuUmtovxtXnmdUAAAIfkEAQoAAgAsDQACAAcACwAAAhRUIpmHy/3gUVQAQO9NetuugCFWAAAh+QQBCgACACwNAAcABwALAAACE5QVcZjKbVo6ck2AF95m5/6BSwEAIfkEAQoAAgAsBwANAAsABwAAAhOUH3kr6QaAcSrGWe1VQl+mMUIBACH5BAEKAAIALAIADQALAAcAAAIUlICmh7ncTAgqijkruDiv7n2YUAAAIfkEAQoAAgAsAAAHAAcACwAAAhQUIGmHyedehIoqFXLKfPOAaZdWAAAh+QQFCgACACwAAAIABwALAAACFJQFcJiXb15zLYRl7cla8OtlGGgUADs=') !important;
    }

    /* Zebra Widget - row alternating colors */
    .tablesorter-default tr.odd > td {
    	background-color: #bdb48a;
    }
    .tablesorter-default tr.even > td {
    	background-color: #c7524c;
    }

    /* Column Widget - column sort colors */
    .tablesorter-default tr.odd td.primary {
    	background-color: #bfbfbf;
    }
    .tablesorter-default td.primary,
    .tablesorter-default tr.even td.primary {
    	background-color: #d9d9d9;
    }
    .tablesorter-default tr.odd td.secondary {
    	background-color: #d9d9d9;
    }
    .tablesorter-default td.secondary,
    .tablesorter-default tr.even td.secondary {
    	background-color: #e6e6e6;
    }
    .tablesorter-default tr.odd td.tertiary {
    	background-color: #e6e6e6;
    }
    .tablesorter-default td.tertiary,
    .tablesorter-default tr.even td.tertiary {
    	background-color: #f2f2f2;
    }

    /* caption */
    .tablesorter-default > caption {
    	background-color: #fff;
    }

    /* filter widget */
    .tablesorter-default .tablesorter-filter-row {
    	background-color: #eee;
    }
    .tablesorter-default .tablesorter-filter-row td {
    	background-color: #eee;
    	border-bottom: #ccc 1px solid;
    	line-height: normal;
    	text-align: center; /* center the input */
    	-webkit-transition: line-height 0.1s ease;
    	-moz-transition: line-height 0.1s ease;
    	-o-transition: line-height 0.1s ease;
    	transition: line-height 0.1s ease;
    }
    /* optional disabled input styling */
    .tablesorter-default .tablesorter-filter-row .disabled {
    	opacity: 0.5;
    	filter: alpha(opacity=50);
    	cursor: not-allowed;
    }
    /* hidden filter row */
    .tablesorter-default .tablesorter-filter-row.hideme td {
    	/*** *********************************************** ***/
    	/*** change this padding to modify the thickness     ***/
    	/*** of the closed filter row (height = padding x 2) ***/
    	padding: 2px;
    	/*** *********************************************** ***/
    	margin: 0;
    	line-height: 0;
    	cursor: pointer;
    }
    .tablesorter-default .tablesorter-filter-row.hideme * {
    	height: 1px;
    	min-height: 0;
    	border: 0;
    	padding: 0;
    	margin: 0;
    	/* don't use visibility: hidden because it disables tabbing */
    	opacity: 0;
    	filter: alpha(opacity=0);
    }
    /* filters */
    .tablesorter-default input.tablesorter-filter,
    .tablesorter-default select.tablesorter-filter {
    	width: 95%;
    	height: auto;
    	margin: 4px auto;
    	padding: 4px;
    	background-color: #fff;
    	border: 1px solid #bbb;
    	color: #333;
    	-webkit-box-sizing: border-box;
    	-moz-box-sizing: border-box;
    	box-sizing: border-box;
    	-webkit-transition: height 0.1s ease;
    	-moz-transition: height 0.1s ease;
    	-o-transition: height 0.1s ease;
    	transition: height 0.1s ease;
    }
    /* rows hidden by filtering (needed for child rows) */
    .tablesorter .filtered {
    	display: none;
    }

    /* ajax error row */
    .tablesorter .tablesorter-errorRow td {
    	text-align: center;
    	cursor: pointer;
    	background-color: #e6bf99;
    }

    </style> 
     
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script> 
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.9.1/jquery.tablesorter.min.js"></script>

    <script>
    $(function(){
      $("#myDummyTable").tablesorter({
       widgets: ['zebra'],
       sortList : [[1,0]]
       });
    });
      
    </script>
  </head>
<body>
    <div style="width:100%; padding: 0px;"><?php echo $top; ?></div>
    <?php echo $main; ?>

</body>
</html>
<?php
}

function top_row()
{
$top="
<table cellspacing=0 cellpadding=3 width=100% border=0>
<tr>
  <td rowspan=2 width=280><a href=index.php><img src=7dtd_logo.png width=260 border=0></a></td>

  <td colspan=4 height=50><b><font size=5>".readConfigValue('ServerName')."</font></b><br>
  <iframe src=index.php?do=serverstatus width=300 height=60 frameborder=2 scrolling=no></iframe>
  </td>
</tr>
<tr>  
  <td><p><a href=index.php?do=modmgr><font size=4><b>Enable/Disable Modlets</b></font></a></p></td>
  <td><p><a href=index.php?do=editFile&editFile=../7dtd.log&full=1><font size=4><b>View 7DTD Log</b></font></a></p></td>
  <td><p><a href=index.php?do=editConfig><font size=4><b>Edit Configs</b></font></a></p></td>
  <td><p><a href=index.php?smmupdate=1><font size=4><b>Update ServerMod Manager</b></font></a></p></td>
</tr>
</table>
";

return $top;
}




?>