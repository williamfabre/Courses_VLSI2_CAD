# TP 5 MOCCA voir : https://www.tcl.tk/man/tcl8.5/tutorial/Tcl0.html
# this is a comment
set name "prevetseski"
puts "Hello $name !"


set name_list [list "jack" "steve" "william" "franck" "edward"]
puts "Hello $name_list"


# l'accolade doit etre sur la ligne du for.
for { set i 0 } { $i < 10 } { incr i } {
    puts " i => $i"
}

# creer un tableau
set coders [list "kailun" "titi" "quentin" "sidiki"]

# recupere une valeur a un index donne dans un tableau
set third_coder [lindex $coders 2]

# print une variable
puts "the third coder is : $third_coder"

# ajouter des valeurs dans un tableau et leur donner un index
set foobarlol(word0) foo
set foobarlol(word1) bar
set foobarlol(word2) lol

# recuperer la taille du tableau
puts [array size foobarlol]

# Boucle foreach
# $k		    => index du tableau
# $foobarlol($k)"   => acces dans le tableau parenthese pour acceder a la val
 foreach k [array names foobarlol] {
     puts "keys:  $k val: $foobarlol($k) \a"
 }
