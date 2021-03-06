/*Using semaphores, boolean flags, counters 
*and other appropriate global variables, 
*create a model that provides the necessary 
*synchronization and coordination among 
*the processes. Your model must include 
*process definitions for Customers, the Cashier, 
*and Servers. Your base system for analysis must 
*instantiate one Customer, one Cashier, and one Server.
*/
#define LIST_SIZE 10

/*
  Order is a type that holds all the state
  info for an order.
  custID: holds customer's process ID
  food: holds the food requested
  fulfilled: this is a check to make sure
             server fulfilled request
*/

typedef Order {
    byte CustID;
	mtype food;
	bool fulfilled;
}

mtype = {CHILI, SANDWICH, PIZZA};

#define sema byte
#define up(s) {s++ ;}
#define down(s) {atomic{s>0 ; s--}}

/*Customer-Cashier
  Customers wait for their turn,The cashier becomes busy
  and remains busy while customers remain to be served, 
  and The customer id and food type are properly 
  communicated from customer to cashier.
*/

sema mutex = 1; //one customer at a time
sema place_order = 0;  //Limits one customer per server
byte tempCustID;
mtype tempFood;
byte cashierIndex = 0;

/*Cashier / Server(s)
  The cashier can store each order so it can be retrieved 
  by a server,One server becomes busy if there is one 
  unfulfilled order; both servers are busy if there are 
  two or more unfulfilled orders.Servers do not try to 
  fulfill the same order, and no orders are �dropped.� 
*/
Order orders[LIST_SIZE];
byte serverIndex = 0;
byte unfulfilledOrders = 0;
byte Server1 = 0;
/*
  Customer Process
  1)Enter store
  2)Record new customer
  3)wait for cashier
  4)place order for fav food
  5)wait for order to be fulfilled
  6)exit store with food
*/

active proctype Customer() {
byte Index;
do
    ::	// Enter Store; wait for cashier
        printf("Customer #%d: Enters restaurant.\n", _pid);
        down(mutex);

        // Record new customer
        Index = cashierIndex;

        // Wait for cashier to place order
        up(place_order);

        // Place order for coffee or tea
        tempCustID = _pid;
        if
            :: true -> tempFood = CHILI;
            :: true -> tempFood = PIZZA;
            :: true -> tempFood = SANDWICH;
		fi;
        printf("Customer #%d: Places order for %e.\n", _pid, tempFood);

        // Wait for Food
        orders[Index].fulfilled == true;
        printf("Customer #%d exits restaurant with %e.\n", _pid, orders[Index].food);
od;
}

/*
  Cashier process
  1)wait for a new customer
  2)select waiting customer
  3)take order
  4)pass order to server

*/
active proctype Cashier() {
do
     ::	// Wait for a new customer
        printf("Cashier waits for a new customer.\n");

		//cashier can only place one order at a time for a customer
        down(place_order);

            printf("Cashier selects a waiting customer.\n");

            // Cashier takes the order
            if
              :: cashierIndex + 1 < LIST_SIZE ->
                    printf("Cashier is taking the order.\n");
                    orders[cashierIndex].CustID = tempCustID;
                    orders[cashierIndex].food = tempFood;
            //Cashier passes order to server
                    printf("Cashier passes Customer #%d's order to server.\n",orders[cashierIndex].CustID);
                    unfulfilledOrders++;
                    cashierIndex++;
                    up(mutex);
            fi;
     	
od;
}

/*
  Server Process
  1)wait for an order
  2)retrieve order(customer and food)
  3)make the order
  4)deliver order to (correct) customer
*/

active proctype Server() {
byte myOrder;
do
	::	// Wait for an order
		printf("Server #%d waits for an order.\n", _pid);
		atomic {
			unfulfilledOrders > 0;
			unfulfilledOrders--;
		}

		// Retrieve order
		atomic {
			myOrder = serverIndex;
			serverIndex++;
            if
              :: _pid % 2 == 0 -> Server1 = orders[myOrder].CustID;
            fi;
        }
		printf("Server #%d retrieves Customer #%d's order for %e.\n",
					_pid, orders[myOrder].CustID, orders[myOrder].food);

		// Make order
		printf("Server#%d makes Customer #%d's order.\n",
												_pid, orders[myOrder].CustID);

		// Deliver order
		printf("Server #%d delivers Customer #%d's order.\n",
												_pid, orders[myOrder].CustID);

		orders[myOrder].fulfilled = true;

od;
}

/*
  LTL statements
  1)server always gives correct food to cust
  2)It is always the case that if the customer wants to place an
    order then eventually the customer does
*/


ltl LivenessOrderPlaced {
	<> (mutex > 0);
}