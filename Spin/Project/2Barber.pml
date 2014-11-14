/*
 * Sleeping barbers problem - V 3.0
 * McAfee
 */


#define NB 2        /* number of barbers */
#define NC 4        /* number of customers */


chan custWaiting = [0] of {byte}; //cust id
chan custDone[NC] = [0] of {bool}; //dummy
chan barbFree =  [0] of {byte}; //barb id
chan nextCust[NB] = [0] of {byte}; //id of customer whose hair to cut
chan barbDone = [0] of {byte, byte};  //barber, client



//LTL var
local int numWaitingCust = 0;
local int numNappingBarbers = 0;
local int activeCust = 0;
local bool barbIsNapping[NB] = false;
local bool custIsWaiting[NC] = false;


proctype Barber(byte id){
	//full barber loop

	int cid;	

	do
	::
		//request next customer
		barbFree ! id;

		//wait for cust id
		nextCust[id] ? cid;

		//hair cutting time
		printf("B%d cuts C%d’s hair\n",id, cid) ;
		barbDone ! id, cid;

	//end full barber loop
	od;

}

proctype Customer(byte id) {

	do
	::	
		//enter shop
		custWaiting ! id;
		printf("C%d enters shop\n", id) ;


		custDone[id] ? true;
		//leave shop
		printf("C%d exits shop\n", id) ;
	od;
}

proctype WaitingRoom(){
	byte barbID = 0;
	byte custID = 0;

	do
		::custWaiting ? custID ->

			if
				::numNappingBarbers > 0->
					//get a napping barber
					do
						::barbIsNapping[barbID]->break;
						::else-> barbID = (barbID+1) % NB;
					od;
					// feed the customer to the barber
					numNappingBarbers--;
					activeCust++;
					nextCust[barbID] ! custID;

				::else->
					//if no barb, go wait
					numWaitingCust++;
					custIsWaiting[custID] = true;
			fi;


			skip;
		::barbFree ? barbID ->

			//check if can nap
			if
				::numWaitingCust < 1->
					numNappingBarbers++;
					barbIsNapping[barbID] = true;
					printf("B%d naps\n", barbID);
				::else->
					//if not, get waiting cust
					do
						::custIsWaiting[custID]->break;
						::else-> custID = (custID+1) % NC;
					od;
					numWaitingCust--;
					activeCust++;
					custIsWaiting[custID] = false;
					nextCust[barbID] ! custID;
			fi;

		:: barbDone ? barbID, custID ->
			//decrement active, tell customer they're done
			activeCust--; 
			custDone[custID] ! true;
	od;


}



//generate the actual barbers, customers 
init {
  byte i ;

  atomic {
#ifdef NB
    for( i : 0 .. NB-1 ) {
      run Barber(i) ;
    } ;
#endif

#ifdef NC
    for( i : 0 .. NC-1 ) {
      run Customer(i) ;
    } ;
#endif
	run WaitingRoom();
  }
}

/*
 * Safety claim
 * S_Safe
 *      # of customers is one or less
 */

ltl S_Safe {
    []   ( activeCust <= NB )
}

/*
 * L_Progress
 *      No napping with waiting customers
 */

ltl L_Progress {
    [] ( !( (numNappingBarbers == NB) && numWaitingCust>0 ) )
}

/*
 * L_Liveness
 *      There will always eventually be a state where one barber is awake 
 */

ltl L_Liveness {
    []  <> (numNappingBarbers < NB)
}