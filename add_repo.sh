#!/bin/bash

#->user        ([name] )
#->blame       (*user,   date,    time,     message,  [id])
#->environment ([title], blame*)
#->role        (title,   [id],    env*,     blame*)
#->repo        (hash,    label,   [id],     url,      dir,     blame*,  role*)


#todo: create blame, create repo, given a hash and label, auto_id, url, directory, and role pointer
#      do it all in one transaction, so we can delete the blame if the title is in use
