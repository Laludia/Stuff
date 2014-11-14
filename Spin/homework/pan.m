#define rand	pan_rand
#if defined(HAS_CODE) && defined(VERBOSE)
	cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC Phil */
	case 3: /* STATE 1 - philosophers.pml:47 - [printf('P%d is thinking\\n',me)] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][1] = 1;
		Printf("P%d is thinking\n", ((int)((P0 *)this)->_1_me));
		_m = 3; goto P999; /* 0 */
	case 4: /* STATE 2 - philosophers.pml:52 - [want_to_eat[me] = 1] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][2] = 1;
		(trpt+1)->bup.oval = ((int)want_to_eat[ Index(((int)((P0 *)this)->_1_me), 4) ]);
		want_to_eat[ Index(((P0 *)this)->_1_me, 4) ] = 1;
#ifdef VAR_RANGES
		logval("want_to_eat[Phil:me]", ((int)want_to_eat[ Index(((int)((P0 *)this)->_1_me), 4) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 5: /* STATE 3 - philosophers.pml:53 - [printf('P%d wants to chow down\\n',me)] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][3] = 1;
		Printf("P%d wants to chow down\n", ((int)((P0 *)this)->_1_me));
		_m = 3; goto P999; /* 0 */
	case 6: /* STATE 4 - philosophers.pml:55 - [(((me%2)==0))] (12:0:0 - 1) */
		IfNotBlocked
		reached[0][4] = 1;
		if (!(((((int)((P0 *)this)->_1_me)%2)==0)))
			continue;
		/* merge: printf('P%d wants the Right fork\\n',me)(0, 5, 12) */
		reached[0][5] = 1;
		Printf("P%d wants the Right fork\n", ((int)((P0 *)this)->_1_me));
		/* merge: .(goto)(0, 13, 12) */
		reached[0][13] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 7: /* STATE 6 - philosophers.pml:58 - [((fork[me]>0))] (12:0:1 - 1) */
		IfNotBlocked
		reached[0][6] = 1;
		if (!((((int)now.fork[ Index(((int)((P0 *)this)->_1_me), 4) ])>0)))
			continue;
		/* merge: fork[me] = (fork[me]-1)(0, 7, 12) */
		reached[0][7] = 1;
		(trpt+1)->bup.oval = ((int)now.fork[ Index(((int)((P0 *)this)->_1_me), 4) ]);
		now.fork[ Index(((P0 *)this)->_1_me, 4) ] = (((int)now.fork[ Index(((int)((P0 *)this)->_1_me), 4) ])-1);
#ifdef VAR_RANGES
		logval("fork[Phil:me]", ((int)now.fork[ Index(((int)((P0 *)this)->_1_me), 4) ]));
#endif
		;
		/* merge: .(goto)(0, 13, 12) */
		reached[0][13] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 8: /* STATE 15 - philosophers.pml:62 - [printf('P%d got his Right fork\\n',me)] (0:32:0 - 3) */
		IfNotBlocked
		reached[0][15] = 1;
		Printf("P%d got his Right fork\n", ((int)((P0 *)this)->_1_me));
		/* merge: .(goto)(0, 18, 32) */
		reached[0][18] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 9: /* STATE 19 - philosophers.pml:69 - [(((me%2)==1))] (27:0:0 - 1) */
		IfNotBlocked
		reached[0][19] = 1;
		if (!(((((int)((P0 *)this)->_1_me)%2)==1)))
			continue;
		/* merge: printf('P%d wants the Left fork\\n',me)(0, 20, 27) */
		reached[0][20] = 1;
		Printf("P%d wants the Left fork\n", ((int)((P0 *)this)->_1_me));
		/* merge: .(goto)(0, 28, 27) */
		reached[0][28] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 10: /* STATE 21 - philosophers.pml:72 - [((fork[((me+1)%4)]>0))] (27:0:1 - 1) */
		IfNotBlocked
		reached[0][21] = 1;
		if (!((((int)now.fork[ Index(((((int)((P0 *)this)->_1_me)+1)%4), 4) ])>0)))
			continue;
		/* merge: fork[((me+1)%4)] = (fork[((me+1)%4)]-1)(0, 22, 27) */
		reached[0][22] = 1;
		(trpt+1)->bup.oval = ((int)now.fork[ Index(((((int)((P0 *)this)->_1_me)+1)%4), 4) ]);
		now.fork[ Index(((((P0 *)this)->_1_me+1)%4), 4) ] = (((int)now.fork[ Index(((((int)((P0 *)this)->_1_me)+1)%4), 4) ])-1);
