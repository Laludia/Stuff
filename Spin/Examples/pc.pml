#define BUFSIZE 4

typedef message {
   byte from ;
   byte value ;
}
message buffer[BUFSIZE] ;
byte head = 0 ;
byte tail = 0 ;

#define sema byte
#define down(s) { atomic{s > 0 ; s--} }
#define up(s)   { s++ }

sema fullslots = 0 ;
sema emptyslots = BUFSIZE ;

/*
*	For ltl safety and liveness
*/


byte pwant = 0;
byte cwant = 0;
byte pincs = 0;
byte cincs = 0;

proctype Producer() {
	message msg ;

	msg.from = _pid ;
	do
	::
		/*
		 * Produce a message with a random
		 * value.
		 */
		if
		:: msg.value = 0 ;			/* random value from 0-3 */
		:: msg.value = 1 ;
		:: msg.value = 2 ;
		:: msg.value = 3 ;
		fi ;

		printf("P%d produces msg.from(%d) msg.value(%d)\n",
			_pid, msg.from, msg.value) ;
		/*
		 * Put message in next empty slot
		 */
		down(emptyslots) ;		/* wait for empty slot */

		atomic{
		buffer[tail].from = msg.from ;
		buffer[tail].value = msg.value ;
		tail = (tail + 1) % BUFSIZE ;
		}
		up(fullslots) ;
	od ;
}

proctype Consumer() {
	message msg ;    /* local message buffer */

	do
	::
		/*
		 * Get message from next full slot
		 */
		down(fullslots) ;			/* wait for incoming message */

		atomic{
		msg.from = buffer[head].from ;
		msg.value = buffer[head].value ;
		head = (head + 1) % BUFSIZE ;
		}

		up(emptyslots) ;

		printf("C%d consumes msg.from(%d) msg.value(%d)\n",
			_pid, msg.from, msg.value) ;
	od ;
}

init {
	atomic {
		run Producer() ;
		run Producer() ;
		run Consumer() ;
		run Consumer() ;
	}
}