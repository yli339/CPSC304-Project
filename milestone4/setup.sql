DROP TABLE accept;
DROP TABLE has_Mission2;
DROP TABLE has_Mission1;
DROP TABLE know;
DROP TABLE NPC2;
DROP TABLE NPC1;
DROP TABLE Weapon;
DROP TABLE Armor;
DROP TABLE dropping_own_Items;
DROP TABLE has_enemy2;
DROP TABLE has_enemy1;
DROP TABLE explore;
DROP TABLE Map3;
DROP TABLE Map2;
DROP TABLE Map1;
DROP TABLE follow_Pet2;
DROP TABLE follow_Pet1;
DROP TABLE join_Player;
DROP TABLE Guild;

CREATE TABLE Guild(
    guild_level INTEGER,
    guild_id INT,
    guild_name VARCHAR(20),
    PRIMARY KEY (guild_id)
);

CREATE TABLE join_Player(
	player_id INTEGER PRIMARY KEY,
	player_name VARCHAR(20), 
	player_level INTEGER CHECK (player_level >= 1),
	leader CHAR(1) CHECK (leader IN ('Y','N')),
	guild_id INT NOT NULL,
	FOREIGN KEY (guild_id) REFERENCES Guild(guild_id)
	ON DELETE CASCADE
);

CREATE TABLE follow_Pet1(
    breed   VARCHAR(20) PRIMARY KEY,
    species VARCHAR(20)
);

CREATE TABLE follow_Pet2(
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
);

CREATE TABLE Map1(
    entry_level       INTEGER PRIMARY KEY,
    Number_of_enemies INTEGER,
    CHECK (entry_level >= 1)
);

CREATE TABLE Map2(
    terrain     VARCHAR(20) PRIMARY KEY,
    entry_level INTEGER NOT NULL CHECK (entry_level >= 1),
    FOREIGN KEY (entry_level) REFERENCES Map1(entry_level)
        ON DELETE CASCADE
);

CREATE TABLE Map3(
    map_name VARCHAR(20) PRIMARY KEY,
    terrain  VARCHAR(20),
    FOREIGN KEY (terrain) REFERENCES Map2(terrain)
        ON DELETE CASCADE
);

CREATE TABLE explore(
    number_of_visits   INTEGER CHECK (number_of_visits >= 0),
    first_visited_date VARCHAR(20),
    player_id          INTEGER,
    map_name           VARCHAR(20),
    PRIMARY KEY (map_name, player_id),
    FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
        ON DELETE CASCADE,
    FOREIGN KEY (map_name) REFERENCES Map3(map_name)
        ON DELETE CASCADE
);

CREATE TABLE has_enemy1(
    enemy_type  VARCHAR(20),
    enemy_health INTEGER CHECK (enemy_health >= 0),
    enemy_level  INTEGER CHECK (enemy_level >= 1),
    PRIMARY KEY (enemy_type, enemy_level)
);

CREATE TABLE has_enemy2(
    enemy_name  VARCHAR(20) PRIMARY KEY,
    enemy_level INTEGER CHECK (enemy_level >= 1) NOT NULL,
    map_name    VARCHAR(20),
    enemy_type  VARCHAR(20) NOT NULL,
    FOREIGN KEY (map_name) REFERENCES Map3(map_name)
        ON DELETE CASCADE,
    FOREIGN KEY (enemy_type, enemy_level)
        REFERENCES has_enemy1(enemy_type, enemy_level)
        ON DELETE CASCADE
);

CREATE TABLE dropping_own_Items (
    item_name  VARCHAR(20) PRIMARY KEY,
    equip_level INTEGER,
    enemy_name VARCHAR(20),
    player_id  INTEGER,
    FOREIGN KEY (enemy_name) REFERENCES has_enemy2(enemy_name)
        ON DELETE SET NULL,
    FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
        ON DELETE SET NULL
);

CREATE TABLE Weapon (
    item_name  VARCHAR(20) PRIMARY KEY,
    durability INTEGER,
    FOREIGN KEY (item_name) REFERENCES dropping_own_Items(item_name)
        ON DELETE CASCADE
);

CREATE TABLE Armor (
    item_name VARCHAR(20) PRIMARY KEY,
    health    INTEGER,
    FOREIGN KEY (item_name) REFERENCES dropping_own_Items(item_name)
        ON DELETE CASCADE
);

CREATE TABLE NPC1 (
    age    INTEGER PRIMARY KEY CHECK (age >= 1),
    health INTEGER CHECK (health >= 1)
);

