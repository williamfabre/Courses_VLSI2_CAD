# Cadence Encounter(R) RTL Compiler
#   version RC13.12 - v13.10-s021_1 (64-bit) built Jun  5 2014
#
# Run with the following arguments:
#   -logfile rc.log
#   -cmdfile rc.cmd

source script_synthesis.tcl
report timing
write_hdl
write_sdc
write_hdl -h
write_hdl > mips_post_optimisation
write_sdc > mips_post_optimisation_constraints
report -h
report timing
