#!/bin/bash

#->user        ([name] )
#->blame       (*user,   date,    message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)

#arguments needed: most likely just database - values returned are of PSV format

ARGUMENTS="usage: list_roles [database] (-e (env), env_name | -r (role), role_id)"
DATABASE=$1
ARG=$2
ROLE=$3
ENV=$3

if [ $# -eq 0 ]
then
    echo "$ARGUMENTS"
    exit
fi

#check that a database was entered as an argument, and that that database really exists
if [ -z "$DATABASE" ];
then echo "$ARGUMENTS" && exit
else if ! [ -f "$DATABASE" ] #check database exists
then echo "database '$DATABASE' doesn't exist" && exit
fi
fi

#check argument was actually given
if [ -z "$ARG" ];
    then echo "$ARGUMENTS" && exit
fi

#select based on supplied role number
if [[ "$ARG" == "-r" ]]
then
    if ! [ -z "$ROLE" ] ; then
	if [ "$ROLE" -eq "$ROLE" ] 2>/dev/null; then #evil black magic
	    sqlite3 $DATABASE "-list" "select label, dir, url, hash, role_link from repo WHERE role_link is ($ROLE);" &&exit
	fi
    fi
fi

if [[ "$ARG" == "-e" ]]
then
    if ! [ -z "$ENV" ] ; then
	#select all repos where the matching role matches an environment - select all repos from an env
	sqlite3 $DATABASE "-list" "select label, dir, url, hash, role_link from repo where role_link in (select role_id from role where env in (select title from environment where title is '$ENV'));" && exit
    fi
fi

echo "$ARGUMENTS" && exit
