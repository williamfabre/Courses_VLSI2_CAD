#start###################################################################
puts "================="
puts "Synthesis Started"
date
puts "================="
#Include TCL utility scripts.
#Set up variables.
set rtl [list /users/enseig/fabre/work/MOCCA/ProjetMOCCA/src/mips_with_reset.vhd]
set_attribute endpoint_slack_opto true /

##A CHANGE HERE IS REQUIRED##
set DESIGN MIPS_32_1P_MUL_DIV
#set SYN_EFF <Required_synthesis_effort>
set SYN_EFF high 
#set MAP_EFF <Required_mapping_effort>
set MAP_EFF medium
#set SYN_PATH <Required_working_directory>
set SYN_PATH "."
#set the PDK’s path as a variable ‘PDKDIR’
#set PDKDIR $::env(PDKDIR)

######################################################################
#set the search path for the “.lib’ files provided with the PDK.
#set_attribute lib_search_path $PDKDIR/gsclib045_all_v4.4/gsclib045/timing
#select the needed .lib files.
#set_attribute library { slow_vdd1v0_basicCells.lib}
set_attribute library /users/enseig/tuna/ue_vlsi2/techno/cmos_120/cmos_120nm_core_Worst.lib
######################################################################


#This command is to read in your RTL code.
##A CHANGE HERE IS REQUIRED##
##Verilog##
read_hdl -vhdl $rtl
#Elaboration validates the syntax.
elaborate $DESIGN

#Reports the time and memory used in the elaboration.
puts "Runtime & Memory after 'read_hdl'"
timestat Elaboration
#return problems with your RTL code.
check_design -unresolved
#Read in your clock difinition and timing constraints
#read_sdc ./in/UP_COUNTER.sdc
read_sdc /users/enseig/fabre/work/MOCCA/ProjetMOCCA/src/mips.sdc
######################################################################


#Synthesizing to generic cell (not related to the used PDK)
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
#generate the verilog file with actual gates-> to be used in Encounter and ModelSim
##Verilog##
write_hdl -mapped > ./out/${DESIGN}_map.v
##SystemVerilog##
#write_hdl -mapped > ”./out/${DESIGN}_map.sv
#generate the constaraints file> to be used in Encounter
write_sdc > ./out/${DESIGN}_map.sdc
#generate the delays file> to be used in ModelSim
write_sdf > ./out/${DESIGN}_map.sdf



puts "Final Runtime & Memory."
timestat FINAL
#THE END
puts "====================="
puts "Synthesis Finished :)"
puts "====================="
#Exit RTL Compiler
#quit
