byte gcd = 0 ;

proctype GCD( byte ox ; byte oy ) {
	byte temp = 0 ;
	byte x = ox ;
	byte y = oy ;


	do
	:: x > y -> temp = y ; y = x - y ; x = temp ;
	:: x < y -> temp = x ; x = y - x ; y = temp ;
	:: x == y -> break ;
	od ;

	gcd = (ox*oy)/x ;
	printf("GCD of %d and %d is %d\n", ox, oy, gcd) ;
}

init {
	run GCD(12, 18) ;
}