CREATE TABLE NPC2 (
    npc_name VARCHAR(20) PRIMARY KEY,
    age      INTEGER NOT NULL CHECK (age >= 1),
    FOREIGN KEY (age) REFERENCES NPC1(age)
        ON DELETE CASCADE
);

CREATE TABLE know (
    npc_name  VARCHAR(20),
    player_id INTEGER,
    PRIMARY KEY (npc_name, player_id),
    FOREIGN KEY (npc_name) REFERENCES NPC2(npc_name)
        ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
        ON DELETE CASCADE
);

CREATE TABLE has_Mission1 (
    mission_level INTEGER PRIMARY KEY CHECK (mission_level >= 0),
    reward        VARCHAR(50)
);

CREATE TABLE has_Mission2 (	
    mission_name  VARCHAR(20) PRIMARY KEY,
    mission_level INTEGER,
    npc_name      VARCHAR(20) NOT NULL,
    FOREIGN KEY (mission_level) REFERENCES has_Mission1(mission_level)
        ON DELETE CASCADE,
    FOREIGN KEY (npc_name) REFERENCES NPC2(npc_name)
        ON DELETE CASCADE
);

CREATE TABLE accept (
    mission_name VARCHAR(20),
    player_id    INTEGER,
    PRIMARY KEY (mission_name, player_id),
    FOREIGN KEY (mission_name) REFERENCES has_Mission2(mission_name)
        ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES join_Player(player_id)
        ON DELETE CASCADE
);


insert into Guild values (2, 1, 'First');
insert into Guild values (4, 2, 'Second');
insert into Guild values (5, 3, 'Third');
insert into Guild values (5, 4, 'Fourth');
insert into Guild values (6, 5, 'Fifth');


insert into join_Player values (1, 'Alice', 1, 'Y', 1);
insert into join_Player values (2, 'Bob', 2, 'N', 1);
insert into join_Player values (3, 'David', 3, 'Y', 2);
insert into join_Player values (4, 'Jonny', 4, 'Y', 2);
insert into join_Player values (5, 'Kitty', 3, 'N', 3);

insert into follow_Pet1 values ('DireWolf', 'Wolf');
insert into follow_Pet1 values ('FireHawk', 'Bird');
insert into follow_Pet1 values ('ShadowCat', 'Feline');
insert into follow_Pet1 values ('IronBoar', 'Boar');
insert into follow_Pet1 values ('FrostBear', 'Bear');
insert into follow_Pet1 values ('StoneDog', 'Dog');


insert into follow_Pet2 values (1, 'Lupus',   'DireWolf', 1);
insert into follow_Pet2 values (2, 'Blaze',   'FireHawk', 2);
insert into follow_Pet2 values (3, 'Saber',   'ShadowCat',3);
insert into follow_Pet2 values (4, 'Tusk',    'IronBoar', 4);
insert into follow_Pet2 values (5, 'IcePaw',  'FrostBear',5);


insert into Map1 values (1, 10);
insert into Map1 values (5, 15);
insert into Map1 values (10, 20);
insert into Map1 values (15, 25);
insert into Map1 values (20, 30);

insert into Map2 values ('Forest',   1);
insert into Map2 values ('Desert',   5);
insert into Map2 values ('Mountain', 10);
insert into Map2 values ('Swamp',    15);
insert into Map2 values ('Volcano',  20);

insert into Map3 values ('Greenwood',    'Forest');
insert into Map3 values ('Sands of Time','Desert');
insert into Map3 values ('Iron Peaks',   'Mountain');
insert into Map3 values ('Murkfen',      'Swamp');
insert into Map3 values ('Lava Fields',  'Volcano');


insert into explore values (5, '2025-01-15', 1, 'Greenwood');
insert into explore values (3, '2025-02-10', 2, 'Sands of Time');
insert into explore values (7, '2025-03-05', 3, 'Iron Peaks');
insert into explore values (2, '2025-04-12', 4, 'Murkfen');
insert into explore values (4, '2025-05-20', 5, 'Lava Fields');


insert into has_enemy1 values ('Goblin', 50,  1);
insert into has_enemy1 values ('Troll',  100, 5);
insert into has_enemy1 values ('Orc',    150, 10);
insert into has_enemy1 values ('Dragon', 200, 15);
insert into has_enemy1 values ('Demon',  250, 20);


insert into has_enemy2 values ('Gobbo',       1,  'Greenwood',    'Goblin');
insert into has_enemy2 values ('TrollKing',   5,  'Sands of Time','Troll');
insert into has_enemy2 values ('OrcWarlord',  10, 'Iron Peaks',   'Orc');
insert into has_enemy2 values ('FireDrake',   15, 'Murkfen',      'Dragon');
insert into has_enemy2 values ('Hellspawn',   20, 'Lava Fields',  'Demon');


