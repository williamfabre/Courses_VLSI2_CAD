set design "cordic_cor"
set verilog_file $design.v
set verilog_top  $design 
set liberty_file /soc/alliance/cells/sxlib/sxlib.lib
#set liberty_file /home/tchi/Documents/sxlib.lib
yosys read_verilog          $verilog_file
yosys hierarchy -check -top $verilog_top
yosys synth            -top $verilog_top
yosys dfflibmap -liberty    $liberty_file
yosys abc       -liberty    $liberty_file
yosys clean
yosys write_blif $design.blif
