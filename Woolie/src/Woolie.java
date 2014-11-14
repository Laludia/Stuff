public class Woolie extends Thread
{
	private int crossTime;
	private String destination;
	private Bridge bridgeGuard;

	/**
	 * Main function to run
	 */
	 static Bridge testBridge = new Bridge(3);
	 public static void main( String args[] ) throws NumberFormatException {
	        Thread w1 = new Thread( new Woolie( "One", 11, "Merctan", testBridge ) );
	        Thread w2 = new Thread( new Woolie( "Two", 2, "Merctan",testBridge  ) );
	        Thread w3 = new Thread( new Woolie( "Three", 3, "Sicstine",testBridge  ) );
	        Thread w4 = new Thread( new Woolie( "Four", 14, "Merctan",testBridge) );
	        Thread w5 = new Thread( new Woolie( "Five", 23, "Merctan",testBridge) );
	        Thread w6 = new Thread( new Woolie( "Six", 11, "Merctan",testBridge) );
	        Thread w7 = new Thread( new Woolie( "Seven", 7, "Sicstine",testBridge) );
	        
	        w1.start();
	        w2.start();
	        w3.start();
	        w4.start();
	        w5.start();
	        w6.start();
	        w7.start();
	    }
	 
	 /**
	  *Woolie constructor
	 */
	public Woolie(String name, int crossTime, String destination, Bridge bridgeGuard)
	{
		// Set thread name
		setName(name);
		// Set time
		this.crossTime = crossTime;
		// Set destination
		this.destination = destination;
		//set bridge
		this.bridgeGuard = bridgeGuard;

	}

	/**
	 *The run() method of the Woolie class simulates the Woolie crossing the bridge.  
	 *The Woolie starts crossing the bridge as soon as the run() method begins execution.  
	 *The run() method consists of a loop, that executes once for every second the Woolie 
	 *is on the bridge.
	 */
	public void run() {

        bridgeGuard.enterBridge(this);

        for( int i = 0; i < crossTime;  ++i ) {
            if( i == 0 ) {
                System.out.println( getName() + " is starting to cross.");
            }
            else {
                System.out.println( "\t" + getName() + " " + i + " seconds." );
            }

            try{
                Thread.sleep( 1000 ); 
            }
            catch( InterruptedException e ) {}

        }
        bridgeGuard.leaveBridge();
        System.out.println( getName() + " leaves at " + destination + "." );
        
    }
}