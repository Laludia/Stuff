abstract sig Person{
	father : lone Man,
	mother : lone Woman
}

sig Man extends Person{
	// FILL IN: "every Man may or may not be married, but if married has only one Woman as a wife"
    wife : lone Woman

}

sig Woman extends Person{
	// FILL IN: "every Woman may or may not be married, but if married has only one Man as a husband"
    husband : lone Man

}

fact NotYourOwnAncestor{
	// FILL IN: "No person can be their own ancestor"
    no p: Person | p in p.^ (mother +father)    //none of the people are (reachable) to own parents
}

fact HusbandWifeSymetry{
	// FILL IN: "If someone is your husband, you are his wife and visa versa"
    wife = ~husband    //a man's wife has that man as husband... vice versa
}

fact NoIncest{
	// FILL IN: "No person has a spouse who is also an ancestor"
    no (husband +wife) & ^(mother +father)     //no married couple and no (reachable) ancestor exists

}

run { }
