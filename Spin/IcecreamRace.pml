mtype = {NO_ONE, MIKE, PETE} ;

mtype ice_cream_owner = NO_ONE;

active proctype M() {
    bool gotit = false ;

    if
    :: ice_cream_owner == NO_ONE ->
         ice_cream_owner = MIKE ;
         gotit = true ;
         printf("Mike says \"I've got it!\"\n") ;
    :: else
    fi ;                         //closing for if
    assert( ! gotit || ice_cream_owner == MIKE ) ;

}

active proctype P() {
    bool gotit = false;

    if
    :: ice_cream_owner == NO_ONE ->
         ice_cream_owner = PETE ;
         gotit = true ;
         printf("Pete says \"I've got it!\"\"\n") ;
    :: else
    fi ;
    assert( ! gotit || ice_cream_owner == PETE ) ;
}