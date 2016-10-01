#!/bin/bash

#->user        ([name] )
#->blame       (*user,   date,    time,     message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)


#todo: create blame, create repo, given a hash and label, auto_id, url, directory, and role pointer
#      do it all in one transaction, so we can delete the blame if the title is in use
DATE=$(date +"%s")
DATABASE=$1
USER=$2
HASH=$3
LABEL=$4
URL=$5
DIR=$6
ROLE_ID=$7
MESSAGE="Added repo $URL to role $ROLE_ID"

#arguments: database, user, hash, label, url, directory, role_id
#arguments for repo: hash, label, [id], url, directory, blame*, role*)
if [ $# -eq 0 ]
then
    echo "No arguments supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi

if [ -z "$1" ];
then echo "no database supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi
if [ -z "$2" ];
then echo "no user supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi
if [ -z "$3" ];
then echo "no hash supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi
if [ -z "$4" ];
then echo "no label supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi
if [ -z "$5" ];
then echo "no url supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi
if [ -z "$6" ];
then echo "no directory supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi
if [ -z "$7" ];
then echo "no role supplied: database, user*, hash, label, url, directory, role_id*" && exit 1
fi


if [ -f "$DATABASE" ] #check the database actually exists
then
    if sqlite3 $DATABASE "select * from blame" >/dev/null #check the tables actually exist
    then #handle the missing vals
	if (sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT max(id) FROM blame) + 1); INSERT INTO repo VALUES(\"$HASH\", \"$LABEL\", (SELECT max(repo_id) FROM repo) + 1, \"$URL\", \"$DIR\", (SELECT max(id) FROM blame), $ROLE_ID); commit;"  || sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT max(id) FROM blame) + 1); INSERT INTO repo VALUES('$HASH', '$LABEL', 0, '$URL', '$DIR', (SELECT max(id) FROM blame), $ROLE_ID); commit;") && echo "SUCCESS"
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
