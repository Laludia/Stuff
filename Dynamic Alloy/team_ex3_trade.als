open util/ordering[Step]

abstract sig Person {}
sig Coach, Player extends Person {}

sig Step {}

sig Team {
	coach : one Coach,
	roster: Player some -> Step
}


---------------------Facts----------------------
//Coaches cannot coach more than one team

fact f_coach {
	Coach = Team.coach //every coach is associated with a team

	no disj t1, t2 : Team | t1.coach = t2.coach //coaches cannot coach more than one team
}


---------------------Predicates----------------------

pred p_roster [st : Step] {
	Player = Team.roster.st // every player is associated with a team
	all disj t1, t2 : Team |no t1.roster.st & t2.roster.st // players cannot play for two teams
	all disj t1, t2 : Team | #t1.roster.st = #t2.roster.st //every team has the same number of players
} 

//the state invariant that must hold at every step
pred Invariant [st : Step]{
	p_roster[st]
}


pred p_run {
	some st : Step - last, t1, t2: Team, t1r, t2r : Player | 
	(trade [t1, t1r, t2, t2r, st] 
	and Invariant[st])
}


pred trade [t1: Team, t1r : set Player, t2: Team, t2r : set Player, st : Step] {

	//Pre-condition
	one st.next //a next step exists
	--t1r in t1.roster.st // can only trader players you have
	--t2r in t2.roster.st // have to trade the same number of players
	--#t1r = #t2r //trade the same number of players
	-- t1 != t2 //have to trade with a different team
	-- some t1r  // need to handle the case where players is an empty set

	//Post-condition - two teams swap teams 
	let st' = st.next{
		t1.roster.st' = t1.roster.st - t1r + t2r // trade player(s)
		t2.roster.st' = t2.roster.st - t2r + t1r // trade player(s)
	}

	//Frame condition - no change to other team's rosters
	let st' = st.next {
		all t : Team - (t1 + t2) | t.roster.st' = t.roster.st
	}
}


---------------------Run----------------------
run p_run for 12 but exactly 2 Player, exactly 3 Step, exactly 2 Team




