<!-- Oracle file for UBC CPSC304 Project Team 46
  Adapted from CPSC 304 demo
  Demo Created by Jiemin Zhang, Modified by Simona Radu, Modified by Jessica Wong (2018-06-22), Modified by Jason Hall (23-09-20)
  Modified by Tianai Zhong (2025-11-23)

  This file is the PHP application for Team 46's Adventure Game database.
  Specifically, it will drop a table, create a table, insert values update
  values, and then query for values
  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up All OCI commands are
  commands to the Oracle libraries. To get the file to work, you must place it
  somewhere where your Apache server can run it, and you must rename it to have
  a ".php" extension. You must also change the username and password on the
  oci_connect below to be your ORACLE username and password
-->

<?php
// The preceding tag tells the web server to parse the following text as PHP
// rather than HTML (the default)

// The following 3 lines allow PHP errors to be displayed along with the page
// content. Delete or comment out this block when it's no longer needed.
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Set some parameters

// Database access configuration
$config["dbuser"] = "ora_yli339";			// change "cwl" to your own CWL
$config["dbpassword"] = "a25684408";	// change to 'a' + your student number
$config["dbserver"] = "dbhost.students.cs.ubc.ca:1522/stu";
$db_conn = NULL;	// login credentials are used in connectToDB()

$success = true;	// keep track of errors so page redirects only if there are no errors

$show_debug_alert_messages = False; // show which methods are being triggered (see debugAlertMessage())

// The next tag tells the web server to stop parsing the text as PHP. Use the
// pair of tags wherever the content switches to PHP
?>

<html>

<head>
	<title>Adventure Game DataBase Demo (PHP/Oracle Demonstration) - CPSC 304 Team 46</title>
</head>

