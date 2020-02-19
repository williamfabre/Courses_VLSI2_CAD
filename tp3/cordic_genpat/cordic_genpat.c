#include <stdio.h>
#include "genpat.h"
#define __USE_BSD
#include <math.h>
#include <stdint.h>

int pas = 5;
//horloge de 2*pas ps de période et au doux nom de "ck"

// void cossin(double a_p, char x_p, char y_p, char *nx_p, char *ny_p)
// {
//     *nx_p = (char) (x_p * cos(a_p) - y_p * sin(a_p));
//     *ny_p = (char) (x_p * sin(a_p) + y_p * cos(a_p));
// }

short F_PI = (short)((M_PI) * (1<<7));
short ATAN[8] = {
    0x64,                 // ATAN(2^-0)
    0x3B,                 // ATAN(2^-1)
    0x1F,                 // ATAN(2^-2)
    0x10,                 // ATAN(2^-3)
    0x08,                 // ATAN(2^-4)
    0x04,                 // ATAN(2^-5)
    0x02,                 // ATAN(2^-6)
    0x01,                 // ATAN(2^-7)
};

void cordic(short a_p, char x_p, char y_p, char *nx_p, char *ny_p)
{
    unsigned char i, q;
    short a, x, y, dx, dy;   
    
    // conversion en virgule fixe : 7 chiffres après la virgule
    a = a_p;
    x = x_p << 7;         
    y = y_p << 7;

    // normalisalion de l'angle pour être dans le premier quadrant
    q = 0; 
    while (a >= F_PI/2) {
        a = a - F_PI/2; 
        q = (q + 1) & 3;
    }

    // rotation 
    for (i = 0; i <= 7; i++) {
        dx = x >> i;
        dy = y >> i;
        if (a >= 0) {
            x -= dy;
            y += dx;
            a -= ATAN[i];
        } else {
            x += dy;
            y -= dx;
            a += ATAN[i];
        }
    }

    // produit du résultat par les cosinus des angles : K=0x4D=1001101
    x = ((x>>7) + (x>>5) + (x>>4) + (x>>1))>>7;
    y = ((y>>7) + (y>>5) + (y>>4) + (y>>1))>>7;
    
    // placement du points dans le quadrant d'origine
    switch (q) {
    case 0:
        dx = x;
        dy = y;
        break;
    case 1:
        dx = -y;
        dy = x;
        break;
    case 2:
        dx = -x;
        dy = -y;
        break;
    case 3:
        dx = y;
        dy = -x;
        break;
    }
    *nx_p = dx;
    *ny_p = dy;
}

char *inttostr(entier)
	int entier;
{
	char *str;
	str = (char *) mbkalloc (32 * sizeof (char));
	sprintf (str, "%d",entier);
	return(str);
}/*------------------------------*/
/* end of the description       */
/*------------------------------*/

void genclock(int high, int N){
    int i;

    if(high == 0){
        AFFECT ("0", "ck", "0b0");
        for(i=0;i<N;i++){
            AFFECT (inttostr( pas*(2*i    ) ), "ck", "0b0");
            AFFECT (inttostr( pas*(2*i + 1) ), "ck", "0b1");
        }
    }
    else{
        AFFECT("0", "ck", "0b1");
        for(i=0;i<N;i++){
            AFFECT (inttostr( pas*(2*i    ) ), "ck", "0b1");
            AFFECT (inttostr( pas*(2*i + 1) ), "ck", "0b0");
        }        
    } 
}

