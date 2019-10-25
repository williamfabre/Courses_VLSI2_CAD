module cordic_ctl (ck, raz, wr_axy_p, a_p, wok_axy_p, rd_nxy_p, rok_nxy_p, get_p, calc_p, mkc_p, place_p, a_lt_0_p, quadrant_p, i_p);

  input  	ck;
  input  	raz;
  input  	wr_axy_p;
  input  [9:0]	a_p;
  output 	wok_axy_p;
  input  	rd_nxy_p;
  output 	rok_nxy_p;
  output 	get_p;
  output 	calc_p;
  output 	mkc_p;
  output 	place_p;
  output 	a_lt_0_p;
  output [1:0]	quadrant_p;
  output [2:0]	i_p;

  wire	[15:0]  rtlexts_0;
  reg 	  rtldef_5;
  reg 	  rtldef_4;
  reg 	  rtldef_3;
  reg 	  rtldef_2;
  reg 	  rtldef_1;
  reg 	  rtldef_0;
  wire	  n_get;
  reg 	  get;
  wire	  n_norm;
  reg 	  norm;
  wire	  n_calc;
  reg 	  calc;
  wire	  n_mkc;
  reg 	  mkc;
  wire	  n_place;
  reg 	  place;
  wire	  n_put;
  reg 	  put;
  wire	  a_lt_0;
  wire	  quadrant_0;
  reg 	[1:0]  n_quadrant;
  reg 	[1:0]  quadrant;
  reg 	[2:0]  n_i;
  reg 	[2:0]  i;
  reg 	[15:0]  n_a;
  reg 	[15:0]  a;
  reg 	[15:0]  atan;
  wire	[15:0]  a_mpidiv2;
  wire	  fsm_def_14;
  assign	rtlexts_0 = {6'b000000 , a_p};

  always @ ( posedge ck )
    begin
      a = n_a;
    end

  always @ ( posedge ck )
    begin
      quadrant = n_quadrant;
    end

  always @ ( posedge ck )
    begin
      i = n_i;
    end

  always @ ( i or mkc or calc or get )
    if (get == 1'b1) n_i = 3'b000;
    else if ((calc | mkc) == 1'b1) n_i = (i + 3'b001);
    else n_i = i;

  always @ ( atan or a or a_lt_0 or calc or a_mpidiv2 or quadrant_0 or norm or rtlexts_0 or get )
    if (get == 1'b1) n_a = rtlexts_0;
    else if ((norm & ~(quadrant_0)) == 1'b1) n_a = a_mpidiv2;
    else if ((calc & ~(a_lt_0)) == 1'b1) n_a = (a - atan);
    else if ((calc & a_lt_0) == 1'b1) n_a = (a + atan);
    else n_a = a;
  assign	a_lt_0 = a[15];
  assign	quadrant_0 = a_mpidiv2[15];
  assign	a_mpidiv2 = (a - 16'b0000000011001001);

  always @ ( i )
    if (i == 3'b000) atan = 16'b0000000001100100;
    else if (i == 3'b001) atan = 16'b0000000000111011;
    else if (i == 3'b010) atan = 16'b0000000000011111;
    else if (i == 3'b011) atan = 16'b0000000000010000;
    else if (i == 3'b100) atan = 16'b0000000000001000;
    else if (i == 3'b101) atan = 16'b0000000000000100;
    else if (i == 3'b110) atan = 16'b0000000000000010;
    else atan = 16'b0000000000000001;

  always @ ( quadrant or quadrant_0 or norm or get )
    if (get == 1'b1) n_quadrant = 2'b00;
    else if ((norm & ~(quadrant_0)) == 1'b1) n_quadrant = (quadrant + 2'b01);
    else n_quadrant = quadrant;
  assign	a_lt_0_p = a_lt_0;
  assign	quadrant_p = quadrant;
  assign	i_p = i;
  assign	place_p = place;
  assign	mkc_p = mkc;
  assign	calc_p = calc;
  assign	get_p = get;
  assign	rok_nxy_p = put;
  assign	wok_axy_p = get;

  always @ ( posedge ck )
    begin
      put = (rtldef_5 & n_put);
    end

  always @ ( posedge ck )
    begin
      place = (rtldef_4 & n_place);
    end

  always @ ( posedge ck )
    begin
      mkc = (rtldef_3 & n_mkc);
    end

  always @ ( posedge ck )
    begin
      calc = (rtldef_2 & n_calc);
    end

  always @ ( posedge ck )
    begin
      norm = (rtldef_1 & n_norm);
    end

  always @ ( posedge ck )
    begin
      get = ((rtldef_0 & n_get) | fsm_def_14);
    end

  always @ ( fsm_def_14 )
    if (fsm_def_14 == 1'b0) rtldef_5 = 1'b1;
    else rtldef_5 = 1'b0;

  always @ ( fsm_def_14 )
    if (fsm_def_14 == 1'b0) rtldef_4 = 1'b1;
    else rtldef_4 = 1'b0;

  always @ ( fsm_def_14 )
    if (fsm_def_14 == 1'b0) rtldef_3 = 1'b1;
    else rtldef_3 = 1'b0;

  always @ ( fsm_def_14 )
    if (fsm_def_14 == 1'b0) rtldef_2 = 1'b1;
    else rtldef_2 = 1'b0;

  always @ ( fsm_def_14 )
    if (fsm_def_14 == 1'b0) rtldef_1 = 1'b1;
    else rtldef_1 = 1'b0;

  always @ ( fsm_def_14 )
    if (fsm_def_14 == 1'b0) rtldef_0 = 1'b1;
    else rtldef_0 = 1'b0;
  assign	fsm_def_14 = (raz == 1'b0);
  assign	n_put = (place | (put & ~(rd_nxy_p)));
  assign	n_place = (mkc & (i == 3'b010));
  assign	n_mkc = ((calc & (i == 3'b111)) | (mkc & ~((i == 3'b010))));
  assign	n_calc = ((norm & quadrant_0) | (calc & ~((i == 3'b111))));
  assign	n_norm = ((get & wr_axy_p) | (norm & ~(quadrant_0)));
  assign	n_get = ((get & ~(wr_axy_p)) | (put & rd_nxy_p));

endmodule
