byte x = 10 ;

active proctype decrement() {
    int oldx = x :

    printf("Hello, world\n") ;
    printf("x = %d\n" , x) ;

    if
    :: x <= 10 -> x++ ;
    :: x >= 10 -> x-- ;
    fi;

    printf("x = %d\n" , x);
    assert(x <= oldx ) ;
)