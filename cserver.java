import java.io.*;
import java.net.*;
import java.util.List;
public class cserver {
    static String dbname = "conam.db";
    public static void main(String[] args) {
	bindings.setDB(dbname);
	int port = Integer.parseInt(args[0]);
	ServerSocket serv = null;
	try {
	    serv = new ServerSocket(port);
	}
	catch (Exception e) {
	    System.err.println("ERR: Could not start server");	    
	    System.exit(1);
	}

	for(;;) {
	    //get single message	    
	    //send response
	    try {
		Socket s = serv.accept();
		(new Thread(new ServMan(s))).start();
	    } catch (Exception e) {
		System.err.println(e);
	    }
	}	
    }

    private static class ServMan implements Runnable {
	Socket s = null;
	String m = null;
	String[] argv = null;
	PrintWriter out;
	BufferedReader in;
	Pair<List<String>, Integer> func_ret = null;
	public ServMan(Socket s) {
	    this.s = s;	    
	}
	public void run() {
	    try {
		out = new PrintWriter(s.getOutputStream(), true);
		in = new BufferedReader(new InputStreamReader(s.getInputStream()));	    
	    }
	    catch (Exception e) {
		System.err.println(e);
		return;
	    }	    

	    /*
	      Syntax: split on pipes, first token identifier
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
	    try {
		out.println("--BEGIN--");
		while((m = in.readLine()) != null && !m.equals("--END--")) {
		    // 1 - list of environments
		    if(m.equals("readenv"))
			func_ret = bindings.DB_list_environments();
		    // 2 - get list of all roles
		    else if (m.equals("readroles"))
			func_ret = bindings.DB_list_roles();
		    else {
			argv = m.split("\\|");
		
			// 3 - get list of all roles matching environment			
			if(argv.length == 2 && argv[0].equals("readroles"))
			    func_ret = bindings.DB_list_roles(argv[1]);
			// 4 - get list of all repos matching environment
			else if (argv.length == 2 && argv[0].equals("readrepos-e"))
			    func_ret = bindings.DB_list_repos(argv[1]);
			// 5 - get list of all repos matching role
			else if (argv.length == 2 && argv[0].equals("readrepos-r")) {
			    if(checkArg(argv[1]) == -1) {
				func_ret = bindings.err_helper("role_id most be positive: ie readrepos_r|1568");
				break;
			    }
			    else
				func_ret = bindings.DB_list_repos(Integer.parseInt(argv[1]));
			}
			// 6 - add environment (user, env)
			else if (argv.length == 3 && argv[0].equals("addenv"))
			    func_ret = bindings.DB_add_environment(argv[1], argv[2]);
			// 7 - create new role based on existing environment (user, env, role)
			else if (argv.length == 4 && argv[0].equals("addrole"))
			    func_ret = bindings.DB_add_role(argv[1], argv[2], argv[3]);
			// 8 - create new repo based on existing role
			//---(user, rolenum, hash, label, url, directory)
			else if (argv.length == 7 && argv[0].equals("addrepo")) {
			    if(checkArg(argv[2]) == -1) {
				func_ret = bindings.err_helper("role_id most be positive: ie add_repo|lob|1568|abc|def|ghi|jkl");
				break;
			    }
			    else
				func_ret = bindings.DB_add_repo(Integer.parseInt(argv[2]), argv[1], argv[3], argv[4], argv[5], argv[6]);
			}
			// B - delete environment
			else if (argv.length == 3 && argv[0].equals("rmenv"))
			    func_ret = bindings.DB_rm_env(argv[1], argv[2]);
			// C - delete role
			else if (argv.length == 3 && argv[0].equals("rmrole")) {
			    if(checkArg(argv[2]) == -1) {
				func_ret = bindings.err_helper("role_id most be positive: ie rm_role|lob|1766");
				break;
			    }
			    else
				func_ret = bindings.DB_rm_role(argv[1], Integer.parseInt(argv[2]));
			}
			// D - delete repo
			else if (argv.length == 3 && argv[0].equals("rmrepo")) {
			    if(checkArg(argv[2]) == -1) {
				func_ret = bindings.err_helper("repo_id most be positive: ie rm_role|lob|1766");
				break;
			    }
			    else
				func_ret = bindings.DB_rm_repo(argv[1], Integer.parseInt(argv[2]));
			}
			else {
			    func_ret = bindings.err_helper("err: unrecognized entry parameter");
			}
		    }
		    
		    //handle output to client:
		    //  just print exit *status, followed by output
		    //  func_ret is a tuple of type: list, int
		    try {
			out.println("*" + func_ret.val);
			List<String> ols = func_ret.res;
			for(int i = 0; i < ols.size(); i++)
			    out.println(ols.get(i));
		    }
		    catch (Exception  e) {
			//not sure what to do here..
		    }
		}
		out.println("--DONE--");
		out.close();
		in.close();
	    }
	    catch (Exception e) {
		System.err.println(e);
		return;
	    }
	}

	private int checkArg(String str) {
	    try {
		int arg = Integer.parseInt(str);
		return arg;
	    } catch (Exception e) {
		return -1;
	    }
	}
    }    
}