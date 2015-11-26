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

package body Construction_Ast is

   use Arbre_Abstrait;
   use Type_Patchwork;

   ---------------------------------------------------------------------
   -- procedure creer_operation(opr : TypeOperateur ;
   --                           ne, nw, sw, se : Ast ;
   --                           expr : out Ast)
   --
   -- cree un noeud de type operation quaternaire (ASSEMBLAGE)
   ---------------------------------------------------------------------
   procedure creer_operation(opr : TypeOperateur ;
                             ne, nw, sw, se : Ast ;
                             expr : out Ast) is
   begin
      expr:=new NoeudAst;
      expr.nature := OPERATION;
      expr.operateur := opr;
      expr.ne := ne;
      expr.nw := nw;
      expr.sw := sw;
      expr.se := se;
   end;

   ---------------------------------------------------------------------
   -- procedure creer_operation(opr : TypeOperateur ;
   --                           opde : Ast ; expr : out Ast)
   --
   -- cree un noeud de type operation unaire (ROTATION, couleur)
   ---------------------------------------------------------------------
   procedure creer_operation(opr : TypeOperateur ;
                             opde : Ast ; expr : out Ast) is
   begin
      expr:=new NoeudAst;
      expr.nature := OPERATION;
      expr.operateur := opr;
      expr.ne := opde;
   end;

   ---------------------------------------------------------------------
   -- procedure creer_operation(opr : TypeOperateur ;
   --                           opde : Ast ; quadrant : TypeQuadrant ;
   --                           expr : out Ast)
   --
   -- cree un noeud de type operation unaire (ECLATEMENT, ZOOM)
   ---------------------------------------------------------------------
   procedure creer_operation(opr : TypeOperateur ;
                             opde : Ast ; quadrant : TypeQuadrant ;
                             expr : out Ast) is
   begin
      expr:=new NoeudAst;
      expr.nature := OPERATION;
      expr.operateur := opr;
      expr.quadrant := quadrant;
      expr.ne := opde;
   end;

   ---------------------------------------------------------------------
   -- procedure creer_valeur(motif : NaturePrimitif ; expr : out Ast)
   --
   -- cree une feuille (valeur)
   ---------------------------------------------------------------------
   procedure creer_valeur(motif : NaturePrimitif ; expr : out Ast) is
   begin
      expr:=new NoeudAst;
      expr.nature := VALEUR;
      expr.valeur := motif;
   end;

end Construction_Ast;
