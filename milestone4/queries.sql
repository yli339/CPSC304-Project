-- 1. INSERT
-- 1a) Valid insert into dropping_own_Items
INSERT INTO dropping_own_Items (item_name, equip_level, enemy_name, player_id)
VALUES ('ShadowBlade', 18, 'OrcWarlord', 3);

-- 1b) Example that would cause a foreign key error (enemy does not exist)
-- Uncomment to test FK constraint
INSERT INTO dropping_own_Items (item_name, equip_level, enemy_name, player_id)
VALUES ('GhostBlade', 12, 'NonExistentEnemy', 3);



-- 2. UPDATE
-- 2a) Valid update of a item's equip level for a given item name
UPDATE dropping_own_Items
SET enemy_name = 'FireDrake'
WHERE item_name = 'ShadowBlade';

-- 2b) Example that would cause a foreign key error by setting breed 
-- to a value that does not exist in dropping_own_Items
-- Uncomment to test FK constraint
UPDATE dropping_own_Items
SET enemy_name = 'FakeEnemy'
WHERE item_name = 'IronSword';



-- 3. DELETE
-- Delete an item and cascade to related enemy
DELETE FROM dropping_own_Items
WHERE item_name = 'LeatherArmor';




-- 4. SELECTION
-- Select all players of level >= 3 who are leaders
SELECT player_id,
       player_name,
       player_level,
       leader,
       guild_id
FROM join_Player
WHERE player_level >= 3
  AND leader = 'Y';



-- 5. PROJECTION
-- Project only item_name and enemy_name from dropping_own_Items
SELECT item_name,
       enemy_name
FROM dropping_own_Items;




-- 6. JOIN
-- For all items dropped by enemies in a specific map 'Murkfen' , show the item,
-- its level, the enemy info, and the map
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
  WHERE m3.map_name = 'Murkfen';




-- 7. AGGREGATION with GROUP BY
-- For each map, count the number of enemies (including maps with none)
SELECT m3.map_name,
       COUNT(he2.enemy_name) AS num_enemies
FROM Map3 m3
LEFT JOIN has_enemy2 he2
       ON m3.map_name = he2.map_name
GROUP BY m3.map_name;




-- 8. AGGREGATION with HAVING
-- Show only maps that have at least one enemy
SELECT he2.map_name,
       COUNT(*) AS num_enemies
FROM has_enemy2 he2
GROUP BY he2.map_name
HAVING COUNT(*) >= 1;




-- 9. NESTED AGGREGATION with GROUP BY
-- Find guild(s) whose average player level is greater than or equal to
-- every other guild’s average player level
SELECT g.guild_name,
       AVG(p.player_level) AS avg_player_level
FROM Guild g
JOIN join_Player p
  ON g.guild_id = p.guild_id
GROUP BY g.guild_name
HAVING AVG(p.player_level) >= ALL (
    SELECT AVG(p2.player_level)
    FROM join_Player p2
    GROUP BY p2.guild_id
);




-- 10. DIVISION
-- Find players who have explored ALL maps in Map3
-- (Relational division: Player ÷ Map)
SELECT p.player_id,
       p.player_name
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
);