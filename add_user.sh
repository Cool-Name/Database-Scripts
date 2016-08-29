#!/bin/bash

#->user        ([name] )
#->blame       (*user,   date,    time,     message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)

sqlite3 $1 "PRAGMA foreign_keys = ON; insert into user values('$2');"
