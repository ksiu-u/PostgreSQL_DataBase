-- Упражнение 1

SELECT team.city city_name, team.name team_name, arena.name arena_name
  FROM team
       INNER JOIN arena ON team.arena_id = arena.id
 WHERE arena.size > 10000
 ORDER BY city_name DESC;

/*
city_name|team_name  |arena_name                        |
---------+-----------+----------------------------------+
Пирей    |Олимпакос  |Пис энд Френдшип Стадиум          |
Мадрид   |Реал Мадрид|Визинк-Центр - Паласио де Депортес|
*/



-- Упражнение 2

SELECT t1.name owner_team, t2.name guest_team, t3.name winner_team, 
       CONCAT(game.owner_score, ':', game.guest_score) score, arena.name arena_name
  FROM game 
       INNER JOIN arena ON game.arena_id = arena.id 
       INNER JOIN team t1 ON game.owner_team_id = t1.id 
       INNER JOIN team t2 ON game.guest_team_id = t2.id
       INNER JOIN team t3 ON game.winner_team_id = t3.id;   
      
/*
owner_team |guest_team |winner_team|score|arena_name                        |
-----------+-----------+-----------+-----+----------------------------------+
Барселона  |Зенит      |Барселона  |84:58|Палау Блауграна                   |
Барселона  |ЦСКА       |Барселона  |81:73|Палау Блауграна                   |
Барселона  |Реал Мадрид|Барселона  |93:80|Палау Блауграна                   |
Барселона  |Олимпакос  |Барселона  |83:68|Палау Блауграна                   |
Зенит      |Реал Мадрид|Реал Мадрид|68:75|СИБУР Арена                       |
Зенит      |ЦСКА       |ЦСКА       |67:77|СИБУР Арена                       |
Зенит      |Олимпакос  |Зенит      |84:78|СИБУР Арена                       |
Реал Мадрид|ЦСКА       |Реал Мадрид|71:65|Визинк-Центр - Паласио де Депортес|
Реал Мадрид|Олимпакос  |Реал Мадрид|75:67|Визинк-Центр - Паласио де Депортес|
ЦСКА       |Олимпакос  |ЦСКА       |79:78|УСК ЦСКА им. А.Я. Гомельского     |
 */
  
      

-- Упражнение 3

  WITH arena1 AS (
       SELECT name
         FROM arena
        WHERE size > 10000)
SELECT team.city city_name, team.name team_name, arena.name arena_name
  FROM team
       INNER JOIN arena ON team.arena_id = arena.id 
 WHERE arena.name IN (SELECT name FROM arena1)
 ORDER BY city_name DESC;

/*
city_name|team_name  |arena_name                        |
---------+-----------+----------------------------------+
Пирей    |Олимпакос  |Пис энд Френдшип Стадиум          |
Мадрид   |Реал Мадрид|Визинк-Центр - Паласио де Депортес|
*/



-- Упражнение 4

SELECT arena.name arena_name, 
       COALESCE(CAST(game.game_date AS VARCHAR(20)), 'игра не проводилась') game_date 
  FROM arena
       LEFT JOIN game ON arena.id = game.arena_id
 ORDER BY 1, 2;

/*
arena_name                        |game_date          |
----------------------------------+-------------------+
Визинк-Центр - Паласио де Депортес|2021-10-28         |
Визинк-Центр - Паласио де Депортес|2022-02-01         |
Палау Блауграна                   |2021-10-12         |
Палау Блауграна                   |2021-10-15         |
Палау Блауграна                   |2021-10-22         |
Палау Блауграна                   |2021-11-17         |
Пис энд Френдшип Стадиум          |игра не проводилась|
СИБУР Арена                       |2022-01-15         |
СИБУР Арена                       |2022-10-20         |
СИБУР Арена                       |2022-12-15         |
УСК ЦСКА им. А.Я. Гомельского     |2022-02-02         |
 */



-- Упражнение 5

SELECT (CASE
 	   WHEN height < 190 THEN 1
 	   WHEN height >= 190 AND height < 200 THEN 2
 	   ELSE 3
 	   END) height_class,
 	   COUNT(id) amount_players
  FROM player
 GROUP BY height_class
 ORDER BY height_class;

/*
height_class|amount_players|
------------+--------------+
           1|             4|
           2|            10|
           3|            11|
 */



-- Упражнение 6

SELECT name, 'стадион' AS object_type
  FROM arena
 UNION ALL
SELECT name, 'команда' AS object_type
  FROM team 
 ORDER BY object_type DESC, name ASC;

/*
name                              |object_type|
----------------------------------+-----------+
Визинк-Центр - Паласио де Депортес|стадион    |
Палау Блауграна                   |стадион    |
Пис энд Френдшип Стадиум          |стадион    |
СИБУР Арена                       |стадион    |
УСК ЦСКА им. А.Я. Гомельского     |стадион    |
Барселона                         |команда    |
Зенит                             |команда    |
Олимпакос                         |команда    |
Реал Мадрид                       |команда    |
ЦСКА                              |команда    |
*/



-- Упражнение 7

SELECT name 
  FROM arena
 WHERE name IN (
       SELECT arena.name
         FROM arena
              INNER JOIN game ON arena.id = game.arena_id)
 ORDER BY 1;

/*
name                              |
----------------------------------+
Визинк-Центр - Паласио де Депортес|
Палау Блауграна                   |
СИБУР Арена                       |
УСК ЦСКА им. А.Я. Гомельского     |
 */



-- Упражнение 8
 
SELECT name, salary
  FROM player 
 ORDER BY 
       CASE 
       WHEN salary = 475000 THEN 0
       WHEN salary != 475000 THEN salary
       END      
 LIMIT 5;

/*
name              |salary|
------------------+------+
Михалис Лунцис    |475000|
Яннулис Ларенцакис| 75000|
Билли Джеймс Бэрон| 75000|
Гершон Ябуселе    | 99000|
Кайл Курич        |100000|
/