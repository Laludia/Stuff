/*
 * Three processes (init is process 0)
 */
#define NPROC 3

/*
 * Create to boolean arrays
 *      want_cs[i] is true when process 'i' wants to enter its
 *          critical section but has not yet passed the "gate"
 *      in_cs[i] is true when process 'i' is in its critical
 *          section.
 */
bool want_cs[NPROC] = false ;
bool in_cs[NPROC] = false ;

/*
 * Boolean used as a gate - cannot enter critical section
 * when inuse is true.
 */
bool inuse = false ;

/*
 * The forever process
 */
proctype forever() {
    do
    ::
        /*
         * Outside critical section for a bit, but not
         * forever.
         */

        skip ;

        /*
         * ENTER CRITICAL SECTION
         */
        want_cs[_pid] = true ;
        printf("P%d wants to enter its CS\n", _pid) ;
        if
        :: ! inuse ->
            inuse = true ;
        fi ;
        want_cs[_pid] = false ;
        printf("P%d passes the gate\n", _pid) ;

        /*
         * IN CRITICAL SECTION -- 1 at a time
         */
        in_cs[_pid] = true ;
        printf( "P%d in its CS\n", _pid) ;
        in_cs[_pid] = false ;

        /*
         * EXIT CRITICAL SECTION
         */
        printf("P%d exits its CS\n", _pid) ;
        inuse = false ;
    od ;
}

/*
 * Fire off two instances of the forever process.
 */
init {
    run forever() ;
    run forever() ;
}

/*
 * Both processes can't be in their CS simultaneously
 */
ltl Safety {
  [] (! (in_cs[1] && in_cs[2]) )
}

/*
 * If one or more processes wants to enter its CS then
 * eventually one will.
 */
ltl Liveness_1_EventuallyAWanterWillEnter {
    [] ( (want_cs[1] || want_cs[2]) -> <>(in_cs[1] || in_cs[2]) )
}

/*
 * It's always the case that eventually a process in its CS
 * exits the CS (when no one will be in it)
 */
ltl Liveness_2_EventuallyExitCS {
    [] ( (in_cs[1] || in_cs[2]) -> (! in_cs[1] && ! in_cs[2]) )
}
