------------------------------------------------------------------------
-- paquetage Parcours_Ast
--
-- affichage textuel et evaluation d'une description de motif a partir
-- de son arbre syntaxique abstrait
--
-- P. Habraken : 25 octobre 2006
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------
with Arbre_Abstrait;
with Type_Patchwork;

package Parcours_Ast is

   use Arbre_Abstrait;
   use Type_Patchwork;

   ---------------------------------------------------------------------
   -- procedure afficher(expr : Ast ; notation : OrdreAst := PREFIXE)
   --
   -- affiche l'arbre syntaxique abstrait d'une description de motif
   -- (sous forme prefixee par defaut)
   ---------------------------------------------------------------------
   procedure afficher(expr : Ast ; notation : OrdreAst := PREFIXE);

   ---------------------------------------------------------------------
   -- procedure construire(expr : Ast ; motif : out Patchwork)
   --
   -- evaluation (construction) un motif d'apres son arbre syntaxique
   -- abstrait
   ---------------------------------------------------------------------
   procedure construire(expr : Ast ; motif : out Patchwork);

end Parcours_Ast;
