typedef Time 
{
	int minute, hour, second;
}

inline setTime(T, min, hr, sec){
T.minute = min; T.hour = hr; T.second = sec 
}


active proctype P()
{
Time t;
setTime(t,59,23,32);
printf ("min is %d\n", t.minute)
}