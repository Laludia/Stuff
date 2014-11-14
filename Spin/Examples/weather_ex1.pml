mtype = {snowing, raining, sunny} ;

chan to_channel = [0] of { mtype, byte } ;


active proctype WeatherChannel() {
    short temp_in = 0 ;
    chan response_ch ;

    do
    :: to_channel ? sunny, temp_in ->
        temp_in++;
		printf("The condition is %e and temp is %d\n", sunny, temp_in);

    :: to_channel ? raining, temp_in ->
        temp_in--;
		printf("The condition is %e and temp is %d\n", raining, temp_in);

	:: to_channel ? snowing, temp_in ->
        temp_in = temp_in-2;
		printf("The condition is %e and temp is %d\n", snowing, temp_in);

    od ;
}



active proctype User() {
    mtype condition = sunny ;
    short current_temp = 0 ;
    chan my_result = [0] of { short } ;

    do
    ::
        if
        :: true -> condition = sunny ;
        :: true -> condition = raining ;
        :: true -> condition = snowing ;
        fi ;

        if
        ::          condition == sunny ;
		            printf("Send condition %e\n", condition) ;
                    to_channel ! sunny, current_temp ;
        
		::          condition == raining;
		            printf("Send condition %e\n", condition) ;
                    to_channel ! raining, current_temp ;

		::          condition == snowing;
		            printf("Send condition %e\n", condition) ;
                    to_channel ! snowing, current_temp ;

        fi ;

    od ;
}

