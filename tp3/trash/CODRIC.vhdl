library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_signed.all;
--use IEEE.std_logic_unsigned.all;

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

	signal r_pi     : std_logic_vector(15 downto 0);--inutile: non utilisé
	signal r_pihalf : std_logic_vector(15 downto 0);
	signal r_a      : std_logic_vector(8 downto 0);
	signal r_x      : std_logic_vector(15 downto 0);
	signal r_dx     : std_logic_vector(15 downto 0);
	signal r_y      : std_logic_vector(15 downto 0);
	signal r_dy     : std_logic_vector(15 downto 0);
	signal r_q      : std_logic_vector(7 downto 0);
	signal r_nx     : std_logic_vector(7 downto 0);
	signal r_ny     : std_logic_vector(7 downto 0);
	signal buf_nx   : std_logic_vector(7 downto 0);
	signal buf_ny   : std_logic_vector(7 downto 0);

	type ETAT_TYPE is (IDLE,LOAD,NORM,ROT0,ROT1,ROT2,ROT3,ROT4,ROT5,ROT6,ROT7,PROD,RES);
	signal EP,EF : ETAT_TYPE;

begin

	r_pi     <= X"0192";
	r_pihalf <= X"00C9";

	process(reset,ck)
	begin
		if ( reset = '1' ) then
			EP <= IDLE;
		elsif (ck='1' and not ck'stable) then  
			EP <= EF;
		end if;
	end process;

	process(ck,wr)
	begin
		case EP is
			when IDLE =>
				r_q <= X"00";
				r_a <= A;
				if(wr='1')then
					EF <= LOAD;
				else 
					EF <= IDLE;
				end if;

			when LOAD =>
				r_a <= A;
				r_x <= X(7) & X & "0000000";
				r_y <= Y(7) & Y & "0000000";
				EF <= NORM;

			when NORM =>
				if( r_a >= r_pihalf ) then
					r_a <= r_a - r_pihalf;
					r_q <= (r_q + 1) AND X"03";
					EF <= NORM;
				else
					EF <= ROT0;
				end if;

			when ROT0  =>
				r_dx <= r_x;
				r_dy <= r_y;
				EF <= ROT1;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"0064";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"0064";
				end if;

			when ROT1  =>
				r_dx <= r_x(15) & r_x(15 downto 1);
				r_dy <= r_y(15) & r_y(15 downto 1);
				EF <= ROT2;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"003B";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"003B";
				end if;

			when ROT2  =>
				r_dx <= r_x(15) & r_x(15) & r_x(15 downto 2);
				r_dy <= r_y(15) & r_y(15) & r_y(15 downto 2);
				EF <= ROT3;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"001F";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"001F";
				end if;

			when ROT3  =>
				r_dx <= r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 3);
				r_dy <= r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 3);
				EF <= ROT4;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"0010";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"0010";
				end if;

			when ROT4  =>
				r_dx <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 4);
				r_dy <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 4);
				EF <= ROT5;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"0008";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"0008";
				end if;

			when ROT5  =>
				r_dx <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 5);
				r_dy <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 5);
				EF <= ROT6;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"0004";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"0004";
				end if;

			when ROT6  =>
				r_dx <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 6);
				r_dy <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 6);
				EF <= ROT7;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"0002";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"0002";
				end if;

			when ROT7  =>
				r_dx <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 7);
				r_dy <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 7);
				EF <= PROD;
				if(r_a >= X"0000")then
					r_x <= r_x - r_dy;
					r_y <= r_y + r_dx;
					r_a <= a - X"0001";
				else
					r_x <= r_x + r_dy;
					r_y <= r_y - r_dx;
					r_a <= a + X"0001";
				end if;

			when PROD =>
				r_x <=  ( r_x(15)&r_x(15)&r_x(15)&r_x(15)&r_x(15)&r_x(15)&r_x(15 downto 6) ) +
						( r_x(15)&r_x(15)&r_x(15)&r_x(15)&r_x(15)&r_x(15 downto 5) ) +
						( r_x(15)&r_x(15)&r_x(15)&r_x(15)&r_x(15 downto 4) ) +
						( r_x(15)&r_x(15 downto 1) );
				r_y <=  ( r_y(15)&r_y(15)&r_y(15)&r_y(15)&r_y(15)&r_y(15)&r_y(15 downto 6) ) +
						( r_y(15)&r_y(15)&r_y(15)&r_y(15)&r_y(15)&r_y(15 downto 5) ) +
						( r_y(15)&r_y(15)&r_y(15)&r_y(15)&r_y(15 downto 4) ) +
						( r_y(15)&r_y(15 downto 1) );
				EF <= RES;

			when RES =>
				if(r_q(1) xor r_q(0))then
					r_nx <= - r_x(14 downto 7);
				else
					r_nx <= r_x(14 downto 7);
				end if;

				if(r_q(1) = '1') then
					r_ny <= - r_y(14 downto 7);
				else
					r_ny <= r_y(14 downto 7);
				end if;

				when others => report "unreachable state" severity failure;

			end case;
		end process;

		process(ck,EP)
		begin
			case EP is
				when (IDLE or LOAD) => -- nX et nY sortie de type Mealy sinon faire un etat de lecture
					rok <= '1';
					wok <= '0';
					if(rd = '1') then
						buf_nx <= r_nx;
						buf_ny <= r_ny;
					else
						buf_nx <= buf_nx;
						buf_ny <= buf_ny;
					end if;

				when (NORM or ROT0 or ROT1 or ROT2 or ROT3 or ROT4 or ROT5 or ROT6 or ROT7 or PROD or RES) =>
					rok <= '0';
					wok <= '1';
					buf_nx <= buf_nx;
					buf_ny <= buf_ny;

					when others => report "unreachable state" severity failure;
				end case;
			end process;

			nX <= buf_nx;
			nY <= buf_ny;

		end;
