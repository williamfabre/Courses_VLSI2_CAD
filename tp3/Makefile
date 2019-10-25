logic=cordic_cor
ifndef logic
		$(error logic must be set)
endif

all : $(logic).v 
		#$(logic).v 
		#$(logic)_o.vbe 
		#$(logic)_o.vst

#$(logic).vbe : $(logic).vhdl
	#vasy -I vhdl -V -o -a $(logic).vhdl $(logic)

#$(logic).v : $(logic).vhdl
	#vasy -I vhdl -V -v -o $(logic).vhdl $(logic)

$(logic).v : $(logic).vhd
	vasy -I vhd -V -o -v $< $(logic)

# faire read_verilog du verilog
#

#$(logic)_o.vbe : $(logic).vbe
	#boom -l 3 -V -sjbg -A $<

#$(logic)_o.vst : $(logic)_o.vbe
	#boog $(logic)_o


clean:
	rm -f *.al *.vbe *.vst *.rep *.o core *~ vivado.* *.xsc
