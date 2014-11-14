import java.lang.Runnable;
import java.lang.Math; //for random function
 

public class SimpleThread implements Runnable {
	
	
	public void run(){
		Thread thread = Thread.currentThread();
		int n = 1;
		
	   while(n < 11)
		{
		   try {
				thread.sleep((long)Math.random());
			} 
		   catch (InterruptedException e) {
				System.out.println("Thread interrupted");
			} 
		   
		   if(n != 10){
			System.out.println(n + " " + thread.getName());
		   }
		   else System.out.println("DONE! " + thread.getName() );
		   n++;
		} 
	}
	
	
	public static void main(String[] args) {
		(new Thread (new SimpleThread())).start();
	}

}