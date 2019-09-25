--library ieee;
--use iee.std_logic_1164.all;

entity nand2 is
	port(
		i0 : in std_logic;
		i1 : in std_logic;
		nq : out std_logic;
		vdd : in std_logic;
		vss : in std_logic
	);
end nand2;

architecture behavior of nand2 is
begin
	nq <= not(i0 and i1);
end;
