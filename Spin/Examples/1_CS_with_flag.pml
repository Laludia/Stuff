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
 * inuse flag - true if a critical section is inuse.
 */
bool inuse = false ;

/*
 * Forever process (2 copies).
 */
active[2] proctype FE() {
    byte me = _pid ;
    byte you = 1 - me ;

    do
    ::
        /*
         * Outside critical section for a bit, but not
         * FE.
         */

        skip ;

        /*
         * ENTER CRITICAL SECTION
         */
        want_cs[me] = true ;
        printf("P%d wants to enter its CS\n", me) ;
        if
        :: ! inuse ->
            inuse = true ;
        fi ;
        want_cs[me] = false ;
        printf("P%d passes the gate\n", me) ;

        /*
         * IN CRITICAL SECTION -- 1 at a time
         */
        in_cs[me] = true ;
        printf( "P%d in its CS\n", me) ;
        in_cs[me] = false ;

        /*
         * EXIT CRITICAL SECTION
         */
        printf("P%d exits its CS\n", me) ;
        inuse = false ;
    od ;
}

/*
 * SAFETY
 * Mutually exclusive entry into critical section.
 */
ltl MutualExclusion {
    [] (! (in_cs[0] && in_cs[1]) )
}
