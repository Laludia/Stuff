/**********************
 ***
 ***	Change this to an equivalent dynamic
 ***	model, with facts (implicit and explicit) turned into
 ***	Step-dependent predicates.
 ***	Add an Invariant that combines all these predicates
 ***	into one overall claim.
 ***
 ***	Then define each of the predicates below, and attach
 ***	appropriate closure assertions and existence predicates.
 ***
 ***	init[st : Step]
 ***		The initial state has no cars in any space in the garage.
 ***
 ***	park[c : Car, st : Step]
 ***		At step 'st', a new car 'c' enters the garage an parks
 ***		in an empty space. No other car of space changes.
 ***		Get the prerequisites right!
 ***
 ***	exit[c : Car, st : Step]
 ***		A car 'c' currently parked exits the garage at
 ***		step 'st'. No other car or space changes.
 ***
 **********************/
open util/ordering[Step] as step //(NEW) Added ordering for dyanamicism
sig Step{}

/**
 * Cars that may be parked in the garage.
 */
some sig Car{}

/**
 * The spaces for cars in the garage.
 * A space is occupied by at most one car.
 */
some sig Space{
	parked : Car -> Step  //field of space is occupied by car (dependent on step whether it's parked)
}

/**
 * Any given car is parked in at most one space.
 */

//--------------Invariant---------------//

pred AtMostOneSpacePerCar[st:Step] {
	all c:Car | lone parked.st.c
}

/**
* Any given space holds at most one care
*/
pred AtMostOneCarPerSpace[st: Step] {
    all s: Space | lone s.parked.st
}

pred Invariant[st:Step]{ //Invariants are referenced from the operations
    AtMostOneSpacePerCar[st]
    AtMostOneCarPerSpace[st]
}

//----------------------------------------//


run { } for 5
