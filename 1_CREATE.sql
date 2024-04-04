CREATE TABLE arena (
    id   INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    size INTEGER NOT NULL DEFAULT 100
    );

CREATE TABLE team (
    id         INTEGER PRIMARY KEY,
    city       VARCHAR NOT NULL,
    name       VARCHAR NOT NULL UNIQUE,
    coach_name VARCHAR NOT NULL UNIQUE,
    arena_id   INTEGER NOT NULL REFERENCES arena (id) ON DELETE RESTRICT ON UPDATE CASCADE
    );

CREATE TABLE player (
    id       INTEGER PRIMARY KEY,
    name     VARCHAR NOT NULL UNIQUE,
    position VARCHAR NOT NULL,
    height   NUMERIC NOT NULL CHECK (height > 0),
    weight   NUMERIC NOT NULL CHECK (weight > 0),
    salary   NUMERIC NOT NULL CHECK (salary > 0),
    team_id  INTEGER NOT NULL REFERENCES team (id) ON DELETE CASCADE ON UPDATE CASCADE 
    );
    
CREATE TABLE game (
    id             INTEGER PRIMARY KEY,
    owner_team_id  INTEGER NOT NULL REFERENCES team (id) ON DELETE CASCADE ON UPDATE CASCADE,  
    guest_team_id  INTEGER NOT NULL REFERENCES team (id) ON DELETE CASCADE ON UPDATE CASCADE,
    game_date      DATE    NOT NULL,
    winner_team_id INTEGER NOT NULL REFERENCES team (id) ON DELETE CASCADE ON UPDATE CASCADE,
    owner_score    INTEGER NOT NULL DEFAULT 0 CHECK (owner_score >= 0),
    guest_score    INTEGER NOT NULL DEFAULT 0 CHECK (guest_score >= 0),
    arena_id       INTEGER NOT NULL REFERENCES arena (id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (owner_team_id, guest_team_id)
    );