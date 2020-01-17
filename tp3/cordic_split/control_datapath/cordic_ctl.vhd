ENTITY cordic_ctl IS
    PORT(
	    ck				: IN  std_logic;
	    raz      			: IN  std_logic;

	    wr_axy_p 			: IN  std_logic;
	    a_p      			: IN  std_logic_vector(9 DOWNTO 0);
	    wok_axy_p			: OUT std_logic;

	    rd_nxy_p 			: IN  std_logic;
	    rok_nxy_p			: OUT std_logic;

	    i_p      			: OUT std_logic_vector(2 DOWNTO 0);
	    cmd_n_0  			: OUT std_logic;
	    cmd_n_1_1			: OUT std_logic;
	    cmd_n_1_0			: OUT std_logic;
	    cmd_n			: OUT std_logic;
	    cmd_adder_pm		: OUT std_logic;
	    cmd_post0_adder_1		: OUT std_logic;
	    cmd_post0_adder		: OUT std_logic;
	    cmd_post0_adder_0		: OUT std_logic;
	    cmd_post1_adder		: OUT std_logic;
	    cmd_adder_x_pm_y_sra_i	: OUT std_logic;
	    cmd_adder_y_pm_x_sra_i	: OUT std_logic
);
END cordic_ctl;

ARCHITECTURE vhd OF cordic_ctl IS

    SIGNAL
    n_get,  get,                -- get coordinates and angle
    n_norm, norm,               -- normalization
    n_calc, calc,               -- calcul
    n_mkc,  mkc,                -- multiply KC
    n_place,place,              -- place in good quadrant
    n_put,  put,                -- put result
    a_lt_0,                     -- a lower than 0
    quadrant_0                  -- 1 quand a est dans le quadrant 0
    : std_logic;

    SIGNAL
    n_quadrant, quadrant        -- numéro du quadrant
    : std_logic_vector(1 downto 0);

    SIGNAL
    n_i, i                      -- compteur de recherche dichotomique
    : std_logic_vector(2 downto 0);

    SIGNAL
    n_a,    a,                  -- angle
    atan,                       -- arctangeante de l'angle de rotation
    a_mpidiv2                   -- a - PI/2
    : std_logic_vector(15 downto 0);

BEGIN

    -------------------------------------------------------------------------------
    -- FSM
    -------------------------------------------------------------------------------

    -- FSM transition

    n_get       <= (get  AND NOT wr_axy_p)
		   OR (put  AND rd_nxy_p)
		   ;
    n_norm      <= (get  AND wr_axy_p)
		   OR (norm AND NOT quadrant_0)
		   ;
    n_calc      <= (norm AND quadrant_0)
		   OR (calc AND NOT (i = 7))
		   ;
    n_mkc       <= (calc AND (i = 7))
		   OR (mkc  AND NOT (i = 2))
		   ;
    n_place     <= (mkc  AND (i = 2))
		   ;
    n_put       <= (place)
		   OR (put  AND NOT rd_nxy_p)
		   ;

    FSM : PROCESS (ck) begin
	if ((ck = '1') AND NOT(ck'STABLE) )
	then
	    if (raz = '0') then
		get   <= '1';
		norm  <= '0';
		calc  <= '0';
		mkc   <= '0';
		place <= '0';
		put   <= '0';
	    else
		get   <= n_get   ;
		norm  <= n_norm  ;
		calc  <= n_calc  ;
		mkc   <= n_mkc   ;
		place <= n_place ;
		put   <= n_put   ;
	    end if;
	end if;
    end process FSM;

    -- Sorties issues de l'automate

    wok_axy_p   <= get;
    rok_nxy_p   <= put;

    --    get_p       <= get;
    --    calc_p      <= calc;
    --    mkc_p       <= mkc;
    --    place_p     <= place;
    i_p         <= i;
    --    quadrant_p  <= quadrant;
    --    a_lt_0_p    <= a_lt_0;

    -------------------------------------------------------------------------------
    -- Compteurs de l'algorithme et calcul de l'angle de rotation@
    -------------------------------------------------------------------------------

    -- Compteurs de normalisation de l'angle : quadrant est le numéro du quadrant

    n_quadrant  <= "00"           when get
		   else quadrant + 1   when norm AND NOT quadrant_0
		   else quadrant;

    -- ROM with arctan(2-i)

	atan        <= x"0064" when i = 0     -- atan(2^-0)
		       else x"003B" when i = 1     -- atan(2^-1)
		       else x"001F" when i = 2     -- atan(2^-2)
		       else x"0010" when i = 3     -- atan(2^-3)
		       else x"0008" when i = 4     -- atan(2^-4)
		       else x"0004" when i = 5     -- atan(2^-5)
		       else x"0002" when i = 6     -- atan(2^-6)
		       else x"0001";               -- atan(2^-7)

    -- Calcul de l'angle : recherche par dichotomie

	    a_mpidiv2   <= a - x"00C9";
	    quadrant_0  <= a_mpidiv2(15);
	    a_lt_0      <= a(15);    -- 1 si a est négatif (signe de a)

	    n_a         <= a_p       when get                     -- init
			   else a_mpidiv2 when norm AND NOT quadrant_0 -- a - PI/2
			   else a - atan  when calc AND NOT a_lt_0     -- trop grand
			   else a + atan  when calc AND a_lt_0         -- trop petit
			   else a;                                     -- stable

    -- Compteurs de la dichotomie et de la normalisation de l'angle

		n_i         <= "000"     when get                     -- init
			       else i + 1     when calc or mkc             -- inc 
			       else i ;                                    -- stable


CTL : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE) )
    then
	i        <= n_i        ;
	quadrant <= n_quadrant ;
	a        <= n_a        ;
    end if;
end process CTL;

	-- Combinatoire de controle

	-- Pour x
cmd_adder_pm <= quadrant(1) AND NOT(quadrant(0)); --NB : quadrant_p(1) suffit sans le "AND NOT..."
cmd_n_0 <= get;
cmd_n_1_1 <= place AND quadrant(0); --( ( quadrant_p(0) AND (NOT(quadrant_p)) ) OR ( quadrant_p(1) AND quadrant_p(0) ) ); -- Q_p = 1 OR Q_p = 3 <==> 
cmd_n_1_0 <= put OR get;
cmd_n <= place;

cmd_adder_x_pm_y_sra_i <= NOT(a_lt_0);

	-- Pour y

	--Pour le mux de sortie donant ny, on reprend les commandes A,B,C et D


cmd_adder_y_pm_x_sra_i <= a_lt_0;

	-- Pour x et y

cmd_post0_adder_1 <= mkc AND i(0);
cmd_post0_adder <= mkc AND ( i(2) OR i(1) );
cmd_post0_adder_0 <= mkc AND ( i(2) OR i(0) );
cmd_post1_adder <= mkc AND ( i(2) OR i(1) OR i(0) );
















END vhd;
