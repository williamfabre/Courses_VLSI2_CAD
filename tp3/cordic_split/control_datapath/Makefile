all : cordic_ctl.v

#cordic_dp.v

cordic_ctl.v : cordic_ctl.vhd
	vasy -I vhd -V -o -v $< cordic_ctl

#cordic_dp.v : cordic_dp.vhd
	#vasy -I vhd -V -o -v $< cordic_dp

clean:
	rm -f *.al *.vbe *.vst *.v *.blif *.rep *.o core *~ vivado.* *.xsc *.ap
