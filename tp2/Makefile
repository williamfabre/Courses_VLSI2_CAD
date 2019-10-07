uut=
genpat_uut=genpat_$(uut)

uut_o = $(uut)o
uut_a = $(uut)a
uut_j = $(uut)j
uut_m = $(uut)m
uut_r = $(uut)r

SYF_OPT=-CEV
ASIMUT_OPT=-b

all:$(uut)o.vbe \
		$(uut)a.vbe \
		$(uut)j.vbe \
		$(uut)m.vbe \
		$(uut)r.vbe \
		uut_pat \
		$(uut)_result_o.pat \
		$(uut)_result_a.pat \
		$(uut)_result_j.pat \
		$(uut)_result_m.pat \
		$(uut)_result_r.pat

# utilisation de tous les formats de SYF avec les differents algos
$(uut)o.vbe:
	syf $(SYF_OPT) -o $(uut).fsm
$(uut)a.vbe:
	syf $(SYF_OPT) -a $(uut).fsm
$(uut)j.vbe:
	syf $(SYF_OPT) -j $(uut).fsm
$(uut)m.vbe:
	syf $(SYF_OPT) -m $(uut).fsm
$(uut)r.vbe:
	syf $(SYF_OPT) -r $(uut).fsm

uut_pat: 
	genpat $(genpat_uut)

$(uut)_result_o.pat :
	asimut -b $(ASIMUT_OPT) $(uut)o $(uut) $(uut)_result_o
$(uut)_result_a.pat :
	asimut -b $(ASIMUT_OPT) $(uut)a $(uut) $(uut)_result_a
$(uut)_result_j.pat :
	asimut -b $(ASIMUT_OPT) $(uut)j $(uut) $(uut)_result_j
$(uut)_result_m.pat :
	asimut -b $(ASIMUT_OPT) $(uut)m $(uut) $(uut)_result_m
$(uut)_result_r.pat :
	asimut -b $(ASIMUT_OPT) $(uut)r $(uut) $(uut)_result_r

clean:
	rm -f *.al *.vbe *.vst *.rep *.o *.enc *.pat core Makefile.* *~
