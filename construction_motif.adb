------------------------------------------------------------------------
-- paquetage Construction_Motif
--
-- Construction de motifs
--
-- P. Habraken : 25 octobre 2006
------------------------------------------------------------------------
with Ada.Text_IO;

package body Construction_Motif is

   function copie(motif : in Patchwork) return Patchwork;

   ---------------------------------------------------------------------
   -- creerPrimitif(n, c, mc) : cree le motif primitif mc de nature n
   -- (carre | triangle | ...) et de couleur c
   ---------------------------------------------------------------------
   procedure creerPrimitif(nature : in NaturePrimitif ;
                           motifCree : out Patchwork) is
   begin
      motifCree := new NoeudPatchwork;
      motifCree.carre.nature := nature;
      motifCree.carre.orientation := EST;
   end creerPrimitif;

   ---------------------------------------------------------------------
   -- creerAssemblage(m1, m2, m3, m4, mc) : cree le motif mc a partir
   -- des motifs m1 (NE), m2 (NW), m3 (SW) et m4 (SE)
   ---------------------------------------------------------------------
   procedure creerAssemblage(ne, nw, sw, se : in Patchwork ;
                               motifCree : out Patchwork) is
   begin
      motifCree := new NoeudPatchwork;
      motifCree.ne := ne;
      motifCree.nw := nw;
      motifCree.sw := sw;
      motifCree.se := se;
   end creerAssemblage;

   ---------------------------------------------------------------------
   -- creerColoration(m,mc) : cree le motif mc a partir du motif m en lui
   -- appliquant la coloration adéquate
   ---------------------------------------------------------------------
   procedure creerColoration(motif : in Patchwork ; couleur : in CouleurCarre ;
							 motifCree : out Patchwork) is
      motifCreeNE, motifCreeNW, motifCreeSW, motifCreeSE : Patchwork;
   begin
	  motifCree := new NoeudPatchwork;
	  if estFeuille(motif) then
         motifCree.carre.nature := motif.carre.nature;
         motifCree.carre.orientation := motif.carre.orientation;
         motifCree.carre.couleur := couleur;
	  else
		 creerColoration(motif.ne,couleur,motifCreeNE);
		 creerColoration(motif.nw,couleur,motifCreeNW);
		 creerColoration(motif.sw,couleur,motifCreeSW);
		 creerColoration(motif.se,couleur,motifCreeSE);
		 creerAssemblage(motifCreeNE,motifCreeNW,motifCreeSW,motifCreeSE,motifCree);
	  end if;   
   end creerColoration;
   
   
   ---------------------------------------------------------------------
   -- creerRotation(m, mc) : cree le motif mc a partir du motif m en lui
   -- appliquant une rotation de 90 degres vers la gauche
   ---------------------------------------------------------------------
   procedure creerRotation(motif : in Patchwork ;
                           motifCree : out Patchwork) is
      motifCreeNE, motifCreeNW, motifCreeSW, motifCreeSE : Patchwork;
   begin
      motifCree := new NoeudPatchwork;
      if estFeuille(motif) then
         motifCree.carre.nature := motif.carre.nature;
		 motifCree.carre.couleur := motif.carre.couleur;
         if motif.carre.orientation = EST then
            motifCree.carre.orientation := NORD;
         elsif motif.carre.orientation = NORD then
            motifCree.carre.orientation := OUEST;
         elsif motif.carre.orientation = OUEST then
            motifCree.carre.orientation := SUD;
         elsif motif.carre.orientation = SUD then
            motifCree.carre.orientation := EST;
         end if;
      else
         creerRotation(motif.ne,motifCreeNE);
         creerRotation(motif.nw,motifCreeNW);
         creerRotation(motif.sw,motifCreeSW);
         creerRotation(motif.se,motifCreeSE);
         creerAssemblage(motifCreeSE,motifCreeNE,motifCreeNW,motifCreeSW,motifCree);
      end if;
      
   end creerRotation;

   ---------------------------------------------------------------------
   -- creerEclatement(m, q, mc) :
   -- E.I. : m designe un motif
   -- E.F. : si m est un motif primitif, mc est une copie de m ; sinon,
   --        on pose smq = sous-motif du quadrant q de m : mc est une
   --        copie de m dans laquelle le sous-motif du quadrant q a ete
   --        remplace par le motif smq + smq + smq + smq
   ---------------------------------------------------------------------
   procedure creerEclatement(motif : in Patchwork ;
                             quadrant : in TypeQuadrant;
                             motifCree : out Patchwork) is
      smq, smq2 : Patchwork;
   begin
      motifCree := new NoeudPatchwork;
      if estFeuille(motif) then
         creerAssemblage(copie(motif),copie(motif),copie(motif),copie(motif),motifCree);
      else
         if quadrant = NE then
            smq := copie(motif.ne);
            creerAssemblage(smq,smq,smq,smq,smq2);
            creerAssemblage(smq2,copie(motif.nw),copie(motif.sw),copie(motif.se),motifCree);
         elsif quadrant = NW then
            smq := copie(motif.nw);
            creerAssemblage(smq,smq,smq,smq,smq2);
            creerAssemblage(copie(motif.ne),smq2,copie(motif.sw),copie(motif.se),motifCree);
         elsif quadrant = SW then
            smq := copie(motif.sw);
            creerAssemblage(smq,smq,smq,smq,smq2);
            creerAssemblage(copie(motif.ne),copie(motif.nw),smq2,copie(motif.se),motifCree);
         elsif quadrant = SE then
            smq := copie(motif.se);
            creerAssemblage(smq,smq,smq,smq,smq2);
            creerAssemblage(copie(motif.ne),copie(motif.nw),copie(motif.sw),smq2,motifCree);
         end if;
      end if;
      
   end creerEclatement;

   ---------------------------------------------------------------------
   -- creerZoom(m, q, mc) :
   -- E.I. : m designe un motif
   -- E.F. : si m est un motif primitif, mc est une copie de m ; sinon,
   --        on pose smq = sous-motif du quadrant q de m : mc est une
   --        copie de smq
   ---------------------------------------------------------------------
   procedure creerZoom(motif : in Patchwork ;
                       quadrant : in TypeQuadrant;
                       motifCree : out Patchwork) is
   begin
      motifCree := new NoeudPatchwork;
      if estFeuille(motif) then
         motifCree := copie(motif);
      else
         if quadrant = NE then
            motifCree := copie(motif.ne);
         elsif quadrant = NW then
            motifCree := copie(motif.nw);
         elsif quadrant = SW then
            motifCree := copie(motif.sw);
         elsif quadrant = SE then
            motifCree := copie(motif.se);
         end if;
      end if;
   end creerZoom;
   
  
   ---------------------------------------------------------------------
   -- copie(m) est une copie du motif m
   ---------------------------------------------------------------------
   function copie(motif : in Patchwork) return Patchwork is
      copieCreee : Patchwork;
   begin
      copieCreee := new NoeudPatchwork;
      if estFeuille (motif) then
         copieCreee.carre := motif.carre;
      else
         creerAssemblage(copie(motif.ne),copie(motif.nw),copie(motif.sw),copie(motif.se),copieCreee);
      end if;
      return copieCreee;
   end copie;

   ---------------------------------------------------------------------
   -- estFeuille(m) <=> m est un motif primitif
   ---------------------------------------------------------------------
   function estFeuille(motif : in Patchwork) return Boolean is
   begin
      return motif.ne = null;
   end estFeuille;

end Construction_Motif;
