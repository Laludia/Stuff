open util/ordering[Person] as po

abstract sig Person{
    name: Name,
    country: Country,
    award :Award,
}

enum Name{ Bobbie, Bratney, Six, Smiley, Spots}
enum Award{ Act, Album, Newcomer, Single, Video}
enum Country { Australia, Canada, Ireland, UK, USA}
//spots and six are group

fun earlier[p : Person] : lone Person {
	prev[p]
}
fun later[p : Person] : lone Person {
	next[p]
}

fun at_Ord1 : Person { po/first }
fun at_Ord2 : Person { later[at_Ord1] }
fun at_Ord3 : Person { later[at_Ord2] }
fun at_Ord4 : Person { later[at_Ord3] }
fun at_Ord5 : Person { later[at_Ord4] }

//no two distinct person/group have the same has the same Name, Country, and Award
fact OneToOne{
    no disjoint p1, p2 : Person| p1.name = p2.name //no two people/group have the same name
    no disjoint p1, p2 : Person| p1.country = p2.country    //no two people/group have same country
    no disjoint p1, p2 : Person| p1.award = p2.award    //no two people/group have same Award
}

fact One{
/*
Bratney received her award later in the evening than Bobbie, who received the award for Best Video
of the year.
*/
    later[name.Bobbie] = name.Bratney
    name.Bobbie = award.Video
}

fact Two{
/*
Smiley received her award immediately before a group received theirs. She was not the third to receive
an award that night
*/
    (later[name.Smiley] =name.Six) or (later[name.Smiley]= name.Spots)
    name.Smiley != at_Ord3
    
}

fact Three{
/*
Best Act is at Ord5. Irish didn't receive this reward
*/
    award.Act = at_Ord5
    country.Ireland != award.Act
}

fact Four{
/*
The UK group was the Ord4. Didn't receive Single award
*/
    country.UK != award.Single
    country.UK = at_Ord4
    country.UK = name.Spots or country.UK = name.Six
    

}

fact Five{
/*
Australian act received Album. They aren't at Ord1
*/
    country.Australia != at_Ord1
    country.Australia = award.Album

}

fact Six{
/*
Six is Canada
*/
    name.Six = country.Canada
}

run {} for 5
