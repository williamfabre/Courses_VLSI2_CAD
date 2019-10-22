library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_signed.all;
--use IEEE.std_logic_unsigned.all;

entity cordic is
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
end cordic ;

architecture behav of cordic is

	signal r_pihalf : std_logic_vector(15 downto 0);

	signal r_atan : std_logic_vector(7 downto 0);
	signal r_atan_boucle : std_logic_vector(7 downto 0);
	signal r_atan_2 : std_logic_vector(7 downto 0);
	signal r_atan_2_0 : std_logic_vector(7 downto 0);
	signal r_atan_2_1 : std_logic_vector(7 downto 0);
	signal r_atan_2_2 : std_logic_vector(7 downto 0);
	signal r_atan_2_3 : std_logic_vector(7 downto 0);
	signal r_atan_2_4 : std_logic_vector(7 downto 0);
	signal r_atan_2_5 : std_logic_vector(7 downto 0);
	signal r_atan_2_6 : std_logic_vector(7 downto 0);
	signal r_atan_2_7 : std_logic_vector(7 downto 0);

	signal r_a       : std_logic_vector(15 downto 0);
	--signal r_a      : std_logic_vector(8 downto 0);
	signal r_x       : std_logic_vector(15 downto 0);
	signal r_x_boucle: std_logic_vector(15 downto 0);

	signal r_y       : std_logic_vector(15 downto 0);
	signal r_y_boucle: std_logic_vector(15 downto 0);

	signal r_dx      : std_logic_vector(15 downto 0);
	signal r_dx_0    : std_logic_vector(15 downto 0);
	signal r_dx_1    : std_logic_vector(15 downto 0);
	signal r_dx_2    : std_logic_vector(15 downto 0);
	signal r_dx_3    : std_logic_vector(15 downto 0);
	signal r_dx_4    : std_logic_vector(15 downto 0);
	signal r_dx_5    : std_logic_vector(15 downto 0);
	signal r_dx_6    : std_logic_vector(15 downto 0);
	signal r_dx_7    : std_logic_vector(15 downto 0);

	signal r_dy      : std_logic_vector(15 downto 0);
	signal r_dy_0    : std_logic_vector(15 downto 0);
	signal r_dy_1    : std_logic_vector(15 downto 0);
	signal r_dy_2    : std_logic_vector(15 downto 0);
	signal r_dy_3    : std_logic_vector(15 downto 0);
	signal r_dy_4    : std_logic_vector(15 downto 0);
	signal r_dy_5    : std_logic_vector(15 downto 0);
	signal r_dy_6    : std_logic_vector(15 downto 0);
	signal r_dy_7    : std_logic_vector(15 downto 0);

	-- STATE FOR ONEHOT ENCODING
	-- get   => wr?       : nouvelles valeurs, on reste tq (not nouvelles valeurs)
	-- norm  => quadrant0?:  normalisation de la valeur, on reste tq (not quadrant 0)
	-- calc  => i=7?      : On fait le callcule et on reste tq not i=7
	-- mkc   => i=2?      : multiplication par k, add 2 entree avec boucle
	-- place => 1         : 1 cycle, on passe direct dans l'etat suivant, pas de boucle
	-- put   => rd_nxy_p? : assignation dans rd et retour a l'etat get, une boucle?
	signal r_wr_axy_p  : std_logic;
	signal r_quadrant0 : std_logic;
	signal r_i_calc    : std_logic;
	signal r_i_mkc     : std_logic;
	signal r_rd_nxy_p  : std_logic;
	signal r_placeme   : std_logic;
	signal r_condition : std_logic_vector(5 downto 0);

	signal r_q      : std_logic_vector(7 downto 0);
	signal r_nx     : std_logic_vector(7 downto 0);
	signal r_ny     : std_logic_vector(7 downto 0);

	signal buf_nx   : std_logic_vector(7 downto 0);
	signal buf_ny   : std_logic_vector(7 downto 0);

	signal r_i       : std_logic_vector(2 downto 0);
	signal r_i_boucle: std_logic_vector(2 downto 0);

	type ETAT_TYPE is (GET, NORM, CALC, MKC, PLACE, PUT);
	signal EP,EF : ETAT_TYPE;

