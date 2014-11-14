#define NPROC 2
bool in_cs[NPROC] ;		/* in_cs[i] <=> process i in its crit. sect. */

byte in_cs_count = 0 ;
byte want_cs_count = 0 ;

byte turn = 0 ;

proctype forever(byte id) {
	byte i = 1 ;

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
		if
		:: turn == id -> skip ;
		fi ;
        want_cs_count-- ;

		/*
	         * IN CRITICAL SECTION -- 1 at a time
		 */
		in_cs[id] = true ;
                in_cs_count++ ;

                skip ;

		in_cs[id] = false ;
                in_cs_count-- ;

		/*
		 * EXIT CRITICAL SECTION
		 */

		turn = (turn + 1) % NPROC ;
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

ltl NoHogging {
true
}


