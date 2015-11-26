------------------------------------------------------------------------
-- paquetage Analyseur_Syntaxique
--
-- analyse syntaxique d'une description de motif et creation de
-- l'arbre syntaxique abstrait correspondant
--
-- P. Habraken : 23 octobre 2006
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------
with Machine_Lexemes, Arbre_Abstrait, Construction_Ast, Type_Patchwork, Table_Symboles;
with Ada.Text_IO;

package body Analyseur_Syntaxique is

   use Machine_Lexemes, Arbre_Abstrait, Construction_Ast, Table_Symboles;

   pragma Warnings (Off, "possible infinite recursion");
   pragma Warnings (Off, "Storage_Error may be raised at run time");

   ---------------------------------------------------------------------
   -- pre-declaration /specification des sous-programmes
   -- utilises / appeles par la procedure analyser
   ---------------------------------------------------------------------
   
   procedure rec_instr (expr : out Ast);
   procedure rec_decl;
   procedure rec_affect;
   procedure rec_suitedecl;
   
   procedure rec_exp (expr : out Ast);
   procedure rec_motif (expr : out Ast);
   procedure rec_suitecons (expr : in out Ast);
   procedure rec_m (expr : out Ast);
   procedure rec_quadrant (quad : out TypeQuadrant);    
   procedure rec_primitif (expr : out Ast);
   procedure rec_idf(expr : out Ast);    
   procedure rec_lex(lexeme_attendu : Nature_Lexeme);
   procedure traiter_erreur;
   
   expr : Ast;
   
   ---------------------------------------------------------------------
   -- procedure analyser
   --
   -- analyse une description de motif saisie au clavier et en cree
   -- l'arbre syntaxique abstrait
   ---------------------------------------------------------------------
   procedure analyser(expr : out Ast) is   
      use Ada.Text_IO;
   begin
      put_line("Saisir une expression :");
      put("> ");
      analyser("",expr);
   end;

   ---------------------------------------------------------------------
   -- procedure analyser(nom_fichier : in String)
   --
   -- analyse une description de motif contenue dans un fichier et en
   -- cree l'arbre syntaxique abstrait
   ---------------------------------------------------------------------
   procedure analyser(nom_fichier : in String ; expr : out Ast) is  
   begin
      demarrer(nom_fichier);
      rec_instr(expr);
   end;

   ---------------------------------------------------------------------
   -- realisation des sous-programmes correspondant aux regles de la
   -- grammaire des descriptions de motif
   ---------------------------------------------------------------------
   
   procedure rec_instr (expr : out Ast) is
   begin
      if lexeme_courant.nature = IDENTIFICATEUR then
         rec_decl;
         rec_lex(FIN_DECLARATION);
         rec_lex(FIN_LIGNE);
         rec_exp(expr);
