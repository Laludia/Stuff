//open util/ordering[Act]   - This model does not use ordering on the Act sig, as Act maintains a pos field.
//										    We still use functions and predicates from ordering when composing our facts

// An act has an associated country, award, and order in which its
// award was given.
// Acts are further broken down into solo and group acts (this will be
// useful in defining some of the facts).

abstract sig Act {
	country : Country,
	award :	  Award,
	pos : Position
}

abstract sig Solo extends Act{}
one sig Spires, Willins, Kinoque extends Solo{}

abstract sig Group extends Act{}
one sig Six, Spots extends Group{}

// Countries and awards are simple enumerations.

enum Country{	Australia, Canada, Ireland, USA, UK }
enum Award {	BestAct, BestAlbum, BestNew,	BestSingle, BestVideo }

enum Position { First, Second, Third, Fourth, Fifth }

// The general facts are that the award and country relations are 1-1.
// Each act has one award and one country; each award has one act; each
// country has one act.

fact AwardCountryGeneralFacts {
	Act.award = Award
	Act.country = Country
	Act.pos = Position
}

// The remaining facts are taken directly from the numbered statements.

// Fact #1 - Bratney Spires received her award later in the evening than Bobbie Willins, 
//                 who received the award for Best Video of the year.
fact F_1 {
	gt[Spires.pos, Willins.pos]							// gt is a predicate from util/ordering : e1 is greater than e2 in the ordering
	Willins.award = BestVideo
}

// Smiley Kinogue received her award immediately before a group received theirs.
// She was not the third act to receive an award that night.
// Note - from the statements about Kinoque we know she did not receive her
// award in *two* of the possible five positions (orders).

fact F_2 {    														  // This one's a little tricky
	let afterKinoque = Kinoque.pos.next.~pos {    // The act at the pos (~pos) standing next to Kinoque's position
		one afterKinoque											 //  There is exaclty one Act at that position
		afterKinoque in Group									 //  The Act is a Group
	}
	Kinoque.pos != Third
}

// Fact #3 	To build up the tension, the award for Best Act of the year is not given out until the very end. 
//                  It was not an Irish act that received this award.

fact F_3 {
	let bestact = award.BestAct {
		bestact.pos = Fifth
		bestact.country != Ireland
	}
}

// Fact #4  The UK group was the fourth act to receive an award (not for Best Single) on the night.

fact F_4 {
	let ukact = country.UK {
		ukact in Group
		ukact.pos = Fourth
		ukact.award != BestSingle
	}
}

// Fact 5    The Australian act received the award for Best Album of the year, which was not the first award given out.
fact F_5 {
	let aussieact = country.Australia {
		aussieact.award = BestAlbum
		aussieact.pos != First
	}
}

// Fact 6  	6ix who are a boy band from Canada ...blah, blah, blah
fact F_6 {
	Six.country = Canada
}

run{}
