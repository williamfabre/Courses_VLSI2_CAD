synchronious_synchronizer : process (CK)
signal flip1, flip2 : std_logic;
begin
    -- RESET_N actif 0
    -- activation synchrone
    -- desactivation synchrone
    if rising_edge(CK) then 
    	flip1 <= RESET_pad_N;
    	flip2 <= flip1;
	end if;
end process;

asynchronious_synchronizer : process (CK, RESET_pad_N)
signal flip1, flip2 : std_logic;
begin
    -- RESET_N actif 0
    -- activation asynchrone
    -- desactivation synchrone
    if(RESET_pad_N = '0') then
        flip1 <= '0';
        flip2 <= '0';
    elsif rising_edge(CK) then 
    	flip1 <= '1';
    	flip2 <= flip1;
	end if;
end process;

-----------------------------------

signal   RESET_RX     : std_logic                       ;-- reset
signal   RESET_SYNC1  : std_logic                       ;-- reset synchroniz
signal   RESET_SYNC2  : std_logic                       ;-- reset synchroniz

synchronious_synchronizer : process (CK)
begin
    -- RESET_N actif 0
    -- activation synchrone
    -- desactivation synchrone
    if rising_edge(CK) then 
    	RESET_SYNC1 <= RESET_N;
    	RESET_SYNC2 <= RESET_SYNC1;
	end if;
end process;

asynchronious_synchronizer : process (CK, RESET_pad_N)
begin
    -- RESET_N actif 0
    -- activation asynchrone
    -- desactivation synchrone
    if(RESET_pad_N = '0') then
        RESET_SYNC1 <= '0';
        RESET_SYNC2 <= '0';
    elsif rising_edge(CK) then 
    	RESET_SYNC1 <= '1';
    	RESET_SYNC2 <= RESET_SYNC1 ;
	end if;
end process;

RESET_RX   <= not RESET_SYNC2   ;