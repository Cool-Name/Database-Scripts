import java.util.List;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
public class bindings {
    public static String dbname;
    

    //operations that should be supported:
    // 1 - get list of all environments
    // 2 - get list of all roles
    // 3 - get list of all roles matching environment
    // 4 - get list of all repos
    // 5 - get list of all repos matching role

    // 6 - create new environment
    // 7 - create new role based on existing environment
    // 8 - create new repo based on existing role
    // x - (maybe) create new user

    // 9 - duplicate environment (including roles, repos)
    // 0 - duplicate repo pointing to envionment(including all repos)

    //operations that are supported:


    //###################################################################################//
    //                                                                                   //
    //                       ACTUAL DATABASE INTERACTION FUNCTIONS                       //
    //                                                                                   //
    //###################################################################################//    
    

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
