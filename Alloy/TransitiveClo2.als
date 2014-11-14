sig Person{
    transcript : set Course
}

some sig Course {
    prereqs : set Course,
    enrolled : set Person
}

fact MustHavePreReq{
    all c : Course {                                //for all the courses
        all p : c.enrolled{                        //for all the people in those courses
            // course prereq to appear on their transcript
            c. prereqs in p.transcript  //course prerequisites in the enrolled person's transcript
         }
    }
}

fact CannotBeOwnPrereq{
    all c : Course | c ! in c. ^prereqs  //Transitive closure (^) to make it a acyclic direct graph
}

run{
    some enrolled          //AND  at least one or more person is enrolled
    some c : Course | #c.prereqs = 3 // one or more courses, the number of prereq must be 3
    Course. enrolled != Person //not all Person enrolled
    #Person = 4    //number of person is a 4
} for 5
