#!/bin/bash

#->user        ([name] )
#->blame       (*user,   date,    time,     message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)

DATE=$(date +"%s")
DATABASE=$1
USER=$2
MESSAGE="User $USER added to list of users"

if [ $# -eq 0 ]
then
    echo "No arguments supplied: dabase, [user]"
    exit
fi

if [ -z "$1" ];
then echo "no database supplied: database, [user]" && exit
fi
if [ -z "$2" ];
then echo "no user supplied: database, [user]" && exit
fi

#this layout makes me want to vomit, but it's good enough
if [ -f "$DATABASE" ] #check the database actually exists
then
    if sqlite3 $DATABASE "select * from blame" >/dev/null #check the tables actually exist
    then 
	if sqlite3 "$DATABASE" "PRAGMA foreign_keys = ON; begin; insert into user values('$USER'); INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT COUNT(*) FROM blame)); commit;"  && echo "SUCCESS"
	then 
	    echo "date:     "$DATE
	    echo "DATABASE: "$DATABASE
	    echo "USER:     "$USER
	    echo "ACTION:   "$MESSAGE
	fi
    else echo "tables don't exist in database" && exit
    fi
else
    echo "database doesn't exist" && exit
fi

