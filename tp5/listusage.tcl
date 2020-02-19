set list [list {Washington 1789} {Adams 1797} {Jefferson 1801} \
{Madison 1809} {Monroe 1817} {Adams 1825} ]

set x [lsearch $list Washington*]
set y [lsearch $list Madison*]
incr x
incr y -1                        ;# Set range to be

set subsetlist [lrange $list $x $y]

puts "The following presidents served between Washington and
Madison"

foreach item $subsetlist {
    puts "Starting in [lindex $item 1]: President [lindex $item 0] "
}

