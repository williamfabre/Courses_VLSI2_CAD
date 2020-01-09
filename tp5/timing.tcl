set library(and2) 	{NAME and2	TYPE AND	INPUTS [list "I0" "I1"]			OUTPUTS [list "O"]		BC 102 WC 198}
set library(andn3) 	{NAME andn3	TYPE AND	INPUTS [list "I0" "I1" "NI2"] 		OUTPUTS [list "O"]		BC 251 WC 430}
set library(nand4) 	{NAME nand4	TYPE NAND	INPUTS [list "I0" "I1" "I1"]		OUTPUTS [list "Z"]		BC 123 WC 199}
set library(or2)	{NAME or2	TYPE OR		INPUTS [list "i0" "i1"]			OUTPUTS [list "o"]		BC 102 WC 203}
set library(or3)	{NAME or3	TYPE OR		INPUTS [list "i0" "i1" "i2"]		OUTPUTS [list "o"]		BC 126 WC 233}
set library(xor2)	{NAME xor2	TYPE XOR	INPUTS [list "i0" "i1"]			OUTPUTS [list "x"]		BC 213 WC 359}
set library(xor3)	{NAME xor3	TYPE XOR	INPUTS [list "i0" "i1"]			OUTPUTS [list "x"]		BC 245 WC 402}
set library(bcell4)	{NAME bcell4	TYPE BCELL	INPUTS [list "a0" "a1" "b0" "b1"]	OUTPUTS [list "O0" "O1"]	BC 412 WC 756}
set library(bcell5) 	{NAME bcell5 	TYPE BCELL 	INPUTS [list "a0" "a1" "b0" "b1" "b2"] 	OUTPUTS [list "O0" "O1"]	BC 498 WC 876}

set path [list and2 or2 or2 xor3]
set BC_sum 0
set WC_sum 0
set G 0

# mot cle proc pour declarer une fonction
proc get_wc_timing { cell } {
    global library
    return [lindex $library($cell) 11]
}

puts [get_wc_timing or2]

#foreach p $path {
#	#set BC_sum [expr $BC_sum + 1]
#	set G [expr dict get cell($p) BC]
#	#puts (dict get $cell($p) BC)
#}

#puts $BC_sum
