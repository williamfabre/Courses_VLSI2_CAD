# this is a comment
set name [list "jack" "steve" "william" "franck" "edward"]
#puts "Hello $name !"

#for { set i 0 } {$i<10} {incr i} {
#puts "i => $name($i)"
#}

#foreach coder $name {
#	puts $coder
#}

#set third_coder [lindex $name 2]
#puts "the nanana is : $third_coder"

set days(d1) Monday
set days(d2) Tuesday
set days(d3) Wednesday
set days(d4) Thursday
set days(d5) Friday
set days(d6) Saturday
set days(d7) Sunday

puts [array size days]

foreach k [array names days] {
	puts "key: $k val: $days($k)"
	#puts $names
}


