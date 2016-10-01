import java.util.List;
public class BindTest {
    public static void main(String[] args) {
	for(int i = 0; i < args.length; i++) {
	    try {
		Pair<List<String>, Integer> pair = bindings.run_command(args[i]);
		System.out.print(pair.val + ": ");
		bindings.print_list(pair.res);
	    }
	    catch (Exception e) {
		e.printStackTrace();
	    }
	}
    }
}
