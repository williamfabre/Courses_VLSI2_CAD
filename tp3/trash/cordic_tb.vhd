LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_signed.ALL;
 
ENTITY cordic_tb IS
END ENTITY;
 
ARCHITECTURE arch OF cordic_tb IS
	CONSTANT CLK_PERIOD : TIME := 100 ns;
 
	SIGNAL reset : std_logic;
	SIGNAL ck : std_logic;
	SIGNAL A : std_logic_vector(8 DOWNTO 0);
	SIGNAL X : std_logic_vector(7 DOWNTO 0);
	SIGNAL Y : std_logic_vector(7 DOWNTO 0);
	SIGNAL wr : std_logic;
	SIGNAL rd : std_logic;
	SIGNAL wok : std_logic;
	SIGNAL rok : std_logic;
	SIGNAL nX : std_logic_vector(7 DOWNTO 0);
	SIGNAL nY : std_logic_vector(7 DOWNTO 0);
	SIGNAL vdd : std_logic;
	SIGNAL vss : std_logic;
 
 
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
 
 
 
	SIGNAL CLK : std_logic := '0'; 
BEGIN
	cordic_instance : cordic
	PORT MAP(
		reset => reset, 
		ck => ck, 
		A => A, 
		X => X, 
		Y => Y, 
		wr => wr, 
		rd => rd, 
		wok => wok, 
		rok => rok, 
		nX => nX, 
		nY => nY, 
		vdd => vdd, 
		vss => vss
	);

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
	
	
    process
    begin
    reset <= '0';    
    A <=    ;      
    X <=    ;  
    Y <=    ;   
    wr <=   ;     
    rd <=   ;     
    wait for CLK_PERIOD;
 
	ASSERT false REPORT "END OF test" SEVERITY note;
	-- Wait forever; this will finish the simulation.
	wait;
	END PROCESS;
END arch;