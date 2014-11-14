chan request = [0] of {byte};

active proctype Server () {
byte rec;
end:
do
:: request ? rec -> printf("Rx: %d\n", rec);
od
}

active proctype Client(){
byte send = 0;
do
::	send = send + 1;
	printf("Sx: %d\n", send);
	request ! send;
od
}