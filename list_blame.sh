#!/bin/bash

#arguments needed: most likely just database - values returned are of PSV format

ARGUMENTS="usage: ./list_blame [database]"
DATABASE=$1
ALL_ACTIONS_ALL_USERS="selecting all actions from all users"

if [ $# -eq 0 ]
then
    echo "No arguments supplied: database"
    exit
fi

#check that a database was entered as an argument, and that that database really exists
if [ -z "$DATABASE" ];
then echo "no database supplied: database, [user]" && exit
else if ! [ -f "$DATABASE" ] #check database exists
then echo "database '$DATABASE' doesn't exist" && exit
fi
fi
    
    echo "no arguments supplied: $ALL_ACTIONS_ALL_USERS"
#select all actions from all users
sqlite3 $DATABASE "select * from blame;" && exit
exit