main (){

    int i = 0;
    int j = 1;
    int t = 0;
    int N = 402;//??????????
    int time_vect = 0;
    int temp = 0;

    // char nx_p;
    // char ny_p;

    DEF_GENPAT("CORDIC_patern");

    /* interface */
    DECLAR ("vdd"		,":2", "B", IN, "", "" );
	DECLAR ("vss"		,":2", "B", IN, "", "" );
	DECLAR ("reset"		,":2", "B", IN, "", "" );
	DECLAR ("ck"		,":2", "B", IN, "", "" );
    /* to the next DECLAR the others ports in the order of entity declaration from <source>.vbe*/
    DECLAR ("A"		,":2", "B", IN      , "8 DOWNTO 0"  , "" );
    DECLAR ("X"		,":2", "X", IN      , "7 DOWNTO 0"  , "" );
    DECLAR ("Y"		,":2", "X", IN      , "7 DOWNTO 0"  , "" );
    DECLAR ("wr"	,":2", "B", IN      , ""            , "" );
    DECLAR ("rd"	,":2", "B", IN      , ""            , "" );
    DECLAR ("wok"	,":2", "B", OUT     , ""            , "" );
    DECLAR ("rok"	,":2", "B", OUT     , ""            , "" );
    DECLAR ("nX"	,":2", "B", OUT     , "7 DOWNTO 0"  , "" );
    DECLAR ("nY"	,":2", "B", OUT     , "7 DOWNTO 0"  , "" );

    /* AFFECTATION AU TEMPS 0 */
    AFFECT	("0",			"vss",		"0b0");
	AFFECT	("0",			"vdd",		"0b1");
	AFFECT	("0",			"reset",	"0b1");
    AFFECT	(inttostr(2*pas),"reset",	"0b0");
    AFFECT	("0",			"ck",	    "0b0");
    
    
    AFFECT	("0","X",	"0x7F");
    AFFECT	("0","Y",	"0x00");
    AFFECT	("0","A",	"0b000000000");
    AFFECT  ("0","rd",  "0b0");
    AFFECT  ("0","wr",  "0b0");
    //Affectation des sorties en sortie inécouté/aisée(don't care for william :)  durant le reset
    AFFECT("0",	"wok","0b*");
    AFFECT("0",	"rok","0b*");
    AFFECT("0","nX","0b*");
    AFFECT("0","nY","0b*");


//to affect in the loop : A,wr,rd and wok,rok,nX,nY

    for(i=0;i<=N;i++){
        /* char* nx_p = malloc(sizeof(char));
        char* ny_p = malloc(sizeof(char));
        *nx_p = 0;
        *ny_p = 0;
        */
        int nx_p;
        int ny_p;
        nx_p = 0;
        ny_p = 0;
        //cordic(i, 127, 0, nx_p, ny_p);
        cordic(i, 127, 0, &nx_p, &ny_p);
        //T0
        t = pas*2*j;
        AFFECT(inttostr(t+pas),"rd","0b0");
        AFFECT(inttostr(t    ),	"A" ,inttostr(i));
        AFFECT(inttostr(t    ),"wok","0b0");
        AFFECT(inttostr(t+pas),	"wr","0b1");
        if(i==0)    AFFECT(inttostr(t),"rok","0b0");
        else        AFFECT(inttostr(t),"rok","0b1");

        //-------------------------------
        time_vect++;
        temp = j;
        while(j<temp+13){//13 cycles d'attente
            j++;
            //T1
            t = pas*2*j;
            AFFECT(inttostr(t),"wok","0b*");
            AFFECT(inttostr(t),"rok","0b*");
            AFFECT(inttostr(t),"nX","0b*");
            AFFECT(inttostr(t),"nY","0b*");
            j+=13;
            time_vect += 13;
        }
        
        //--------------------------------

        //T2 = T1 + 13
        t = pas*2*j;
        AFFECT(inttostr(t      ),"rok","0b0");
        AFFECT(inttostr(t      ),"wok","0b1");
        AFFECT(inttostr(t + pas),"wr" ,"0b0");
        //AFFECT(inttostr(t),"nX", atoi(strcat("0b",nx_p)));
        //fprintf(stderr, "nxp = %4d\n", nx_p);
        //fprintf(stderr, "nyp = %4d\n", ny_p);
        AFFECT(inttostr(t),"nX", inttostr(nx_p));
        AFFECT(inttostr(t),"nY", inttostr(ny_p));j++;
        //T3
        t = pas*2*j +pas;
        AFFECT(inttostr(t    ),"rd","0b1");
        AFFECT(inttostr(t+pas),"wok","0b0");j++;
        //T4
        t = pas*2*j;
        AFFECT(inttostr(t),"rok","0b1");j++;
        
        //free(nx_p);
        //free(ny_p);
    }
    
    genclock(0,j + 4);
    SAV_GENPAT ();
}
