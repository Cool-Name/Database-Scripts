##Dummy database and how to use it:
      
  * find out all of the environments on the database:
    1. list_environment.sh <- $database
    2. gets list of all environments by title
    3. all lines will be formatted as a single environment
  
  * get a list of all the users in the database
    1. list_users <- $database
    2. gets list of all users by name
    3. all lines will be formatted as a single user

  * get a list of all (non-trivial) operations performed on the database
    1. list_blame <- $database
    2. gets list of all actions performed
    3. all lines will be formatted as: _user* | date | message | [id]

  * get a list of all roles from the database
    1. select_role <- $database ( null | $environment )
    2. gets list of all roles (null)
    2. gets list of all roles (matching environment)
    3. all lines will be formatted as: title | [id] | *environment

  * get a list of repos from the database
    1. select_repo <- $database (-e $env_name | -r $role_id)
    2. gets list of all repos matching the any parent role attached to the selected environment
    2. gets list of all repos matching the parent role
    3. all lines will be formatted as: label | directory | url | hash | id_of_parent_role
