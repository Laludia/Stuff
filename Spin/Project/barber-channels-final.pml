#define NCUST 4
#define NCHAIR 1
#define NO_ONE 255 //popular value (255) to define that no one is there-value is used for chair

chan customer_to_room = [0] of { mtype, byte } ; /* customer makes request to room, byte=cust ID */
chan barber_to_room = [0] of { mtype } ;		 /* barber is done */

chan to_barber = [0] of { mtype, byte } ;		 /* from either room or customer */
chan to_customer[NCUST] = [0] of { mtype } ;

/*
 * Customer to waiting room.
 */
mtype = { ENTER } ;

/*
 * Customer to barber.
 */
mtype = { IN_CHAIR } ;

/*
 * Waiting room to customer
 */
mtype = { SIT, NO_ROOM } ;

/*
 * Barber room to customer
 */
mtype = { HAVE_A_SEAT } ;

/*
 * Waiting room to barber.
 */

mtype = {NAP, NEXT_CUST} ;  //barber channel has NAP and next customer option


/*
 * Barber to waiting room and customer.
 */

mtype = {DONE} ;

proctype WaitingRoom() {  //before the "do" the previous statements are initializations
	byte eid = 0;				/* cust ID entering -initial*/
	byte in_bchair = NO_ONE;	/* cust ID in barber chair -initial*/
	byte in_wrchair = NO_ONE;	/* cust ID in waiting chair -intial*/

	to_barber ! NAP, 0;			/* create well defined state -barber is initialized sleeping*/

	do
	::	customer_to_room ? ENTER, eid->		/* enter ID of cust */
										/* cust_to_room ? ENTER(eid)  */
		if
		::	in_wrchair != NO_ONE ->  //the waiting room is full
				to_customer[eid] ! NO_ROOM; //sends NO_ROOM message to customer
		::  in_bchair == NO_ONE ->		/* assume no one in chair, no one waiting */
				to_barber ! NEXT_CUST(eid);
				in_bchair = eid;
		::	else ->
				to_customer[eid] ! SIT;
				in_wrchair = eid;
		fi;
	:: barber_to_room ? DONE -> //room channel is waiting for message
		if
		::	in_wrchair != NO_ONE ->  //person in waiting chair
				to_barber ! NEXT_CUST(in_wrchair);  //lets barber know there is next cust
				in_bchair = in_wrchair;
				in_wrchair = NO_ONE;  
		::	in_wrchair == NO_ONE ->  //no on in waiting chair (so channel tells barber can nap)
				to_barber ! NAP, 0;		/* ignore customer ID */
				in_bchair = NO_ONE; //no one in barber chair
		fi;
	od ;
}

proctype Barber() {
	byte next_id = NO_ONE ;
	byte in_id = NO_ONE;
	do          //barber in forever loop doing either of those 3 choices
	:: to_barber ? NAP, _ ->          //barber is sleeping the "_" means the data doesn't matter
		printf("Barber naps zzzzzzzzzz\n");

	:: to_barber ? NEXT_CUST(next_id) ->  //customer is here(taken from channel)
		to_customer[next_id] ! HAVE_A_SEAT;  //tell customer to sit down

	:: to_barber ? IN_CHAIR(in_id) ->  //in chair (invited by barber)
		assert(next_id == in_id);			/* is this the expected customer? */
		printf("Barber gives C%d a haircut\n", in_id);
		to_customer[in_id] ! DONE;
		barber_to_room ! DONE;
		
	od ;
}

proctype Customer(byte id) {
	do
	::	customer_to_room ! ENTER(id) ; //barber enters room
		if
		:: to_customer[id] ? NO_ROOM -> //waiting room is full
			skip;
		:: to_customer[id] ? HAVE_A_SEAT ->  //sitting in chair option
			to_barber ! IN_CHAIR(id);   //barber cuts hair
			to_customer[id] ? DONE;     //customer haircut is done
		:: to_customer[id] ? SIT ->
			to_customer[id] ? HAVE_A_SEAT ->  //sitting in waiting room(barber chair is occupied case)
			to_barber ! IN_CHAIR(id);     //barber chair available
			to_customer[id] ? DONE;       //haircut is done
		fi;		
	od ;
}

init {
	byte i ;

	atomic {
		for(i : 0 .. NCUST - 1) { //for customers at the start-all want haircut
			run Customer(i) ;
		}
		run Barber() ;
		run WaitingRoom() ;
	}
}











