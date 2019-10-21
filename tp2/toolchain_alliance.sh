#!/bin/bash

option_SYF="o a j m r"
option_BOOM="s j b g p w t m o r n"

IFS=' ' read -r -a array_SYF <<< "$option_SYF"
IFS=' ' read -r -a array_BOOM <<< "$option_BOOM"

for optsyf in ${array_SYF[@]}
do
	for optboom in ${array_BOOM[@]}
	do
		make -f Makefile -k opt_SYF=$optsyf  uut=digicode opt_BOOM=$optboom
	done
done
