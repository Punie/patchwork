------------------------------------------------------------------------
-- paquetage Construction_Motif
--
-- Construction de motifs
--
-- P. Habraken : 25 octobre 2006
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------
with Type_Patchwork, Arbre_Abstrait;

package Construction_Motif is

   use Type_Patchwork, Arbre_Abstrait;
   
   function estFeuille(motif : in Patchwork) return Boolean;
   
   ---------------------------------------------------------------------
   -- creerPrimitif(n, c, mc) : cree le motif primitif mc de nature n
   -- (carre | triangle | ...) et de couleur c
   ---------------------------------------------------------------------
   procedure creerPrimitif(nature : in NaturePrimitif ;
                           motifCree : out Patchwork);

   ---------------------------------------------------------------------
   -- creerAssemblage(m1, m2, m3, m4, mc) : cree le motif mc a partir
   -- des motifs m1 (NE), m2 (NW), m3 (SW) et m4 (SE)
   ---------------------------------------------------------------------
   procedure creerAssemblage(ne, nw, sw, se : in Patchwork ;
                               motifCree : out Patchwork);

   ---------------------------------------------------------------------
   -- creerColoration(m,mc) : cree le motif mc a partir du motif m en lui
   -- appliquant la coloration adéquate
   ---------------------------------------------------------------------
   procedure creerColoration(motif : in Patchwork ; couleur : in CouleurCarre ;
							 motifCree : out Patchwork);
   
   ---------------------------------------------------------------------
   -- creerRotation(m, mc) : cree le motif mc a partir du motif m en lui
   -- appliquant une rotation de 90 degres vers la gauche
   ---------------------------------------------------------------------
   procedure creerRotation(motif : in Patchwork ;
                           motifCree : out Patchwork);

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
                             motifCree : out Patchwork);

   ---------------------------------------------------------------------
   -- creerZoom(m, q, mc) :
   -- E.I. : m designe un motif
   -- E.F. : si m est un motif primitif, mc est une copie de m ; sinon,
   --        on pose smq = sous-motif du quadrant q de m : mc est une
   --        copie de smq
   ---------------------------------------------------------------------
   procedure creerZoom(motif : in Patchwork ;
                       quadrant : in TypeQuadrant;
                       motifCree : out Patchwork);

end Construction_Motif;
