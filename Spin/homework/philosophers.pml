/*
 * Number of processes, including init.
 */
#define NPROC 4

/*
 * want_to_eat[i] is true <-> philospher with pid = i wants
 * two forks to eat.
 */
bool want_to_eat[NPROC] = false ;

/*
 * eating[i] is true <-> philosopher with pid = i has both
 * forks and is eating.
 */
bool eating[NPROC] = false ;

/*
 * Pseudo-type semaphore
 */
#define semaphore byte

/*
 * Forks - each fork *is* a mutual exclusion semaphore
 */
semaphore fork[NPROC] = 1 ;

/*
 * Up and down functions on semaphores.
 * down blocks if the semaphore is 0 on entry.
 */
#define up(s)    { s++ }
#define down(s)  { atomic{ s > 0 ; s-- } }

/*
 * Forever process (4 copies)
 */
active[4] proctype Phil() {
    byte me = _pid ;


	do
	::
		/*
		 * Thinking
		 */
		printf("P%d is thinking\n", me) ;

	    /*
         * Get The Forks
         */
        want_to_eat[me] = true ;
		printf("P%d wants to chow down\n", me) ;
        if  //Philosopher"me" has pid of even
        ::(me % 2) == 0 ->
            printf("P%d wants the Right fork\n", me);
            do
            :: down(fork[me]); //gets right fork
            :: else ->
                 break; //do nothing
            od;
            printf("P%d got his Right fork\n", me);
        :: else
        fi;


//left fork
        if  //Philosopher"me" has pid of of
        ::(me % 2) == 1 ->
            printf("P%d wants the Left fork\n", me);
            do
            :: down(fork[ (me + 1) % NPROC ]) ; //gets left fork
            :: else ->
                 break; //do nothing
            od;
            printf("P%d got his left fork\n", me);
        :: else
        fi;

        want_to_eat[me] = false ;

		/*
	     * Eating
		 */
        printf("P%d is eating\n", me) ;
		eating[me] = true ;
		eating[me] = false ;

		/*
		 * Give Back The Forks
		 */
         up(fork[me]) ;
		 up(fork[ (me + 1) % NPROC ]) ;
		 printf("P%d finished eating and is thinking\n", me) ;
	od
}