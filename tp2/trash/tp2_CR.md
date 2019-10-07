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
	*   -- pragma CURRENT_STATE EP
	  -- pragma NEXT_STATE EF
	  -- pragma CLOCK CK
* Toujours ajouter vdd et vss dans les ports d'E/S
*
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
