#/usr/bin/bash

if [[ "${#}" -lt 1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

element_to_find=$1
shift

query_reply=$(psql --username=freecodecamp \
  --dbname=periodic_table \
  -c "SELECT 'The element with atomic number ' || atomic_number || ' is ' || name || ' (' || symbol || '). It´s a ' || type || ', with a mass of ' || atomic_mass || ' amu. ' || name || ' has a melting point of ' || melting_point_celsius || ' celsius and a boiling point of ' || boiling_point_celsius || ' celsius.' FROM elements INNER JOIN properties using(atomic_number) INNER JOIN types ON types.type_id = properties.type_id WHERE(elements.symbol LIKE '%${element_to_find}%' OR elements.name LIKE '%${element_to_find}%' OR elements.atomic_number = ${element_to_find}) ;" | grep "The element")

if [[ -z "${query_reply}" ]]; then
  echo "I could not find that element in the database."
  exit 1;
else
  echo "${query_reply}"
fi

exit 0