<body>
	<h2>Reset</h2>
	<p>If you wish to reset the table press on the reset button.</p>

	<form method="POST" action="oracle-app.php">
		<!-- "action" specifies the file or page that will receive the form data for processing. As with this example, it can be this same file. -->
		<input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
		<p><input type="submit" value="Reset" name="reset"></p>
	</form>

	<hr />

	<h2>Insert Items</h2>
	<p>
    	<b>Description:</b><br>
    	Use this form to add a new item to the game. 
    	Each item must have a unique name.  
    	If you choose to link the item to an enemy or a player, the enemy and player 
    	must already exist in the database.  
    	If they don't exist, the insert will fail and you will see an error message.  
    	This helps make sure all items are linked only to valid enemies and players.
	</p>

	    <form method="POST" action="oracle-app.php">
        <input type="hidden" id="insertRequest" name="insertRequest">
		Item Name: <input type="text" name="itemName"> <br /><br />
		Equip Level: <input type="number" name="equipLevel"> <br /><br />
		Enemy Name: <input type="text" name="enemyName"> <br /><br />
		Player Id: <input type="number" name="playerId"> <br /><br />
        <input type="submit" value="Insert" name="insertSubmit">
    </form>

    <hr />

	<h2>Update Enemy Name</h2>
	<p>
        <b>Description:</b><br>
    	This tool allows you to update which enemy drops a specific item.  
    	Enter the new enemy name and the item name you want to modify.  
    	If the enemy does not exist in the database, the update will fail due to
    	the foreign key constraint, ensuring data consistency.
    </p>

    <form method="POST" action="oracle-app.php">
        <input type="hidden" id="updateEnemyNameRequest" name="updateEnemyNameRequest">
		New Enemy Name: <input type="text" name="enemyName"> <br /><br />
		Item Name: <input type="text" name="itemName"> <br /><br />
        <input type="submit" value="Update" name="updateEnemyNameSubmit">
    </form>

    <hr />

	 <h2>Delete Items</h2>
    <p>
        <b>Description:</b><br>
    	Use this tool to remove an item from the game database.  
    	Just type the name of the item you want to delete, and the system will
    	take care of the rest.  
    </p>

    <form method="POST" action="oracle-app.php">
        <input type="hidden" id="deleteRequest" name="deleteRequest">
		Item Name: <input type="text" name="itemName"> <br /><br />
        <input type="submit" value="Delete" name="deleteSubmit">
    </form>

    <hr />

	<h2>Select Players</h2>
    <p>
        <b>Description:</b><br>
		Use this form to search for players based on their level and whether they are a leader.  
		You can choose a comparison operator (such as ≥, ≤, =), enter a level value, 
		and select if you want leaders or non-leaders.  
    </p>

	<form method="GET" action="oracle-app.php">
        <input type="hidden" id="selectionPlayersFixedRequest" name="selectionPlayersFixedRequest">
		<label>Equip Level</label>
		<select name="operator">
        	<option value=">=">&ge;</option>
        	<option value="<=">&le;</option>
        	<option value=">">></option>
        	<option value="<"><</option>
        	<option value="=">=</option>
    	</select>

   		<input type="number" name="levelValue" required>
		<br><br>
    	Leader Or Not?
    	<select name="leader">
        	<option value="Y">Yes</option>
        	<option value="N">No</option>
    	</select>

    	<br><br>
        <input type="submit" value="Select" name="selectionPlayersFixed">
    </form>

	<hr />
	
	<h2>Show Items / Equip Level / Enemy Name / Player ID</h2>
    <p>
        <b>Description:</b><br>
		This tool lets you choose which columns you want to display from the
		database. Instead of always showing all item information, you can pick 
		only the attributes you care about—such as just the item names, enemy names, or the player IDs.

    </p>

    <form method="GET" action="oracle-app.php">
    <input type="hidden" id="projectionItemsRequest" name="projectionItemsRequest">

    <label><input type="checkbox" name="attrs[]" value="item_name"> Item Name</label><br>
    <label><input type="checkbox" name="attrs[]" value="equip_level"> Equip Level</label><br>
    <label><input type="checkbox" name="attrs[]" value="enemy_name"> Enemy Name</label><br>
    <label><input type="checkbox" name="attrs[]" value="player_id"> Player ID</label><br><br>

    <input type="submit" value="Project" name="projectionItems">
	</form>

    <hr />


	<h2>Items & Enemies Info on all Maps</h2>
	<p>
		<b>Description:</b><br>
	This query combines information from three tables to show which items come from 
	which enemies, and on which maps those enemies appear.  
	You can enter a map name to filter the results and see only the items and enemies 
	found on that specific map.  

	<form method="GET" action="oracle-app.php">
        <input type="hidden" id="joinItemsEnemiesMapRequest" name="joinItemsEnemiesMapRequest">
        Map Name: <input type = "text" name = "mapName"> <br /><br />
		<input type="submit" value="Join" name="joinItemsEnemiesMap">
    </form>

	<hr />

	<h2>Number of Enemies on Each Map</h2>
    <p>
        <b>Description:</b><br>
	This query shows how many enemies are on each map.  
	It goes through every map and counts the enemies that appear there.  
	Even if a map has zero enemies, it will still show up in the results.  
	This makes it easy to compare how crowded or empty different maps are.
    </p>

    <form method="GET" action="oracle-app.php">
        <input type="hidden" id="groupByEnemiesRequest" name="groupByEnemiesRequest">
        <input type="submit" value="Group" name="groupByEnemies">
    </form>

    <hr />

	<h2>Maps with At Least One enemy</h2>
    <p>
		<b>Description:</b><br>
        This query finds all maps that have enemies on them.  
	It counts how many enemies appear on each map, and then shows only the maps 
	where the number is one or more.  
	In other words, it lists every map that is not empty and tells you how many enemies it contains.
    </p>

    <form method="GET" action="oracle-app.php">
        <input type="hidden" id="havingEnemiesRequest" name="havingEnemiesRequest">
        <input type="submit" value="Run" name="havingEnemies">
    </form>

    <hr />

	<h2>Guilds with the Highest average player level</h2>
    <p>
        <b>Description:</b><br>
	This query finds the guild or guilds with the highest average player level.  
	First, each guild's average player level is calculated using <code>GROUP BY</code>.  
	Then, the <code>HAVING</code> clause compares each guild's average to the averages of all other guilds.  
	Any guild whose average level is greater than or equal to every other guild's average is included in the result.  
	In other words, this nested aggregation identifies the top-performing guild(s) based on player level.
    </p>

    <form method="GET" action="oracle-app.php">
        <input type="hidden" id="nestedAggGuildRequest" name="nestedAggGuildRequest">
        <input type="submit" value="Run" name="nestedAggGuild">
    </form>

    <hr />


	<h2>Players who explored ALL maps</h2>
    <p>
        <b>Description:</b><br>
    	This query finds players who have explored <u>every</u> map in the game.  
    	For each player, it checks whether there is any map in <code>Map3</code> that the player
    	has not visited in the <code>explore</code> table.  
    	If no such “unvisited” map exists for that player, then the player has explored all maps
    	and is included in the result.  
    	This is an example of a division query: we are selecting players who cover the entire
    	set of maps.
    </p>

    <form method="GET" action="oracle-app.php">
        <input type="hidden" id="divisionPlayersAllMapsRequest" name="divisionPlayersAllMapsRequest">
        <input type="submit" value="Run" name="divisionPlayersAllMaps">
    </form>

    <hr />
	</p>


	<?php
	// The following code will be parsed as PHP

	function debugAlertMessage($message)
	{
		global $show_debug_alert_messages;

		if ($show_debug_alert_messages) {
			echo "<script type='text/javascript'>alert('" . $message . "');</script>";
		}
	}

	function executePlainSQL($cmdstr)
	{ //takes a plain (no bound variables) SQL command and executes it
		//echo "<br>running ".$cmdstr."<br>";
		global $db_conn, $success;

		$statement = oci_parse($db_conn, $cmdstr);
		//There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

		if (!$statement) {
			echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
			$e = OCI_Error($db_conn); // For oci_parse errors pass the connection handle
			echo htmlentities($e['message']);
			$success = False;
		}

		$r = oci_execute($statement, OCI_DEFAULT);
		if (!$r) {
			echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
			$e = oci_error($statement); // For oci_execute errors pass the statementhandle
			echo htmlentities($e['message']);
			$success = False;
		}

		return $statement;
	}

	function executeBoundSQL($cmdstr, $list)
	{
		/* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		In this case you don't need to create the statement several times. Bound variables cause a statement to only be
		parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		See the sample code below for how this function is used */

		global $db_conn, $success;
		$statement = oci_parse($db_conn, $cmdstr);

		if (!$statement) {
			echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
			$e = OCI_Error($db_conn);
			echo htmlentities($e['message']);
			$success = False;
		}

		foreach ($list as $tuple) {
			foreach ($tuple as $bind => $val) {
				//echo $val;
				//echo "<br>".$bind."<br>";
				oci_bind_by_name($statement, $bind, $val);
				unset($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
			}

			$r = oci_execute($statement, OCI_DEFAULT);
			if (!$r) {
				echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
				$e = OCI_Error($statement); // For oci_execute errors, pass the statementhandle
				echo htmlentities($e['message']);
				echo "<br>";
				$success = False;
			}
		}
	}

	// Print SELECT results as HTML table
	function printTable($result, $title)
	{
		echo "<h3>$title</h3>";
		echo "<table border='1'>";

		// Header row
		$ncols = oci_num_fields($result);
		echo "<tr>";
		for ($i = 1; $i <= $ncols; $i++) {
			$colname = oci_field_name($result, $i);
			echo "<th>" . htmlentities($colname) . "</th>";
		}
		echo "</tr>";

		// Data rows
		while (($row = oci_fetch_array($result, OCI_ASSOC + OCI_RETURN_NULLS)) != false) {
			echo "<tr>";
			foreach ($row as $item) {
				if ($item !== null) {
					echo "<td>" . htmlentities($item, ENT_QUOTES) . "</td>";
				} else {
					echo "<td>&nbsp;</td>";
				}
			}
			echo "</tr>";
		}

		echo "</table>";
	}


	function connectToDB()
	{
		global $db_conn;
		global $config;

		// Your username is ora_(CWL_ID) and the password is a(student number). For example,
		// ora_platypus is the username and a12345678 is the password.
		// $db_conn = oci_connect("ora_cwl", "a12345678", "dbhost.students.cs.ubc.ca:1522/stu");
		$db_conn = oci_connect($config["dbuser"], $config["dbpassword"], $config["dbserver"]);

		if ($db_conn) {
			debugAlertMessage("Database is Connected");
			return true;
		} else {
			debugAlertMessage("Cannot connect to Database");
			$e = OCI_Error(); // For oci_connect errors pass no handle
			echo htmlentities($e['message']);
			return false;
		}
	}

	function disconnectFromDB()
	{
		global $db_conn;

		debugAlertMessage("Disconnect from Database");
		oci_close($db_conn);
	}

	function handleUpdateRequest()
	{
		global $db_conn;

    	$enemyName = $_POST['enemyName'];
    	$itemName = $_POST['itemName']; 

    	$check = executePlainSQL("
        	SELECT 1 FROM dropping_own_Items 
        	WHERE item_name = '" . $itemName . "'
    	");

    	if (!OCI_Fetch_Array($check, OCI_NUM)) {
        	echo "<p><b>Error:</b> No such item found (item_name = " . htmlentities($itemName) . ").</p>";
        	return;
    	}


		$tuple = array(
        	":enemyName" => $enemyName,
        	":itemName" => $itemName
    	);

    	$alltuples = array($tuple);
		executeBoundSQL("UPDATE dropping_own_Items
        				 SET enemy_name = :enemyName
         				 WHERE item_name = :itemName",
        $alltuples);
		oci_commit($db_conn);
	}

	function handleResetRequest()
{
    global $db_conn;

    echo "<br>Resetting database...<br>";

    $dropStatements = [
        "DROP TABLE accept",
        "DROP TABLE has_Mission2",
        "DROP TABLE has_Mission1",
        "DROP TABLE know",
        "DROP TABLE NPC2",
        "DROP TABLE NPC1",
        "DROP TABLE Weapon",
        "DROP TABLE Armor",
        "DROP TABLE dropping_own_Items",
        "DROP TABLE has_enemy2",
        "DROP TABLE has_enemy1",
        "DROP TABLE explore",
        "DROP TABLE Map3",
        "DROP TABLE Map2",
        "DROP TABLE Map1",
        "DROP TABLE follow_Pet2",
        "DROP TABLE follow_Pet1",
        "DROP TABLE join_Player",
        "DROP TABLE Guild"
    ];

    foreach ($dropStatements as $sql) {
        $stid = @oci_parse($db_conn, $sql);
        if ($stid) {
            @oci_execute($stid, OCI_DEFAULT);
        }
    }

    // 2. Create tables one by one
    $createStatements = [

        "CREATE TABLE Guild(
            guild_level INTEGER,
            guild_id INT,
            guild_name VARCHAR(20),
            PRIMARY KEY (guild_id)
        )",

        "CREATE TABLE join_Player(
            player_id INTEGER PRIMARY KEY,
            player_name VARCHAR(20), 
            player_level INTEGER CHECK (player_level >= 1),
            leader CHAR(1) CHECK (leader IN ('Y','N')),
            guild_id INT NOT NULL,
            FOREIGN KEY (guild_id) REFERENCES Guild(guild_id)
                ON DELETE CASCADE
        )",

        "CREATE TABLE follow_Pet1(
            breed   VARCHAR(20) PRIMARY KEY,
            species VARCHAR(20)
        )",

        "CREATE TABLE follow_Pet2(
            pet_id     INTEGER,
            pet_name   VARCHAR(20),
            breed      VARCHAR(20),
            player_id  INTEGER NOT NULL,
            PRIMARY KEY (pet_id, player_id),
            UNIQUE (player_id),
            FOREIGN KEY (breed) REFERENCES follow_Pet1(breed)
                ON DELETE CASCADE,
            FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
                ON DELETE CASCADE
        )",

        "CREATE TABLE Map1(
            entry_level       INTEGER PRIMARY KEY,
            Number_of_enemies INTEGER,
            CHECK (entry_level >= 1)
        )",

        "CREATE TABLE Map2(
            terrain     VARCHAR(20) PRIMARY KEY,
            entry_level INTEGER NOT NULL CHECK (entry_level >= 1),
            FOREIGN KEY (entry_level) REFERENCES Map1(entry_level)
                ON DELETE CASCADE
        )",

        "CREATE TABLE Map3(
            map_name VARCHAR(20) PRIMARY KEY,
            terrain  VARCHAR(20),
            FOREIGN KEY (terrain) REFERENCES Map2(terrain)
                ON DELETE CASCADE
        )",

        "CREATE TABLE explore(
            number_of_visits   INTEGER CHECK (number_of_visits >= 0),
            first_visited_date VARCHAR(20),
            player_id          INTEGER,
            map_name           VARCHAR(20),
            PRIMARY KEY (map_name, player_id),
            FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
                ON DELETE CASCADE,
            FOREIGN KEY (map_name) REFERENCES Map3(map_name)
                ON DELETE CASCADE
        )",

        "CREATE TABLE has_enemy1(
            enemy_type  VARCHAR(20),
            enemy_health INTEGER CHECK (enemy_health >= 0),
            enemy_level  INTEGER CHECK (enemy_level >= 1),
            PRIMARY KEY (enemy_type, enemy_level)
        )",

        "CREATE TABLE has_enemy2(
            enemy_name  VARCHAR(20) PRIMARY KEY,
            enemy_level INTEGER CHECK (enemy_level >= 1) NOT NULL,
            map_name    VARCHAR(20),
            enemy_type  VARCHAR(20) NOT NULL,
            FOREIGN KEY (map_name) REFERENCES Map3(map_name)
                ON DELETE CASCADE,
            FOREIGN KEY (enemy_type, enemy_level)
                REFERENCES has_enemy1(enemy_type, enemy_level)
                ON DELETE CASCADE
        )",

        "CREATE TABLE dropping_own_Items (
            item_name  VARCHAR(20) PRIMARY KEY,
            equip_level INTEGER,
            enemy_name VARCHAR(20),
            player_id  INTEGER,
            FOREIGN KEY (enemy_name) REFERENCES has_enemy2(enemy_name)
                ON DELETE SET NULL,
            FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
                ON DELETE SET NULL
        )",

        "CREATE TABLE Weapon (
            item_name  VARCHAR(20) PRIMARY KEY,
            durability INTEGER,
            FOREIGN KEY (item_name) REFERENCES dropping_own_Items(item_name)
                ON DELETE CASCADE
        )",

        "CREATE TABLE Armor (
            item_name VARCHAR(20) PRIMARY KEY,
            health    INTEGER,
            FOREIGN KEY (item_name) REFERENCES dropping_own_Items(item_name)
                ON DELETE CASCADE
        )",

        "CREATE TABLE NPC1 (
            age    INTEGER PRIMARY KEY CHECK (age >= 1),
            health INTEGER CHECK (health >= 1)
        )",

        "CREATE TABLE NPC2 (
            npc_name VARCHAR(20) PRIMARY KEY,
            age      INTEGER NOT NULL CHECK (age >= 1),
            FOREIGN KEY (age) REFERENCES NPC1(age)
                ON DELETE CASCADE
        )",

        "CREATE TABLE know (
            npc_name  VARCHAR(20),
            player_id INTEGER,
            PRIMARY KEY (npc_name, player_id),
            FOREIGN KEY (npc_name) REFERENCES NPC2(npc_name)
                ON DELETE CASCADE,
            FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
                ON DELETE CASCADE
        )",

        "CREATE TABLE has_Mission1 (
            mission_level INTEGER PRIMARY KEY CHECK (mission_level >= 0),
            reward        VARCHAR(50)
        )",

        "CREATE TABLE has_Mission2 (	
            mission_name  VARCHAR(20) PRIMARY KEY,
            mission_level INTEGER,
            npc_name      VARCHAR(20) NOT NULL,
            FOREIGN KEY (mission_level) REFERENCES has_Mission1(mission_level)
                ON DELETE CASCADE,
            FOREIGN KEY (npc_name) REFERENCES NPC2(npc_name)
                ON DELETE CASCADE
        )",

        "CREATE TABLE accept (
            mission_name VARCHAR(20),
            player_id    INTEGER,
            PRIMARY KEY (mission_name, player_id),
            FOREIGN KEY (mission_name) REFERENCES has_Mission2(mission_name)
                ON DELETE CASCADE,
            FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
                ON DELETE CASCADE
        )"
    ];

    foreach ($createStatements as $sql) {
        executePlainSQL($sql);
    }

    oci_commit($db_conn);
    echo "<br>Schema recreated successfully.<br>";
}


	function handleInsertRequest()
	{
		global $db_conn;

		$tuple = array(
			":bind1" => $_POST['itemName'],
			":bind2" => $_POST['equipLevel'],
			":bind3" => $_POST['enemyName'],			
			":bind4" => $_POST['playerId'],
		);

		$alltuples = array(
			$tuple
		);

		executeBoundSQL("insert into dropping_own_Items (item_name, equip_level, enemy_name, player_id)
							values (:bind1, :bind2, :bind3, :bind4)", $alltuples);
		oci_commit($db_conn);
	}

	function handleDeleteRequest()
	{
		global $db_conn;

   		$itemName = $_POST['itemName'];

		$check = executePlainSQL(
        "SELECT 1 FROM dropping_own_Items WHERE item_name = '" . $itemName . "'"
    	);

    	if (!OCI_Fetch_Array($check, OCI_NUM)) {
        	echo "<p><b>Error:</b> Item <code>" . htmlentities($itemName) .
            	"</code> does not exist in <code>dropping_own_Items</code>.</p>";
        	return;
    	}

		$tuple = array(
        	":bind1" => $itemName
    	);

    	$alltuples = array($tuple);

    	executeBoundSQL(
        	"DELETE FROM dropping_own_Items WHERE item_name = :bind1",
        	$alltuples
    	);

    	oci_commit($db_conn);
	}

	function handleSelectionRequest()
	{
    	global $db_conn;

    	$op      = $_GET['operator'] ?? '>=';
    	$level   = $_GET['levelValue'] ?? null;
    	$leader  = $_GET['leader'] ?? null;

    	$levelNum = (int)$level;
    	$leaderVal = ($leader === 'Y') ? 'Y' : 'N';

    	$sql = "
        	SELECT player_id, player_name, player_level, leader, guild_id
        	FROM join_Player
        	WHERE player_level $op $levelNum
          	AND leader = '" . $leaderVal . "'
    	";

    	$result = executePlainSQL($sql);

    	printTable($result, "Selected players (player_level $op $levelNum AND leader = '$leaderVal')");
	}

	function handleDivisionRequest() {
		global $db_conn;

    	$sql = "
        	SELECT p.player_id, p.player_name
        	FROM join_Player p
        	WHERE NOT EXISTS (
            	SELECT m.map_name
            	FROM Map3 m
            	WHERE NOT EXISTS (
                	SELECT *
                	FROM explore e
                	WHERE e.player_id = p.player_id
                  	AND e.map_name = m.map_name
            	)
        	)
    	";

    	$result = executePlainSQL($sql);

    	printTable($result, "Players who have explored ALL maps");
	}

	function handleNestedRequest()
	{
    	global $db_conn;

    	$sql = "
        	SELECT g.guild_name, AVG(p.player_level) AS avg_player_level
        	FROM Guild g 
        	JOIN join_Player p ON g.guild_id = p.guild_id
        	GROUP BY g.guild_name
        	HAVING AVG(p.player_level) >= ALL (
            	SELECT AVG(p2.player_level)
            	FROM join_Player p2
            	GROUP BY p2.guild_id)
    	";

    	$result = executePlainSQL($sql);

    	printTable($result, "Guild(s) with the highest average player level");
	}

	function handleHavingRequest()
	{
    	global $db_conn;

    	$sql = "
        	SELECT he2.map_name, COUNT(*) AS num_enemies
        	FROM has_enemy2 he2
        	GROUP BY he2.map_name
        	HAVING COUNT(*) >= 1
    	";

    	$result = executePlainSQL($sql);

    	printTable($result, "Maps that have at least one enemy");
	}

	function handleGroupByRequest()
	{
    	global $db_conn;

    	$sql = "
        	SELECT m3.map_name, COUNT(he2.enemy_name) AS num_enemies
        	FROM Map3 m3
        	LEFT JOIN has_enemy2 he2 ON m3.map_name = he2.map_name
        	GROUP BY m3.map_name
    	";

    	$result = executePlainSQL($sql);

    	printTable($result, "Number of enemies on each map");
	}

	function handleJoinRequest()
	{
		global $db_conn;

		$mapName = isset($_GET['mapName']) ? trim($_GET['mapName']) : '';
		
		$sql = "
        SELECT doi.item_name,
               doi.equip_level,
               he2.enemy_name,
               he2.enemy_type,
               m3.map_name
        FROM dropping_own_Items doi
        JOIN has_enemy2 he2
          ON doi.enemy_name = he2.enemy_name
        JOIN Map3 m3
          ON he2.map_name = m3.map_name
        WHERE m3.map_name = '" . $mapName . "'
    	";

    	$result = executePlainSQL($sql);

    	printTable($result, "Items and enemies on map: " . htmlentities($mapName));
	}

	function handleProjectionRequest() 
	{
		global $db_conn;

    	if (!isset($_GET['attrs']) || count($_GET['attrs']) === 0) {
        	echo "<p style='color:red;'><b>Error:</b> You must select at least one attribute to project.</p>";
        	return;
    	}

    	$attrs = $_GET['attrs'];

    	$validColumns = ["item_name", "equip_level", "enemy_name", "player_id"];

    	$selected = array_filter($attrs, function ($col) use ($validColumns) {
        	return in_array($col, $validColumns);
    	});

    	if (empty($selected)) {
        	echo "<p style='color:red;'><b>Error:</b> No valid attributes selected.</p>";
        	return;
    	}

    	$columnList = implode(", ", $selected);
    	$sql = "SELECT $columnList FROM dropping_own_Items";

    	$result = executePlainSQL($sql);

    	$title = "Projection: " . htmlentities($columnList);
    	printTable($result, $title);
	}


	// HANDLE ALL POST ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
	function handlePOSTRequest()
	{
		if (connectToDB()) {
			try {
			if (array_key_exists('resetTablesRequest', $_POST)) {
				handleResetRequest();
			} else if (array_key_exists('updateEnemyNameSubmit', $_POST)) {
				handleUpdateRequest();
			} else if (array_key_exists('insertRequest', $_POST)) {
				handleInsertRequest();
			} else if (array_key_exists('deleteRequest', $_POST)) {
				handleDeleteRequest();
			}
		} finally {
			disconnectFromDB();
		}
		} 
	}

	// HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
	function handleGETRequest()
	{
		if (connectToDB()) {
			try {
			if (array_key_exists('selectionPlayersFixedRequest', $_GET)) {
				handleSelectionRequest();
			} elseif (array_key_exists('joinItemsEnemiesMapRequest', $_GET)) {
				handleJoinRequest();
			} elseif (array_key_exists('groupByEnemiesRequest', $_GET)) {
				handleGroupByRequest();
			} elseif (array_key_exists('havingEnemiesRequest', $_GET)) {
				handleHavingRequest();
			} elseif (array_key_exists('nestedAggGuildRequest', $_GET)) {
				handleNestedRequest();
			} elseif (array_key_exists('divisionPlayersAllMapsRequest', $_GET)) {
				handleDivisionRequest();
			} elseif (array_key_exists('projectionItemsRequest', $_GET)) {
                handleProjectionRequest();
            }
		} finally {
			disconnectFromDB();
		}
		}
	}

	if (isset($_POST['reset']) || isset($_POST['updateEnemyNameSubmit']) || 
			isset($_POST['insertSubmit']) || isset($_POST['deleteSubmit'])) {
		handlePOSTRequest();
	} else if (isset($_GET['selectionPlayersFixed']) ||
    	isset($_GET['joinItemsEnemiesMap']) ||
    	isset($_GET['groupByEnemies']) ||
    	isset($_GET['havingEnemies']) ||
    	isset($_GET['nestedAggGuild']) ||
    	isset($_GET['divisionPlayersAllMaps']) ||
        isset($_GET['projectionItems'])) {
			handleGETRequest();
	}

	// End PHP parsing and send the rest of the HTML content
	?>
</body>


</html>
