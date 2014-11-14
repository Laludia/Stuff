#define NCUST 4
#define NCHAIR 1

chan customer_to_room = [0] of { mtype, byte } ;
chan barber_to_room = [0] of { mtype } ;

chan to_barber = [0] of { mtype, byte } ;
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

mtype = {NAP, NEXT_CUST} ;


/*
 * Barber to waiting room and customer.
 */

mtype = {DONE} ;

proctype Customer(byte id) {
	do
	::
		skip ;
	od ;
}

proctype Barber() {
	byte id = 0 ;
	do
	::
		skip ;
	od ;
}

proctype WaitingRoom() {
	do
	::
		skip ;
	od ;
}

init {
	byte i ;

	atomic {
		for(i : 0 .. NCUST - 1) {
			run Customer(i) ;
		}
		run Barber() ;
		run WaitingRoom() ;
	}
}











