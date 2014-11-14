/**
 * The ordered Step set for sequencing states.
 */
open util/ordering[Step]
sig Step{}

/**
 *	Courses have a set of Persons enrolled at each step,
 *	an enrollment limit, and a set of prerequisite courses.
 */
some sig Course{
	enrolled		: Person -> Step,
	limit				: Int,
	prereqs			: set Course
}

/**
 *	Persons have a transcript of the courses they've completed.
 */
some sig Person {
	transcript	:	set Course,
}

/**
 *	Function to return the Courses Person p is taking
 *	at a given Step.
 */
fun taking[p : Person, st : Step] : set Course {
	(enrolled.st).p  //no need for parenthesis give a (course enrolled at a given step) for that person
}

/**
 *	A Person should not be able to retake a Course.
 *	That is, at the given Step the person is not
 *	enrolled in a course on the transcript.
 */
pred Cannot_Retake_Course[st : Step] {
	no p : Person | some p.transcript & taking[p, st]
}

/**
 *	For a Person to be enrolled in a Course at the given
 *	Step, the Course's prerequisites should be on the
 *	Person's transcript.
 */
pred Must_Have_Prereqs_To_Enroll[st : Step] {
	all p : Person, c : taking[p, st] {
		c.prereqs in p.transcript
	}
}

/**
 *	The number of Persons enrolled in a Course at a
 *	given Step should not exceed the Course's limit.
 */
pred Class_Limit_Enforced[st : Step] {
	all c : Course | #c.enrolled.st <= c.limit
}

/**
 *	The enrollment limit for a Course must be
 *	strictly positive.
 */
fact Class_Limit_Postive {
	all c : Course | c.limit > 0
}

/**
 *	A Course cannot be its own prerequisite, either
 *	directly or indirectly (that is, the prerequisite
 *	graph is a DAG).
 */
fact Cannot_Be_Own_Prerequisite {
	no c : Course | c in c.^prereqs
}

/**
 *	The transcript must be consistent in that for any Course
 *	on a Person's transcript, the Course's prerequisites must
 *	also be on the transcript.
 */
fact Consistent_Transcript {
	all p : Person | p.transcript.prereqs in p.transcript
}

/**
 * The invariant is the conjunction of all facts
 * that were converted to step-variant predicates
 */
pred Invariant[st : Step] {
	Cannot_Retake_Course[st]
	Must_Have_Prereqs_To_Enroll[st]
	Class_Limit_Enforced[st]
}

/**
 *	Will eventually show all legal states of up to 4
 *	Courses, up to 5 Persons, with an Int bit width
 *	of 5 (-16 .. 15) and up to 3 Steps.
 */
run{
	all st : Step | Invariant[st]
} for exactly 4 Course, exactly 5 Person, 5 Int, 3 Step

/**
 *	A restriction on the previous run statement:
 *	+ The state is legal at all Steps
 *	+	Some course must be full at some Step
 *	+	Some course with students enrolled has some
 *		prerequisites at some Step
 */
run{
	all st : Step | Invariant[st]
	some st : Step, c0 : Course | #c0.enrolled.st = c0.limit
	some st : Step, c1 : Course | some c1.enrolled.st && some c1.prereqs
} for exactly 4 Course, exactly 5 Person, 5 Int, 3 Step

/********************* INITIAL STATE ******************/

/**
 * In the initial state no one is enrolled in any courses.
 */
pred init[st : Step] {
	no enrolled.st
}

assert init_closed {
	init[first] => Invariant[first]
}
check init_closed for 6 but exactly 1 Step

pred init_exists {
	Invariant[first]
	init[first]
}
run init_exists for 6 but exactly 1 Step

/********************* ENROLL *********************/

/**
 *	If the precondition is met, enroll Person 'p' in
 *	Course 'c' at step 'st'. Nothing else changes.
 */
pred enroll[p : Person, c : Course, st : Step] {
	/*
	 * Preconditions
	 */
	st != last
	p ! in c.enrolled.st
	c ! in p.transcript
	c.prereqs in p.transcript
	#(c.enrolled.st) < c.limit

	let st' = next[st] {
		/*
		 * Effects
		 */
		c.enrolled.st' = c.enrolled.st + p

		/*
		 * Frame
		 */
		all c1 : Course - c | c1.enrolled.st' = c1.enrolled.st
	}
}

assert enroll_closed {
	all p : Person, c : Course {
		Invariant[first] && enroll[p, c, first] =>
			Invariant[next[first]]
	}
}
check enroll_closed for 6 but exactly 2 Step

pred enroll_exists {
	Invariant[first]
	some p : Person, c : Course | enroll[p, c, first]
}
run enroll_exists for 6 but exactly 2 Step
