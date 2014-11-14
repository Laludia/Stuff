sig Person{}
sig Period{}
sig Room{}
sig Course{
    enrolled: set Person,     //set = 0 or more
    when: some Period,     //some = at least one
    where: one Room         //one = one room
}

//sig Instructor{}

fact NoCourseRoomConflict{
    all disjoint c1, c2:Course | some c1.when & c2.when => c1.where != c2.where
}

fact NoPersonPeriodConflict{
    all disjoint p:Person, disjoint c1, c2:Course | (p in c1.enrolled &&
         p in c2.enrolled) => no c1.when & c2.when
}

run {
    #Course >=2
    #Period >=2
    #enrolled >=2
} for 5
