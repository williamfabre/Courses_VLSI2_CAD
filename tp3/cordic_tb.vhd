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
	SIGNAL A : std_logic_vector(8 DOWNTO 0) := X"00";
	SIGNAL X : std_logic_vector(7 DOWNTO 0) := X"7F";
	SIGNAL Y : std_logic_vector(7 DOWNTO 0) := X"00";
	SIGNAL wr : std_logic := '0';
	SIGNAL rd : std_logic := '0';
	SIGNAL wok : std_logic;
	SIGNAL rok : std_logic;
	SIGNAL nX : std_logic_vector(7 DOWNTO 0);
	SIGNAL nY : std_logic_vector(7 DOWNTO 0);
	SIGNAL vdd : std_logic;
	SIGNAL vss : std_logic;
	file   dat : text open read_mode is "cossin.dat" ;
	SIGNAL nX_ext : std_logic_vector(7 DOWNTO 0);
	SIGNAL nY_ext : std_logic_vector(7 DOWNTO 0);
 
 
	COMPONENT cordic
		PORT (
			reset :  IN std_logic; 
			ck :     IN std_logic; 
			A :      IN std_logic_vector(8 DOWNTO 0); 
			X :      IN std_logic_vector(7 DOWNTO 0); 
			Y :      IN std_logic_vector(7 DOWNTO 0); 
			wr :     IN std_logic; 
			rd :     IN std_logic; 
			wok :    OUT std_logic; 
			rok :    OUT std_logic; 
			nX :     OUT std_logic_vector(7 DOWNTO 0); 
			nY :     OUT std_logic_vector(7 DOWNTO 0); 
			vdd :    IN std_logic; 
			vss :    IN std_logic 
		);
	END COMPONENT; 


 
--Architecture BEGIN 
BEGIN
	cordic_instance : cordic
	PORT MAP(
		reset => reset, 
		ck    => ck, 
		A     => A, 
		X     => X, 
		Y     => Y, 
		wr    => wr, 
		rd    => rd, 
		wok   => wok, 
		rok   => rok, 
		nX    => nX, 
		nY    => nY, 
		vdd   => vdd, 
		vss   => vss
	);

    Stimulus_check: process
    procedure check(
        wok, rok : std_logic;
        nX, nY, nX_ext, nY_ext : std_logic_vector(7 downto 0) ) is
        --reset, ck, A, X, Y, wr, rd, wok, rok, nX, nY, vdd, vss )  is
        variable i : integer := 0;
        begin
        wait until rok = '1';
            i := i + 1;
            assert nX = nX_ext and nY = nY_ext report " error matching value(s) on output at image iteration " & integer'image(i) & ": nX value is " & std_logic_vector(7 downto 0)'image(nX) & " and must be " & std_logic_vector(7 downto 0)'image(nX_ext) & " ; and nY value is " & std_logic_vector(7 downto 0)'image(nY) & " and must be " & std_logic_vector(7 downto 0)'image(ny_ext) &";"severity error;--mettre des printf
        end procedure check;
        
        variable tt: integer;
        variable ll: line;
        
        begin
            readline(dat,ll); --en-tête
            while not endfile(dat)loop
                readline(dat,ll);
                read(ll,tt);
                wait on wok;
                nX_ext <= std_logic_vector(to_signed(tt,8));
                readline(dat,ll);
                read(ll,tt);
                nY_ext <= std_logic_vector(to_signed(tt,8));
                check(wok, rok, nX, nY, nX_ext, nY_ext);
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
	
	reset <= '1' after 30 ns;
    process
    variable i : integer := 0;
    begin
        
        for i in 0 to 804 loop 
        rd <= '0'; 
        A <=  std_logic_vector( to_signed( i , 9 ) ) ;      
        wr <=  '1' ;     
        wait until wok = '1';
        wr <= '0';
        rd <=  '1';
        wait until rok = '1';
        end loop;     
        wait for CLK_PERIOD;
     
        ASSERT false REPORT "END OF test" SEVERITY note;
        -- Wait forever; this will finish the simulation.
        wait;
	END PROCESS;
END arch;