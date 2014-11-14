#define NPROC 4
bool in_cs[NPROC] ;		/* in_cs[i] <=> process i in its crit. sect. */

byte want_cs_count = 0 ;
byte in_cs_count = 0 ;

#define sema byte

inline down(s) { atomic { s > 0 ; s-- } }
inline up(s)  { s++ }

/*
 * Other names for down / up include
 *
 *	P / V		(original)
 *	acquire / release
 *	get / put
 */

sema mutex = 1 ;	/* generic mutual exclusion semaphore name */

proctype forever(byte id) {
	byte i = 0 ;

	do
	::
		/*
		 * Outside critical section for indeterminate
		 * amount of time.
		 */

		do
		:: true -> skip ;
		:: true -> break ;
		od ;

		/*
	         * ENTER CRITICAL SECTION
		 */

                want_cs_count++ ;
				down(mutex) ;
                want_cs_count-- ;

		/*
	         * IN CRITICAL SECTION -- 1 at a time
		 */

				in_cs[id] = true ;
                in_cs_count++ ;

                skip ;

                in_cs_count-- ;
				in_cs[id] = false ;

		/*
		 * EXIT CRITICAL SECTION
		 */

		up(mutex) ;
	od ;
}

init {
	byte i ;

	for ( i : 0 .. NPROC - 1  ) {
		run forever(i) ;
	}
}

ltl Safety {
[] (in_cs_count <= 1)
}

ltl Live {
[] ( (want_cs_count > 0) -> <> (in_cs_count > 0) )
}

ltl NoOneInCsForever {
[] ( (in_cs_count > 0) -> <> (in_cs_count == 0) )
}


