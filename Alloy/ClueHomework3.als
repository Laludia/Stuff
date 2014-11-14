abstract sig SurName{
    male :MName,
    female: FName,
    animal: Animal,
    bird : Bird
}

one sig Connor, Carver, Jones, Porter, White extends SurName{}

enum MName {Tom, Paul, Mike, Peter, Jim}

enum FName{Olivia, Patricia, Sandra, Joanna, Marjorie}

enum Animal{ fox, beaver, coyote, rabbit, woodchuck}

enum Bird { turkey, eagle, swan, goose, pheasant}

fact OneToOne{
    //unique names
    all disjoint s1, s2: SurName | s1.male != s2.male
    SurName. male = MName
    SurName.female  = FName
    SurName.animal = Animal
    SurName. bird = Bird

}

/*
FACT 1: Tom, who wasn't married to Olivia, saw a fox. 
The couple that saw the beaver also saw wild turkeys.
*/
fact One {
    Tom. ~male.animal = fox
    Tom. ~male.female != Olivia
    beaver.~animal.bird = turkey
}
/*
FACT 2: Patricia Carver didn't see the pheasant. Paul didn't see the eagle.
The Jones' saw a coyote. Jim's last name wasn't White.
*/
fact Two{
    Carver.female = Patricia
    Carver.bird != pheasant
    Paul.~male.bird != eagle
    Jones.animal = coyote
    White.male != Jim
}

/*
FACT 3: The Porters didn't see the swans. Tom wasn't married to Sandra
and his last name wasn't Jones. The Connors spotted a rabbit.
*/
fact Three{
    Porter.bird != swan
    Tom.~male.female != Sandra
    Jones.male != Tom
    Connor.animal = rabbit
} 

/*
FACT 4: The couple who saw the coyote didn't see the swan. Mike, whose
last name wasn't Connor, didn't see the woodchuck. Sandra saw the gooses.
*/
fact Four{
    coyote.~animal.bird != swan
    Connor.male != Mike
    Mike.~male.animal != woodchuck
    Sandra.~female.bird = goose
}


/*
FACT 5: Peter and his wife Joanna didn't see the wild turkeys. Jim, whose last
name wasn't Jones, saw the pheasant but not the woodchuck
*/
fact Five{
    Peter.~male.bird != turkey
    Peter.~male.female = Joanna
    Joanna.~female.bird != turkey
    Jones.male != Jim
    Jim.~male.bird = pheasant
    Jim.~male.animal != woodchuck
}

/*
FACT 6: Marjorie White didn't see the swans. Paul Porter didn't see the beaver.
*/
fact Six{
    White.bird != swan
    White.female = Marjorie
    Porter.male = Paul
    Porter.animal !=beaver
}

run {} for 5
