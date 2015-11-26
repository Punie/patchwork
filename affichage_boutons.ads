------------------------------------------------------------------------
-- paquetage Affichage_Boutons
--
-- Affichage des boutons de l'interface graphique
--
-- H. Saracino & G. Frumy : 23 avril 2009
--
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Graphsimple, Construction_Motif, Affichage_Motif, Type_Patchwork;
use Graphsimple, Construction_Motif, Affichage_Motif, Type_Patchwork;

package Affichage_Boutons is
	
	-------------------------------------------------------------
	-- procedure afficher_boutons                              --
	--                                                         --
	-- Affiche l'ensemble des boutons de l'interface graphique --
	-------------------------------------------------------------
	procedure afficher_boutons;

end Affichage_Boutons;
