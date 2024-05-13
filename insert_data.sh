#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games,teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  if [[ $YEAR != year ]]
  then
    # get winner team ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found insert winner team
    if [[ -z $WINNER_ID ]]
    then
      WINNER_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $WINNER_TEAM_INSERT == 'INSERT 0 1' ]]
      then
        echo "Inserted new team (winner): $WINNER"
      fi
    # else get opponent team ID
    else
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #if not found insert opponent team
      if [[ -z $OPPONENT_ID ]]
      then
        OPPONENT_TEAM_INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        if [[ $OPPONENT_TEAM_INSERT == 'INSERT 0 1' ]]
        then
          echo "Inserted new team (opponent): $OPPONENT"
        fi
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # get WINNER ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # get OPPONENT ID 
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert into games table
    GAMES_INSERT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR','$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS) ")
    if [[ $GAMES_INSERT == "INSERT 0 1" ]]
    then
      echo "Inserted row: $YEAR,$ROUND,$WINNER,$OPPONENT,$WINNER_GOALS,$OPPONENT_GOALS"
    fi
  fi
done
