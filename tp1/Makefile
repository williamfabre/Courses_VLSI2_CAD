FILE = nand2
FILEref = $(FILE)ref.vbe
FILEtest = $(FILE).vbe

OBJ = $(FILEref) \
	$(FILEtest)

export MBK_IN_LO=al
export MBK_IN_PH=ap
export MBK_OUT_LO=al

all : $(OBJ)
## iii) proof_test
	proof $(FILE) $(FILE)ref

$(FILEref) : $(FILE).vhdl
## o) vasyREF(.vbe) >from-> BEHAVIOUR(.vhdl)
	vasy -I vhdl -V -o -a $(FILE).vhdl $(FILE)ref

$(FILEtest) : $(FILE).al
## ii) yagleBEHAVIOUR(.vbe) >from-> cougarNETLIST(.al)
	#export MBK_IN_LO=al
	~encadr/yagle -s $(FILE) $(FILE)

$(FILE).al : $(FILE).ap
## i) cougarNETLIST(.al) >from-> graalDRAW(.ap)
	#export MBK_IN_PH=ap
	#export MBK_OUT_LO=al
	cougar -t $(FILE) $(FILE)

clean:
	rm -f *.al *.vbe *.vst *.rep *.o core *~
