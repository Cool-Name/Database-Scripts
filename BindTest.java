import java.util.List;
public class BindTest {
    public static void main(String[] args) {
	//if(args.length == 0)
	//    return;
	
	String db = "randtest.db";
	bindings.setDB(db);
	//add_env_test(args);
	list_env_test(args);
	System.err.println();
    }
    
    private static void add_env_test(String[] args) {
	if(args.length < 2)
	    return;
	try {
	    output_succ(bindings.DB_add_environment(args[0], args[1]));
	}
	catch(Exception e) {
	    System.err.println(e);
	}
    }

    private static void list_env_test(String[] args) {
	try {
	    output_succ(bindings.DB_list_environments());
	}
	catch(Exception e) {
	    System.err.println(e);
	}
    }
    private static void output_succ(Pair<List<String>, Integer> pair) {
	System.out.print(pair.val + ": ");
	bindings.print_list(pair.res);
    }

    private static void test_arbitrary_args(String[] args) {
	for(int i = 0; i < args.length; i++) {
	    try {
		Pair<List<String>, Integer> pair = bindings.run_command(args[i]);
		output_succ(pair);
	    }
	    catch (Exception e) {
		e.printStackTrace();
	    }
	}
    }
}
