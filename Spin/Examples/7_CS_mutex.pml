/*
 * Number of processes, including init.
 */
#define NPROC 4

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
 * Pseudo-type semaphore
 */

#define semaphore byte

/*
 * Mutual exclusion semaphore (initially 1).
 */
semaphore mutex = 1 ;

/*
 * Up and down functions on semaphores.
 * down blocks if the semaphore is 0 on entry.
 * 1)intial value for "semaphore mutex = 1" will go to 0
 * 2) after going through it again it'll be back to 1
 */
inline up(s)    { s++ }
inline down(s)  { atomic{ s > 0 ; s-- } }

/*
 * Forever process (2 copies)
 */
active[4] proctype FE() {  //running 4 processes (active[4])
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
         * ENTER CRITICAL SECTION - GET AND SET LOCK
         * (busy wait)
         */
        want_cs[me] = true ;
        down(mutex)
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
         up(mutex) ;
	od ;
}

/*
 * SAFETY
 * Mutually exclusive entry into critical section.
 */
ltl MutualExclusion {
    [] (! (in_cs[0] && in_cs[1] && in_cs[2] && in_cs[3]) )
}

/*
 * SAFETY (FAIL = SUCCESS)
 * Claim no process can ever enter - counter example
 * shows entry is possible.
 */
ltl F_NeverEnter { // fail safety shows *can* enter CS
    [] (! (in_cs[0] || in_cs[1] || in_cs[2] || in_cs[3]) )
}

/*
 * LIVENESS (ACCEPTANCE)
 * At any point in time, if some process wants to enter
 * its then eventually some process does enter its CS.
 */
ltl EventuallyEnter {
    [] ( (want_cs[0] || want_cs[1] || want_cs[2] || want_cs[3]) ->
            <> (in_cs[0] || in_cs[1] || in_cs[2] || in_cs[3]) )
}

/*
 * FAIRNESS
 * Both will eventually enter if they want to.
 */
ltl AllCanEnter {
    [] (
         (want_cs[0] -> <> in_cs[0]) &&
         (want_cs[1] -> <> in_cs[1]) &&
         (want_cs[2] -> <> in_cs[2]) &&
         (want_cs[3] -> <> in_cs[3])
       )
}