insert into dropping_own_Items values ('IronSword',  5,  'Gobbo',      1);
insert into dropping_own_Items values ('FireStaff', 10,  'TrollKing',  2);
insert into dropping_own_Items values ('WarAxe',    15,  'OrcWarlord', 3);
insert into dropping_own_Items values ('DragonBow', 20,  'FireDrake',  4);
insert into dropping_own_Items values ('DemonBlade',25,  'Hellspawn',  5);

INSERT INTO dropping_own_Items VALUES ('OrcShield', 12, 'OrcWarlord', 3);
INSERT INTO dropping_own_Items VALUES ('OrcHelmet', 8, 'OrcWarlord', 3);

INSERT INTO dropping_own_Items VALUES ('GoblinDagger', 3, 'Gobbo', 1);
INSERT INTO dropping_own_Items VALUES ('GoblinHammer', 7, 'Gobbo', 2);

INSERT INTO dropping_own_Items VALUES ('TrollClub', 6, 'TrollKing', 2);
INSERT INTO dropping_own_Items VALUES ('DrakeFang', 18, 'FireDrake', 4);
INSERT INTO dropping_own_Items VALUES ('DemonHorn', 28, 'Hellspawn', 5);
INSERT INTO dropping_own_Items VALUES ('ShadowWraithBlade', 32, 'ShadowWraith', 6);
INSERT INTO dropping_own_Items VALUES ('TitanGolemShield', 38, 'TitanGolem', 7);
INSERT INTO dropping_own_Items VALUES ('SkyHarpyClaw', 42, 'SkyHarpy', 8);
INSERT INTO dropping_own_Items VALUES ('ReaperDarkScythe', 48, 'SoulReaper', 9);
INSERT INTO dropping_own_Items VALUES ('AncientSpiritStone', 55, 'PrimordialSpirit', 10);

INSERT INTO dropping_own_Items VALUES ('MythrilArmor', 30, NULL, NULL);
INSERT INTO dropping_own_Items VALUES ('ObsidianShield', 33, NULL, NULL);


insert into dropping_own_Items values ('LeatherArmor',  1,  null, null);
insert into dropping_own_Items values ('ChainMail',     5,  null, null);
insert into dropping_own_Items values ('PlateArmor',    10, null, null);
insert into dropping_own_Items values ('DragonScale',   15, null, null);
insert into dropping_own_Items values ('DemonHide',     20, null, null);

insert into Weapon values ('IronSword',  100);
insert into Weapon values ('FireStaff',  80);
insert into Weapon values ('WarAxe',     90);
insert into Weapon values ('DragonBow',  70);

INSERT INTO Guild VALUES (3, 6, 'Sixth');
INSERT INTO Guild VALUES (7, 7, 'Seventh');
INSERT INTO Guild VALUES (8, 8, 'EliteGuard');
INSERT INTO Guild VALUES (9, 9, 'Mythic');
INSERT INTO Guild VALUES (10, 10, 'Legendary');

INSERT INTO join_Player VALUES (6, 'Eve', 5, 'N', 4);
INSERT INTO join_Player VALUES (7, 'Frank', 6, 'Y', 4);
INSERT INTO join_Player VALUES (8, 'Grace', 2, 'N', 5);
INSERT INTO join_Player VALUES (9, 'Helen', 7, 'Y', 6);
INSERT INTO join_Player VALUES (10, 'Ivan', 8, 'N', 7);
INSERT INTO join_Player VALUES (11, 'Judy', 4, 'N', 7);
INSERT INTO join_Player VALUES (12, 'Karl', 6, 'N', 8);
INSERT INTO join_Player VALUES (13, 'Liam', 9, 'Y', 9);
INSERT INTO join_Player VALUES (14, 'Mia', 3, 'N', 9);
INSERT INTO join_Player VALUES (15, 'Nina', 10, 'Y', 10);

INSERT INTO follow_Pet1 VALUES ('ThunderWolf', 'Wolf');
INSERT INTO follow_Pet1 VALUES ('SkySerpent', 'Serpent');
INSERT INTO follow_Pet1 VALUES ('NightStalker', 'Feline');
INSERT INTO follow_Pet1 VALUES ('StoneRam', 'Ram');
INSERT INTO follow_Pet1 VALUES ('VenomFang', 'Snake');

INSERT INTO follow_Pet2 VALUES (6, 'Storm', 'ThunderWolf', 6);
INSERT INTO follow_Pet2 VALUES (7, 'Nimbus', 'SkySerpent', 7);
INSERT INTO follow_Pet2 VALUES (8, 'Shade', 'NightStalker', 8);
INSERT INTO follow_Pet2 VALUES (9, 'Boulder', 'StoneRam', 9);
INSERT INTO follow_Pet2 VALUES (10, 'Fang', 'VenomFang', 10);

