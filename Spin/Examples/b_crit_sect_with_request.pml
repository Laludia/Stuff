#define NPROC 2
bool in_cs[NPROC] ;		/* in_cs[i] <=> process i in its crit. sect. */
bool want_cs[NPROC] ;           /* request flag */

byte w_cs_cnt = 0 ;
byte in_cs_cnt = 0 ;

proctype FE(byte id) {
	byte i = 1 ;
	bool owants = false ;

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

        w_cs_cnt++ ;
		do
		::
			want_cs[id] = true ;
			owants = false ;

			for ( i : 0 .. NPROC - 1 ) {
				owants = owants || (i != id && want_cs[i]) ;
			}

			if
			:: ! owants ->
				break ;
			:: else
				want_cs[id] = false ;
			fi ;
		od ;
                w_cs_cnt-- ;

		/*
	         * IN CRITICAL SECTION -- 1 at a time
		 */
		in_cs[id] = true ;
                in_cs_cnt++ ;

                skip ;

		in_cs[id] = false ;
                in_cs_cnt-- ;

		/*
		 * EXIT CRITICAL SECTION
		 */

		want_cs[id] = false ;
	od ;
}

init {
	byte i ;

	for ( i : 0 .. NPROC - 1 ) {
		want_cs[i] = false ;
	}

	for ( i : 0 .. NPROC - 1  ) {
		run FE(i) ;
	}
}

ltl Safety {
 [] (in_cs_cnt <= 1)
}

ltl Live {
 [] ( (w_cs_cnt > 0) -> <> (in_cs_cnt > 0) )
}

ltl NoHogging {
true
}

