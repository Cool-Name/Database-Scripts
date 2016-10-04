//Send data to server as space seperated values
//one command per line
//try to send --DONE-- before you close the socket connection
//server will respond to commands in the basic syntax:
//  --BEGIN--
//  *return value of function
//  output from function
//  ...
//  *return value of next function
//  ...
//  --DONE--

/*
  Syntax: split on pipes, first token identifier
  ie: to delete and environment
    rmenv|lob|dev <- valid, but rip all work
  1 - readenv
  2 - readroles
  3 - readroles   (envname)
  4 - readrepos-e (env)
  5 - readrepos-r (role)
  6 - addenv      (user)       (env)
  7 - addrole     (user)       (env)        (role_title)
  8 - addrepo     (user)       (rolenum)    (hash)        (label)     (url)     (directory)
  
  B - rmenv       (user)       (env)
  C - rmrole      (user)       (role)
  D - rmrepo      (user)       (repo)
*/