INSERT INTO Map1 VALUES (25, 40);
INSERT INTO Map1 VALUES (30, 50);
INSERT INTO Map1 VALUES (35, 60);
INSERT INTO Map1 VALUES (40, 75);
INSERT INTO Map1 VALUES (50, 100);

INSERT INTO Map2 VALUES ('CrystalCave', 25);
INSERT INTO Map2 VALUES ('FrozenTundra', 30);
INSERT INTO Map2 VALUES ('SkyRuins', 35);
INSERT INTO Map2 VALUES ('ShadowRealm', 40);
INSERT INTO Map2 VALUES ('AncientValley', 50);

INSERT INTO Map3 VALUES ('Crystal Depths', 'CrystalCave');
INSERT INTO Map3 VALUES ('Frost Hollow', 'FrozenTundra');
INSERT INTO Map3 VALUES ('Temple of Winds', 'SkyRuins');
INSERT INTO Map3 VALUES ('Eternal Shade', 'ShadowRealm');
INSERT INTO Map3 VALUES ('Valley of Ancients', 'AncientValley');

INSERT INTO explore VALUES (6, '2025-06-01', 6, 'Crystal Depths');
INSERT INTO explore VALUES (4, '2025-06-03', 7, 'Frost Hollow');
INSERT INTO explore VALUES (5, '2025-06-05', 8, 'Temple of Winds');
INSERT INTO explore VALUES (3, '2025-06-10', 9, 'Eternal Shade');
INSERT INTO explore VALUES (7, '2025-06-12', 10, 'Valley of Ancients');

INSERT INTO has_enemy1 VALUES ('Wraith', 180, 25);
INSERT INTO has_enemy1 VALUES ('Golem', 300, 30);
INSERT INTO has_enemy1 VALUES ('Harpy', 120, 35);
INSERT INTO has_enemy1 VALUES ('Reaper', 400, 40);
INSERT INTO has_enemy1 VALUES ('AncientSpirit', 500, 50);

INSERT INTO has_enemy2 VALUES ('ShadowWraith', 25, 'Eternal Shade', 'Wraith');
INSERT INTO has_enemy2 VALUES ('TitanGolem', 30, 'Crystal Depths', 'Golem');
INSERT INTO has_enemy2 VALUES ('SkyHarpy', 35, 'Temple of Winds', 'Harpy');
INSERT INTO has_enemy2 VALUES ('SoulReaper', 40, 'Frost Hollow', 'Reaper');
INSERT INTO has_enemy2 VALUES ('PrimordialSpirit', 50, 'Valley of Ancients', 'AncientSpirit');

INSERT INTO dropping_own_Items VALUES ('WraithBlade', 30, 'ShadowWraith', 6);
INSERT INTO dropping_own_Items VALUES ('GolemHammer', 35, 'TitanGolem', 7);
INSERT INTO dropping_own_Items VALUES ('HarpyWingbow', 40, 'SkyHarpy', 8);
INSERT INTO dropping_own_Items VALUES ('ReaperScythe', 45, 'SoulReaper', 9);
INSERT INTO dropping_own_Items VALUES ('SpiritOrb', 50, 'PrimordialSpirit', 10);

INSERT INTO dropping_own_Items VALUES ('SilverArmor', 12, NULL, NULL);
INSERT INTO dropping_own_Items VALUES ('GoldArmor', 18, NULL, NULL);
INSERT INTO dropping_own_Items VALUES ('CrystalShield', 22, NULL, NULL);
INSERT INTO dropping_own_Items VALUES ('WindCape', 16, NULL, NULL);

INSERT INTO Weapon VALUES ('WraithBlade', 150);
INSERT INTO Weapon VALUES ('GolemHammer', 200);
INSERT INTO Weapon VALUES ('HarpyWingbow', 120);
INSERT INTO Weapon VALUES ('ReaperScythe', 160);
INSERT INTO Weapon VALUES ('SpiritOrb', 250);

INSERT INTO Armor VALUES ('SilverArmor', 40);
INSERT INTO Armor VALUES ('GoldArmor', 60);
INSERT INTO Armor VALUES ('CrystalShield', 80);
INSERT INTO Armor VALUES ('WindCape', 35);

INSERT INTO NPC1 VALUES (20, 50);
INSERT INTO NPC1 VALUES (30, 60);
INSERT INTO NPC1 VALUES (40, 70);
INSERT INTO NPC1 VALUES (50, 80);
INSERT INTO NPC1 VALUES (60, 100);

