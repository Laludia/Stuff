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
 * lock bit - controlled by atomic access
 */
bool locked = false ;

/*
 * Turn - possession arrow to break ties for access.
 */

bit turn = 0 ;

/*
 * In-line function to atomically swap two variables, x & y,
 * using a temporary t.
 */
inline swap(x, y, t) { atomic{ t = x ; x = y ; y = t } }

/*
 * Forever process (2 copies)
 */
active[2] proctype FE() {
    byte me = _pid ;
    byte you = 1 - me ;

	bit set_lock = false ;
    bit temp = false ;

	do
	::
		/*
		 * Outside critical section for indeterminate
		 * amount of time.
		 */
		skip ;

	    /*
         * ENTER CRITICAL SECTION - GET AND SET LOCK
         * (busy wait)
         */
        want_cs[me] = true ;

		/*
         * Give the other guy a chance if he wants one.
         */
		if
        :: ! (turn == you && want_cs[you]) -> skip
        fi ;

        set_lock = true ;
		do
        :: set_lock ->
            swap(set_lock, locked, temp) ;
        :: else ->
            break ;
        od ;

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
        locked = false ;
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
