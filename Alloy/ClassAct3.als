abstract sig Person{}

sig Faculty extends Person {}

abstract sig Student extends Person {}

sig Grad, Undergrad extends Student {}                            //student composes of Grad and Undergrad

sig Instructor in Person{                                                     //instructor teaches Course
    teaches : Course
}

sig Course{
    taughtby: one Instructor,
    enrolled: some Student,
    waitlist: set Student,
    prereq: set Course
    
}


------------FACTS--------------
//Fact 1: All instructors are either faculty or graduate students
fact{
    all i : Instructor | i in Faculty + Grad                                // (i in Grad or i in Faculty)


//Fact 2 : You cannot teach a course that you are enrolled in or are on the waitlist for it
    all c: Course | c.taughtby !in (c.enrolled + c.waitlist)     //instructor ISNOT in (enrolled or waitlist)


//Fact 3: Course cannot be a pre-req of itself (or any course that is a pre-req for)
    all c: Course | c !in c. ^prereq                                         //Transitive closure (^) to make it a acyclic direct graph


//Fact 4: No one can be on the waiting list of a course unless someone is enrolled in that course
    all c: Course | some c.waitlist =>  some c.enrolled        //if someone is on the waitlist it implies that someone is enrolled


//Fact 5: No student can be enrolled and on the waiting list for the same course
    all c: Course | no (c.enrolled & c.waitlist)                      //no union for enrolled and waitlist

}


---------ASSERTIONS-----------

// No instructor is on the waitlist for a course they teach
assert InstructorWaitlist{
     all c: Course | no (c.taughtby & c.waitlist)

}
check InstructorWaitlist

//No student can be enrolled and on the waiting list for the same course
assert StudentEnroll {
    all c: Course | no (c.waitlist & c.enrolled)

}
check StudentEnroll

run MyRun1{}

---------PREDICATES-----------
pred p_academic {
     some Grad & Instructor
#Course > 1
#Undergrad > 2
}

run p_academic for 4
