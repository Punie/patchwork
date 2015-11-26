------------------------------------------------------------------------
-- paquetage Table_Symboles
--
-- rangement des symboles dans un tableau et recuperation
--
-- H. Saracino & G. Frumy : 20 avril 2009
--
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Arbre_Abstrait, Machine_Lexemes;

package Table_Symboles is

	use Arbre_Abstrait, Machine_Lexemes;
   
	---------------------------------------------------------------------
	-- procedure inserer (id : in string ;
	--                    exp : in Ast )
	--
	-- cree la case du tableau tab correspondant a id et contenant exp
	-- si id n'est pas deja present dans le tableau tab
	---------------------------------------------------------------------
   
	procedure inserer(id : in Pointeur_Chaine ; exp : in Ast);
   
	---------------------------------------------------------------------
	-- procedure rechercher (id : in string ;
	--                       exp : out Ast )
	--
	-- renvoie dans exp l'Ast correspondant au symbole id
	---------------------------------------------------------------------
   
	procedure rechercher(id : in Pointeur_Chaine ; exp : out Ast);


end Table_Symboles;
