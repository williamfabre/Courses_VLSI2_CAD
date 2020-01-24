# UE VLSI-2 TP: RTL Compiler
##2. Load the libraries
###Explain the difference between these two different types.

``` bash
/users/outil/indus/techno/backend/cmos_120nm_clock_Best.lib
/users/outil/indus/techno/backend/cmos_120nm_core_Best.lib
/users/outil/indus/techno/backend/cmos_120nm_filler_Best.lib
/users/outil/indus/techno/backend/cmos_120nm_io_3v3_Best.lib
/users/outil/indus/techno/backend/cmos_120nm_io_Best.lib

```

	* Library MAX (worst case) c'est la vérification de la stabilité du signal avant le front. C'est la setup analysis.

``` bash
/users/outil/indus/techno/backend/cmos_120nm_clock_Worst.lib
/users/outil/indus/techno/backend/cmos_120nm_core_Worst.lib
/users/outil/indus/techno/backend/cmos_120nm_filler_Worst.lib
/users/outil/indus/techno/backend/cmos_120nm_io_3v3_Worst.lib
/users/outil/indus/techno/backend/cmos_120nm_io_Worst.lib
```

	* Library MIN (best case)  c'est la vérification de la stabilité du signal avant le front. C'est la setup hold.

### Which one is needed for the synthesis step ? Explain your choice.
	* L'analyse de chaîne longue peut être intéressante car même en ayant des délais nuls sur le net lors de la synthèse,
	il est possible d'observer des problèmes de setup car l'addition de l'ensemble des délais des portes peut ne pas
	respecter les contraintes de temps.
	Nous pouvons aussi utiliser le WLM (Wire Load Model) qui est un modèle statistique de longueur de fils, permettant
	une étude plus cohérente lors de la synthèse.
	* L'analyse de chaîne courte n'est pas vraiment utile car ce problème est surtout induit par l'arbre à clock.

### Pick up a timing arc in the WC lib and the same timing arc in the BC, what is the value in the first library and in the second library. Add in your report a figure of the cell and the corresponding timing arc. (/users/enseig/tuna/ue_vlsi2/techno/cmos_120)


```
    timing() {
      related_pin : "A" ;
      drc_charcond : "1_1  0_0 " ;
      timing_sense : positive_unate ;
      /* A_R_Z_R */
      cell_rise(table_2) { 
        values( "0.07636, 0.08297, 0.09518, 0.12083, 0.17166, 0.26697, 0.29009", \
                "0.09692, 0.10353, 0.11575, 0.14138, 0.19228, 0.28749, 0.31070", \
                "0.11893, 0.12554, 0.13774, 0.16339, 0.21394, 0.30936, 0.33248", \
                "0.15182, 0.15843, 0.17063, 0.19627, 0.24705, 0.34214, 0.36553", \
                "0.20553, 0.21214, 0.22436, 0.24997, 0.30084, 0.39594, 0.41947" );
      }
      rise_transition(table_2) { 
        values( "0.01310, 0.02693, 0.06291, 0.14287, 0.30338, 0.60576, 0.67817", \
                "0.01311, 0.02694, 0.06292, 0.14332, 0.30339, 0.60577, 0.67818", \
                "0.01312, 0.02695, 0.06301, 0.14333, 0.30340, 0.60578, 0.67819", \
                "0.01313, 0.02696, 0.06302, 0.14334, 0.30341, 0.60579, 0.67820", \
                "0.01314, 0.02697, 0.06303, 0.14335, 0.30425, 0.60580, 0.67821" );
      }
      /* A_F_Z_F */
      cell_fall(table_2) { 
        values( "0.07297, 0.07996, 0.09231, 0.11672, 0.16474, 0.25451, 0.27653", \
                "0.10206, 0.10905, 0.12140, 0.14580, 0.19382, 0.28363, 0.30561", \
                "0.13715, 0.14414, 0.15649, 0.18091, 0.22877, 0.31868, 0.34048", \
                "0.19222, 0.19921, 0.21157, 0.23596, 0.28382, 0.37354, 0.39535", \
                "0.28517, 0.29217, 0.30452, 0.32890, 0.37689, 0.46656, 0.48838" );
      }
      fall_transition(table_2) { 
        values( "0.01020, 0.02027, 0.04457, 0.09875, 0.20820, 0.41458, 0.46511", \
                "0.01021, 0.02028, 0.04458, 0.09876, 0.20821, 0.41459, 0.46512", \
                "0.01022, 0.02031, 0.04459, 0.09877, 0.20825, 0.41460, 0.46513", \
                "0.01023, 0.02032, 0.04460, 0.09878, 0.20826, 0.41461, 0.46514", \
                "0.01024, 0.02033, 0.04461, 0.09879, 0.20827, 0.41462, 0.46515" );
      }
      timing_label : "A_Z" ;
      intrinsic_rise : 0.09651 ;
      intrinsic_fall : 0.10163 ;
``` 


