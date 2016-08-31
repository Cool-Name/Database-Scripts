#!/bin/bash

#->user        ([name] )
#->blame       (*user,    date,     message,  [id])
#->environment ([title],  blame*)
#->role        (title,    [id],     env*,     blame*)
#->repo        (hash,     label,    [id],     url,      dir,     blame*,  role*)

DATE=$(date +"%s")
DATABASE=$1
USER=$2
MESSAGE=$3
echo "date:     "$DATE
echo "DATABASE: "$DATABASE
echo "USER:     "$USER
echo "MESSAGE:  "$MESSAGE
#arguments: database, user, message 
sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (select count(*) from blame)); commit;"
