create_clock -name clk_200MHz -period 5 [get_port CK]


set_input_delay 1.2 -clock clk_200MHz [get_port RESET_N]
set_input_delay 1.2 -clock clk_200MHz [get_port IT_N]
set_input_delay 1.2 -clock clk_200MHz [get_port CPU_NBR]
set_input_delay 1.2 -clock clk_200MHz [get_port I_RBERR]
set_input_delay 1.2 -clock clk_200MHz [get_port I_ACCPT]
set_input_delay 1.2 -clock clk_200MHz [get_port I_IN]
set_input_delay 1.2 -clock clk_200MHz [get_port D_RBERR]
set_input_delay 1.2 -clock clk_200MHz [get_port D_WBERR]
set_input_delay 1.2 -clock clk_200MHz [get_port D_ACCPT]
set_input_delay 1.2 -clock clk_200MHz [get_port D_IN]
set_input_delay 1.2 -clock clk_200MHz [get_port MCHECK_N]

set_output_delay 1.2 -clock clk_200MHz [get_port I_A]
set_output_delay 1.2 -clock clk_200MHz [get_port I_RQ]
set_output_delay 1.2 -clock clk_200MHz [get_port MODE]
set_output_delay 1.2 -clock clk_200MHz [get_port I_ACK]
set_output_delay 1.2 -clock clk_200MHz [get_port I_BEREN]
set_output_delay 1.2 -clock clk_200MHz [get_port I_INLINE]
set_output_delay 1.2 -clock clk_200MHz [get_port D_A]
set_output_delay 1.2 -clock clk_200MHz [get_port D_BYTSEL]
set_output_delay 1.2 -clock clk_200MHz [get_port D_RQ]
set_output_delay 1.2 -clock clk_200MHz [get_port D_RW]
set_output_delay 1.2 -clock clk_200MHz [get_port D_SYNC]
set_output_delay 1.2 -clock clk_200MHz [get_port D_REG]
set_output_delay 1.2 -clock clk_200MHz [get_port D_LINKED]
set_output_delay 1.2 -clock clk_200MHz [get_port D_RSTLKD]
set_output_delay 1.2 -clock clk_200MHz [get_port D_CACHE]
set_output_delay 1.2 -clock clk_200MHz [get_port D_CACHOP]
set_output_delay 1.2 -clock clk_200MHz [get_port D_OUT]
set_output_delay 1.2 -clock clk_200MHz [get_port D_ACK]
set_output_delay 1.2 -clock clk_200MHz [get_port SCOUT]
