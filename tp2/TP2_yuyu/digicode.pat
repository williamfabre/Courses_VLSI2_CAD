
-- description generated by Pat driver

--			date     : Tue Oct  1 20:53:13 2019
--			revision : v109

--			sequence : digicode

-- input / output list :
in       vdd B;;;
in       vss B;;;
in       reset B;;;
in       ck B;;;
in       jour B;;;
in       press_kbd B;;;
in       o B;;;
in       timer5_tm B;;;
in       timer120_tm B;;;
in       i (3 downto 0) B;;;
out      timer5_en B;;;
out      timer120_en B;;;
out      porte B;;;
out      alarm B;;;

begin

-- Pattern description :

--                        v  v  r  c  j  p  o  t  t  i      t   t   p   a   
--                        d  s  e  k  o  r     i  i         i   i   o   l   
--                        d  s  s     u  e     m  m         m   m   r   a   
--                              e     r  s     e  e         e   e   t   r   
--                              t        s     r  r         r   r   e   m   
--                                       _     5  1         5   1           
--                                       k     _  2         _   2           
--                                       b     t  0         e   0           
--                                       d     m  _         n   _           
--                                                t             e           
--                                                m             n           


-- Beware : unprocessed patterns

<          0 ps>        : 1  0  1  1  0  1  0  0  0  0101  ?0  ?0  ?0  ?0  ;
<          5 ps>        : 1  0  1  0  0  1  0  0  0  0101  ?0  ?0  ?0  ?0  ;
<         10 ps>        : 1  0  0  1  0  1  0  0  0  0101  ?0  ?0  ?0  ?0  ;
<         15 ps>        : 1  0  0  0  0  1  0  0  0  0101  ?0  ?0  ?0  ?0  ;
<         20 ps>        : 1  0  0  1  0  1  0  0  0  0101  ?0  ?0  ?0  ?0  ;
<         25 ps>        : 1  0  0  0  0  1  0  0  0  0101  ?0  ?0  ?0  ?0  ;
<         30 ps>        : 1  0  0  1  0  1  0  0  0  0011  ?0  ?0  ?0  ?0  ;
<         35 ps>        : 1  0  0  0  0  1  0  0  0  0011  ?0  ?0  ?0  ?0  ;
<         40 ps>        : 1  0  0  1  0  1  0  0  0  1010  ?0  ?0  ?0  ?0  ;
<         45 ps>        : 1  0  0  0  0  1  0  0  0  1010  ?0  ?0  ?0  ?0  ;
<         50 ps>        : 1  0  0  1  0  1  0  0  0  0001  ?0  ?0  ?0  ?0  ;
<         55 ps>        : 1  0  0  0  0  1  0  0  0  0001  ?0  ?0  ?0  ?0  ;
<         60 ps>        : 1  0  0  1  0  1  0  0  0  0111  ?0  ?0  ?0  ?0  ;
<         65 ps>        : 1  0  0  0  0  1  0  0  0  0111  ?0  ?0  ?0  ?0  ;
<         70 ps>        : 1  0  0  1  0  1  0  0  0  0111  ?1  ?0  ?1  ?0  ;
<         75 ps>        : 1  0  0  0  0  1  0  0  0  0111  ?1  ?0  ?1  ?0  ;
<         80 ps>        : 1  0  0  1  0  1  0  1  0  0111  ?1  ?0  ?1  ?0  ;
<         85 ps>        : 1  0  0  0  0  1  0  1  0  0111  ?1  ?0  ?1  ?0  ;
<         90 ps>        : 1  0  0  1  0  1  0  1  0  0111  ?1  ?0  ?0  ?0  ;
<         95 ps>        : 1  0  0  0  0  1  0  1  0  0111  ?1  ?0  ?0  ?0  ;
<        100 ps>        : 1  0  0  1  0  1  0  1  0  0111  ?1  ?0  ?0  ?0  ;
<        105 ps>        : 1  0  0  0  0  1  0  1  0  0111  ?1  ?0  ?0  ?0  ;
<        110 ps>        : 1  0  0  1  0  1  0  1  0  0111  ?1  ?0  ?0  ?0  ;
<        115 ps>        : 1  0  0  0  0  1  0  1  0  0111  ?1  ?0  ?0  ?0  ;
<        120 ps>        : 1  0  0  1  0  1  0  1  0  0111  ?1  ?0  ?0  ?0  ;

end;
