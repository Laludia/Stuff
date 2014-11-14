
#define NPROC 4
bool in_cs[NPROC] ;		/* in_cs[i] <=> process i in its crit. sect. */

byte in_cs_count = 0 ;
byte want_cs_count = 0 ;

inline swap(v1, v2, t) { atomic {t = v1 ; v1 = v2 ; v2 = t} }
bool locked = false ;

proctype forever(byte id) {
	byte i = 1 ;
	bool swap_temp = false ;
	bool lock_was_set = false ;

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

		lock_was_set = true ;
		do
		:: lock_was_set ->
			swap(lock_was_set, locked, swap_temp) ;			
		:: else -> break
		od ;

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
		locked = false ;
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

