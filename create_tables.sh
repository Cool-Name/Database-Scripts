#!/bin/bash

#sqlite3 test2.db "PRAGMA foreign_keys = ON;"
#->user        ([name] )
#->blame       (*user,   date,    message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)

sqlite3 $1 "PRAGMA foreign_keys = ON; CREATE TABLE user(name TEXT PRIMARY KEY NOT NULL);"
sqlite3 $1 "PRAGMA foreign_keys = ON; CREATE TABLE blame (_user TEXT NOT NULL, date DATE NOT NULL, message TEXT not null, id INT PRIMARY KEY NOT NULL, foreign key(_user) references user(name));"
sqlite3 $1 "PRAGMA foreign_keys = ON; CREATE TABLE environment(title TEXT PRIMARY KEY NOT NULL, env_blame INT NOT NULL, foreign key(env_blame) references blame(id));"
sqlite3 $1 "PRAGMA foreign_keys = ON; CREATE TABLE role(role_title TEXT NOT NULL, role_id INT PRIMARY KEY NOT NULL,  env TEXT NOT NULL, role_blame INT NOT NULL, foreign key(role_blame) references blame(id), foreign key(env) references environment(title) ON DELETE CASCADE);"
sqlite3 $1 "PRAGMA foreign_keys = ON; CREATE TABLE repo(hash TEXT NOT NULL, label TEXT NOT NULL, repo_id INT PRIMARY KEY NOT NULL, url TEXT NOT NULL, dir TEXT NOT NULL, repo_blame INT NOT NULL, role_link INT not null, foreign key(repo_blame) references blame(id), foreign key(role_link) references role(role_id) ON DELETE CASCADE);"
