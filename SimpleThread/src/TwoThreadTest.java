public class TwoThreadTest {
	public static void main(String[] args) {
		
		SimpleThread hi = new SimpleThread();
		Thread threadOne = new Thread(hi, "Hi"); //initiates the first thread "Hi"
		
		SimpleThread ho = new SimpleThread();
		Thread threadTwo = new Thread(ho, "Ho"); //initiates the 2nd thread "Ho"
		
		threadOne.start();
		threadTwo.start();
	}

}