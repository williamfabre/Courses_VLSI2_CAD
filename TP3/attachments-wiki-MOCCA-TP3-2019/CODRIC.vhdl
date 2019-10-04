entity CODRIC is
	port(
        reset   : in std_logic;
        ck      : in std_logic;
		A       : in std_logic_vector(8 downto 0);
		X       : in std_logic_vector(7 downto 0);
		Y       : in std_logic_vector(7 downto 0);
        wr      : in std_logic;
        rd      : in std_logic;
        wok     : out std_logic;
        rok     : out std_logic;
        nX      : out std_logic_vector(7 downto 0);
        nY      : out std_logic_vector(7 downto 0);
		vdd     : in std_logic;
		vss     : in std_logic
	);
end CODRIC;

architecture BEHAV of CODRIC is

signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal xxx      : std_logic;
signal r_a      : std_logic_vector(8 downto 0);
signal r_x      : std_logic_vector(15 downto 0);
signal r_y      : std_logic_vector(15 downto 0);
signal r_q      : std_logic_vector(7 downto 0);
signal r_i      : std_logic_vector(7 downto 0);
signal xxx      : std_logic_vector( downto 0);
signal xxx      : std_logic_vector( downto 0);
signal xxx      : std_logic_vector( downto 0);
signal xxx      : std_logic_vector( downto 0);
signal xxx      : std_logic_vector( downto 0);
signal xxx      : std_logic_vector( downto 0);
signal xxx      : std_logic_vector( downto 0);

type ETAT_TYPE is (IDLE,LOAD,NORM,ROT);
signal EP,EF : ETAT_TYPE;

begin

process(reset,clk)
begin
    if ( reset = '1' ) then
        EP <= IDLE;
    elsif (ck='1' and not ck'stable) then  
        EP <= EF;
    end if;
end process;

process()
begin
    switch case EP
    when IDLE =>
        r_i <= 0X"00";
        r_q <= 0X"00";
        r_a <= A;
        if(wr='1')then
            EF <= LOAD;
        else 
            EF <= IDLE;
        end if;
    when LOAD =>
        r_a <= A;
        if(X(7)==1) then r_x <= X && 0X"11";
        else r_x <= X && 0X"00";
        
    when NORM =>
    when ROT  =>


end process;

end;