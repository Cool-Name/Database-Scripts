#!/bin/bash
#will remove a repo based on an id

ARGUMENTS="usage: remove_repo [database] (repo_id) (user)"
DATE=$(date +"%s")
DATABASE=$1
REPO_ID=$2
USER=$3
MESSAGE="Deleted repo $REPO_ID"

if [ -z "$1" ];
then echo "no database supplied: database, repo_id*, user" && exit 1
fi

if [ -z "$2" ];
then echo "no repo supplied: database, repo_id*, user" && exit 1
fi                                                                                           

if [ -z "$3" ];
then echo "no user supplied: database, repo_id*, user" && exit 1
fi                                                                                           


if [ -f "$DATABASE" ] #check the database actually exists
then
    if sqlite3 $DATABASE "select * from blame" >/dev/null #check the tables actually exist
    then #handle the missing vals
	if [ "$REPO_ID" -eq "$REPO_ID" ] 2>/dev/null; then #evil black magic	    
	    if sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT max(id) FROM blame) + 1); delete from repo where repo_id = $REPO_ID; commit;" && echo "SUCCESS"
	    then
		echo "date:     "$DATE
		echo "DATABASE: "$DATABASE
		echo "USER:     "$USER
		echo "ACTION:   "$MESSAGE
		exit 0
	    fi
	fi
    fi
fi
echo "FAILIURE"
exit 1

