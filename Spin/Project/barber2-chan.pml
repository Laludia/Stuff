#
# Two Sleeping Barbers
#
# Note, this model is a slightly modfied version of the
# single sleeping barber model. The customer will always go
# directly to the waiting room and not have the option of 
# sitting directly in a barber chair. This reduces the types
# of messages that need to exchanged.
#

#define NC 3
#define NB 2

local byte nwait = 0 ;
local byte nextc = 0 ;
local bool waiting[NC] = false ;

local byte nnap = 0 ;
local bool napping[NB] = false ;

mtype = { enter, next, complete } ;

chan to_room = [0] of { mtype, byte } ;

chan to_cust[NC] = [0] of { bool } ;

chan to_barber[NB] = [0] of { byte } ;

proctype Barber(byte id) {
    byte cid ;

    do
    ::
        to_room ! next(id) ;
        to_barber[id] ? cid ;

        printf("B%d cuts C%d’s hair\n", id, cid) ; 
        skip ;
        printf("B%d done with C%d\n", id, cid) ; 

        to_room ! complete(cid) ;
    od;
}

proctype Customer(byte id) {

    do
    ::
        printf("C%d enters shop\n", id) ;

        to_room ! enter(id) ;
        to_cust[id] ? _ ;

        printf("C%d exits shop\n", id) ; 
    od
}

proctype WaitingRoom() {
    byte cid ;  /* customer id */
    byte bid ;  /* barber id */
    mtype x ;
    do
    :: to_room ? enter(cid) ->
        if
        :: nnap > 0 ->
            if
            :: napping[0] ->
                bid = 0 ;
            :: napping[1] ->
                bid = 1 ;
            fi ;
            nnap-- ;
            napping[bid] = false ;
            to_barber[bid] ! cid ;
        :: else ->
            nwait++ ;
            waiting[cid] = true ;
            printf("C%d sits\n", cid) ;
        fi ;

    :: to_room ? next(bid) ->
        if
        :: nwait > 0 ->
            nextc = (nextc + 1) % NC ;
            do
            :: waiting[nextc] ->
                break ;
            :: else
                nextc = (nextc + 1) % NC ;
            od ;
            nwait-- ;
            waiting[nextc] = false ;
            to_barber[bid] ! nextc ;
        :: else ->
            nnap++ ;
            napping[bid] = true ;
            printf("B%d naps\n", bid) ;
        fi ;

    :: to_room ? complete(cid) ->
        to_cust[cid] ! true ;
    od ;
}

init {
    byte i ;

    atomic {
        
            run Barber(0) ;
			run Barber(1) ;
			run Customer(0);
			run Customer(1);
			run Customer(2);
       
        run WaitingRoom() ;
    }
}

ltl L_Live {
    [] ( (napping[0] && napping[1]) -> <> (! napping[0] || ! napping[1]) )
}

ltl L_Fair {
    [] ( waiting[0] -> <> ! waiting[0] )
}
