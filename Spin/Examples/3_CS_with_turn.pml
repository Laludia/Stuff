/*
 * Number of processes, including init.
 */
#define NPROC 2

/*
 * want_cs[i] is true <-> process with pid = i wants to enter its CS.
 * This array is used to gain or deny access to the CS.
 */
bool want_cs[NPROC] = false ;

/*
 * in_cs[i] is true <-> process with pid = i is *in* its CS.
 * (for 1 <= i < NPROC)
 */
bool in_cs[NPROC] = false ;

/*
 * Whose turn is it? 0 or 1?
 */
byte turn = 1 ;

/*
 * Forever process (2 copies)
 */
active[2] proctype FE() {
    byte me = _pid ;
    byte you = 1 - me ;

	do
	::
		/*
		 * Outside critical section for indeterminate
		 * amount of time.
		 */

		skip ;

		/*
	         * ENTER CRITICAL SECTION
		 */

        want_cs[me] = true ;
		if
		:: turn == me -> skip ;
		fi ;
        want_cs[me] = false ;

		/*
	         * IN CRITICAL SECTION -- 1 at a time
		 */
		in_cs[me] = true ;

        printf("P %d in CS\n", me) ;

		in_cs[me] = false ;

		/*
		 * EXIT CRITICAL SECTION
		 */

         turn = you ;
    od ;
}

/*
 * SAFETY
 * Mutually exclusive entry into critical section.
 */
ltl MutualExclusion {
    [] (! (in_cs[0] && in_cs[1]) )
}

/*
 * SAFETY (FAIL = SUCCESS)
 * Claim no process can ever enter - counter example
 * shows entry is possible.
 */
ltl F_NeverEnter { // fail safety shows *can* enter CS
    [] (! (in_cs[0] || in_cs[1]) )
}

/*
 * LIVENESS (ACCEPTANCE)
 * At any point in time, if some process wants to enter
 * its then eventually some process does enter its CS.
 */
ltl EventuallyEnter {
    [] ( (want_cs[0] || want_cs[1]) -> <> (in_cs[0] || in_cs[1]) )
}

/*
 * FAIRNESS
 * Both will eventually enter if they want to.
 */
ltl BothCanEnter {
    [] (
         (want_cs[0] -> <> in_cs[0]) &&
         (want_cs[1] -> <> in_cs[1])
       )
}
