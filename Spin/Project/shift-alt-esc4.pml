/*Channel Model
*Your model must include 
*process definitions for Customers, the Cashier, 
*and Servers. Your base system for analysis
*must instantiate three Customers (each with 
*a different favorite food), one Cashier, and 
*two Servers.
*/
//Number of customers
#define NC 3

/*	
    Global Data Types
    cust_cash: customer to cashier request channel
    cash_server: cashier to server request channel
    ltlfood: food requested by the most recently processed customer(ltl use)
    ltlrec_food: food received by the recently processed customer(ltl use)
    numOrders: Semaphore limiting at most one customer's order given to the cashier at a time
    numOrdersReceived: Number of orders that have been recieved by customers
    mtype: The food options in the restaurant
*/
chan cust_cash = [0] of {byte, chan, mtype};
chan cash_server = [0] of {byte, chan, mtype};
mtype ltlfood, ltlrec_food;
byte numOrders = 0;
byte numOrdersReceived;
mtype = {CHILI, SANDWICH, PIZZA};


/*
  Customer Process
  1)Enter store
  2)Record new customer
  3)wait for cashier
  4)place order for fav food
  5)wait for order to be fulfilled
  6)exit store with food
  byte rec_customerID:receiving customer ID
  customer:customer channel to receive orders
  food: food requested by customer
  rec_food: food received by customer
*/

active [NC] proctype Customer() {

byte rec_customerID;
chan customer = [0] of {byte, mtype};
mtype food, rec_food;

do
    ::  // Enter Store; wait for cashier
        printf("Customer %d: Enters restaurant.\n", _pid);

		// Decide which food they want
        if
            :: true -> food = CHILI;
            :: true -> food = PIZZA;
            :: true -> food = SANDWICH;
        fi;

		// Place Order
        printf("Customer %d: Places order for %e.\n", _pid, food);
		atomic {
			numOrders == 0;
			numOrders++;
			cust_cash ! _pid, customer, food;

		}

		// Recieve Order
		customer ? rec_customerID, rec_food ->
			printf("Customer %d exits restaurant with %e.\n", rec_customerID, rec_food);

		//ltl statment setting
        atomic {
			numOrdersReceived++;
			ltlfood = food;
			ltlrec_food = rec_food;
		}
od;
}



/*
  Cashier process
  1)wait for a new customer
  2)select waiting customer
  3)take order
  4)pass order to server

  custID: The customer ID received from the customer
  customer: A channel that is used to process the order received
  food: food requested by customer
*/
active proctype Cashier() {
byte CustID;
chan customer;
mtype food;

do
	::	// Wait for a new customer
		printf("Cashier waits for a new customer.\n");
		// Select waiting customer
		atomic {
		cust_cash ? CustID, customer, food ->
			numOrders--;
			printf("Cashier selects a waiting Customer %d.\n", CustID);
			// Cashier takes the Order
			printf("Cashier takes order from Customer %d - %e.\n", CustID, food);
			// sends order to server
			printf("Cashier passes Customer %d's order to server.\n", CustID);
			cash_server ! CustID, customer, food;
			}
od;
}


/*
  Server Process
  1)wait for an order
  2)retrieve order(customer and food)
  3)make the order
  4)deliver order to (correct) customer

  CustID: Customer id for order, received from cashier
  customer: channel representing process of Customer's order
  food: food requested, from cashier
*/
active [2] proctype Server() {

byte CustID;
chan customer;
mtype food;

do
	::	// Wait for an order
		printf("Server %d waits for an order.\n", _pid);
		// Retrieve Order
		cash_server ? CustID, customer, food ->
			printf("Server %d retrieves order for Customer %d.\n", _pid, CustID);
			// Make Order
			printf("Server %d makes Customer %d's order for %e.\n", _pid, CustID, food);
			// Deliver to the customer
			printf("Server %d delivers Customer %d's order for %e.\n", _pid, CustID, food);
			customer ! CustID, food;

od;
}

