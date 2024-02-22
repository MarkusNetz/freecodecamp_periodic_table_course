#!/bin/bash

#
# Variables
#


readonly PSQL_CONNECT="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

# Go through given input to script
if [[ ${#} -eq 1 ]]; then
  arg="${1}"
  shift
  if [[ $arg =~ ^[1-9]+$ ]]; then
    atomic_number="$arg"
    query_result=$(${PSQL_CONNECT} "SELECT 'The element with atomic number ' || atomic_number || ' is ' || name || ' (' || symbol || '). It´s a ' || type || ', with a mass of ' || atomic_mass || ' amu. ' || name || ' has a melting point of ' || melting_point_celsius || ' celsius and a boiling point of ' || boiling_point_celsius || ' celsius.' FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types ON types.type_id = properties.type_id WHERE elements.atomic_number = ${atomic_number} ;" | grep "The element")
  else
    element="${arg}"
    query_result=$(${PSQL_CONNECT} "SELECT 'The element with atomic number ' || atomic_number || ' is ' || name || ' (' || symbol || '). It´s a ' || type || ', with a mass of ' || atomic_mass || ' amu. ' || name || ' has a melting point of ' || melting_point_celsius || ' celsius and a boiling point of ' || boiling_point_celsius || ' celsius.' FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types ON types.type_id = properties.type_id WHERE elements.symbol LIKE '${element}' OR elements.name LIKE '${element}' ;" | grep "The element")
  fi

  
  if [[ -n "${query_result}" ]]; then
    echo "${query_result}" | sed -e "s/´/'/" -e 's/^ //g'
  else
    echo "I could not find that element in the database."
  fi
elif [[ ${#} -eq 0 ]]; then
  echo Please provide an element as an argument.
fi

