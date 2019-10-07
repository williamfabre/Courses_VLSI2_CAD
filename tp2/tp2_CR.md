# [TP2 : Synthèse d'automate avec Alliance](https://www-soc.lip6.fr/trac/sesi-tools/wiki/MOCCA-TP2-2019)

## Outils de la chaîne Alliance

![](https://www-soc.lip6.fr/trac/sesi-tools/raw-attachment/wiki/MOCCA-TP2-2019/synthese_alliance.jpg)

	* syf,boom,boog,loon :Les outils de synthèse logique.
	* xsch : L'éditeur graphique de netlist.
	* flatbeh, proof : Les outils pour la preuve formelle.
	* asimut : Le simulateur.
	
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
Un fichier pat est un fichier de simulation.
Un oublie etant fatale pour la simulation.


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

#