INSERT INTO NPC2 VALUES ('Elder Rowan', 20);
INSERT INTO NPC2 VALUES ('Sage Mira', 30);
INSERT INTO NPC2 VALUES ('Hunter Vex', 40);
INSERT INTO NPC2 VALUES ('Guardian Talon', 50);
INSERT INTO NPC2 VALUES ('Oracle Lyra', 60);

INSERT INTO know VALUES ('Elder Rowan', 6);
INSERT INTO know VALUES ('Sage Mira', 7);
INSERT INTO know VALUES ('Hunter Vex', 8);
INSERT INTO know VALUES ('Guardian Talon', 9);
INSERT INTO know VALUES ('Oracle Lyra', 10);

INSERT INTO has_Mission1 VALUES (1, 'Collect herbs');
INSERT INTO has_Mission1 VALUES (2, 'Defeat mini-boss');
INSERT INTO has_Mission1 VALUES (3, 'Rescue villager');
INSERT INTO has_Mission1 VALUES (4, 'Protect caravan');
INSERT INTO has_Mission1 VALUES (5, 'Retrieve lost artifact');

INSERT INTO has_Mission2 VALUES ('HerbalRun', 1, 'Elder Rowan');
INSERT INTO has_Mission2 VALUES ('MiniBossHunt', 2, 'Hunter Vex');
INSERT INTO has_Mission2 VALUES ('RescueCall', 3, 'Sage Mira');
INSERT INTO has_Mission2 VALUES ('CaravanGuard', 4, 'Guardian Talon');
INSERT INTO has_Mission2 VALUES ('AncientRecovery', 5, 'Oracle Lyra');

INSERT INTO accept VALUES ('HerbalRun', 6);
INSERT INTO accept VALUES ('MiniBossHunt', 7);
INSERT INTO accept VALUES ('RescueCall', 8);
INSERT INTO accept VALUES ('CaravanGuard', 9);
INSERT INTO accept VALUES ('AncientRecovery', 10);

INSERT INTO has_enemy2 VALUES ('GoblinScout', 1, 'Greenwood', 'Goblin');
INSERT INTO has_enemy2 VALUES ('TrollBrute', 5, 'Sands of Time', 'Troll');
INSERT INTO has_enemy2 VALUES ('DrakeMinion', 15, 'Murkfen', 'Dragon');
INSERT INTO has_enemy2 VALUES ('LesserDemon', 20, 'Lava Fields', 'Demon');
INSERT INTO has_enemy2 VALUES ('GolemGuardian', 30, 'Crystal Depths', 'Golem');
INSERT INTO has_enemy2 VALUES ('HarpyScreamer', 35, 'Temple of Winds', 'Harpy');
INSERT INTO has_enemy2 VALUES ('SpiritWatcher', 50, 'Valley of Ancients', 'AncientSpirit');

INSERT INTO explore VALUES (2, '2025-07-01', 1, 'Sands of Time');
INSERT INTO explore VALUES (3, '2025-07-02', 1, 'Iron Peaks');
INSERT INTO explore VALUES (1, '2025-07-03', 1, 'Murkfen');
INSERT INTO explore VALUES (4, '2025-07-04', 1, 'Lava Fields');
INSERT INTO explore VALUES (2, '2025-07-05', 1, 'Crystal Depths');
INSERT INTO explore VALUES (2, '2025-07-06', 1, 'Frost Hollow');
INSERT INTO explore VALUES (5, '2025-07-07', 1, 'Temple of Winds');
INSERT INTO explore VALUES (1, '2025-07-08', 1, 'Eternal Shade');
INSERT INTO explore VALUES (3, '2025-07-09', 1, 'Valley of Ancients');

INSERT INTO explore VALUES (4, '2025-07-01', 3, 'Greenwood');
INSERT INTO explore VALUES (2, '2025-07-02', 3, 'Sands of Time');
INSERT INTO explore VALUES (1, '2025-07-03', 3, 'Murkfen');
INSERT INTO explore VALUES (3, '2025-07-04', 3, 'Lava Fields');
INSERT INTO explore VALUES (2, '2025-07-05', 3, 'Crystal Depths');
INSERT INTO explore VALUES (3, '2025-07-06', 3, 'Frost Hollow');
INSERT INTO explore VALUES (4, '2025-07-07', 3, 'Temple of Winds');
INSERT INTO explore VALUES (2, '2025-07-08', 3, 'Eternal Shade');
INSERT INTO explore VALUES (3, '2025-07-09', 3, 'Valley of Ancients');