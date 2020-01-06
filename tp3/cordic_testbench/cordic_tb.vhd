LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
USE STD.textio.all;
 
ENTITY cordic_tb IS
END ENTITY;
 
ARCHITECTURE arch OF cordic_tb IS
	CONSTANT CLK_PERIOD : TIME := 100 ns;
 
	SIGNAL reset : std_logic := '0';
	SIGNAL ck : std_logic := '1';
	SIGNAL A : std_logic_vector(8 DOWNTO 0) := "000000000";
	SIGNAL X : std_logic_vector(7 DOWNTO 0) := X"7D";
	SIGNAL Y : std_logic_vector(7 DOWNTO 0) := X"00";
	SIGNAL wr : std_logic := '0';
	SIGNAL rd : std_logic := '0';
	SIGNAL wok : std_logic := '0';
	SIGNAL rok : std_logic :='0';
	SIGNAL nX : std_logic_vector(7 DOWNTO 0);
	SIGNAL nY : std_logic_vector(7 DOWNTO 0);
	SIGNAL vdd : std_logic;
	SIGNAL vss : std_logic;
	file   dat : text open read_mode is "/users/enseig/sekouri/Documents/tempCordic/MOCCA/tp3/tempCORDIC/tempCORDIC.srcs/sim_1/new/cordic.dat" ;
	SIGNAL nX_ext : std_logic_vector(7 DOWNTO 0);
	SIGNAL nY_ext : std_logic_vector(7 DOWNTO 0);
 
 
	COMPONENT cordic_cor
		PORT (
			ck          : IN  std_logic;                   
			raz         : IN  std_logic;                   
			                                               
			wr_axy_p    : IN  std_logic;                   
			a_p         : IN  std_logic_vector(8 DOWNTO 0);
			x_p         : IN  std_logic_vector(7 DOWNTO 0);
			y_p         : IN  std_logic_vector(7 DOWNTO 0);
			wok_axy_p   : OUT std_logic;                   
			                                               
			rd_nxy_p    : IN  std_logic;                   
			nx_p        : OUT std_logic_vector(7 DOWNTO 0);
		    ny_p        : OUT std_logic_vector(7 DOWNTO 0);
		    rok_nxy_p   : OUT std_logic                    
		);       
	END COMPONENT;
	
	COMPONENT CODRIC
		PORT (                   
			reset       : IN  std_logic; 
			ck          : IN  std_logic;                                                                                 
			A           : IN  std_logic_vector(8 DOWNTO 0);
			X           : IN  std_logic_vector(7 DOWNTO 0);
			Y           : IN  std_logic_vector(7 DOWNTO 0);
			wr          : IN  std_logic;                                                           
			rd          : IN  std_logic;
			wok         : OUT std_logic;  
			rok         : OUT std_logic;                        
			nX          : OUT std_logic_vector(7 DOWNTO 0);
		    nY          : OUT std_logic_vector(7 DOWNTO 0)
		                     
		);       
	END COMPONENT; 

    procedure check(--!!!ne fonctionne pas
        signal p_wok, p_rok : std_logic;
        signal p_nX, p_nY, p_nX_ext, p_nY_ext : std_logic_vector(7 downto 0) ) is
        --reset, ck, A, X, Y, wr, rd, wok, rok, nX, nY, vdd, vss )  is
        variable i : integer := 0;--!!! sortir l'integer i vers les arguments de la procedure car vaut alors tout le temps 0
        begin
        wait until (p_rok = '1' and not ck'stable);
            assert p_nX = p_nX_ext and p_nY = p_nY_ext report " error matching value(s) on output at image iteration " & integer'image(i) & ": nX value is " & integer'image(to_integer(signed(p_nX))) & " and must be " & integer'image(to_integer(signed(p_nX_ext))) & " ; and nY value is " & integer'image(to_integer(signed(p_nY))) & " and must be " & integer'image(to_integer(signed(p_nY_ext))) &";"severity error;--mettre des printf
            i := i + 1;
    end procedure check;
 
 
--Architecture BEGIN 
BEGIN
	--cordic_instance : cordic_cor
	--PORT MAP(ck, reset, wr, A, X, Y, wok, rd, nX, nY, rok);
	
	cordic_instance : CODRIC
	PORT MAP(reset, ck, A, X, Y, wr, rd, wok, rok, nX, nY);

    Stimulus_check: process
        variable tt: integer;
        variable ll: line;
        variable i : integer := 0;
        begin
            --readline(dat,ll); --en-tête
            --readline(dat,ll);
            while not endfile(dat) loop
                readline(dat,ll);
                read(ll,tt);
                wait until wr =  '1' and not wr'stable;--wok;
                nX_ext <= std_logic_vector(to_signed(tt,8));
                readline(dat,ll);
                read(ll,tt);
                nY_ext <= std_logic_vector(to_signed(tt,8));
                --check(wok, rok, nX, nY, nX_ext, nY_ext);
                wait until (rok = '1' and not ck'stable);
                assert nX = nX_ext and nY = nY_ext report " error matching value(s) on output at image iteration " & integer'image(i) & ": nX value is " & integer'image(to_integer(signed(nX))) & " and must be " & integer'image(to_integer(signed(nX_ext))) & " ; and nY value is " & integer'image(to_integer(signed(nY))) & " and must be " & integer'image(to_integer(signed(nY_ext))) &";"severity error;--mettre des printf
                i := i + 1;
            end loop;
            wait; --wait forever <3<3<3
  end process;
    
    
    
    

	clk_generation : 
	PROCESS
	BEGIN
		ck <= '1';
		WAIT FOR
		CLK_PERIOD / 2;
		ck <= '0';
		WAIT FOR
		CLK_PERIOD / 2;
	END PROCESS
	clk_generation;
	
	reset <= '1' after 300 ns;
    process
    variable i : integer := 0;
    begin
        wait for 30 ns;
        
        for i in 0 to 804 loop 
            --rd <= '0'; 
            wait until (wok = '1' and ck'stable );-- not handshacking ie : on verifie wok avant le wr
            A <=  std_logic_vector( to_signed( i , 9 ) ) ;      
            wr <=  '1' ;     
            wait for 2*CLK_PERIOD;
            --wait for 100 ns;
            wr <= '0';
            rd <=  '1';
            wait until ( rok = '1'and ck'stable );
            wait for 2*CLK_PERIOD;
            rd <= '0';
        end loop; 
            
        wait for CLK_PERIOD;
     
        ASSERT false REPORT "END OF test" SEVERITY note;
        -- Wait forever; this will finish the simulation.
        --wait;
	END PROCESS;
END arch;