import java.io.*;
import java.net.*;
import java.util.Scanner;

class DatabaseTest
{
    public static void main(String argv[]) throws Exception
    {
	Scanner inFromUser = new Scanner(System.in);
	String line = null;
	while(inFromUser.hasNextLine()) {	    
	    Socket clientSocket = new Socket("localhost", 65051);
	    DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
	    BufferedReader inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
	    line = inFromUser.nextLine();	
	    outToServer.writeBytes(line + '\n');
	    outToServer.writeBytes("--END--\n");
	    try {
		while(!(line = inFromServer.readLine()).equals("--DONE--"))
		    System.out.println("FROM SERVER: " + line);
		System.out.println("FROM SERVER: --DONE--");
		clientSocket.close();
	    }
	    catch (Exception e) {
		System.err.println(e);
		try {
		    clientSocket.close();
		}
		catch (Exception f) {}
	    }
	}
    }
}
