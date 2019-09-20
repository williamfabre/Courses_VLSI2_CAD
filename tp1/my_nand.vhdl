--library ieee;
--use iee.std_logic_1164.all;

entity my_nand is
	port(
		A : in std_logic;
		B : in std_logic;
		RES : out std_logic
	);
end my_nand;

architecture behavior of my_nand is
begin
	res <= (not A) and (not B);
end;
