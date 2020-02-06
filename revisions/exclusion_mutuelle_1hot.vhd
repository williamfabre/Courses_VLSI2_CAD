entity exclusion_mutuelle_1hot is
	port ( ck	    : in std_logic;
	       req0	    : in std_logic;
	       req1	    : in std_logic
	       nreset   : in std_logic;
	       gnt0	    : out std_logic;
	       gnt1	    : out std_logic);
end exclusion_mutuelle_1hot

architecture fsm of exclusion_mutuelle_1hot is

	signal s_wait0, r_wait0,	-- attente req0 prio
	s_wait1, r_wait1,	-- attente req1 prio
	s_alloc0, r_alloc0,	-- bus alloue par req0
	s_alloc1, r_alloc1	-- bud alloue par req1
	: std_logic;

begin

	gnt0 <= r_alloc0;
	gnt1 <= r_alloc1;

	s_wait0 	<= (r_wait0 and not req0 and not req1)
			or (r_alloc1 and not req1);

	s_wait1 	<= (r_wait1 and not req0 and not req1)
			or (r_alloc0 and not req0);

	s_alloc0	<= (r_wait0 and req0)
			or (r_wait1 and req0);

	s_alloc1	<= (r_wait1 and req1)
			or (r_wait0 and req1);

	reg : process(ck) begin
		if (rising_edge(ck) then
			if (nreset='0') then
				r_wait0 <= '1';
				r_wait1 <= '0';
				r_alloc0 <= '0';
				r_alloc1 <= '0';
			else
				r_wait0 <= s_wait0;
				r_wait1 <= w_wait1;
				r_alloc0 <= s_alloc0;
				r_alloc1 <= s_alloc1;
			end if;
		end if;
	end process;
end fsm;
