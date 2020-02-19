set verilog_file cordic_dp.v
set verilog_top  cordic_dp
set liberty_file /soc/alliance/cells/sxlib/sxlib.lib
#set liberty_file /home/tchi/Documents/sxlib.lib
yosys read_verilog          $verilog_file
yosys hierarchy -check -top $verilog_top
yosys synth            -top $verilog_top
yosys dfflibmap -liberty    $liberty_file
yosys abc       -liberty    $liberty_file
yosys clean
yosys write_blif cordic_dp.blif
