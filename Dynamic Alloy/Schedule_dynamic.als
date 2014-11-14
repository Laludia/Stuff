open util/ordering[Step] as step //(NEW) Added ordering for dyanamicism
sig Step{}   //(NEW) step signature pairs with ordering-skip variant


/**
		The set of tasks, including the idle task.
*/
enum Task {IDLE, Java, Python, Ruby}

/**
		The (one and only) Scheduler.
*/
one sig Scheduler {
	onCPU :			Task -> Step,	//(NEW) onCPU : one Task
	blocked :		Task -> Step,	// (NEW) blocked: set Task
	runnable :	Task -> Step	// (NEW) runnable: set Task
}

pred OneTaskOnCPU[st : Step] { //only one task on the cpu by adding pred
		one Scheduler.onCPU.st
}
/**
		All tasks are either runnable or blocked, and
		no task is both runnable and blocked.
		(i.e., blocked and runnable partition task)
*/
pred Partitioning[st : Step] {  //(NEW) fact Partitioning {
	Scheduler.(runnable.st + blocked.st) = Task  //(NEW)Scheduler.(runnable + blocked) = Task
	no Scheduler.runnable.st & Scheduler.blocked.st  //basically added (.st) for the set
}

/**
		The IDLE task is always runnable.
		The IDLE task is on the cpu if and only if
		there are no other runnable tasks.
*/
pred IDLE_Task_Runnable[st : Step] {
	IDLE in Scheduler.runnable.st
}

/**
		The IDLE task is on the cpu if and only if
		there are no other runnable tasks.
*/
pred IDLE_Task_LastToRun[st : Step] {
	IDLE = Scheduler.onCPU.st <=> IDLE = Scheduler.runnable.st
}

/**
		The task on the CPU is a runnable task.
*/
pred onCPU_is_Runnable[st : Step] {
	Scheduler.onCPU.st in Scheduler.runnable.st
}

//------------------------Define Invariant and initial States------------------------//

pred Invariant[st : Step] {
		OneTaskOnCPU[st]
		Partitioning[st]
		IDLE_Task_Runnable[st]
		IDLE_Task_LastToRun[st]
		onCPU_is_Runnable[st]
}

pred init[st : Step] {
	one Scheduler.onCPU.st
	Scheduler.onCPU.st + IDLE = Scheduler.runnable.st
	Scheduler.blocked.st = Task - IDLE - Scheduler.onCPU.st
}
pred init_exists {
	Invariant[step/first]   //instance exists
	init[step/first]
}
run init_exists for 4 but exactly 1 Step    //looking for Effective (states exist)
assert init_closed {
	all st : Step | init[st] => Invariant[st]  //initial step leads to invariant step (valid start step)
}
check init_closed for 4 but exactly 1 Step  //looking for Closure



//------------------------Block Operation------------------------//

/*
 * Block the task currently on the CPU
 */
pred block[st : Step] {
	/*
	 * Preconditions
	 */
	st != step/last   //step can't be last step
	Scheduler.onCPU.st != IDLE   //can't block the idle task

	let st' = next[st] {
		/*
		 * Effects (Post Conditions)
		 */

		Scheduler.runnable.st' = Scheduler.runnable.st - Scheduler.onCPU.st //whoever is blocked on the cpu  is blocked
		Scheduler.blocked.st' = Scheduler.blocked.st + Scheduler.onCPU.st

		IDLE = Scheduler.runnable.st' => Scheduler.onCPU.st' = IDLE //runnable set contains idle, everythign else is blocked
		IDLE != Scheduler.runnable.st' => 
			(
				Scheduler.onCPU.st' in Scheduler.runnable.st' - IDLE && //runnable set of CPU except Idle, put that one on CPU
				one Scheduler.onCPU.st'
			)
	}
}
assert block_closed {
	all st : Step - step/last {
		Invariant[st] && block[st] => Invariant[next[st]]
	}
}
check block_closed for 4 but exactly 2 Step

pred block_exists {
	Invariant[step/first]
	block[step/first]
	Invariant[ next[step/first] ]
}
run block_exists for 4 but exactly 2 Step

//------------------------------------------UNBLOCK OPERATION---------------------------------------//
/*
 * Unblock a currently blocked task
 */
pred unblock[st : Step, t : Task] {   // t = task to unblock
	/*
	 * Preconditions
	 */
	st != step/last
	t in Scheduler.blocked.st   // t has to be blocked

	let st' = next[st] {
		/*
		 * Effects
		 */
		Scheduler.runnable.st' = Scheduler.runnable.st + t //something that was runnable and  set t is blocked
		Scheduler.blocked.st' = Scheduler.blocked.st - t //anything that is blocked minus the set
		Scheduler.onCPU.st = IDLE => Scheduler.onCPU.st' = t //put a task that is runnable(Idle) on the cpu
		Scheduler.onCPU.st != IDLE => Scheduler.onCPU.st' = Scheduler.onCPU.st //if it isn't cpu then it'll be in the same state
	}
}
assert unblock_closed {  //THIS PATTERN IS COMMON
	all t:Task, st : Step - step/last {
		Invariant[st] && unblock[st, t] => Invariant[next[st]]
	}
}
check unblock_closed for 4 but exactly 2 Step

pred unblock_exists {
     some t : Task {
		Invariant[step/first]
		unblock[step/first, t]
		Invariant[ next[step/first] ]
	}
}
run unblock_exists for 4 but exactly 2 Step

//------------------------------------------SWITCH OPERATION---------------------------------------//

/*
 * Switch a currently blocked task
 */
pred switch[st : Step] {   
	/*
	 * Preconditions
	 */
	st != step/last
	some disj t1,t2 : Task | (t1 + t2) in Scheduler.runnable.st - IDLE
	/* same as above
	IDLE != Scheduler.onCPU.st
	some t: TASK | t in Scheduler.runnable.st - IDLE - Scheduler.onCPU.st
    */
	let st' = next[st] {    // can't say exactly what task, but can characterize it
		/*
		* Effects
		*/
	some t : Scheduler.runnable.st {    
		t != IDLE
		t != Scheduler.onCPU.st
		Scheduler.onCPU.st' =  t    // somebody new on CPU in next step
	     }
	/*
	* Framing condition - what doesn't change
	*/
	Scheduler.runnable.st' = Scheduler.runnable.st
	Scheduler.blocked.st' = Scheduler.blocked.st
	}
}

assert switch_closed {
	all st : Step - step/last {
		Invariant[st] && switch[st] => Invariant[next[st]]
	}
}
check switch_closed for 4 but exactly 2 Step

pred switch_exists {
		Invariant[step/first]
		switch[step/first]
		Invariant[ next[step/first] ]
}
run switch_exists for 4 but exactly 2 Step

/******* Trace Predicate ********/

pred trace {
	init[step/first]

	all st : Step - step/last {
			(
				block[st]
			)
					||
			(
				some t : Task | unblock[st, t]
			)
					||
			(
				switch[st]
			)
	}
}
run trace for 4 but 8 Step

pred suppose {
	trace

	some disj st1, st2, st3, st4 : Step {
		Scheduler.onCPU.st1 = IDLE
		Scheduler.onCPU.st2 = Java
		Scheduler.onCPU.st3 = Python
		Scheduler.onCPU.st4 = Ruby
	}
}
run suppose for 4 but 12 Step
