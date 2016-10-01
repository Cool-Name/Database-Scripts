#!/bin/bash

#->user        ([name] )
#->blame       (*user,   date,    time,     message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)


#todo: create blame, then create role, add title, (id), point to env
#      do it all in one transaction, so we can delete the blame if the title is in use
DATE=$(date +"%s")
DATABASE=$1
TITLE=$2
ENVIRONMENT=$3
USER=$4
MESSAGE="Added role $TITLE to environment $ENVIRONMENT"

#arguments: database, title, environement, user
# -->sanity check args here -> make sure it's not empty


if [ $# -eq 0 ]
then
    echo "No arguments supplied: database,role_title, environment_title*, user*"
    exit
fi

if [ -z "$1" ];
then echo "no database supplied: database,role_title, environment_title*, user*" && exit
fi
if [ -z "$2" ];
then echo "no role supplied: database,role_title, environment_title*, user*" && exit
fi
if [ -z "$3" ];
then echo "no environment supplied: database,role_title, environment_title*, user*" && exit
fi
if [ -z "$4" ];
then echo "no user supplied: database,role_title, environment_title*, user*" && exit
fi

if [ -f "$DATABASE" ] #check the database actually exists
then
    if sqlite3 $DATABASE "select * from blame" >/dev/null #check the tables actually exist
    then  #I think there's a special case for the first item added into role if I use this pattern - max returns null when 0 items in table
	if (sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (select max(id) from blame) + 1); INSERT INTO role VALUES(\"$TITLE\", (SELECT max(role_id) from role) + 1, \"$ENVIRONMENT\", (SELECT max(id) from blame)); commit;" || sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (select max(id) from blame) + 1); INSERT INTO role VALUES(\"$TITLE\", 0, \"$ENVIRONMENT\", (SELECT max(id) from blame)); commit;") && echo "SUCCESS"
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
exit 1