begin
	r_pihalf   <= X"00C9";
	r_atan_2_0 <= X"64"; -- ATAN(2^-0)
	r_atan_2_1 <= X"3B"; -- ATAN(2^-1)
	r_atan_2_2 <= X"1F"; -- ATAN(2^-2)
	r_atan_2_3 <= X"10"; -- ATAN(2^-3)
	r_atan_2_4 <= X"08"; -- ATAN(2^-4)
	r_atan_2_5 <= X"04"; -- ATAN(2^-5)
	r_atan_2_6 <= X"02"; -- ATAN(2^-6)
	r_atan_2_7 <= X"01"; -- ATAN(2^-7)



	-- DECALAGES POUR X
	r_dx_0 <= r_x(15) & r_x(15 downto 1);
	r_dx_1 <= r_x(15) & r_x(15) & r_x(15 downto 2);
	r_dx_2 <= r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 3);
	r_dx_3 <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 4);
	r_dx_4 <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15 downto 5);
	r_dx_5 <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) &
			  r_x(15 downto 6);
	r_dx_6 <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) &
			  r_x(15) & r_x(15 downto 7);
	r_dx_7 <= r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) & r_x(15) &
			  r_x(15) & r_x(15)& r_x(15 downto 8);

	-- DECALAGES POUR Y
	r_dy_0 <= r_y(15) & r_y(15 downto 1);
	r_dy_1 <= r_y(15) & r_y(15) & r_y(15 downto 2);
	r_dy_2 <= r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 3);
	r_dy_3 <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 4);
	r_dy_4 <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15 downto 5);
	r_dy_5 <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) &
			  r_y(15 downto 6);
	r_dy_6 <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) &
			  r_y(15) & r_y(15 downto 7);
	r_dy_7 <= r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) & r_y(15) &
			  r_y(15) & r_y(15)& r_y(15 downto 8);

	-- CONDITION DE CHANGEMENT D'ETAT MUTUELLEMENT EXCLUSIF
	r_condition <= r_wr_axy_p & r_quadrant0 & r_i_calc & r_i_mkc & r_placeme & r_rd_nxy_p;


	with r_i_boucle select r_y_boucle <= 
	r_dy_0 when b"000",
	r_dy_1 when b"001",
	r_dy_2 when b"010",
	r_dy_3 when b"011",
	r_dy_4 when b"100",
	r_dy_5 when b"101",
	r_dy_6 when b"110",
	r_dy_7 when b"111";

	with r_i_boucle select r_x_boucle <= 
	r_dx_0 when b"000",
	r_dx_1 when b"001",
	r_dx_2 when b"010",
	r_dx_3 when b"011",
	r_dx_4 when b"100",
	r_dx_5 when b"101",
	r_dx_6 when b"110",
	r_dx_7 when b"111";

	with r_i_boucle select r_atan_boucle <= 
	r_atan_2_0 when b"000",
	r_atan_2_1 when b"001",
	r_atan_2_2 when b"010",
	r_atan_2_3 when b"011",
	r_atan_2_4 when b"100",
	r_atan_2_5 when b"101",
	r_atan_2_6 when b"110",
	r_atan_2_7 when b"111";

	-- VALEURS DE SORTIE
	nX <= buf_nx;
	nY <= buf_ny;


	---------------------------------
	---- FONCTION DANS LES ETATS ----
	---------------------------------
	process(ck, wr)
	begin
		if (reset = '1') then
			-- INITIALISATION
			--resultat
			r_q						<= X"00";
			-- angle en radian
			r_a						<= A(7) & A & "0000000";
			-- state
			r_wr_axy_p				<= wr;
			r_quadrant0				<= '0';
			r_i_calc				<= '0';
			r_i_mkc					<= '0';
			r_placeme				<= '0';
			r_rd_nxy_p				<= '0';
			-- boucle
			r_i						<= b"000";
			r_i_boucle				<= b"000";
		else 
			case EP is
				when GET =>
					--CONVERSION EN VIRGULE FIXE
					--9 bit entier 7 bit virgule fixe donc extension de signe
					r_x					<= X(7) & X & "0000000";
					r_y					<= X(7) &  Y & "0000000";
					r_wr_axy_p			<= '0';
					r_quadrant0			<= '1';							-- DEMANDE CHANGEMENT ETAT
				when NORM =>
					-- NORMALISATION DANS LE CADRAN 0
					if (signed(r_a) >= signed(r_pihalf)) then		-- signed pour >=
						r_a				<= r_a - r_pihalf;
						r_q				<= (r_q + 1) AND X"03";
					else
						r_quadrant0		<= '0';
						r_i_calc		<= '1';							-- DEMANDE CHANGEMENT ETAT
					end if;
				when CALC =>
					-- ROTATION, RECHERCHE DICHOTOMIQUE D'ANGLE
					--calcule effectif  des rotations
					if (r_i_boucle < b"111") then
						r_dx			<= r_x_boucle;
						r_dy			<= r_y_boucle;
						r_atan			<= r_atan_boucle;
						r_i_boucle		<= r_i_boucle + 1;
					else
						r_i_calc		<= '0';
						r_i_mkc			<= '1';
					end if;

					if (signed(r_a) >= signed(X"0000")) then
						r_x				<= r_x - r_dy;
						r_y				<= r_y + r_dx;
						r_a				<= A - r_atan;
					else
						r_x				<= r_x + r_dy;
						r_y				<= r_y - r_dx;
						r_a				<= A + r_atan;
					end if;
				when MKC =>
					--MULTIPLICATION PAR K
					--produit du résultat par les cosinus des angles : K=0x4D=1001101
					if (r_i = b"000") then
						r_x				<= r_dx_7 + r_dx_5 + r_dx_4 + r_dx_1;
						r_i				<= b"001";
					else
						r_y				<= r_dy_7 + r_dy_5 + r_dy_4 + r_dy_1;
						r_i				<= b"000";
						r_i_mkc			<= '0';
						r_placeme		<= '1';						-- DEMANDE CHANGEMENT ETAT
					end if;
				when PLACE =>
					-- PLACEMENT DANS LE BON CADRANT
					-- todo verifier?
					if(r_q(1) xor r_q(0))then
						r_dx <= - r_x(14 downto 7);
					else
						r_dx <= r_x(14 downto 7);
					end if;

					if(r_q(1) = '1') then
						r_dy <= - r_y(14 downto 7);
					else
						r_dy <= r_y(14 downto 7);
					end if;
					r_placeme		<= '0';
					r_rd_nxy_p		<= '1';						-- DEMANDE CHANGEMENT ETAT
				when PUT =>
					r_nx				<= r_dx;
					r_ny				<= r_dy;
					r_rd_nxy_p			<= '0';
					r_wr_axy_p			<= '1';						-- DEMANDE CHANGEMENT ETAT
			end case;
		end if;
	end process;

	-- CREATION DE L'ETAT FUTUR MUTUELLEMENT EXCLUSIF
	process(ck)
	begin
		if (ck='1' and not ck'stable) then
			case r_condition is
				when b"100000" =>
					EF <= NORM;
					rok <= '0';
					wok <= '1';
					buf_nx <= buf_nx;
					buf_ny <= buf_ny;
				when b"010000" =>
					EF <= CALC;
				when b"001000" =>
					EF <= MKC;
				when b"000100" =>
					EF <= PLACE;
				when b"000010" =>
					EF <= PUT;
				when b"000001" =>
					EF <= GET;
					rok <= '1';
					wok <= '0';
					if (rd = '1') then
						buf_nx <= r_nx;
						buf_ny <= r_ny;
					else
						buf_nx <= buf_nx;
						buf_ny <= buf_ny;
					end if;
					when others => assert ('1') report "etat illegal";
				end case;
			end if;
		end process;

	-- CHAMGEMENT D"ETAT EP <= EF
		process(ck, reset)
		begin
			if (reset = '1') then
				EP <= GET;
			elsif (ck='1' and not ck'stable) then  
				EP <= EF;
			end if;
		end process;

	end;
