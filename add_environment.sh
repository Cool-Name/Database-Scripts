#!/bin/bash

#->user        ([name] )
#->blame       (*user,    date,     message,  [id])
#->environment ([title],  blame*)
#->role        (title,    [id],     env*,     blame*)
#->repo        (hash,     label,    [id],     url,      dir,     blame*,  role*)

DATE=$(date +"%s")
DATABASE=$1
USER=$2
ENVIRONMENT=$3
MESSAGE="Added environment "$3


#arguments: database, user, message 

if [ $# -eq 0 ]
then
    echo "No arguments supplied: database, user*, [environment_title]"
    exit
fi

if [ -z "$1" ];
then echo "no database supplied: database, user*, [environment_title]" && exit
fi
if [ -z "$2" ];
then echo "no user supplied: database, user*, [environment_title]" && exit
fi
if [ -z "$3" ];
then echo "no environment title supplied: database, user*, [environment_title]" && exit
fi


if [ -f "$DATABASE" ] #check the database actually exists
then
    if sqlite3 $DATABASE "select * from blame" >/dev/null #check the tables actually exist
    then
	if sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT COUNT(*) FROM blame)); INSERT INTO environment VALUES(\"$ENVIRONMENT\", (SELECT COUNT(*) FROM blame) - 1); commit;" && echo "Success"
	    
	then
	    echo "date:     "$DATE
	    echo "DATABASE: "$DATABASE
	    echo "USER:     "$USER
	    echo "ACTION:   "$MESSAGE
	    exit 0
	fi
    else echo "tables don't exist in database" && exit 1
    fi
else
    echo "database doesn't exist" && exit 1
fi

echo "could not add item to database: environment already exists with matching name"
exit 1

