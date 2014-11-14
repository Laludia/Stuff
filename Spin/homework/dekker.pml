//Flag is boolean, turn is a byte

bool flag1 = false;
bool flag2 = false;

byte    turn = 1;


active proctype process1() {
    do
    ::  flag1 = true;   //non critical section
        do              //trying section
        :: !flag2 -> break;
        :: else ->
            if
            :: (turn == 1)
            :: (turn == 2) ->
                flag1 = false;
                (turn == 1);
                flag1 = true
            fi
        od;

        flag1 = false;  //critical section
        turn = 2
    od
}

active proctype process2() {
    do
    ::  flag2 = true;     //non critical section
        do                //trying section
        :: !flag1 -> break;
        :: else ->
            if
            :: (turn == 2)
            :: (turn == 1) ->
                flag2 = false;
                (turn == 2);
                flag2 = true
            fi
        od;

        flag2 = false;    //critical section
        turn = 1
    od
}
