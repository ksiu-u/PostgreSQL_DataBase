/* Создание триггера для аудита

Для таблицы player создайте триггер для аудита изменений на функциональном языке pl/pgsql
с именем trg_player_changed и соответствующей триггерной функцией fnc_trg_player_changed.
Триггер должен факт применения команд INSERT / UPDATE / DELETE для таблицы player
записывать в отдельно созданную таблицу player_audit.

Структура таблицы player_audit показана ниже.

Столбец	        Тип	         Комментарий
modified_date	TIMESTAMP	 дата внесения изменения в таблицу player
modified_type	VARCHAR	     тип примененного изменения (возможны варианты INSERT)
+ все остальные столбцы из таблицы player	
 */  
     
     
-- создание таблицы для аудита --     
CREATE TABLE player_audit (
    id            SERIAL    PRIMARY KEY,   -- тип serial для автоматического вычисления новых id
    modified_date TIMESTAMP NOT NULL,
    modified_type VARCHAR   NOT NULL,
    player_id     INTEGER   NOT NULL,
    name          VARCHAR   NOT NULL,
    position      VARCHAR   NOT NULL,
    height        NUMERIC   NOT NULL CHECK (height > 0),
    weight        NUMERIC   NOT NULL CHECK (weight > 0),
    salary        NUMERIC   NOT NULL CHECK (salary > 0),
    team_id       INTEGER   NOT NULL REFERENCES team (id) ON DELETE CASCADE ON UPDATE CASCADE
    );
   
  
   
-- создание трггерной функции --  
CREATE FUNCTION fnc_trg_player_changed() RETURNS TRIGGER AS $player_audit$
    BEGIN
    	IF TG_OP = 'INSERT' THEN
    	    INSERT INTO player_audit (modified_date, modified_type, player_id, name, position, height, weight, salary, team_id)
    	    SELECT now(), TG_OP, NEW.id, NEW.name, NEW.position, NEW.height, NEW.weight, NEW.salary, NEW.team_id;
    	RETURN NULL;
    	ELSIF TG_OP = 'UPDATE' THEN
    	    INSERT INTO player_audit (modified_date, modified_type, player_id, name, position, height, weight, salary, team_id)
    	    SELECT now(), TG_OP, OLD.*;
    	RETURN NULL;
    	ELSIF TG_OP = 'DELETE' THEN
    	    INSERT INTO player_audit (modified_date, modified_type, player_id, name, position, height, weight, salary, team_id)
    	    SELECT now(), TG_OP, OLD.*;
    	RETURN NULL;
        ELSE
            raise exception 'impossible TG_OP=%', TG_OP;
        END IF;
    END
$player_audit$ LANGUAGE plpgsql;



-- создание триггера --
CREATE TRIGGER trg_player_changed 
    AFTER INSERT OR UPDATE OR DELETE ON player
    FOR EACH ROW EXECUTE FUNCTION fnc_trg_player_changed();


   
-- вставка значений --   
INSERT INTO player (id, name, position, height, weight, salary, team_id)
VALUES ((SELECT MAX(id) + 10 FROM player), 'Николай Соколов', 'защитник', 189, 89, 120000, 
        (SELECT id FROM team WHERE name = 'Зенит'));

INSERT INTO player (id, name, position, height, weight, salary, team_id)
VALUES ((SELECT MAX(id) + 10 FROM player), 'Николай Николаев', 'защитник', 189, 89, 120000, 
        (SELECT id FROM team WHERE name = 'Зенит'));

INSERT INTO player (id, name, position, height, weight, salary, team_id)
VALUES ((SELECT MAX(id) + 10 FROM player), 'Иван Горелый', 'центровой', 190, 91, 150000, 
        (SELECT id FROM team WHERE name = 'Зенит'));
       
-- обновление данных --
UPDATE player 
   SET salary = 120000
 WHERE name = 'Рафа Вильяр';

-- удаление данных --
DELETE FROM player
 WHERE name = 'Николай Николаев';

/*

id|modified_date          |modified_type|player_id|name            |position |height|weight|salary|team_id|
--+-----------------------+-------------+---------+----------------+---------+------+------+------+-------+
 1|2023-11-25 18:54:10.654|INSERT       |      260|Николай Соколов |защитник |   189|    89|120000|     50|
 2|2023-11-25 18:54:16.124|INSERT       |      270|Николай Николаев|защитник |   189|    89|120000|     50|
 3|2023-11-25 18:54:19.939|INSERT       |      280|Иван Горелый    |центровой|   190|    91|150000|     50|
 4|2023-11-25 18:54:24.425|UPDATE       |       10|Рафа Вильяр     |защитник |   188|    85|180000|     10|
 5|2023-11-25 18:54:27.608|DELETE       |      270|Николай Николаев|защитник |   189|    89|120000|     50|
 
 */