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
open util/ordering[Step] as st    
sig Step{}									// step variant or step signature

/**
 * Cars that may be parked in the garage.
 */
some sig Car{}

/**
 * The spaces for cars in the garage.
 * A space is occupied by at most one car.
 */
some sig Space{
	parked : Car-> Step	          // add the step variant to parked
}

/**
 * Any given car is parked in at most one space.
 */
pred AtMostOneSpacePerCar[st : Step] {
	all c : Car | lone parked.st.c					// note that that the Step (st) has to be specified before Car (c)
}

/**
* Any given space holds at most one care
*/
pred AtMostOneCarPerSpace[st : Step] {
	all s : Space | lone s.parked.st
}

pred Invariant[st : Step]{				// The Inariant is just the composition of predicates defined above
	AtMostOneSpacePerCar[st]
	AtMostOneCarPerSpace[st]
}

//-------------------------------  Invariant and Initial State ----------------------------------------------------//

run{													// This run will create instances that satisfy the Invariant
	all st : Step | Invariant[st]
} for 5

pred init[st : Step]{						// The defined initial state - no cars are paked
	no parked.st
}

assert init_closed {							// Check for closure, does the initial state satisfy the Invariant?
	init[first] => Invariant[first]		// Check show produce no counterexamples
}	
check init_closed for 6 but 1 Step  // Note - just 1 Step as we only have the initial state

pred init_exists{							   // Is the initial state effective? (Do instances exist?)
	init[first]									  //  We should just see Cars & Spaces with no associations
	Invariant[first]
}
run init_exists for 6 but 1 Step

//-------------------------------  Park Operation - a car enters and parks  -----------------------//

pred park[c : Car, st : Step]{
	/*
	 * Prerequisites
	 * Not last step; car not already parked; space available.
	 */
	st != last											// not the last step
	no parked.st.c									// car is not already parked
	some s : Space | no s.parked.st		// one or more spaces where a car is not parked

	let st' = next[st] {  //MUCH IMPORTANT STEP
		/*
		 * Effects (Post Condition)
		 */
		one s : Space {							// The exactly one space effected in this operation - 
			no s.parked.st							// That was empty at the start of this operations (st)-
			s.parked.st' = c						// Now contains the parked car (c) in the next step (st')
			/*
			 * Frame (What does not change)
			 */
			all s1 : Space - s {						// All spaces (less the one effected by this operation)
				s1.parked.st' = s1.parked.st	// remain in the same state (parked or not)
			}
		}
	}
}

assert park_closed {								// Closure (assert/check)
	all st : Step - last, c : Car {
		Invariant[st] && park[c, st] =>
			Invariant[next[st]]
	}
}
check park_closed for 6 but 2 Step

pred park_exists {								 // Effective (run)
	some st : Step, c : Car {
		Invariant[st]
		park[c, st]
	}
}
run park_exists for 6 but 2 Step

//-------------------------------  Exit  Operation  -  a car leaves the garage---------------------//

pred exit[c : Car, st : Step] {
	/*
	 * Prerequisites
	 * Not last step; the one car c is currently parked
	 */
	st != last
	one parked.st.c			
	let st' = next[st] {  //post condition st' (st prime)
		/*
		 * Effects (Post Conditions)
		 */
		let s = parked.st.c {  
			no s.parked.st'					// Space containg previously parked car is empty

			/*
			 * Frame (what doesn't change)
			 */
			all s1 : Space - s |		  // All othe spaces remain as they were
				s1.parked.st' = s1.parked.st
		}
	}
}

assert exit_closed {						// Closure
	all st : Step - last, c : Car {
		Invariant[st] && exit[c, st] =>
			Invariant[next[st]]
	}
}
check exit_closed for 6 but 2 Step

pred exit_exists {						// Effective
	some st : Step, c : Car {
		Invariant[st]
		exit[c, st]
	}
}
run exit_exists for 6 but 2 Step
	

