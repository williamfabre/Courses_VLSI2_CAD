# [TP2 : Synthèse d'automate avec Alliance](https://www-soc.lip6.fr/trac/sesi-tools/wiki/MOCCA-TP2-2019)

## Outils de la chaîne Alliance

![](https://www-soc.lip6.fr/trac/sesi-tools/raw-attachment/wiki/MOCCA-TP2-2019/synthese_alliance.jpg)

	* syf,boom,boog,loon :Les outils de synthèse logique.
	* xsch : L'éditeur graphique de netlist.
	* flatbeh, proof : Les outils pour la preuve formelle.
	* asimut : Le simulateur.

	POUR MAKE IL FAUT UTILIER make -f uut=digicode
	
## SYF
* SYF : prend une description proche du VHDL(fsm) pour produire un RTL au format .vbe
	La description .fsm ne doit décrire que la MAE.
* Les entrées/sorties et signaux sont de type "bit (ie: remplacer std_logic par bit)
* Expliciter l'horloge, l'état future et présent par les lignes suivantes :
	*  -- pragma CURRENT_STATE EP
	*  -- pragma NEXT_STATE EF
	*  -- pragma CLOCK CK
* Toujours ajouter vdd et vss dans les ports d'E/S
Il possede plusieurs options :
	* C : verifie les fonctions de transition
	* E : sauvegarde en .enc le fichier resultant (qui encode les etats)
	* V : verbose
Les differents codates (opt -a, -j, -m, -o, -r) permmettent d'encoder les etats
de plusieurs manieres.

### Genpat
L'outil Genpat permet de generer un fichier pat (pattern description format) a
partir d'un fichier ecrit en C qui va assigner chaque signal pour chaque temps.
Un fichier pat est un fichier de simulation. Un oublie etant fatale pour la simulation.
Le reset permet l'initialisation de certains signaux, ils seront notes u (non
determine) si le reset n'est pas positionne au debut de la simulation.


## LOON(problème de sortance)

* grand fanout : ie grand nombre de porte/grille sur une sortie/signal_interne qui induit une forte capacité(transition lente) => rise_time/fall_time détérioré
* LOON résout électriquement le problème des sortie ayant un grand fanout ( suiveur dans le signal ou power_up de la cellule surchargé)

## Chaîne longue

## Objectif :

## notes avant oublie
	commande/outil pour visualiser le chronograme à la suite d'asimut
	le pat_result d'asimut ne met pas les temps dans les labels
	...
	mettre B* dans le pat de test pour ignorer les sorties durant le reset, impossible de mettre u avec genpat_AFFECT
 	?

## DIGICODE
Le fichier pat a donc ete ecrit grave a genpat ecrit en C. Nous avons fait une
boucle pour assigner dans un if a chaque cycle une valeur a nos signaux,
l'increment de boucle etant le cycle actuel.

il faut utiliser la commande : make -k uut=XXXX
l'option -k ignorera les erreurs qui proviennent de genpat que nous n'avons pas
reussi a regler. uut= doit est adjoint du non du fichier vbe prive de son
extension.

Concertnant le nombre de litteraux, il reste le meme, 157 quelque soit l'option
utilisee. Le nombre de registre ne peut etre compter de nombre automatique mais
on peut voir que la description des signaux est exactement la meme grace a la
commane diff entre deux fichiers. Donc ils ont au moins le bon gout d'avoir le
meme nombre de registres.

Pour boom avec l'option -l 3 pour un maximum d'opti et -A pour les opti locales:
INITIAL:
		|	digicoder	|	digicodesm	|	digicodej	|	digicodem	|	digicodeo	|
Surface	|	122750		|	201500		|   201500		|   201500		|	181250		|
depth	|	14			|	14			|   14          |   14			|   11			|
Literals|	151			|	151			|   151			|   151			|   130			|
                                                                                          
POST utilisation de boom (synth)                                                          
		|	digicoder	|	digicodem	|	digicodej	|	digicodem	|	digicodem	|
Surface	|	122750		|	100250	    |   99250       |   103250		|	120750		|
depth	|	14			|	13          |   13			|	13			|	10			|
Literals|	124			|	104         |   104			|	108			|	108			|

Boog sert a faire le lien entre la logique et les cellules de la librairie
SXLIB.
Il faut enlever l'option -b pour asimut car nous ne sommes plus en
comportementale.

Le travail a ete valide apres l'utilisation de boog.

On peut voir dans Xsch que les circuits sont tres differents.

Nous allon utiliser loon pour effectuer des optimisation de fanout. Elle n'est
au final pas possible cat l'option T{1000} ne fonctionne pas. Il faut faire
l'option de T{valeur <1000}
L'option de capacitance de sortie fonctionne

Apres utilisation de flatbeh et proof, tous les circuits sont bons.
