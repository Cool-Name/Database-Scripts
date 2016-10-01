import java.util.List;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
public class bindings {
    //name of the database: this should be set once, or even better, hardcoded
    public static String dbname;    

    //###################################################################################//
    //operations that should be supported:
    // 1 - get list of all environments
    // 2 - get list of all roles
    // 3 - get list of all roles matching environment
    // 4 - get list of all repos
    // 5 - get list of all repos matching role

    // 6 - create new environment
    // 7 - create new role based on existing environment
    // 8 - create new repo based on existing role
    // X - (maybe) create new user

    // 9 - duplicate environment (including roles, repos)
    // A - duplicate repo pointing to envionment(including all repos)

    // B - delete environment
    // C - delete role
    // D - delete repo
    //###################################################################################//

    //###################################################################################//
    //operations that are supported:
    // 1 - list of environments
    // 2 - get list of all roles
    // 6 - add environment
    // 7 - create new role based on existing environment
    //###################################################################################//

    //###################################################################################//
    //                                                                                   //
    //                       ACTUAL DATABASE INTERACTION FUNCTIONS                       //
    //                                                                                   //
    //###################################################################################//    
    
    // 1 - get list of all environments
    // function: <- ()
    // requires:
    //     database name
    public static Pair<List<String>, Integer> DB_list_environments() throws Exception {
	if(dbname == null || dbname == "")
	    return err_helper("No database supplied");           //sanity check
	
	Pair<List<String>, Integer> p = exists(dbname);          //check file exists
	if(p != null) return p;

	return run_command("./list_environments.sh " + dbname);	    
    }

    // 6 - insert environment
    // function: <- (user, env)
    // requires:
    //     database name
    //     environment name
    //     user
    public static Pair<List<String>, Integer> 
	DB_add_environment(String user,String envname) throws Exception {
	if(!validarg(dbname))
	    return err_helper("No database supplied");           //sanity check

	Pair<List<String>, Integer> p = exists(dbname);          //check file exists
	if(p != null) return p;
	
	if(!validarg(user)) return err_helper("invalid argument for user");
	
	if(!validarg(envname)) return err_helper("invalid argument for envname");

	return run_command("./add_environment.sh " + dbname + " " + user + " " + envname);	    
    }

    // 7 - create new role based on existing environment
    // function <- (user, env, role)
    // requires:
    //     database name
    //     environment name
    //     user name
    //     role name
    public static Pair<List<String>, Integer> 
	DB_add_role(String user,String envname, String rolename) throws Exception {
	if(!validarg(dbname))
	    return err_helper("No database supplied");           //sanity check

	Pair<List<String>, Integer> p = exists(dbname);          //check file exists
	if(p != null) return p;
	
	if(!validarg(user)) return err_helper("invalid argument for user name");
	
	if(!validarg(envname)) return err_helper("invalid argument for env name");

	if(!validarg(rolename)) return err_helper("invalid argument for role name");

	return run_command("./add_role.sh " + dbname + " " + rolename + " "
			   + " " + envname + " " + user);
    }

    // 2 - get list of all roles
    // function <- ()
    // requires:
    //     database name
    public static Pair<List<String>, Integer> 
	DB_list_roles() throws Exception {
	if(!validarg(dbname))
	    return err_helper("No database supplied");           //sanity check

	Pair<List<String>, Integer> p = exists(dbname);          //check file exists
	if(p != null) return p;
	
	return run_command("./select_role.sh " + dbname);	    
    }

    // 3 - get list of all roles matching environment
    // function <- (envname)
    // requires:
    //     database name
    public static Pair<List<String>, Integer> 
	DB_list_roles(String envname) throws Exception {
	if(!validarg(dbname))
	    return err_helper("No database supplied");           //sanity check

	Pair<List<String>, Integer> p = exists(dbname);          //check file exists
	if(p != null) return p;
	
	if(!validarg(envname)) return err_helper("invalid argument for env name");
	
	return run_command("./select_role.sh " + dbname + " " + envname);	    
    }

    //###################################################################################//
    //                                                                                   //
    //                               MISC UTILITY FUNCTIONS                              //
    //                                                                                   //
    //###################################################################################//    
    
    //checks argument ""exists""
    public static boolean validarg(String s) {	
	return !(s == null || s.equals(""));
    }
    
    public static Pair<List<String>, Integer> exists(String f) throws Exception {
	if(run_command("[ -f '" + f + "' ]").val != 0)
	    return err_helper("Supplied database does not exist");
	else return null;
    }
    
    public static void setDB(String _dbname) {
	dbname = _dbname;
    }

    //generate a prog_error without actually running a program
    public static Pair<List<String>, Integer> err_helper(String _str) {
	Pair<List<String>, Integer> ret = new Pair<List<String>, Integer>();
	List<String> str = new ArrayList<String>();
	str.add(_str);
	ret.res = str;
	ret.val = 1;
	return ret;
    }

    //###################################################################################//
    //                                                                                   //
    //                        HELPER FUNCTIONS FOR DB INTERACTION                        //
    //                                                                                   //
    //###################################################################################//

    public static Pair<List<String>, Integer> run_command(String cm) throws Exception {
	return run(arg_argv(cm));            //TODO: MAKE PRIVATE AT SOME LATER DATE
    }

    private static String[] arg_argv(String arg) {
	return new String[] {"/bin/bash", "-c", arg};
    }
    
    public static void print_list(List<String> strl) {
	for(int i = 0; i < strl.size(); i++)
	    System.out.println(strl.get(i));
    }
    
    private static Pair<List<String>, Integer> run(String[] argv) throws Exception {
	Pair<List<String>, Integer> res = new Pair<List<String>, Integer>();
	Runtime rt = Runtime.getRuntime();
	Process proc = rt.exec(argv);
	String ln;
	BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
	List<String> ls = new ArrayList<String>();

	while((ln = in.readLine()) != null)
	    ls.add(ln);
	res.res = ls;
	res.val = proc.waitFor();
	return res;
    }
}
