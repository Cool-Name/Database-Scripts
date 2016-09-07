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
echo "date:     "$DATE
echo "DATABASE: "$DATABASE
echo "USER:     "$USER
echo "MESSAGE:  "$MESSAGE
#arguments: database, user, message 
sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT COUNT(*) FROM blame)); INSERT INTO environment VALUES(\"$ENVIRONMENT\", (SELECT COUNT(*) FROM blame) - 1); commit;" && echo "Success"
