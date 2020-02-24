#RTL
set rtl [list /users/enseig/fabre/work/MOCCA/ProjetMOCCA/src/mips_with_reset.vhd]
#OPTIMISATION
set_attribute endpoint_slack_opto true /
#NAME OF DESIGN
set DESIGN MIPS_32_1P_MUL_DIV
#EFFORT FOR SYNTHESIS
set SYN_EFF high 
set MAP_EFF medium
set SYN_PATH "."
#LIBARRY
set_attribute library /users/enseig/tuna/ue_vlsi2/techno/cmos_120/cmos_120nm_core_Worst.lib
######################################################################
#READ VHDL
read_hdl -vhdl $rtl
#ELABORATE AND VALIDATE SYNTAX
elaborate $DESIGN
#Reports the time and memory used in the elaboration.
puts "Runtime & Memory after 'read_hdl'"
timestat Elaboration
#CHECK UNRESOLVED IT'S THE WORST THAT COULD HAPPEN
check_design -unresolved
#CONSTRAINT FILE
read_sdc /users/enseig/fabre/work/MOCCA/ProjetMOCCA/src/mips.sdc
######################################################################
#Synthesizing to generic cell
synthesize -to_generic -eff $SYN_EFF
puts "Runtime & Memory after 'synthesize -to_generic'"
timestat GENERIC
#Synthesizing to gates from the used PDK
synthesize -to_mapped -eff $MAP_EFF -no_incr
puts "Runtime & Memory after 'synthesize -to_map -no_incr'"
timestat MAPPED
#Incremental Synthesis
synthesize -to_mapped -eff $MAP_EFF -incr
#Insert Tie Hi and Tie low cells
insert_tiehilo_cells
puts "Runtime & Memory after incremental synthesis"
timestat INCREMENTAL
######################################################################
#write output files and generate reports
report area > ./out/${DESIGN}_area.rpt
report gates > ./out/${DESIGN}_gates.rpt
report timing > ./out/${DESIGN}_timing.rpt
report power > ./out/${DESIGN}_power.rpt
#Verilog
write_hdl -mapped > ./out/${DESIGN}_map.v
#generate the constaraints file> to be used in Encounter
write_sdc > ./out/${DESIGN}_map.sdc
puts "Final Runtime & Memory."
timestat FINAL
puts "====================="
puts "Synthesis Finished :)"
puts "====================="
