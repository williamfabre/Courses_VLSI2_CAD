logic=
ifndef logic
$(error logic must be set)
endif

OBJ = $(logic).vbe\
	$(logic)_uut.vbe

export MBK_IN_LO=al
export MBK_IN_PH=ap
export MBK_OUT_LO=al

all : $(OBJ)
	proof $(logic) $(logic)_uut

$(logic).vbe : $(logic).vhdl
	vasy -I vhdl -V -o -a $(logic).vhdl $(logic)

$(logic)_uut.vbe : $(logic)_uut.al
	~encadr/yagle -s $(logic)_uut $(logic)

$(logic)_uut.al : $(logic).ap
	cougar -t $(logic) $(logic)_uut

clean:
	rm -f *.al *.vbe *.vst *.rep *.o core *~
