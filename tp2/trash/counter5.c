#include <stdio.h>
#include "genpat.h"

char *inttostr(entier)
	int entier;
{
	char *str;
	str = (char *) mbkalloc (32 * sizeof (char));
	sprintf (str, "%d",entier);
	return(str);
}
/*------------------------------*/
/* end of the description       */
/*------------------------------*/

main ()
{
	int i;
	int j;
	int cur_vect = 0;

	DEF_GENPAT("counter5");

	/* interface */
	/*DECLAR ("a", ":2", "X", IN, "3  downto 0", "" );*/
	/*DECLAR ("b", ":2", "X", IN, "3  downto 0", "" );*/
	/*DECLAR ("s", ":2", "X", OUT, "3 downto 0", "" );*/
	DECLAR ("ck", ":2", "B", IN, "", "" );
	DECLAR ("i", ":2", "B", IN, "", "" );
	DECLAR ("reset", ":2", "B", IN, "", "" );
	DECLAR ("vdd", ":2", "B", IN, "", "" );
	DECLAR ("vss", ":2", "B", IN, "", "" );

	DECLAR ("o", ":2", "B", OUT, "", "" );

	LABEL ("counter5");
	AFFECT ("0", "vdd", "0b1");
	AFFECT ("0", "vss", "0b0");


	AFFECT (inttostr(cur_vect), "reset", inttostr(1) );
	AFFECT (inttostr(cur_vect), "reset", inttostr(0) );

	for (i=0; i<32; i++)
	{
		AFFECT (inttostr(cur_vect), "ck", inttostr(i%2) );
		for (j=0; j<4; j++)
		{
			AFFECT (inttostr(cur_vect), "i", inttostr(1) );
			cur_vect++;
		}
		for (j=0; j<4; j++)
		{
			AFFECT (inttostr(cur_vect), "i", inttostr(0) );
			cur_vect++;
		}
	}
	SAV_GENPAT ();
}
