/*
 * Basic signatures.
 *
 * A signature defines a set of elements or atoms
 *   - An atom has no internal structure at all
 *   - The only property an atom has is identity (we can
 *     whether or not two atoms are equal or different).
 *   - An atom belongs to the set defined by its signature.
 *
 * Top level signatures partition the universal set (univ)
 *   - univ is the union of all such signatures.
 *   - the top level signatures are pair-wise disjoint.
 *     (i.e., no atom is a member of more than one top-level
 *     signature).
 */
 
sig Person{}
sig Period{}
sig Room{}

/*
 * Course is a signature with fields (relations to atoms in
 * other signatures).
 *   - set - a group of zero or more atoms, no order, no dups.
 *   - a unique atom
 *   - some - a set of one or more atoms (not empty).
 */

sig Course {
  instructor			: lone Person,
	enrolled			: set Person,
	where				: one Room,
	when				: some Period
}

/*
 * Facts define the "axioms" of our system - rules that must
 * hold for any possible configuration of signatures and
 * fields.
 */
fact NoCourseRoomConflicts {
	all disj c1, c2 : Course |
		some c1.when & c2.when => c1.where != c2.where
}


/*
 * If a person is enrolled in two different courses, the
 * courses have no periods in common.
 */
fact NoStudentConflicts {
	all p : Person, disj c1, c2 : Course |
		(p in c1.enrolled && p in c2.enrolled) => no c1.when & c2.when
}

/*
 *If a Course has an instructor, that Person cannot 
 *be enrolled in the Course. (be careful!)
 */
fact NoInstructEnroll{
    all p: Person, c1 : Course | 
         (p in c1.instructor) =>no c1.instructor & c1. enrolled 
}

/*
 *No Person can instruct a Course that has Periods 
 *in common with a Course in which he is enrolled.
 */
fact NoStudentInstruct{
    all p:Person, disj c1,c2 : Course| 
         (p in c1.instructor && p in c2. enrolled) => no c1.when & c2.when
}

/*No Person can instruct different Courses that 
 *have any Periods in common.
 */
fact NoInstructPeriod{
    all p:Person, disj c1,c2:  Course | 
        (p in c1.instructor && p in c2.instructor) => no c1.when & c2.when
}

/*
 * Run lets us see all possible configuration up to a given
 * maximum size for each signature in our model.
 *   - The boolean / logical statement in braces further
 *     constrains the possible solutions.
 *   - An empty constrain is true - that is, any
 *     solution consistent with the facts is ok.
 */
run {
	# Course >= 2
	# Period >= 2
	# enrolled >= 2
} for 5
