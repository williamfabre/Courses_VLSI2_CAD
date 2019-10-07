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

	DEF_GENPAT("digicode");

	/* interface */
	DECLAR ("vdd"		,":2", "B", IN, "", "" );
	DECLAR ("vss"		,":2", "B", IN, "", "" );
	DECLAR ("reset"		,":2", "B", IN, "", "" );
	DECLAR ("ck"		,":2", "B", IN, "", "" );
	DECLAR ("jour"		,":2", "B", IN, "", "" );
	DECLAR ("press_kbd"	,":2", "B", IN, "", "" );
	DECLAR ("O"		,":2", "B", IN, "", "" );
	DECLAR ("timer5_tm"	,":2", "B", IN, "", "" );
	DECLAR ("timer120_tm"	,":2", "B", IN, "", "" );
	DECLAR ("i"		,":2", "B", IN, "3 DOWNTO 0", "" );
	DECLAR ("timer5_en"	,":2", "B", OUT,"", "" );
	DECLAR ("timer120_en"	,":2", "B", OUT,"", "" );
	DECLAR ("porte"		,":2", "B", OUT,"", "" );
	DECLAR ("alarm"		,":2", "B", OUT,"", "" );

	/* AFFECTATION AU TEMPS 0 */
	AFFECT	("0",			"vdd",		"0b1");
	AFFECT	("0",			"vss",		"0b0");
	AFFECT	("0",			"ck",		"0b1");
	AFFECT	("0",			"reset",	"0b1");
	AFFECT	("0",			"i",		"0X5");
	AFFECT	("0",			"porte",	"0b0");
	AFFECT	("0",			"timer5_en",	"0b0");
	AFFECT	("0",			"timer120_en",	"0b0");
	AFFECT	("0",			"timer5_tm",	"0b0");
	AFFECT	("0",			"timer120_tm",	"0b0");
	AFFECT	("0",			"O",		"0b0");
	AFFECT	("0",			"alarm",	"0b0");
	AFFECT	("0",			"press_kbd",	"0b1");
	AFFECT	(inttostr(0),		"jour",		"0B0");
	AFFECT	(inttostr(2*pas),	"reset",	"0b0");


	for (cur_vect = 0; cur_vect < 25; cur_vect++)
	{
		if (cur_vect == 0)

		if (cur_vect == 1)
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X5");
		if (cur_vect == 2)
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X3");
		if (cur_vect == 3)
			AFFECT (inttostr(2*pas*cur_vect), "i", "0XA");
		if (cur_vect == 4)
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X1");
		if (cur_vect == 6)
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X7");
		if (cur_vect == 7){
			AFFECT (inttostr(2*pas*cur_vect), "porte", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "timer5_en", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "press_kbd", "0b0");
		}
		if (cur_vect == 8){
			AFFECT (inttostr(2*pas*cur_vect), "timer5_tm", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "timer5_en", "0b0");
		}
		if (cur_vect == 9)
			AFFECT (inttostr(2*pas*cur_vect), "porte", "0b0");
		if (cur_vect == 10)
		if (cur_vect == 11)
		if (cur_vect == 12){
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X5");
			AFFECT (inttostr(2*pas*cur_vect), "press_kbd", "0b1");
		}
		if (cur_vect == 13)
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X1");
		if (cur_vect == 14){
			AFFECT (inttostr(2*pas*cur_vect), "i", "0XE");
			AFFECT (inttostr(2*pas*cur_vect), "alarm", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "timer120_en", "0b1");
		}
		if (cur_vect == 15){
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X5");
			AFFECT (inttostr(2*pas*cur_vect), "press_kbd", "0b0");
		}
		if (cur_vect == 16){
			AFFECT (inttostr(2*pas*cur_vect), "timer120_tm", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "timer120_en", "0b0");
		}
		if (cur_vect == 17){
			AFFECT (inttostr(2*pas*cur_vect), "timer120_tm", "0b0");
			AFFECT (inttostr(2*pas*cur_vect), "alarm", "0b1");
		}
		if (cur_vect == 18){
			AFFECT (inttostr(2*pas*cur_vect), "jour", "0B1");
			AFFECT (inttostr(2*pas*cur_vect), "i", "0X6");
			AFFECT (inttostr(2*pas*cur_vect), "press_kbd", "0b1");
		}
		if (cur_vect == 19)
			AFFECT (inttostr(2*pas*cur_vect), "O", "0b1");
		if (cur_vect == 20)
			AFFECT (inttostr(2*pas*cur_vect), "O", "0b1"); // pbm c'etait a 19
		if (cur_vect == 21){
			AFFECT (inttostr(2*pas*cur_vect), "porte", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "timer5_en", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "press_kbd", "0b0");
		}

		if (cur_vect == 22){
			AFFECT (inttostr(2*pas*cur_vect), "timer5_tm", "0b1");
			AFFECT (inttostr(2*pas*cur_vect), "timer5_en", "0b0");
		}
		if (cur_vect == 23)
			AFFECT (inttostr(2*pas*22), "porte", "0b0");
		if (cur_vect == 24)
		if (cur_vect == 25)

		AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
		AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
	}

	SAV_GENPAT ();
}
