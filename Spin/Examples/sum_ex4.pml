active proctype P()
{
int i = 0;
int sum = 0;
int a[5];
a[0]=0; a[1]=10; a[2]=20; a[3]=30; a[4]=40;

do
:: i > 4 -> break
:: else -> sum = sum + a[i];
		 i++;
od;
printf ("The sum of the numbers is %d\n", sum)
}