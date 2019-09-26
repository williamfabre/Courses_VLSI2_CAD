entity my_nand is
	port(
		i0 : in std_logic;
		i1 : in std_logic;
		nq : out std_logic;

		vdd : in std_logic;
		vss : in std_logic
	);
end my_nand;

architecture behavior of my_nand is
begin
	nq <= (not (i0) or not (i1));
end;
