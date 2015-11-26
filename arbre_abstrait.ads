------------------------------------------------------------------------
-- paquetage Arbre_Abstrait
--
-- structure d'arbre syntaxique abstrait pour descriptions de motif
-- (patchwork)
--
-- P. Habraken : 23 octobre 2006
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------
with Type_Patchwork;

package Arbre_Abstrait is

	use Type_Patchwork;

	type TypeAst is (OPERATION, VALEUR);
	type TypeOperateur is (ASSEMBLAGE, ROTATION, ECLATEMENT, ZOOM, NOIR, BLEU, ROUGE, VERT, JAUNE);
	-- Ajout des operateurs de couleur
	type TypeQuadrant is (NE, NW, SW, SE);
	
	type NoeudAst;
	type Ast is access NoeudAst;
	type NoeudAst is record
		nature : TypeAst;
		operateur : TypeOperateur;
		ne, nw, sw, se : Ast;
		quadrant : TypeQuadrant;
		valeur : NaturePrimitif;
	end record;

	type OrdreAst is (PREFIXE, INFIXE, POSTFIXE);

end Arbre_Abstrait;
