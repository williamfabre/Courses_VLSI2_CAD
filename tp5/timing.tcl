set x0 [list {NAME and2}	{TYPE AND   }	{INPUTS[list "I0" "I1"]			}	{OUTPUTS [list "O"]		} {BC 102} {WC 198}]
set x1 [list {NAME andn3}	{TYPE AND   }	{INPUTS[list "I0" "I1" "NI2"] 		}	{OUTPUTS [list "O"]		} {BC 251} {WC 430}]
set x2 [list {NAME nand4}	{TYPE NAND  }	{INPUTS[list "I0" "I1" "I1"]		}	{OUTPUTS [list "Z"]		} {BC 123} {WC 199}]
set x3 [list {NAME or2}		{TYPE OR    }	{INPUTS[list "i0" "i1"]			}	{OUTPUTS [list "o"]		} {BC 102} {WC 203}]
set x4 [list {NAME or3}		{TYPE OR    }	{INPUTS[list "i0" "i1" "i2"]		}	{OUTPUTS [list "o"]		} {BC 126} {WC 233}]
set x5 [list {NAME xor2}	{TYPE XOR   }	{INPUTS[list "i0" "i1"]			}	{OUTPUTS [list "x"]		} {BC 213} {WC 359}]
set x6 [list {NAME xor3}	{TYPE XOR   }	{INPUTS[list "i0" "i1"]			}	{OUTPUTS [list "x"]		} {BC 245} {WC 402}]
set x7 [list {NAME bcell4}	{TYPE BCELL }	{INPUTS[list "a0" "a1" "b0" "b1"]	}	{OUTPUTS [list "O0" "O1"]	} {BC 412} {WC 756}]
set x8 [list {NAME bcell5}	{TYPE BCELL }	{INPUTS[list "a0" "a1" "b0" "b1" "b2"] 	}	{OUTPUTS [list "O0" "O1"]	} {BC 498} {WC 876}]

set library(and2) 	$x0
set library(andn3) 	$x1
set library(nand4) 	$x2
set library(or2)	$x3
set library(or3)	$x4
set library(xor2)	$x5
set library(xor3)	$x6
set library(bcell4)	$x7
set library(bcell5) 	$x8

set path [list and2 or2 or2 xor3]

# mot cle "proc" pour declarer une fonction
# The upvar command is similar. It "ties" the name of a variable in the current
# scope to a variable in a different scope. This is commonly used to simulate
# pass-by-reference to procs. 
proc get_wc_timing { cell } {

    #reference a la variable globale
    global library

    # recupere une ligne
    set my_cell [lindex $library($cell)]


    # recupere une case
    set bc [lindex $my_cell 4]
    
    #recupere une valeur
    set value [lindex [split $bc] 1]

    return $value
}


proc get_bc_timing { cell } {

    #reference a la variable globale
    global library

    # recupere une ligne
    set my_cell [lindex $library($cell)]


    # recupere une case
    set wc [lindex $my_cell 5]
    
    #recupere une valeur
    set value [lindex [split $wc] 1]

    return $value
}

set BC_sum 0
set WC_sum 0
set i 0
set G 0

foreach cell $path {
	set BC_sum [expr ($BC_sum + [get_bc_timing $cell]) ]
	set WC_sum [expr ($WC_sum + [get_wc_timing $cell]) ]
}

puts [expr $BC_sum / [llength $path]]
puts [expr $WC_sum / [llength $path]]
