abstract sig FName{
    last : LName,
    shoe: Shoe,
    color: Color
}

one sig Clarisse, Margaret, Nancy, Sally extends FName{}

enum LName { Barlow, Parker, Stevens, West}

enum Shoe { Boots, Flats, Pumps, Sandals}

enum Color { Black, Brown, Green, Pink }

fact OneToOne{     //unique names (first,last)
    all disjoint fn1, fn2: FName | fn1.last != fn2.last
    FName.last = LName
    FName.shoe  = Shoe
    FName.color = Color

}

fact One {
// Nancy Barlow didn't buy the boots
    Nancy. last = Barlow
    Nancy.shoe != Boots

}

fact Two{
// Ms. Parker bought the green shoes and Sally bought the pumps
    Sally.shoe = Pumps
    let w_parker = Parker.~last{ //don't know last name so refer it as a w_parker variable
      w_parker.color = Green
    }
    //or can just use Parker.~last.color = Green
}

fact Three{
//pumps aren't pink
    let w_pumps = Pumps.~shoe{
         w_pumps.color != Pink
    }
}

fact Four{
//boots were brown but were't purchased by Ms.West
    let w_boots = Boots.~shoe{
      w_boots.color = Brown
      w_boots.last != West
    }
}

fact Five{
//Sallly's last name isn't Stevens. Clarisse didn't buy the flats.
     Sally.last != Stevens
    Clarisse.shoe != Flats
}

fact Six{
//Margaret's last name wasn't Parker but she did get the sandals which weren't black
    Margaret.last != Parker
    Margaret.shoe = Sandals
    Margaret.color != Black
}


run{} for 4
