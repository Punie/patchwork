------------------------------------------------------------------------
-- paquetage Actions_Affichage
--
-- Recuperations des actions demandées par l'utilisateur et mise à jour
-- du motif en conséquence
--
-- H. Saracino & G. Frumy : 23 avril 2009
--
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Type_Patchwork, Affichage_Motif, Graphsimple, Construction_Motif, Arbre_Abstrait;
use Type_Patchwork, Affichage_Motif, Graphsimple, Construction_Motif, Arbre_Abstrait;

package Actions_Affichage is
	
	------------------------------------------------------------------------
	-- recuperer_motif (motif)                                            --
	--                                                                    --
	-- initialise l'historique et enregistre motif pour la restauration   --
	------------------------------------------------------------------------
	procedure recuperer_motif(motif : in Patchwork);
	
	------------------------------------------------------------------------
	-- chargement                                                         --
	--                                                                    --
	-- Affiche l'écran de chargement du motif                             --
	------------------------------------------------------------------------
	procedure chargement;
	
	------------------------------------------------------------------------
	-- effectuer_action (tailleV, tailleH, motif)                         --
	--                                                                    --
	-- Effectue la suite des actions désirées par l'utilisateur           --
	-- avant que celui-ci ne décide de quitter l'application              --
	------------------------------------------------------------------------
	procedure effectuer_action (tailleV, tailleH : in Natural ; motif : in Patchwork);
   
end Actions_Affichage;
