uut=
genpat_uut=genpat_$(uut)
#uut_o=$(uut)o.vbe
#uut_pat=$(uut).pat
#SYF_OPT=-CEV -o
#ASIMUT_OPT=-b

#all: uut_pat

#uut_pat: 

#CMD=genpat -v genpat_digicode
CMD = syf -CEV -a digicode.fsm; genpat genpat_digicode;

all:
	$(CMD)
	#genpat $(genpat_uut)
#uut_o :
	#syf $(SYF_OPT) $(uut).fsm
#result :
	#asimut -b $(ASIMUT_OPT) $(uut)o $(uut) $(uut)_result

clean:
	rm -f *.al *.vbe *.vst *.rep *.o *.enc *.pat core *~
