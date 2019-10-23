uut=digicode
opt_SYF=r
opt_BOOM=j

all: $(uut)$(opt_SYF).vbe \
		$(uut)_pat \
		$(uut)_result_$(opt_SYF).pat \
		$(uut)$(opt_SYF)_$(opt_SYF)_o.vbe \
		$(uut)$(opt_SYF)_o.vst \
		$(uut)_result_boom_$(opt_SYF).pat \
		$(uut)$(opt_SYF)_$(opt_BOOM)_loon.vst




$(uut)$(opt_SYF).vbe:
	syf  -CEV -$(opt_SYF) $(uut).fsm

$(uut)_pat: 
	genpat genpat_$(uut)

$(uut)_result_$(opt_SYF).pat :
	asimut -b  $(uut)$(opt_SYF) $(uut)$(OPT_SYF) $(uut)_result_$(opt_SYF)

$(uut)$(opt_SYF)_$(opt_SYF)_o.vbe:
	boom -l 3 -V -A -$(opt_BOOM) $(uut)$(opt_SYF).vbe

$(uut)$(opt_SYF)_o.vst:
	boog $(uut)$(opt_SYF)_o

$(uut)_result_boom_$(opt_SYF).pat :
	asimut $(uut)$(opt_SYF)_o $(uut) $(uut)_result_boom_$(opt_SYF)_$(opt_BOOM)

$(uut)$(opt_SYF)_$(opt_BOOM)_loon.vst :
	loon $(uut)$(opt_SYF)_$(opt_BOOM) $(uut)$(opt_SYF)_$(opt_BOOM)_loon my_little_lax

#$(uut)_result_loon_$(opt_SYF)._$(opt_BOOM)pat :
	#asimut  $(uut)$(opt_SYF)_$(opt_BOOM)_loon $(uut) $(uut)_result_loon_$(opt_SYF)_$(opt_BOOM)

#$(uut)$(opt_SYF)_flatbeh.vbe:
	#flatbeh $(uut)$(opt_SYF)_$(opt_BOOM)_loon $(uut)$(opt_SYF)_$(opt_BOOM)_flatbeh

#proof$(opt_SYF) :
	#proof -d $(uut)$(opt_SYF) $(uut)$(opt_SYF)_$(opt_BOOM)_flatbeh

clean:
	rm -f *.al *.vbe *.vst *.rep *.o *.enc *.pat *.xsc *.xst core Makefile.* *~

#$(uut)$(opt_syf)_$(opt_boom)_loon.vst \
#$(uut)_result_loon_$(opt_syf)_$(opt_boom).pat \
#$(uut)$(opt_syf)_$(opt_boom)_flatbeh.vbe \
#proof$(opt_syf)_$(opt_boom) \
