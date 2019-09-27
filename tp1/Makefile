logic=

OBJ = $(logic).vbe \
	$(logic)_uut.vbe

export MBK_IN_LO=al
export MBK_IN_PH=ap
export MBK_OUT_LO=al

all : $(OBJ)
## iii) proof_test
	proof $(logic).vbe $(logic)_uut.vbe

$(logic).vbe : $(logic).vhdl
## o) vasyREF(.vbe) >from-> BEHAVIOUR(.vhdl)
	vasy -I vhdl -V -o -a $(logic).vhdl $(logic)

$(logic)_uut.vbe : $(logic).al
## ii) yagleBEHAVIOUR(.vbe) >from-> cougarNETLIST(.al)
	~encadr/yagle -s $(logic) $(logic)

$(logic).al : $(logic).ap
## i) cougarNETLIST(.al) >from-> graalDRAW(.ap)
	cougar -t $(logic) $(logic)

clean:
	rm -f *.al *.vbe *.vst *.rep *.o core *~
