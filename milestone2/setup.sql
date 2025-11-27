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


insert into dropping_own_Items values ('LeatherArmor',  1,  null, null);
insert into dropping_own_Items values ('ChainMail',     5,  null, null);
insert into dropping_own_Items values ('PlateArmor',    10, null, null);
insert into dropping_own_Items values ('DragonScale',   15, null, null);
insert into dropping_own_Items values ('DemonHide',     20, null, null);

insert into Weapon values ('IronSword',  100);
insert into Weapon values ('FireStaff',  80);
insert into Weapon values ('WarAxe',     90);
insert into Weapon values ('DragonBow',  70);