--         rec_lex(FIN_SEQUENCE);
      else
         traiter_erreur;
      end if;
   end;
   
   procedure rec_decl is
   begin
      if lexeme_courant.nature = IDENTIFICATEUR then
         rec_affect;
         rec_lex(FIN_AFFECTATION);
         rec_lex(FIN_LIGNE);
         rec_suitedecl;
      else
         traiter_erreur;
      end if;
   end;
   
   procedure rec_affect is
      id : Pointeur_Chaine;
   begin
      if lexeme_courant.nature = IDENTIFICATEUR then
         id := lexeme_courant.chaine;
         rec_lex(IDENTIFICATEUR);
         rec_lex(AFFECTATION);
         rec_exp(expr);
         inserer(id,expr);
      else
         traiter_erreur;
      end if;
   end;
   
   procedure rec_suitedecl is
   begin
      if lexeme_courant.nature = IDENTIFICATEUR then
         rec_decl;
      elsif lexeme_courant.nature = FIN_DECLARATION then
         null;
      else 
         traiter_erreur;
      end if;
   end;
   
   
   procedure rec_exp(expr : out Ast) is
   begin
      if lexeme_courant.nature = IDENTIFICATEUR or lexeme_courant.nature = TOURNER or lexeme_courant.nature = ECLATER or lexeme_courant.nature = ZOOMER or lexeme_courant.nature = PARENTH_OUVRANTE or lexeme_courant.nature = CARRE or lexeme_courant.nature = TRIANGLE or lexeme_courant.nature = PLEIN or lexeme_courant.nature = VIDE or lexeme_courant.nature = ROND or lexeme_courant.nature = NOIR or lexeme_courant.nature = ROUGE or lexeme_courant.nature = BLEU or lexeme_courant.nature = VERT or lexeme_courant.nature = JAUNE then
         rec_motif(expr);
         rec_lex(FIN_LIGNE);
      else
         traiter_erreur;
      end if;
   end;
   
   procedure rec_motif(expr : out Ast) is
   begin
      if lexeme_courant.nature = IDENTIFICATEUR or lexeme_courant.nature = TOURNER or lexeme_courant.nature = ECLATER or lexeme_courant.nature = ZOOMER or lexeme_courant.nature = PARENTH_OUVRANTE or lexeme_courant.nature = CARRE or lexeme_courant.nature = TRIANGLE or lexeme_courant.nature = PLEIN or lexeme_courant.nature = VIDE or lexeme_courant.nature = ROND or lexeme_courant.nature = NOIR or lexeme_courant.nature = ROUGE or lexeme_courant.nature = BLEU or lexeme_courant.nature = VERT or lexeme_courant.nature = JAUNE then
         rec_m(expr);
         rec_suitecons(expr);
      else
         traiter_erreur;
      end if;
   end;
   
   procedure rec_suitecons (expr : in out Ast) is
      expr2, expr3, expr4 : Ast;
   begin
      if lexeme_courant.nature = PLUS then
         rec_lex(PLUS);
         rec_m(expr2);
         rec_lex(PLUS);
         rec_m(expr3);
         rec_lex(PLUS);
         rec_m(expr4);
         creer_operation(ASSEMBLAGE,expr,expr2,expr3,expr4,expr);
      elsif lexeme_courant.nature = PARENTH_FERMANTE or lexeme_courant.nature = FIN_LIGNE then
         null;
      else
         traiter_erreur;
      end if;
   end;
   
   procedure rec_m (expr : out Ast) is
      quad : TypeQuadrant;
	   couleur : Nature_Lexeme;
   begin
      if lexeme_courant.nature = TOURNER then
         rec_lex(TOURNER);
         rec_m(expr);
         creer_operation(ROTATION,expr,expr);

	  elsif lexeme_courant.nature = NOIR or lexeme_courant.nature = ROUGE or lexeme_courant.nature = BLEU or lexeme_courant.nature = VERT or lexeme_courant.nature = JAUNE then
		 couleur := lexeme_courant.nature;
		 rec_lex(couleur);
		 rec_m(expr);
		 if couleur = NOIR then
			creer_operation(NOIR,expr,expr);
		 elsif couleur = ROUGE then
			creer_operation(ROUGE,expr,expr);
		 elsif couleur = BLEU then
			creer_operation(BLEU,expr,expr);
		 elsif couleur = VERT then
			creer_operation(VERT,expr,expr);
		 elsif couleur = JAUNE then
			creer_operation(JAUNE,expr,expr);
		 end if;

      elsif lexeme_courant.nature = ECLATER then
         rec_lex(ECLATER);
         rec_m(expr);
         rec_quadrant(quad);
         creer_operation(ECLATEMENT,expr,quad,expr);
      elsif lexeme_courant.nature = ZOOMER then
         rec_lex(ZOOMER);
         rec_m(expr);
         rec_quadrant(quad);
         creer_operation(ZOOM,expr,quad,expr);
      elsif lexeme_courant.nature = PARENTH_OUVRANTE then
         rec_lex(PARENTH_OUVRANTE);
         rec_motif(expr);
         rec_lex(PARENTH_FERMANTE);
      elsif lexeme_courant.nature = CARRE or lexeme_courant.nature = TRIANGLE  or lexeme_courant.nature = PLEIN or lexeme_courant.nature = VIDE or lexeme_courant.nature = ROND then
         rec_primitif(expr);
      elsif lexeme_courant.nature = IDENTIFICATEUR then
         rec_idf(expr);
      else
         traiter_erreur;
      end if;
   end;

   ---------------------------------------------------------------------
   -- procedure rec_quadrant
   --
   -- reconnait un lexeme de type quadrant
   ---------------------------------------------------------------------
   procedure rec_quadrant(quad : out TypeQuadrant) is  
   begin
      if lexeme_courant.nature = NE or lexeme_courant.nature = NW or lexeme_courant.nature = SW or lexeme_courant.nature = SE then
         if lexeme_courant.nature = NE then
            quad := NE;
         elsif lexeme_courant.nature = NW then
            quad := NW;
         elsif lexeme_courant.nature = SW then
            quad := SW;
         elsif lexeme_courant.nature = SE then
            quad := SE;
         end if;
         avancer;
      else
         traiter_erreur;
      end if;
   end;

   ---------------------------------------------------------------------
   -- procedure rec_primitif
   --
   -- reconnait un lexeme de type motif primitif
   ---------------------------------------------------------------------
   procedure rec_primitif (expr : out Ast) is  
      use Type_Patchwork;
   begin
      if lexeme_courant.nature = CARRE or lexeme_courant.nature = TRIANGLE or lexeme_courant.nature = PLEIN or lexeme_courant.nature = VIDE or lexeme_courant.nature = ROND then
         if lexeme_courant.nature = CARRE then
            creer_valeur(CARRE,expr);
         elsif lexeme_courant.nature = TRIANGLE then
            creer_valeur(TRIANGLE,expr);
         elsif lexeme_courant.nature = PLEIN then
            creer_valeur(PLEIN,expr);
         elsif lexeme_courant.nature = VIDE then
            creer_valeur(VIDE,expr);
         elsif lexeme_courant.nature = ROND then
            creer_valeur(ROND,expr);
         end if;
         avancer;
      else
         traiter_erreur;
      end if;
   end;
   
   ---------------------------------------------------------------------
   -- procedure rec_idf
   --
   -- reconnait un lexeme de type identificateur
   ---------------------------------------------------------------------
   
   procedure rec_idf (expr : out Ast) is
      id : Pointeur_Chaine;
   begin
      if lexeme_courant.nature = IDENTIFICATEUR then
         id := lexeme_courant.chaine;
         rechercher(id,expr);
         avancer;
      else
         traiter_erreur;
      end if;
   end;

   ---------------------------------------------------------------------
   -- procedure rec_lex(lexeme_attendu : Nature_Lexeme)
   --
   -- reconnait un lexeme de type autre que motif primtif
   ---------------------------------------------------------------------
   procedure rec_lex(lexeme_attendu : Nature_Lexeme) is
   begin
      if lexeme_courant.nature = lexeme_attendu then
         avancer;
      else 
         traiter_erreur;
      end if;
   end;

   ---------------------------------------------------------------------
   -- procedure traiter_erreur
   --
   -- affiche un message (ou genere une exception) correspondant au type
   -- de l'erreur detectee (lexicale ou syntaxique)
   ---------------------------------------------------------------------
   procedure traiter_erreur is
      use Ada.Text_IO;
   begin
      if lexeme_courant.nature = ERREUR then
         put("Erreur lexicale");
         raise ERREUR_LEXICALE;
      else
         put("Erreur syntaxique");
         raise ERREUR_SYNTAXIQUE;
      end if;
   end;

   pragma Warnings (On, "possible infinite recursion");
   pragma Warnings (On, "Storage_Error may be raised at run time");

end Analyseur_Syntaxique;
