/**
 *	Each person has a salary, a property, and a pet.
 */
abstract sig Person{
	salary : Amount,
	property : Island,
	pet : Animal
}
one sig Celeste, Marcus, Nasir,
		Nataly, Ryder extends Person{}

/**
 *	Salaries (K61 = $61,000)
 */
enum Amount{ K61, K63, K180, K191, K233 }

/**
 *	Islands
 */
enum Island { Aruba, Grenada, Jamaica, StMartin, Tobago }

/**
 *	Animals (pets)
 */
enum Animal { Hamster, Parrot, Pig, Snake, Tarantula }

/*****
 *			FACTS
 ****/

fact F_1 {

}


fact F_2 {

}

fact F_3 {

}

fact F_4 {

}

fact F_5 {

}

fact F_6 {

}

fact F_7 {

}

fact F_8 {

}

fact F_9 {

}

fact F_10 {

}

fact F_11 {

}

run{}





