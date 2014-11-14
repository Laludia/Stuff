	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC Phil */
;
		;
		
	case 4: /* STATE 2 */
		;
		want_to_eat[ Index(((P0 *)this)->_1_me, 4) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		;
		
	case 6: /* STATE 4 */
		goto R999;

	case 7: /* STATE 7 */
		;
		now.fork[ Index(((P0 *)this)->_1_me, 4) ] = trpt->bup.oval;
		;
		goto R999;
;
		
	case 8: /* STATE 15 */
		goto R999;
;
		
	case 9: /* STATE 19 */
		goto R999;

	case 10: /* STATE 22 */
		;
		now.fork[ Index(((((P0 *)this)->_1_me+1)%4), 4) ] = trpt->bup.oval;
		;
		goto R999;
;
		
	case 11: /* STATE 30 */
		goto R999;

	case 12: /* STATE 34 */
		;
		want_to_eat[ Index(((P0 *)this)->_1_me, 4) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 14: /* STATE 36 */
		;
		eating[ Index(((P0 *)this)->_1_me, 4) ] = trpt->bup.oval;
		;
		goto R999;

	case 15: /* STATE 37 */
		;
		eating[ Index(((P0 *)this)->_1_me, 4) ] = trpt->bup.oval;
		;
		goto R999;

	case 16: /* STATE 38 */
		;
		now.fork[ Index(((P0 *)this)->_1_me, 4) ] = trpt->bup.oval;
		;
		goto R999;

	case 17: /* STATE 40 */
		;
		now.fork[ Index(((((P0 *)this)->_1_me+1)%4), 4) ] = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 19: /* STATE 46 */
		;
		p_restor(II);
		;
		;
		goto R999;
	}

