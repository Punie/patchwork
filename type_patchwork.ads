------------------------------------------------------------------------
-- paquetage Type_Patchwork
--
-- Description d'un motif
--
-- P. Habraken : 25 octobre 2006
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------
package Type_Patchwork is

	type NaturePrimitif is (CARRE, TRIANGLE, ROND, PLEIN, VIDE);
	type OrientationCarre is (EST, NORD, OUEST, SUD);
	type CouleurCarre is (ROUGE, BLEU, VERT, JAUNE, NOIR);
	-- Ajout du type CouleurCarre et implémentation dans le record CarreElementaire
	
	type CarreElementaire is record
		nature : NaturePrimitif := CARRE;
		orientation : OrientationCarre := EST;
		couleur : CouleurCarre := NOIR; -- attribut CouleurCarre
	end record;
	
	type NoeudPatchwork;
	type Patchwork is access NoeudPatchwork;
	
	type NoeudPatchwork is record 
		carre : CarreElementaire ;
		ne, nw, sw, se : Patchwork := null;
	end record ;

end Type_Patchwork;
