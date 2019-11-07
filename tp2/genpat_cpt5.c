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
	int N = 8;
	int nb = 0;
	int c = 0;
	int i;
	int o;
	int cur_vect = 0;
	int pas = 5;
	int cpt = 0;

	DEF_GENPAT("cpt5");

	/* interface */
	DECLAR ("reset" ,":2", "B", IN, "", "" );
	DECLAR ("vdd"   ,":2", "B", IN, "", "" );
	DECLAR ("vss"   ,":2", "B", IN, "", "" );
	DECLAR ("ck"    ,":2", "B", IN, "", "" );
	DECLAR ("i"     ,":2", "B", IN, "", "" );
	DECLAR ("o"     ,":2", "B", OUT,"", "" );

	LABEL ("cpt5");
	AFFECT ("0", "vdd", "0b1");
	AFFECT ("0", "vss", "0b0");
	AFFECT ("0", "ck", "0b1");
	AFFECT ("0", "reset", "0b1");
	AFFECT (inttostr(2*pas), "reset", "0b0");
	AFFECT (inttostr(0), "o", "0B*");
	AFFECT ("0", "i", "0b0");

	/*for(nb=0; nb<N; nb++){*/
		/*for (c=0; c<nb; c++){*/

			/*AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));*/
			/*AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));*/

			/*if(c==0){*/
				/*i=0;*/
				/*o=0;*/
				/*cpt=0;*/
			/*}*/
			/*else{*/
				/*i=1;*/
				/*cpt++;*/
				/*if(cpt>=5)  o=1;*/
				/*else        o=0;*/
			/*}*/
			/*AFFECT (inttostr(cur_vect*2*pas +   pas), "i", inttostr(i) );*/
			/*AFFECT (inttostr(cur_vect*2*pas + 2*pas), "o", inttostr(o) );*/
			/*cur_vect++;*/
		/*}*/
	/*}*/

	SAV_GENPAT ();
}
