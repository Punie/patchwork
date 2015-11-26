------------------------------------------------------------------------
-- paquetage Construction_Ast
--
-- creation des noeuds d'un arbre syntaxique abstrait pour descriptions
-- de motifs (patchwork)
--
-- P. Habraken : 23 octobre 2006
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------
with Arbre_Abstrait;
with Type_Patchwork;

package Construction_Ast is

   use Arbre_Abstrait;
   use Type_Patchwork;

   ---------------------------------------------------------------------
   -- procedure creer_operation(opr: TypeOperateur ;
   --                           ne, nw, sw, se : Ast ;
   --                           expr : out Ast)
   --
   -- cree un noeud de type operation quaternaire (ASSEMBLAGE)
   ---------------------------------------------------------------------
   procedure creer_operation(opr: TypeOperateur ;
                             ne, nw, sw, se : Ast ;
                             expr : out Ast);

   ---------------------------------------------------------------------
   -- procedure creer_operation(opr: TypeOperateur ;
   --                           opde : Ast ; expr : out Ast)
   --
   -- cree un noeud de type operation unaire (ROTATION)
   ---------------------------------------------------------------------
   procedure creer_operation(opr : TypeOperateur ;
                             opde : Ast ; expr : out Ast);

   ---------------------------------------------------------------------
   -- procedure creer_operation(opr: TypeOperateur ;
   --                           opde : Ast ; quadrant : TypeQuadrant ;
   --                           expr : out Ast)
   --
   -- cree un noeud de type operation unaire (ECLATEMENT, ZOOM)
   ---------------------------------------------------------------------
   procedure creer_operation(opr : TypeOperateur ;
                             opde : Ast ; quadrant : TypeQuadrant ;
                             expr : out Ast);

   ---------------------------------------------------------------------
   -- procedure creer_valeur(motif : NaturePrimitif ; expr : out Ast)
   --
   -- cree une feuille (valeur)
   ---------------------------------------------------------------------
   procedure creer_valeur(motif : NaturePrimitif ; expr : out Ast);

   ---------------------------------------------------------------------
   -- ERREUR_EXPRESSION : Exception;
   --
   -- un parametre donnee de type Ast est errone
   ---------------------------------------------------------------------
   ERREUR_EXPRESSION : Exception;

end Construction_Ast;
