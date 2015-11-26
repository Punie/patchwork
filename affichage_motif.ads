------------------------------------------------------------------------
-- paquetage Affichage_Motif
--
-- Affichage d'un motif
--
-- P. Habraken : 25 octobre 2006
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
--
-- P. Habraken : 26/03/2009
-- ajout procedure creerFichierDot
------------------------------------------------------------------------
with Type_Patchwork;
use Type_Patchwork;

package Affichage_Motif is

   ---------------------------------------------------------------------
   -- afficher(m, x, y, l, h) : trace le motif m dans la fenetre
   -- d'affichage ; le trace produit est inscrit dans un rectangle de
   -- coordonnees x et y et de dimensions l et h
   ---------------------------------------------------------------------
   procedure afficher(motif : in Patchwork ;
                      x, y, largeur, hauteur : Natural);

   ---------------------------------------------------------------------
   -- creerFichierDot(m, nom) : cree dans le fichier designe par nom une
   -- representation textuelle au format dot du motif m ; le fichier
   -- obtenu permet d'obtenir ensuite une image au format Postscript de
   -- l'arbre representant le motif m au moyen de la commande :
   -- dot -Tps <nom fichier>.dot -o <nom fichier>.ps
   ---------------------------------------------------------------------
   procedure creerFichierDot(motif : in Patchwork ; nom : in String);

end Affichage_Motif;
