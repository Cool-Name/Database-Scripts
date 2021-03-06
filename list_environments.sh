#!/bin/bash

#arguments needed: most likely just database - values returned are of PSV format

ARGUMENTS="usage: ./list_environments [database]"
DATABASE=$1

if [ $# -eq 0 ]
then
    echo "$ARGUMENTS"
    exit
fi

#check that a database was entered as an argument, and that that database really exists
if [ -z "$DATABASE" ];
then echo "no database supplied: database, [user]" && exit
else if ! [ -f "$DATABASE" ] #check database exists
then echo "database '$DATABASE' doesn't exist" && exit
fi
fi

#select all actions from all users
sqlite3 $DATABASE "-list" "select TITLE from environment;" && exit
exit
