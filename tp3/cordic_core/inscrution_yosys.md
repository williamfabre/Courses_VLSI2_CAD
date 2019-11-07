
Pour lancer Yosys:

1. Récupérer et modifier le script runyosys.tcl

2. Lancer yosys

   > yosys -c control.tcl


Pour placer et router avec Coriolis le contrôle seul:

1. Configurer l'environnment UNIX pour Coriolis:

   > eval `/soc/coriolis2/etc/coriolis2/coriolisEnv.py`

2. Lancer cgt -en mode graphique):

   > cgt -V --blif=control


Pour utiliser Stratus:

1. Configurer l'environnment UNIX pour Coriolis:

   > eval `/soc/coriolis2/etc/coriolis2/coriolisEnv.py`

2. Lancer cgt (en mode texte), ne pas mettre l'extension ".py" dans la
   ligne de commande.

   > cgt -V -t --script=cordic_dp



file:///users/outil/coriolis/coriolis-2.x/Linux.el7_64/Release.Shared/install/share/doc/coriolis2/en/html/main/index.html
