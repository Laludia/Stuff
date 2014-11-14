byte x = 15;
byte y = 21 ;

active proctype Min() {
	byte min = 0 ;

	if
	:: x <= y -> min = x ;
	:: y <= x -> min = y ;
	fi ;
	printf("Minimum of %d and %d is %d\n", x, y, min) ;
}
































/*
active proctype Max() {
	byte max = 0 ;

	if
	:: x >= y -> max = x ;
	:: y >= x -> max = y ;
	fi ;
	printf("Max of %d and %d is %d\n",
		x, y, max)
}
*/