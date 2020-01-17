ENTITY cordic_dp IS
PORT(
    ck          : IN  std_logic;

    x_p         : IN  std_logic_vector(7 DOWNTO 0);
    y_p         : IN  std_logic_vector(7 DOWNTO 0);

    nx_p        : OUT std_logic_vector(7 DOWNTO 0);
    ny_p        : OUT std_logic_vector(7 DOWNTO 0);

    xmkc_p      : IN  std_logic_vector(1 DOWNTO 0);
    ymkc_p      : IN  std_logic_vector(1 DOWNTO 0);
    xcmd_p      : IN  std_logic_vector(3 DOWNTO 0);
    ycmd_p      : IN  std_logic_vector(3 DOWNTO 0);
    i_p         : IN  std_logic_vector(3 DOWNTO 0)
);
END cordic_dp;

ARCHITECTURE vhd OF cordic_dp IS

    SIGNAL
        n_x,    x,                  -- coordonnée x
        n_y,    y,                  -- coordonnée y
        n_xkc,  xkc,                -- x * KC
        n_ykc,  ykc,                -- y * KC
        x_sra_1, y_sra_1,           -- x >> 1 et y >> 1
        x_sra_2, y_sra_2,           -- x >> 2 et y >> 2
        x_sra_3, y_sra_3,           -- x >> 3 et y >> 3
        x_sra_4, y_sra_4,           -- x >> 4 et y >> 4
        x_sra_5, y_sra_5,           -- x >> 5 et y >> 5
        x_sra_6, y_sra_6,           -- x >> 6 et y >> 6
        x_sra_7, y_sra_7,           -- x >> 7 et y >> 7
        x_sra_i, y_sra_i            -- x >> i et y >> i
    : std_logic_vector(15 downto 0);

BEGIN

    -- Shifters : x_sra_i <= x << i et y_sra_i <= y << i

    x_sra_1     <= x(15) & x(15 downto 1);
    x_sra_2     <= x(15) & x_sra_1(15 downto 1);
    x_sra_3     <= x(15) & x_sra_2(15 downto 1);
    x_sra_4     <= x(15) & x_sra_3(15 downto 1);
    x_sra_5     <= x(15) & x_sra_4(15 downto 1);
    x_sra_6     <= x(15) & x_sra_5(15 downto 1);
    x_sra_7     <= x(15) & x_sra_6(15 downto 1);
    x_sra_i     <= x_sra_1 when i_p = 1
              else x_sra_2 when i_p = 2
              else x_sra_3 when i_p = 3
              else x_sra_4 when i_p = 4
              else x_sra_5 when i_p = 5
              else x_sra_6 when i_p = 6
              else x_sra_7 when i_p = 7
              else x;

    y_sra_1     <= y(15) &     y(15 downto 1);
    y_sra_2     <= y(15) & y_sra_1(15 downto 1);
    y_sra_3     <= y(15) & y_sra_2(15 downto 1);
    y_sra_4     <= y(15) & y_sra_3(15 downto 1);
    y_sra_5     <= y(15) & y_sra_4(15 downto 1);
    y_sra_6     <= y(15) & y_sra_5(15 downto 1);
    y_sra_7     <= y(15) & y_sra_6(15 downto 1);
    y_sra_i     <= y_sra_1 when i_p = 1
              else y_sra_2 when i_p = 2
              else y_sra_3 when i_p = 3
              else y_sra_4 when i_p = 4
              else y_sra_5 when i_p = 5
              else y_sra_6 when i_p = 6
              else y_sra_7 when i_p = 7
              else y;

    -- produits des coordonnées de rotation par KC

    n_xkc       <= x_sra_7 + x_sra_5 when xmkc_p = 0 -- <==> mkc_p = 1 AND i_p = 0
              else xkc     + x_sra_4 when xmkc_p = 1 -- <==> mkc_p = 1 AND i_p = 1
              else xkc     + x_sra_1 when xmkc_p = 2 -- <==> mkc_p = 1 AND i_p = 2
              else xkc;								 -- <==> mkc_p = 1 AND i_p = {3 ou 4 ou 5 ou 6 ou 7}

    n_ykc       <= y_sra_7 + y_sra_5 when ymkc_p = 0 -- mkc_p AND i_p = 0
              else ykc     + y_sra_4 when ymkc_p = 1 -- mkc_p AND i_p = 1
              else ykc     + y_sra_1 when ymkc_p = 2 -- mkc_p AND i_p = 2
              else ykc;

    -- coordonnées

    n_x         <= x_p(7) & x_p & "0000000" when xcmd_p = 0 -- init
              else x - y_sra_i              when xcmd_p = 1 -- calc_and_calc_p AND NOT a_lt_0_p
              else x + y_sra_i              when xcmd_p = 2 -- calc_p AND a_lt_0_p
              else xkc                      when xcmd_p = 3 -- place_p AND (quadrant_p = 0)
              else -ykc                     when xcmd_p = 4 -- place_p AND (quadrant_p = 1)
              else -xkc                     when xcmd_p = 5 -- place_p AND (quadrant_p = 2)
              else ykc                      when xcmd_p = 6 -- place_p AND (quadrant_p = 3)
              else x;					    				-- et 8 //when n_put = '1'

    n_y         <= y_p(7) & y_p & "0000000" when ycmd_p = 0 -- init
              else y + x_sra_i              when ycmd_p = 1 -- calc_and_calc_p AND NOT a_lt_0_p
              else y - x_sra_i              when ycmd_p = 2 -- calc_p AND a_lt_0_p
              else ykc                      when ycmd_p = 3 -- place_p AND (quadrant_p = 0)
              else xkc                      when ycmd_p = 4 -- place_p AND (quadrant_p = 1)
              else -ykc                     when ycmd_p = 5 -- place_p AND (quadrant_p = 2)
              else -xkc                     when ycmd_p = 6 -- place_p AND (quadrant_p = 3)
              else y;                                       -- et 8 //when n_put = '1'

    DP : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE) )
    then
       x     <= n_x     ;
       y     <= n_y     ;
       xkc   <= n_xkc   ;
       ykc   <= n_ykc   ;
    end if;
    end process DP;

    -- Sorties du chemin de données

    nx_p        <=  x(14 downto 7);
    ny_p        <=  y(14 downto 7);

END vhd;
