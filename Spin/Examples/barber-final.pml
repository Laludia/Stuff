#define NCHAIRS 2
#define	NCUSTS	3

#define NOBODY	255

/* SHARED STATE */

byte haircut = NOBODY ;
byte chair[NCHAIRS] = NOBODY ;

byte first = 0 ;	/* first waiting customer's chair */
byte next = 0 ;		/* chair for the next customer */
byte nwaiting = 0 ;	/* how many customers are waiting? */
byte nserving = 0 ;	/* how many customers getting served? */

#define sema byte
#define up(s) { s++ ; }
#define down(s) { atomic{ s > 0 ; s-- } }

sema mutex = 1 ;

sema in_chair = 0 ;

sema cust_wait[NCUSTS] = 0 ;

proctype Customer(byte me) {

	do
	::
		printf("C%d enters\n", me) ;

		down(mutex) ;
		if
		:: haircut == NOBODY ->
			printf("C%d does not have to wait\n", me) ;
			skip ;
		:: else ->
			chair[next] = me ;
			printf("C%d sits in chair %d\n", me, next) ;

			next = (next + 1) % NCHAIRS ;
			nwaiting++ ;
			up(mutex) ;
			down(cust_wait[me]) ;
		fi ;

		/*******/

		haircut = me ;
		nserving++ ;
		printf("C%d sits in barber chair\n", me) ;
		up(in_chair);
		up(mutex) ;
		down(cust_wait[me]) ;

		printf("C%d leaves with a nice haircut\n", me) ;
	od ;
}

proctype Barber() {
	byte cust = NOBODY ;

	do
	::
		down(in_chair) ;
		down(mutex) ;		/* really don't need this - why? */
		cust = haircut ;
		up(mutex) ;			/* end of unnecessary CS */

		printf("Barber cuts C%d's hair\n", cust) ;

		/*
		 * Switching the following two statements
		 * leads to a safety violations
		 * (ltls S_NoOvercrowding below)
		 * and liveness
		 */
		down(mutex) ;
		up(cust_wait[cust]) ;
		nserving-- ;

		if
			/*
			 * No-one is waiting. So the haircut is
			 * for NOBODY and the barber sleep.
			 */
		:: nwaiting == 0 ->
			haircut = NOBODY ;
			printf("Barber sleeps\n") ;
			up(mutex) ;
			/*
			 * Somebody waiting. Choose the customer in the
			 * first chair, update first, decrement the
			 * number of waiters, and signal the customer to
			 * proceed.
			 */
		:: else ->
			cust = chair[first] ;
			chair[first] = NOBODY ;
			first = (first + 1) % NCHAIRS ;
			nwaiting-- ;
			up(cust_wait[cust]) ;
		fi ;
	od ;
}


init {
	byte c ;

	atomic {
		for( c : 0 .. NCUSTS-1 ) {
			run Customer(c)
		}
		run Barber() ;
	}
}

/*
 * We never have more customers in the waiting
 * area than chairs (given NCUSTS <= NCHAIRS+1).
 */
ltl S_NoOvercrowding {
	[] (nwaiting <= NCHAIRS)
}

/*
 * At most one customer is being served at a time.
 */
ltl S_AtMostOneHaircut {
	[] (nserving <= 1)
}

/*
 * Liveness - the barber always gives someone a
 * haircut eventually - if not we'd have deadlock.
 */
ltl L_EventuallyServeSomebody {
	[]<>(haircut != NOBODY)
}

/*
 * If folks are waiting then eventually someone gets a haircut
 */
ltl L_WaitingMeansService {
	[]((nwaiting > 0) -> <>(haircut != NOBODY))
}

/*
 * This *should* fail. It claims that after some possible
 * startup the haircut can never be NOBODY.
 */
ltl L_FAIL_IfBarberCanGoIdle {
	<>[](haircut != NOBODY)
}

/*
 * Each customer who is waiting for a haircut eventually gets one.
 */
ltl F_GetHaircutIfDesired {
	[]	(
			( (chair[0] == 0 || chair[1] == 0) -> <>(haircut == 0) )
					&&
			( (chair[0] == 1 || chair[1] == 1) -> <>(haircut == 1) )
					&&
			( (chair[0] == 2 || chair[1] == 2) -> <>(haircut == 2) )
		)
}




















