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

	signal r_pihalf : std_logic_vector(15 downto 0);

	signal r_atan_2 : std_logic_vector(7 downto 0);
	signal r_atan_2_0 : std_logic_vector(7 downto 0);
	signal r_atan_2_1 : std_logic_vector(7 downto 0);
	signal r_atan_2_2 : std_logic_vector(7 downto 0);
	signal r_atan_2_3 : std_logic_vector(7 downto 0);
	signal r_atan_2_4 : std_logic_vector(7 downto 0);
	signal r_atan_2_5 : std_logic_vector(7 downto 0);
	signal r_atan_2_6 : std_logic_vector(7 downto 0);
	signal r_atan_2_7 : std_logic_vector(7 downto 0);

	signal r_a      : std_logic_vector(8 downto 0);
	signal r_x      : std_logic_vector(15 downto 0);
	signal r_y      : std_logic_vector(15 downto 0);

	signal r_dx   : std_logic_vector(15 downto 0);
	signal r_dx_0   : std_logic_vector(15 downto 0);
	signal r_dx_1   : std_logic_vector(15 downto 0);
	signal r_dx_2   : std_logic_vector(15 downto 0);
	signal r_dx_3   : std_logic_vector(15 downto 0);
	signal r_dx_4   : std_logic_vector(15 downto 0);
	signal r_dx_5   : std_logic_vector(15 downto 0);
	signal r_dx_6   : std_logic_vector(15 downto 0);
	signal r_dx_7   : std_logic_vector(15 downto 0);

	signal r_dy   : std_logic_vector(15 downto 0);
	signal r_dy_0   : std_logic_vector(15 downto 0);
	signal r_dy_1   : std_logic_vector(15 downto 0);
	signal r_dy_2   : std_logic_vector(15 downto 0);
	signal r_dy_3   : std_logic_vector(15 downto 0);
	signal r_dy_4   : std_logic_vector(15 downto 0);
	signal r_dy_5   : std_logic_vector(15 downto 0);
	signal r_dy_6   : std_logic_vector(15 downto 0);
	signal r_dy_7   : std_logic_vector(15 downto 0);

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

	signal r_i      : std_logic_vector(2 downto 0);

	type ETAT_TYPE is (GET, NORM, CALC, MKC, PLACE, PUT);
	signal EP,EF : ETAT_TYPE;

