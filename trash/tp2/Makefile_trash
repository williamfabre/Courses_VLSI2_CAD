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
		$(uut)_result_r.pat \
		$(uut)o_o.vbe \
		$(uut)a_o.vbe \
		$(uut)j_o.vbe \
		$(uut)m_o.vbe \
		$(uut)r_o.vbe \
		$(uut)o_o.vst \
		$(uut)a_o.vst \
		$(uut)j_o.vst \
		$(uut)m_o.vst \
		$(uut)r_o.vst \
		$(uut)_result_boom_o.pat \
		$(uut)_result_boom_a.pat \
		$(uut)_result_boom_j.pat \
		$(uut)_result_boom_m.pat \
		$(uut)_result_boom_r.pat \
		$(uut)o_loon.vst \
		$(uut)a_loon.vst \
		$(uut)j_loon.vst \
		$(uut)m_loon.vst \
		$(uut)r_loon.vst \
		$(uut)_result_loon_o.pat \
		$(uut)_result_loon_a.pat \
		$(uut)_result_loon_j.pat \
		$(uut)_result_loon_m.pat \
		$(uut)_result_loon_r.pat \
		$(uut)o_flatbeh.vbe \
		$(uut)a_flatbeh.vbe \
		$(uut)j_flatbeh.vbe \
		$(uut)m_flatbeh.vbe \
		$(uut)r_flatbeh.vbe \
		proofo \
		proofa \
		proofj \
		proofm \
		proofr 









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

# Ca c'est pour genpat
uut_pat: 
	genpat $(genpat_uut)

# ca c'est pour l'utilisation de asmut pour verifier si le circuit est conforme
# pendant une simulation
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


# ca c'est pour optimiser le circuit avec boom
$(uut)o_o.vbe:
	boom -l 3 -V -sjbg -A $(uut)o.vbe
$(uut)a_o.vbe:
	boom -l 3 -V -sjbg -A $(uut)a.vbe
$(uut)j_o.vbe:
	boom -l 3 -V -sjbg -A $(uut)j.vbe
$(uut)m_o.vbe:
	boom -l 3 -V -sjbg -A $(uut)m.vbe
$(uut)r_o.vbe:
	boom -l 3 -V -sjbg -A $(uut)r.vbe

# ca c'est pour linker le circuit a la bibliotheque SXLIB
$(uut)o_o.vst:
	boog $(uut)o
$(uut)a_o.vst:
	boog $(uut)a
$(uut)j_o.vst:
	boog $(uut)j
$(uut)m_o.vst:
	boog $(uut)m
$(uut)r_o.vst:
	boog $(uut)r

# ca c'est pour retester post synthese si on est toujour conforme
$(uut)_result_boom_o.pat :
	asimut $(ASIMUT_OPT) $(uut)o $(uut) $(uut)_result_boom_o
$(uut)_result_boom_a.pat :
	asimut $(ASIMUT_OPT) $(uut)a $(uut) $(uut)_result_boom_a
$(uut)_result_boom_j.pat :
	asimut $(ASIMUT_OPT) $(uut)j $(uut) $(uut)_result_boom_j
$(uut)_result_boom_m.pat :
	asimut $(ASIMUT_OPT) $(uut)m $(uut) $(uut)_result_boom_m
$(uut)_result_boom_r.pat :
	asimut $(ASIMUT_OPT) $(uut)r $(uut) $(uut)_result_boom_r

# ca c'est pour verifier les problemes de fanout et grace au fichier lax
# donner quelques modifications lors du fanout mettre la capa plus forte.
$(uut)o_loon.vst :
	loon $(uut)o $(uut)o_loon my_little_lax
$(uut)a_loon.vst :
	loon $(uut)a $(uut)a_loon my_little_lax
$(uut)j_loon.vst :
	loon $(uut)j $(uut)j_loon my_little_lax
$(uut)m_loon.vst :
	loon $(uut)m $(uut)m_loon my_little_lax
$(uut)r_loon.vst :
	loon $(uut)r $(uut)r_loon my_little_lax

# Une fois qu'on a fait le fanout on a un nouveau vst donc on va le re-tester
# avec la simulation de pat
$(uut)_result_loon_o.pat :
	asimut  $(uut)o_loon $(uut) $(uut)_result_loon_o
$(uut)_result_loon_a.pat :
	asimut  $(uut)a_loon $(uut) $(uut)_result_loon_a
$(uut)_result_loon_j.pat :
	asimut  $(uut)j_loon $(uut) $(uut)_result_loon_j
$(uut)_result_loon_m.pat :
	asimut  $(uut)m_loon $(uut) $(uut)_result_loon_m
$(uut)_result_loon_r.pat :
	asimut  $(uut)r_loon $(uut) $(uut)_result_loon_r

# On utilise flatbeh pour generer un vst directement et faire une preuve
# formelle apres
$(uut)o_flatbeh.vbe:
	flatbeh $(uut)o_loon $(uut)o_flatbeh
$(uut)a_flatbeh.vbe:
	flatbeh $(uut)a_loon $(uut)a_flatbeh
$(uut)j_flatbeh.vbe:
	flatbeh $(uut)j_loon $(uut)j_flatbeh
$(uut)m_flatbeh.vbe:
	flatbeh $(uut)m_loon $(uut)m_flatbeh
$(uut)r_flatbeh.vbe:
	flatbeh $(uut)r_loon $(uut)r_flatbeh

# preuve formelle que notre circuit est bien le meme que le circuit de base a
# comparer avec le post flatbeh
proofo :
	proof -d $(uut)o $(uut)o_flatbeh
proofa :
	proof -d $(uut)a $(uut)a_flatbeh
proofj :
	proof -d $(uut)j $(uut)j_flatbeh
proofm :
	proof -d $(uut)m $(uut)m_flatbeh
proofr :
	proof -d $(uut)r $(uut)r_flatbeh


clean:
	rm -f *.al *.vbe *.vst *.rep *.o *.enc *.pat *.xsc *.xst core Makefile.* *~
