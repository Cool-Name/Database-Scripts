##Dummy database and how to use it:
      
  * find out all of the environments on the database:
    1. list_environment.sh -> $database
    2. gets list of all environments by title
    3. all lines will be formatted as a single environment
  
  * get a list of all the users in the database
    1. list_users -> $database
    2. gets list of all users by name
    3. all lines will be formatted as a single user

  * get a list of all (non-trivial) operations performed on the database
    1. list_blame -> $database
    2. gets list of all actions performed
    3. all lines will be formatted as: _user | date | message | id