begin
	r_pihalf <= X"00C9";
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
	-- RESULTAT POUR X

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
	-- RESULTAT POUR Y

	-- CONDITION DE CHANGEMENT D'ETAT MUTUELLEMENT EXCLUSIF
	r_condition <= r_wr & r_quadrant0 & r_i_calc & r_i_mkc & r_placeme & r_rd_nxy_p;



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
			r_a						<= A;
			-- state
			r_wr					<= wr;
			r_quadrant0				<= '0';
			r_i_calc				<= '0';
			r_i_mkc					<= '0';
			r_placeme				<= '0';
			r_rd_nxy				<= '0';
			-- boucle
			r_i						<= 0;
		end if;
		case EP is
			when GET =>
				-- CONVERSION EN VIRGULE FIXE
				-- 9 bit entier 7 bit virgule fixe donc extension de signe
				r_x					<= X(7) &  X & "00000000";
				r_y					<= X(7) &  Y & "00000000";
				r_wr				<= '0';
				r_quadrant0			<= '1';							-- DEMANDE CHANGEMENT ETAT
			when NORM =>
				-- NORMALISATION DANS LE CADRAN 0
				if (r_a >= r_pihalf) then
					r_a				<= r_a - r_pihalf;
					r_q				<= (r_q + 1) AND X"03";
				else
					r_quadrant0		<= '0';
					r_icalc			<= '1';							-- DEMANDE CHANGEMENT ETAT
				end if;
			when CALC =>
				-- ROTATION, RECHERCHE DICHOTOMIQUE D'ANGLE
				case r_i is
					when '0' =>
						r_dy		<= r_dy_0;
						r_dx		<= r_dx_0;
						r_atan_2	<= r_atan_2_0;
						r_i			<= '1';
					when '1' =>
						r_dy		<= r_dy_1;
						r_dx		<= r_dx_1;
						r_atan_2	<= r_atan_2_1;
						r_i			<= '2';
					when '2' =>
						r_dy		<= r_dy_2;
						r_dx		<= r_dx_2;
						r_atan_2	<= r_atan_2_2;
						r_i			<= '3';
					when '3' =>
						r_dy		<= r_dy_3;
						r_dx		<= r_dx_3;
						r_atan_2	<= r_atan_2_3;
						r_i			<= '4';
					when '4' =>
						r_dy		<= r_dy_4;
						r_dx		<= r_dx_4;
						r_atan_2	<= r_atan_2_4;
						r_i			<= '5';
					when '5' =>
						r_dy		<= r_dy_5;
						r_dx		<= r_dx_5;
						r_atan_2	<= r_atan_2_5;
						r_i			<= '6';
					when '6' =>
						r_dy		<= r_dy_6;
						r_dx		<= r_dx_6;
						r_atan_2	<= r_atan_2_6;
						r_i			<= '7';
					when '7' =>
						r_dy		<= r_dy_7;
						r_dx		<= r_dx_7;
						r_atan_2	<= r_atan_2_7;
						r_i			<= '0';
						r_i_calc	<= '0';
						r_mkc		<= '1';						-- DEMANDE CHANGEMENT ETAT
				end case;
				-- calcule effectif  des rotations
				if (r_a >= X"0000")then
					r_x				<= r_x - r_dy;
					r_y				<= r_y + r_dx;
					r_a				<= A - r_atan_2;
				else
					r_x				<= r_x + r_dy;
					r_y				<= r_y - r_dx;
					r_a				<= A + r_atan_2;
				end if;
			when MKC =>
				-- MULTIPLICATION PAR K
				-- produit du résultat par les cosinus des angles : K=0x4D=1001101
				case r_i is
					when '0' =>
						r_dx		<= r_dx_6 + r_dx_5 + r_dx_4 + r_dx_1;
						r_i			<= '1';
					when '1' =>
						r_dy		<= r_dy_6 + r_dy_5 + r_dy_4 + r_dy_1;
						r_i			<= '0';
						r_mkc		<= '0';
						r_placeme	<= '1';						-- DEMANDE CHANGEMENT ETAT
				end case;
			when PLACE =>
				-- PLACEMENT DANS LE BON CADRANT
				-- todo verifier?
				if (r_q(1) xor r_q(0))then
					r_nx			<= - r_x(14 downto 7);
				else
					r_nx			<= r_x(14 downto 7);
				end if;
				if (r_q(1) = '1') then
					r_ny			<= - r_y(14 downto 7);
				else
					r_ny			<= r_y(14 downto 7);
				end if;
				r_placeme			<= '0';
				r_put				<= '1';						-- DEMANDE CHANGEMENT ETAT
			when PUT =>
				r_put				<= '0';
				r_wr				<= '1';						-- DEMANDE CHANGEMENT ETAT
				when others => assert ('1') report "etat illegal";
			end case;
		end if;
	end process;

-- CREATION DE L'ETAT FUTUR MUTUELLEMENT EXCLUSIF
	process(ck)
	begin
		if (ck='1' and not ck'stable) then
			case condition is
				when b"100000" => EF <= NORM;
				when b"010000" => EF <= CALC;
				when b"001000" => EF <= MKC;
				when b"000100" => EF <= PLACE;
				when b"000010" => EF <= PUT;
				when b"000001" => EF <= GET;
				rd_nxy_p <= '0';
				when others => assert ('1') report "etat illegal";
			end case;
		end if;
	end process;

-- CHAMGEMENT D"ETAT EP <= EF
	process( ck )
	begin
		if (ck='1' and not ck'stable) then
			EP <= EF;
		end if;
	end process;
end;
