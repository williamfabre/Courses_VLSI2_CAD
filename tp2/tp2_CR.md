# [TP2 : Synthèse d'automate avec Alliance](https://www-soc.lip6.fr/trac/sesi-tools/wiki/MOCCA-TP2-2019)

## Objectif

Le but de ce TP est de découvrir et prendre en main la chaine d'outils ALLIANCE.
La chaine permet à partir d'une description HDL de generer une NETLIST dimensionnée electriquement.
En l'occurence, le HDL sera celle d'une FSM respectant une syntaxe propre à un ".fsm" qui nourrit l'outil SYF.

Pour atteindre l'objectif, nous nous placons dans un contexte relativement simple quand à la complexité de la MAE.Il s'agit d'un digicode.

## Outils de la chaîne Alliance

![](https://www-soc.lip6.fr/trac/sesi-tools/raw-attachment/wiki/MOCCA-TP2-2019/synthese_alliance.jpg)

	* syf,boom,boog,loon :Les outils de synthèse logique.
	* xsch : L'éditeur graphique de netlist.
	* flatbeh, proof : Les outils pour la preuve formelle.
	* asimut : Le simulateur.

"Chaque" outils de la chaine offrent des options d'encodage ou d'optimisations. Chaque optimisation de l'outil suivant s'applique à la production de l'outil précedant. Ce qui donne un grand nombre de possibilité qui s'apparente à un arbre.

SYF propose de selectionner 1 option ou aucunne parmi 5 algorithme d'encodage des etats : 
	(a j m o r).=> 6 résultats
BOOM propose de selectionner jusqu'à 3 options parmi 3 option d'optimisation : 
	A=0/1 , l -> 0,1,2,3 , d -> 0:100% => 45 résultats
BOOG et LOON proposent de selectionner 1 option ou aucune parmi 1 option d'optimisation : 
	m -> 0,1,2,3,4 => 6 résultats chacuns

Nous avons donc 6x45x6x6
SOIT 9720 possibles résulatats(.vst).
Et ce, sans considerer les l'options d'algoritmes personalisés et en ne considérant que deux valeurs de pourcentage (BOOM -d) que sont 0 et 100%.



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

### Genpat (/Asimut)
L'outil Genpat permet de generer un fichier pat (pattern description format) a
partir d'un fichier ecrit en C qui va assigner chaque signal pour chaque temps.
Un fichier pat est un fichier de simulation. Un oublie etant fatale pour la simulation.
Le reset permet l'initialisation de certains signaux, ils seront notes u (non
determine) si le reset n'est pas positionne au debut de la simulation. C'est pour cela qu'il faut faire un AFFECT avec la valeur "0b*" sur les sorties qui seront à l'état 'undefine' au moment du reset. En effet il n'est pas possible d'utiliser AFFECT pour affecter '0bu' aux signaux.
"0b*" indique à ASIMUT de ne pas considérer cette valeur pour la comparaison et donc de ne pas déclencher REPPORT.

**Remarque :** Le pat_result généré par ASIMUT ne comporte pas les temps dans les labels, contrairement au pat généré par GENPAT.

Tout les temps d'affectations (ie: "rising_edge" et "falling_edge") sont allignés sur des multiples de la variable "pas"; de telle que "2*pas" correspond à la période de l'horloge.

### Chronogramme des .pat avec Xpat
On peut visualiser les chronogramme des pattern généré avec la commande :
	
	xpat -l file_name

## LOON(problème de sortance)

* grand fanout : ie grand nombre de porte/grille sur une sortie/signal_interne qui induit une forte capacité(transition lente) => rise_time/fall_time détérioré
* LOON résout électriquement le problème des sortie ayant un grand fanout ( suiveur dans le signal ou power_up de la cellule surchargé)

## Chaîne longue

## Objectif :

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

|		|digicoder	|digicodesm	|digicodej	|digicodem	|digicodeo	|
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
|Surface	|122750   	|201500	 	|201500		|201500		|181250		|
|depth		|14		|14		|14          	|14		|11		|
|Literals	|151		|151		|151		|151		|	130	|
                                                                                          
POST utilisation de boom (synth)

|		|digicoder	|digicodem	|digicodej	|digicodem	|digicodem	|
|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|
|Surface	|122750		|100250	    	|99250       	|103250		|120750		|
|depth		|14		|13          	|13		|13		|10		|
|Literals	|124		|104         	|104		|108		|108		|

Boog sert a faire le lien entre la logique et les cellules de la librairie
SXLIB.
Il faut enlever l'option -b pour asimut car nous ne sommes plus en
comportementale.

Le travail a ete valide apres l'utilisation de boog.

On peut voir dans Xsch que les circuits sont tres differents.

Nous allons utiliser loon pour effectuer des optimisation de fanout. Elle n'est
au final pas possible cat l'option T{1000} ne fonctionne pas. Il faut faire
l'option de T{valeur <1000}
L'option de capacitance de sortie fonctionne

Apres utilisation de flatbeh et proof, tous les circuits sont bons.
