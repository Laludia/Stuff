/* SOLUTION FOR OPERATIONS */

/**
 * Schedule a new meeting 'm' in room 'r' at time 't' if this
 * will not cause a conflict.
 * Nothing else about the schedule or the other meetings is affected.
 */
pred scheduleMeeting[m : Meeting, r : Room, t : Time, st : Step] {
    /*
     * Preconditions
     */
    st != last
    m ! in Cal.schedule.st                    // meeting is not currently scheduled
    no m1 : Cal.schedule.st {            // check that no other meetings at that time or place
        m1.where.st = r
        m1.when.st = t
    }

    let st' = next[st] {
        /*
         * Effects
         */
        Cal.schedule.st' = Cal.schedule.st + m     // Calendar as before, with new meeting added
        m.where.st' = r
        m.when.st' = t                            // meeting being scheduled has time & room

        /*
         * Frame
         */
        all m1 : Meeting - m {                    // All meetinsg (less the one just scheduled
            m1.when.st' = m1.when.st     // have the same time AND
            m1.where.st' = m1.where.st  //  have the same room
        }
    }
}

assert scheduleMeeting_closed {
    all st : Step, m : Meeting, r : Room, t : Time {
        Invariant[st] && scheduleMeeting[m, r, t, st] =>
            Invariant[next[st]]
    }

}
check scheduleMeeting_closed for 6 but 2 Step

pred scheduleMeeting_exists {
    some st : Step, m : Meeting, r : Room, t : Time {
        Invariant[st]
        scheduleMeeting[m, r, t, st]
    }
}
run scheduleMeeting_exists for 4 but 2 Step

/************* Cancel a Meeting *************/

/**
 * Cancel a scheduled meeting 'm' by removing it from the schedule.
 * This may require updating information associated with 'm'.
 * No other meeting is affected.
 */
pred cancelMeeting[m : Meeting, st : Step] {
    /*
     * Preconditions
     */
    st != last                                    // Not the last step
    m in Cal.schedule.st                    // Meeting to be canceled is currently scheduled

    let st' = next[st] {
        /*
         * Effects
         */
        Cal.schedule.st' = Cal.schedule.st - m     // Meeting removed from scheduled
        no m.where.st'                                            // Canceled room AND
        no m.when.st'                                            // time now available

        /*
         * Frame
         */
        all m1 : Meeting - m {                    // All meetinsg (less the one just scheduled
            m1.when.st' = m1.when.st     // have the same time AND
            m1.where.st' = m1.where.st  //  have the same room
        }
    }
}

assert cancelMeeting_closed {
    all st : Step, m : Meeting {
        Invariant[st] && cancelMeeting[m, st] =>
            Invariant[next[st]]
    }
}
check cancelMeeting_closed for 6 but 2 Step

pred cancelMeeting_exists {
    some st : Step, m : Meeting {
        Invariant[st]
        cancelMeeting[m, st]
    }
}
run cancelMeeting_exists for 4 but 2 Step
