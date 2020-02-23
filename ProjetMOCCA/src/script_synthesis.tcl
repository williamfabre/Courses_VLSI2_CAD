set_attribute library /users/enseig/tuna/ue_vlsi2/techno/cmos_120/cmos_120nm_core_Worst.lib

set_attribute endpoint_slack_opto true

set rtl [list /users/enseig/fabre/work/MOCCA/ProjetMOCCA/src/mips_with_reset.vhd]

read_hdl -vhdl $rtl

elaborate MIPS_32_1P_MUL_DIV

read_sdc /users/enseig/fabre/work/MOCCA/ProjetMOCCA/src/mips.sdc

check_design

#synthesize -to_mapped

synthesize -effort high -to_mapped 
