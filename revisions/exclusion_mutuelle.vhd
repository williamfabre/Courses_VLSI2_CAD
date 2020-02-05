

entity exclusion_mutuelle is
    port ( ck	    : in std_logic;
	   req0	    : in std_logic;
	   req1	    : in std_logic
	   nreset   : in std_logic;
	   gnt0	    : out std_logic;
	   gnt1	    : out std_logic);
end exclusion_mutuelle

architecture fsm of exclusion_mutuelle is

    type etat_type is (wait0, wait1, alloc0, alloc1);

    signal present, futur : etat_type;

--pragma current_state present
--pragma next_state futur
--pragma clock ck

begin

-- process update
process(ck) begin
    if (rising_edge(ck)) then
	present <= futur;
    end if;
end process;

process(present, req0, req1, nreset) begin
    -- fonction de transtion
    if (nreset = '0') then
	futur = wait0;
    else
	case present is
	    when wait0 =>
		if (req0) then futur <= alloc0;
		elsif (req1) then futur <= alloc1;
		else futur <= wait0;
		end if;

	    when wait1 =>
		if (req1) then futur <= alloc1;
		elsif (req0) then futur <= alloc0;
		else futur <= wait1;
		end if;

	    when alloc0 =>
		if (req0 = '0') then futur <= wait1;
		else futur <= alloc0;
		end if;

	    when alloc1 =>
		if (req1 = '0') then futur <= wait0;
		else futur <= alloc1;
		end if;
	end case;
    end if;

    -- fonction de generation
    if (present=alloc0) then
	gnt0 <= '1';
    else
	gnt0 <= '0';
    end if;

    if (present=alloc1) then
	gnt0 <= '0';
    else
	gnt0 <= '1';
    end if;
end process;

