#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
 echo "Please provide an element as an argument."
else

  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    ELE=$($PSQL " select * from properties join elements on properties.atomic_number = elements.atomic_number join types on properties.type_id = types.type_id where elements.atomic_number = '$1'")
  fi

  if [[ -z $ELE ]]
  then
    ELE=$($PSQL " select * from properties join elements on properties.atomic_number = elements.atomic_number join types on properties.type_id = types.type_id where elements.symbol = '$1'")
  fi

  if [[ -z $ELE ]]
  then
    ELE=$($PSQL " select * from properties join elements on properties.atomic_number = elements.atomic_number join types on properties.type_id = types.type_id where elements.name = '$1'")
  fi

  if [[ -z $ELE ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELE" | while IFS='|' read NUMBER MASS MELT BOIL TYPE N2 SYMBOL NAME TYPE2 TNAME; do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TNAME, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi
