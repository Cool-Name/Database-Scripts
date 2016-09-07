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
echo "date:     "$DATE
echo "DATABASE: "$DATABASE
echo "USER:     "$USER
echo "MESSAGE:  "$MESSAGE

#arguments: database, user, hash, label, url, directory, role_id
#arguments for repo: hash, label, [id], url, directory, blame*, role*)
sqlite3 $DATABASE "PRAGMA foreign_keys = ON; begin; INSERT INTO blame VALUES('$USER', $DATE, '$MESSAGE', (SELECT COUNT(*) FROM blame)); INSERT INTO repo VALUES(\"$HASH\", \"$LABEL\", (SELECT COUNT(*) FROM repo), \"$URL\", \"DIR\", (SELECT COUNT(*) FROM blame) - 1, $ROLE_ID); commit;" && echo "SUCCESS"
