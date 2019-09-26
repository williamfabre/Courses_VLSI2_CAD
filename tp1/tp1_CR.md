
# CR1 MOCCA  20/09/19
https://www-soc.lip6.fr/trac/sesi-tools/wiki/MOCCA-TP1-2019

## Commandes pour alliance :
```bash
	source /soc/alliance/etc/profile.d/alc_env.sh
```

## Definitions :
	* GRAAL: éditeur de layout symbolique.
	* DRUC : vérificateur de règles de dessin integré à GRAAL.
	* Largeur : Largeur du canal (horizontale) plus grande que la longueur du canal.
	* ALU1 : première couche de metale invisible (pour la connectique)
	* CALU1 : connecteur ALU 1, premiere couche de metale visible du routeur
	* CALUX : connecteur ALU X (=CALU1, CALU2, CALU3..) forment l'interface de la cellule et jouent le role de connecteurs. 

## Objectif :
* Dessiner une cellule de NAND2 en tenant compte des [!règles de dessin](https://www-soc.lip6.fr/trac/sesi-tools/attachment/wiki/MOCCA-TP1-2019/symb_rules00-1.pdf) grâce à
l'environnement Alliance.

## Outils
### Types d'objets dans Graal :
* instances.
* boites d'aboutenment.
* segments (DIFFN, DIFFP, POLY, ALU1, ALU2).
* CALUX
* Big VIAs.
* T*or NMOS, PMOS.

### Cougar :
* Extraction de netlist d'un circuit format .vst ou .al a partir d'une description
au format ap.

### Yaggle et Proof :
* Yaggle : extraire la descpt VHDL comportementale from netlist .al -> .vbe.
* Proof : prouver l'eq entre deux descriptions comportementales de type dataflow. deux fichiers .vbe.

## Description Cellule par parametres :
hauteur : 50 Lda
largeur : %5Lda=0
VDD/VSS :
	* CALUX place sur une grille de 5*5 Lda n'importe ou dans la cellule.
	* en CALU1 (centre 3-47 Lda en Y), largeur_min_du_segment= 2Lda + 1 Lda pour
	    l'extension
	* 6 Lda de lageur (la largeur c'est du haut vers le bas).
	* Les transistors P sont places pres du rail VDD tandis que les
	    transistrs N sont places pres du rail VSS
	* Les caissons N ont une hauteur de 24Lda centre a 39 Lda en Y (raison
	    de puissance entre N et P)

## CR
### from_extension:tool:to_extension

#### layout:
GRAAL:ap
##### command : 

#### netlist:
.ap:Cougar:.al/.vst
##### command : 

#### VHDL simlifie:
.al:Yagle:.vbe
##### command : 

#### Preuve
.vbe + .vbe:Proof

#### VHDL
.vhdl:VASY/BOOM/BOOG:.vbe
##### command : vasy -I vhdl -V -o -a my_nand.vhdl my_nand
###### vasy :
	* -I Extension
	* -V verbose	
	* -o overwrite existing files
	* -a alliance output


### Protocole de realisation d'une cellule nand sous Graal
	* Preparer la grille (view -> x=5, y=5, set ON).
	* Poser le Nwell au dessus duquel sera la partie P de notre circuit.
	* Poser VDD et VSS en CALU1 qui font 6 de largeur. VSS sera colle au
	    bas de la boite d'aboutement et VDD sera a 1 lda du haut
	* Deposer les transistors (ce sont des entites a part entiere dans
	    graal.
	* Deposer des Cont Pdif(resp Ndif) pour creer des contact avec les transistors.
	    Ne pas faire d'enorme contact sinon le logiciel croit que tout est
	    connecte.
	    (TODO pourquoi doit-on faire contact avec vdd et vss?)
	* Utiliser le ALU1 pour connecter les transistors entre eux.

### Utilisation du tp
Pour utiliser le tp il suffit de faire make dans le dossier racine.
