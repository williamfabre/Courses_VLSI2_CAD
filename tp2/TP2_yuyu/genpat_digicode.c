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

        /*
        entity circuit is
        port ( 


        vdd, vss, reset, ck,  jour, press_kbd, O, timer5_tm, timer120_tm : in bit;


          i : in bit_vector(3 downto 0);


          timer5_en, timer120_en, porte, alarm : out bit

       );
        end circuit;

        Architecture MOORE of circuit is

        type ETAT_TYPE is (IDLE, NIGHT_PRESS, CORRECT5, CORRECT3, CORRECTA, CORRECT1, DRING, DOOR_OPEN);
            signal EF, EP : ETAT_TYPE;
        */
        DEF_GENPAT("digicode");


        /* interface */
        DECLAR ("vdd" ,":2", "B", IN, "", "" );
        DECLAR ("vss"   ,":2", "B", IN, "", "" );
        DECLAR ("reset"   ,":2", "B", IN, "", "" );
        DECLAR ("ck"    ,":2", "B", IN, "", "" );
        DECLAR ("jour"     ,":2", "B", IN, "", "" );
        DECLAR ("press_kbd"     ,":2", "B", IN, "", "" );
        DECLAR ("O"         ,":2", "B", IN, "", "" );
        DECLAR ("timer5_tm"     ,":2", "B", IN, "", "" );
        DECLAR ("timer120_tm" ,":2", "B", IN, "", "" );
        DECLAR ("i",":2", "B", IN, "3 DOWNTO 0", "" );
        DECLAR ("timer5_en"     ,":2", "B", OUT,"", "" );
        DECLAR ("timer120_en"     ,":2", "B", OUT,"", "" );
        DECLAR ("porte"     ,":2", "B", OUT,"", "" );
        DECLAR ("alarm"     ,":2", "B", OUT,"", "" );

        //LABEL ("cpt5");
        AFFECT ("0", "vdd", "0b1");
        AFFECT ("0", "vss", "0b0");
        AFFECT ("0", "ck", "0b1");
        AFFECT ("0", "reset", "0b1");
        AFFECT (inttostr(2*pas), "reset", "0b0");
        AFFECT (inttostr(0), "jour", "0B0");
        AFFECT ("0", "i", "0X5");
        AFFECT ("0", "porte", "0b0");
        AFFECT ("0", "timer5_en", "0b0");
        AFFECT ("0", "timer120_en", "0b0");
        AFFECT ("0", "timer5_tm", "0b0");
        AFFECT ("0", "timer120_tm", "0b0");
        AFFECT ("0", "O", "0b0");
        AFFECT ("0", "alarm", "0b0");
        AFFECT ("0", "press_kbd", "0b1");

        cur_vect = 0;
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        
        cur_vect++;
        AFFECT (inttostr(2*pas*2), "i", "0X5");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        cur_vect++;
        AFFECT (inttostr(2*pas*3), "i", "0X3");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        cur_vect++;
        AFFECT (inttostr(2*pas*4), "i", "0XA");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        cur_vect++;
        AFFECT (inttostr(2*pas*5), "i", "0X1");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        cur_vect++;
        AFFECT (inttostr(2*pas*6), "i", "0X7");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        cur_vect++;
        AFFECT (inttostr(2*pas*7), "porte", "0b1");
        AFFECT (inttostr(2*pas*7), "timer5_en", "0b1");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        cur_vect++;
        AFFECT (inttostr(2*pas*8), "timer5_tm", "0b1");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));

        cur_vect++;
        AFFECT (inttostr(2*pas*9), "porte", "0b0");
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));

        cur_vect++;
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));

        cur_vect++;
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));

        cur_vect++;
        AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
        AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));
        /*
        for(nb=0; nb<N; nb++){
            for (c=0; c<nb; c++){
                
                AFFECT (inttostr( (cur_vect+0)*2*pas + pas), "ck", inttostr(0));
                AFFECT (inttostr( (cur_vect+1)*2*pas +  0 ), "ck", inttostr(1));

                if(c==0){
                    i=0;
                    o=0;
                    cpt=0;
                }
                else{
                    i=1;
                    cpt++;
                    if(cpt>=5)  o=1;
                    else        o=0;
                }
                AFFECT (inttostr(cur_vect*2*pas +   pas), "i", inttostr(i) );
                AFFECT (inttostr(cur_vect*2*pas + 2*pas), "o", inttostr(o) );
                cur_vect++;
            }
        }
        */

        SAV_GENPAT ();
        }
