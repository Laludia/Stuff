import java.util.ArrayList;

public class Bridge
{
	private int maxCapacity;
	private int onBridge;
	private ArrayList<String> waitingQueue;


	public Bridge(int max)
	{
		maxCapacity = max;
		onBridge = 0;
		waitingQueue = new ArrayList<String>();
	}

	/**
	 * The enterBridge() method will contain the code that ensures that only 
	 * one Woolie is on the bridge at a time
	 */
	public synchronized void enterBridge(Woolie thisWoolie)
	{
		// Notify addition
		System.out.println(thisWoolie.getName() + " shows up at the bridge.");
		// Add Woolie name to the queue
		waitingQueue.add(thisWoolie.getName());

		// Wait if the bridge is at max capacity or if its not your turn
		while (onBridge == maxCapacity || !waitingQueue.get(0).equals(thisWoolie.getName()))
		{
			try
			{
				wait();
			}
			catch (InterruptedException e){}
		}

		// Add the Woolie to the crossing count
		onBridge++;
		// Remove the Woolie from the waiting queue
		waitingQueue.remove(0);
		// Notify in case there is still room
		notifyAll();
	}

	/**
	 *The leaveBridge() method contains the code that notifies the troll that the Wollie is off the bridge.
	 */
	public synchronized void leaveBridge()
	{
		// Decrement crossing count
		if (onBridge > 0)
		{
			onBridge--;
		}
		// Notify the threads
		notifyAll();
	}

}