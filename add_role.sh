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
echo "date:     "$DATE
echo "DATABASE: "$DATABASE
echo "USER:     "$USER
echo "MESSAGE:  "$MESSAGE
#arguments: database, title, environement, user
sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT COUNT(*) FROM blame)); INSERT INTO role VALUES(\"$TITLE\", (SELECT COUNT(*) FROM role), \"$ENVIRONMENT\", (SELECT COUNT(*) FROM blame) - 1); commit;" && echo "SUCCESS"
