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
with Graphsimple;
with Ada.Numerics.Elementary_Functions;
with Construction_Motif;
with Ada.Text_IO;

use Ada.Text_IO;

package body Affichage_Motif is

   procedure afficherCarre(motif : CarreElementaire ;
                           x, y, largeur, hauteur : Natural);

   procedure afficherMotif(motif : in Patchwork ;
                           x, y, largeur, hauteur : Natural);

   procedure motifVersDot(m : in Patchwork ; nom : String);

   use Graphsimple;
   use Construction_Motif;
   ---------------------------------------------------------------------
   -- afficher(m, x, y, l, h) : trace le motif m dans la fenetre
   -- d'affichage ; le trace produit est inscrit dans un rectangle de
   -- coordonnees x et y et de dimensions l et h
   ---------------------------------------------------------------------
   procedure afficher(motif : in Patchwork ;
                      x, y, largeur, hauteur : Natural) is
   begin
      DebutDessin;
      ChangerCouleur(Blanc);
      RectanglePlein(x, y, x + largeur - 1, y + hauteur - 1);
      afficherMotif(motif, x, y, largeur, hauteur);
      ChangerCouleur(Blanc);
      Rectangle(x, y, x + largeur - 1 , y + hauteur - 1);
      FinDessin;
   end afficher;

   ---------------------------------------------------------------------
   -- afficherMotif(m, x, y, l, h) : effectue dans la fenetre
   -- d'affichage le trace recursif du motif m ; le trace produit est
   -- inscrit dans un rectangle de coordonnees x et y et de dimensions l
   -- et h
   ---------------------------------------------------------------------
   procedure afficherMotif(motif : in Patchwork ;
                           x, y, largeur, hauteur : Natural) is
   begin
      if motif.ne = null then
         afficherCarre(motif.carre,x,y,largeur,hauteur);
      else
         afficherMotif(motif.ne,x+(largeur/2),y,(largeur/2),hauteur/2);
         afficherMotif(motif.nw,x,y,(largeur/2),hauteur/2);
         afficherMotif(motif.sw,x,y+(hauteur/2),largeur/2,hauteur/2);
         afficherMotif(motif.se,x+(largeur/2),y+(hauteur/2),largeur/2,hauteur/2);
      end if;
   end afficherMotif;

   ---------------------------------------------------------------------
   -- afficherCarre(m, x, y, l, h) : effectue dans la fenetre
   -- d'affichage le trace du motif primitif m, selon sa nature et son
   -- son orientation ; le trace produit est inscrit dans un rectangle
   -- de coordonnees x et y et de dimensions l et h
   ---------------------------------------------------------------------
   procedure afficherCarre(motif : CarreElementaire ;
                           x, y, largeur, hauteur : Natural) is
   begin
   
      if motif.couleur = NOIR then
         ChangerCouleur(Noir);
      elsif motif.couleur = ROUGE then
         ChangerCouleur(Rouge);
      elsif motif.couleur = BLEU then
         ChangerCouleur(Bleu);
      elsif motif.couleur = VERT then
         ChangerCouleur(Vert);
      elsif motif.couleur = JAUNE then
         ChangerCouleur(Jaune);
      end if;
      
      
      if motif.nature = ROND then
         if motif.orientation = EST then
            QuartCerclePleinEst(x,y+hauteur,largeur);
         elsif motif.orientation = NORD then
            QuartCerclePleinNord(x+largeur,y+hauteur,largeur);
         elsif motif.orientation = OUEST then
            QuartCerclePleinOuest(x+largeur,y,largeur);
         elsif motif.orientation = SUD then
            QuartCerclePleinSud(x,y,largeur);
         end if;
      else
         RectanglePlein(x,y,x+largeur,y+hauteur);
         ChangerCouleur(Blanc);
         if motif.nature = CARRE then
            if motif.orientation = EST then
               RectanglePlein(x+(largeur/2),y,x+largeur,y+(hauteur/2));
            elsif motif.orientation = NORD then
               RectanglePlein(x,y,x+(largeur/2),y+(hauteur/2));
            elsif motif.orientation = OUEST then
               RectanglePlein(x,y+(hauteur/2),x+(largeur/2),y+hauteur);
            elsif motif.orientation = SUD then
               RectanglePlein(x+(largeur/2),y+(hauteur/2),x+largeur,y+hauteur);
            end if;
         elsif motif.nature = TRIANGLE then
            if motif.orientation = EST then
               TrianglePlein(x,y,x+largeur+1,y,x+largeur+1,y+hauteur);
            elsif motif.orientation = NORD then
               TrianglePlein(x,y,x+largeur,y,x,y+hauteur);
            elsif motif.orientation = OUEST then
               TrianglePlein(x,y,x,y+hauteur,x+largeur,y+hauteur);
            elsif motif.orientation = SUD then
               TrianglePlein(x+largeur+1,y,x+largeur,y+hauteur,x,y+hauteur);
            end if;
         elsif motif.nature = PLEIN then
            null;
         elsif motif.nature = VIDE then
            RectanglePlein(x,y,x+largeur,y+hauteur);
         end if;

      end if;
            
   end afficherCarre;

   use Ada.Text_IO;
   fichierDot : File_Type;

   ---------------------------------------------------------------------
   -- creerFichierDot(m, nom) : cree dans le fichier designe par nom une
   -- representation textuelle au format dot du motif m ; le fichier
   -- obtenu permet d'obtenir ensuite une image au format Postscript de
   -- l'arbre representant le motif m au moyen de la commande :
   -- dot -Tps <nom fichier>.dot -o <nom fichier>.ps
   ---------------------------------------------------------------------
   procedure creerFichierDot(motif : in Patchwork ; nom : in String) is
   begin
      -- A COMPLETER (facultatif)
      null;
   end creerFichierDot;

   ---------------------------------------------------------------------
   -- motifVersDot(m, nom) : ajoute au fichier au format dot l'arbre
   -- representant le motif m
   -- . la racine de cet arbre a pour identifiant nom
   -- . les feuilles de l'arbre sont etiquetes par la nature et
   --   l'orientation du carre elementaire represente
   -- . les noeuds intermediaires sont etiquetes par le quadrant
   --   concerne (ne, new, sw ou se)
   ---------------------------------------------------------------------
   procedure motifVersDot(m : in Patchwork ; nom : String) is
   begin
      -- A COMPLETER (facultatif)
      null;
   end motifVersDot;

end Affichage_Motif;
