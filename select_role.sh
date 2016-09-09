#!/bin/bash

#->user        ([name] )
#->blame       (*user,   date,    message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)

#arguments needed: most likely just database - values returned are of PSV format

ARGUMENTS="usage: list_repos [database] (null | environment)"
DATABASE=$1
ENVIRONMENT=$2

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
if [ -z $ENVIRONMENT ];
then
    sqlite3 $DATABASE "-header" "-list" "select * from role;" && exit
else
    sqlite3 $DATABASE "-header" "-list" "select * from role WHERE env = '$ENVIRONMENT';" && exit
fi
