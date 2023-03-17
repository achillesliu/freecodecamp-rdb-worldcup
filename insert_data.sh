#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=postgres --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Add winner to teams table.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then 
    # get team ID
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    echo $TEAM_ID

    # if not found
    if [[ -z $TEAM_ID ]]
    then 
      # Insert into teams
      INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $INSERT_TEAM_ID

      if [[ $INSERT_TEAM_ID == "INSERT 0 1" ]]
      then 
        echo Inserted $WINNER into TEAMS!
      fi
    fi
  fi
done

# Add opponent to teams table.
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $opponent != 'opponent' ]]
  then
    team_id=$($PSQL "select team_id from teams where name = '$opponent'")
    echo $team_id
  
    if [[ -z $team_id ]]
    then
      inserted_team_id=$($PSQL "insert into teams(name) values('$opponent')")
      
      if [[ $inserted_team_id == "INSERT 0 1" ]]
      then
        echo Inserted $opponent into teams!
      fi
    fi
  fi
done

# Add games.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then 
    #get game ID
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE round = '$ROUND' AND winner = '$WINNER' AND year = '$YEAR'")
    #if not found
    if [[ -z $GAME_ID ]]
    then 
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")"
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")" 
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner, opponent, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER', '$OPPONENT', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    fi
    if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
    then
      echo Inserted $ROUND Successfully!
    fi
  fi
done