#ifdef VAR_RANGES
		logval("fork[((Phil:me+1)%4)]", ((int)now.fork[ Index(((((int)((P0 *)this)->_1_me)+1)%4), 4) ]));
#endif
		;
		/* merge: .(goto)(0, 28, 27) */
		reached[0][28] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 11: /* STATE 30 - philosophers.pml:76 - [printf('P%d got his left fork\\n',me)] (0:34:0 - 3) */
		IfNotBlocked
		reached[0][30] = 1;
		Printf("P%d got his left fork\n", ((int)((P0 *)this)->_1_me));
		/* merge: .(goto)(0, 33, 34) */
		reached[0][33] = 1;
		;
		_m = 3; goto P999; /* 1 */
	case 12: /* STATE 34 - philosophers.pml:80 - [want_to_eat[me] = 0] (0:0:1 - 3) */
		IfNotBlocked
		reached[0][34] = 1;
		(trpt+1)->bup.oval = ((int)want_to_eat[ Index(((int)((P0 *)this)->_1_me), 4) ]);
		want_to_eat[ Index(((P0 *)this)->_1_me, 4) ] = 0;
#ifdef VAR_RANGES
		logval("want_to_eat[Phil:me]", ((int)want_to_eat[ Index(((int)((P0 *)this)->_1_me), 4) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: /* STATE 35 - philosophers.pml:85 - [printf('P%d is eating\\n',me)] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][35] = 1;
		Printf("P%d is eating\n", ((int)((P0 *)this)->_1_me));
		_m = 3; goto P999; /* 0 */
	case 14: /* STATE 36 - philosophers.pml:86 - [eating[me] = 1] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][36] = 1;
		(trpt+1)->bup.oval = ((int)eating[ Index(((int)((P0 *)this)->_1_me), 4) ]);
		eating[ Index(((P0 *)this)->_1_me, 4) ] = 1;
#ifdef VAR_RANGES
		logval("eating[Phil:me]", ((int)eating[ Index(((int)((P0 *)this)->_1_me), 4) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 15: /* STATE 37 - philosophers.pml:87 - [eating[me] = 0] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][37] = 1;
		(trpt+1)->bup.oval = ((int)eating[ Index(((int)((P0 *)this)->_1_me), 4) ]);
		eating[ Index(((P0 *)this)->_1_me, 4) ] = 0;
#ifdef VAR_RANGES
		logval("eating[Phil:me]", ((int)eating[ Index(((int)((P0 *)this)->_1_me), 4) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 16: /* STATE 38 - philosophers.pml:92 - [fork[me] = (fork[me]+1)] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][38] = 1;
		(trpt+1)->bup.oval = ((int)now.fork[ Index(((int)((P0 *)this)->_1_me), 4) ]);
		now.fork[ Index(((P0 *)this)->_1_me, 4) ] = (((int)now.fork[ Index(((int)((P0 *)this)->_1_me), 4) ])+1);
#ifdef VAR_RANGES
		logval("fork[Phil:me]", ((int)now.fork[ Index(((int)((P0 *)this)->_1_me), 4) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 17: /* STATE 40 - philosophers.pml:93 - [fork[((me+1)%4)] = (fork[((me+1)%4)]+1)] (0:0:1 - 1) */
		IfNotBlocked
		reached[0][40] = 1;
		(trpt+1)->bup.oval = ((int)now.fork[ Index(((((int)((P0 *)this)->_1_me)+1)%4), 4) ]);
		now.fork[ Index(((((P0 *)this)->_1_me+1)%4), 4) ] = (((int)now.fork[ Index(((((int)((P0 *)this)->_1_me)+1)%4), 4) ])+1);
#ifdef VAR_RANGES
		logval("fork[((Phil:me+1)%4)]", ((int)now.fork[ Index(((((int)((P0 *)this)->_1_me)+1)%4), 4) ]));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 18: /* STATE 42 - philosophers.pml:94 - [printf('P%d finished eating and is thinking\\n',me)] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][42] = 1;
		Printf("P%d finished eating and is thinking\n", ((int)((P0 *)this)->_1_me));
		_m = 3; goto P999; /* 0 */
	case 19: /* STATE 46 - philosophers.pml:96 - [-end-] (0:0:0 - 1) */
		IfNotBlocked
		reached[0][46] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

