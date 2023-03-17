DROP DATABASE worldcuptest;
CREATE DATABASE worldcuptest;
ALTER DATABASE worldcuptest OWNER TO postgres;
\connect worldcuptest
CREATE TABLE teams(
  team_id serial PRIMARY KEY,
  name varchar(20) UNIQUE NOT NULL
);
CREATE TABLE games(
  game_id serial PRIMARY KEY,
  year int NOT NULL,
  round varchar(20) NOT NULL,
  winner varchar(20) NOT NULL,
  opponent varchar(20) NOT NULL,
  winner_id int NOT NULL REFERENCES teams(team_id),
  opponent_id int NOT NULL REFERENCES teams(team_id),
  winner_goals int NOT NULL,
  opponent_goals int NOT NULL
);

-- CREATE TABLE teams(team_id serial PRIMARY KEY,name varchar(20) UNIQUE NOT NULL);
-- CREATE TABLE games(game_id serial PRIMARY KEY,year int NOT NULL,round varchar(20) NOT NULL,winner varchar(20) NOT NULL,opponent varchar(20) NOT NULL,winner_id int NOT NULL REFERENCES teams(team_id),opponent_id int NOT NULL REFERENCES teams(team_id),winner_goals int NOT NULL,opponent_goals int NOT NULL);