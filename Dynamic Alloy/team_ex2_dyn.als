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


run {
	all st : Step | Invariant[st]
} for 12 but exactly 3 Step, exactly 3 Team




