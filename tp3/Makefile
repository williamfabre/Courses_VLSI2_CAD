logic=cordic2
ifndef logic
		$(error logic must be set)
endif

all : $(logic).vbe \
		$(logic)_o.vbe \
		$(logic)_o.vst

$(logic).vbe : $(logic).vhdl
	vasy -I vhdl -V -o -a $(logic).vhdl $(logic)

$(logic)_o.vbe : $(logic).vbe
	boom -l 3 -V -sjbg -A $<

$(logic)_o.vst : $(logic)_o.vbe
	boog $(logic)_o


clean:
	rm -f *.al *.vbe *.vst *.rep *.o core *~
