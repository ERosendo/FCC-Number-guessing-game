#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"

read USERNAME

USER_CHECK=$($PSQL "SELECT username FROM user_info WHERE username='$USERNAME'")

if [[ -z $USER_CHECK ]]

then

  echo -e "Welcome, $USERNAME! It looks like this is your first time here."

  ADD_USER=$($PSQL "INSERT INTO user_info(username) VALUES('$USERNAME')")

  GAMES_PLAYED=0
else

  DB_USERNAME=$($PSQL "SELECT username FROM user_info WHERE username='$USERNAME'")

  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_info WHERE username='$USERNAME'")

  BEST_GAME=$($PSQL "SELECT best_game FROM user_info WHERE username='$USERNAME'")

  echo "Welcome back, $DB_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

fi

echo -e "Guess the secret number between 1 and 1000:"

G_NUMBER=$(($RANDOM % 1000 + 1))

read USER_INPUT

let COUNT=1

until [ $USER_INPUT -eq $G_NUMBER ]; do

  while [ $((USER_INPUT)) != $USER_INPUT ]; do

    echo "That is not an integer, guess again:"

    read USER_INPUT

  done

 
  while [ $USER_INPUT -gt $G_NUMBER ]; do

    echo "It's lower than that, guess again:"

    read USER_INPUT

    let COUNT++

  done

  while [ $USER_INPUT -lt $G_NUMBER ]; do

    echo "It's higher than that, guess again:"

    read USER_INPUT

    let COUNT++

  done

done

echo "You guessed it in $COUNT tries. The secret number was $G_NUMBER. Nice job!"

INCREMENT_GAMES_PLAYED=$($PSQL "UPDATE user_info SET games_played=$(($GAMES_PLAYED+1)) WHERE username='$USERNAME'")

UPDATE_BEST_GAME=$($PSQL "UPDATE user_info SET best_game=$COUNT WHERE username='$USERNAME' AND (best_game>$COUNT OR best_game ISNULL)")

