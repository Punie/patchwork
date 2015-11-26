------------------------------------------------------------------------
-- paquetage machine_lexemes
--
-- analyse lexicale d'une description de motif (patchwork)
--
-- P. Habraken : 23 octobre 2006
-- d'apres analex_motifs (A. Rasse)
--
-- A. Rasse, P. Habraken : juin et septembre 2008
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------
with machine_caracteres;
with Ada.Text_IO, Ada.Integer_Text_IO;

package body machine_lexemes is

   ---------------------------------------------------------------------

   subtype Symbole_Quadrant is Character range '1' .. '4';
   subtype Symbole_Couleur is Character range 'B' .. 'V';

   lexeme_en_cours : Lexeme;

   function est_separateur(c : Character) return Boolean;
   function est_lettre(c : Character) return Boolean;
   function est_chiffre(c : Character) return Boolean;
   function est_symbole(c : Character) return Boolean;
   function est_couleur(c : Character) return Boolean;
   function est_fin_ligne(c : Character) return Boolean;
   function est_carre(chaine : String) return Boolean;
   function est_triangle(chaine : String) return Boolean;
   function est_plein(chaine : String) return Boolean;
   function est_vide(chaine : String) return Boolean;
   function est_rond(chaine : String) return Boolean;
   function est_quadrant(c : Character) return Boolean;
   function quadrant(symbole : Symbole_Quadrant) return Nature_Lexeme;
   function couleur(symbole : Symbole_Couleur) return Nature_Lexeme;
   procedure reconnaitre_lexeme;

   ---------------------------------------------------------------------

   procedure demarrer is
      use Ada.Text_IO;
   begin
      put("> ");
      demarrer("");
   end demarrer;

   ---------------------------------------------------------------------

   procedure demarrer(nom_fichier : String) is
   begin
      machine_caracteres.demarrer(nom_fichier);
      avancer;
   end demarrer;

   ---------------------------------------------------------------------

   procedure avancer is
   begin
      reconnaitre_lexeme;
   end avancer;

   ---------------------------------------------------------------------

   function lexeme_courant return Lexeme is
   begin
      return lexeme_en_cours;
   end lexeme_courant;

   ---------------------------------------------------------------------

   function fin_de_sequence return Boolean is
   begin
      return lexeme_en_cours.nature = FIN_SEQUENCE;
   end fin_de_sequence;

   ---------------------------------------------------------------------

   procedure arreter is
   begin
      machine_caracteres.arreter;
   end arreter;

   ---------------------------------------------------------------------

   procedure reconnaitre_lexeme is
      type Etat_Automate is (
         INIT, MOT, AFFECTATION, ERREUR, FIN
      );
      etat : Etat_Automate := INIT;
      function pos(c : Character) return Natural is
      begin
         return Character'pos(c);
      end;
      use machine_caracteres;
   begin
      loop
         case etat is

            when INIT =>
               if machine_caracteres.fin_de_sequence then
                  lexeme_en_cours.nature := FIN_SEQUENCE;
                  etat := FIN;
               else
                  if est_separateur(caractere_courant) then
                     etat := INIT;
                  
                  elsif est_lettre(caractere_courant) then
                     if est_couleur(caractere_courant) then
						lexeme_en_cours.ligne := numero_ligne;
						lexeme_en_cours.colonne := numero_colonne;
						lexeme_en_cours.chaine := 
                                    new String'("" & caractere_courant);
						lexeme_en_cours.nature := 
                                             couleur(caractere_courant);
						etat := FIN;
					 else
						lexeme_en_cours.nature := IDENTIFICATEUR;
						lexeme_en_cours.ligne := numero_ligne;
						lexeme_en_cours.colonne := numero_colonne;
						lexeme_en_cours.chaine :=
                                    new String'("" & caractere_courant);
						etat := MOT;
					 end if;
					 
		          elsif est_quadrant(caractere_courant) then
                     lexeme_en_cours.ligne := numero_ligne;
                     lexeme_en_cours.colonne := numero_colonne;
                     lexeme_en_cours.chaine :=
                                    new String'("" & caractere_courant);
                     lexeme_en_cours.nature :=
                                            quadrant(caractere_courant);
                     etat := FIN;
                  
                  elsif est_symbole(caractere_courant) then
                     lexeme_en_cours.ligne := numero_ligne;
                     lexeme_en_cours.colonne := numero_colonne;
                     lexeme_en_cours.chaine :=
                        new String'("" & caractere_courant);
                     case caractere_courant is
                        when '+' =>
                           lexeme_en_cours.nature := PLUS;
                           etat := FIN;

                        when '!' =>
                           lexeme_en_cours.nature := ECLATER;
                           etat := FIN;

                        when '?' =>
                           lexeme_en_cours.nature := ZOOMER;
                           etat := FIN;

                        when '*' =>
                           lexeme_en_cours.nature := TOURNER;
                           etat := FIN;

                        when '(' =>
                           lexeme_en_cours.nature := PARENTH_OUVRANTE;
                           etat := FIN;

                        when ')' =>
                           lexeme_en_cours.nature := PARENTH_FERMANTE;
                           etat := FIN;
                           
                        when ';' =>
                           lexeme_en_cours.nature := FIN_AFFECTATION;
                           etat := FIN;

                        when '%' =>
                           lexeme_en_cours.nature := FIN_DECLARATION;
                           etat := FIN;
                     
                        when ':' =>
                           lexeme_en_cours.nature := AFFECTATION;
                           etat := AFFECTATION;
                     
                        when others =>
                           null;
                     end case;

                  elsif est_fin_ligne(caractere_courant) then
                     lexeme_en_cours.nature := FIN_LIGNE;
                     lexeme_en_cours.ligne := numero_ligne;
                     lexeme_en_cours.colonne := numero_colonne;
                     etat := FIN;

                  else
                     lexeme_en_cours.nature := ERREUR;
                     lexeme_en_cours.ligne := numero_ligne;
                     lexeme_en_cours.colonne := numero_colonne;
                     lexeme_en_cours.chaine :=
                        new String'("" & caractere_courant);
                     etat := ERREUR;
                  end if;
                  machine_caracteres.avancer;
               end if;

            when MOT =>
               if not machine_caracteres.fin_de_sequence
                  and then (est_lettre(caractere_courant)
                            or est_chiffre(caractere_courant)) then

                  lexeme_en_cours.chaine :=
                                  new String'(lexeme_en_cours.chaine.all
                                              & caractere_courant);
                  etat := MOT;
                  machine_caracteres.avancer;
                  
               else
                  if est_carre(lexeme_en_cours.chaine.all) then
                     lexeme_en_cours.nature := CARRE;
                  elsif est_triangle(lexeme_en_cours.chaine.all) then
                     lexeme_en_cours.nature := TRIANGLE;
                  elsif est_plein(lexeme_en_cours.chaine.all) then
                     lexeme_en_cours.nature := PLEIN;
                  elsif est_vide(lexeme_en_cours.chaine.all) then
                     lexeme_en_cours.nature := VIDE;
                  elsif est_rond(lexeme_en_cours.chaine.all) then
                     lexeme_en_cours.nature := ROND;
                  else
                     null;
                  end if;
                  etat := FIN;
               end if;

            when AFFECTATION =>
               if not machine_caracteres.fin_de_sequence
                  and then caractere_courant = '=' then
                  lexeme_en_cours.chaine :=
                                  new String'(lexeme_en_cours.chaine.all
                                              & caractere_courant);
                  machine_caracteres.avancer;
                  
               else
                  lexeme_en_cours.nature := ERREUR;
                  lexeme_en_cours.chaine :=
                                  new String'(lexeme_en_cours.chaine.all
                                              & caractere_courant);
               end if;
               etat := FIN;

            when ERREUR =>
               if machine_caracteres.fin_de_sequence
                  or else (est_separateur(caractere_courant)
                           or est_lettre(caractere_courant)
                           or est_symbole(caractere_courant)
                           or est_fin_ligne(caractere_courant)) then
                  etat := FIN;

               else
                  lexeme_en_cours.chaine :=
                     new String'(lexeme_en_cours.chaine.all
                                 & caractere_courant);
                  etat := ERREUR;
                  machine_caracteres.avancer;
               end if;

            when FIN =>
               null;

         end case;
         exit when etat = FIN;
      end loop;
   end;

   ---------------------------------------------------------------------

   function est_separateur(c : Character) return Boolean is
   begin
      return c = ' ' or c = Ascii.HT;
   end;

   ---------------------------------------------------------------------

   function est_lettre(c : Character) return Boolean is
   begin
      return c in 'a' .. 'z' or c in 'A' .. 'Z' or c = '_';
   end;

   ---------------------------------------------------------------------

   function est_chiffre(c : Character) return Boolean is
   begin
      return c in '0' .. '9';
   end;

   ---------------------------------------------------------------------

   function est_symbole(c : Character) return Boolean is
   begin
      case c is
         when '+' | '!' | '?' | '*' | '(' | ')' | ':' | '%' | ';' =>
            return TRUE;

         when others =>
            return FALSE;
      end case;
   end;
      
   ---------------------------------------------------------------------
   
   function est_couleur(c : Character) return Boolean is
   begin
      case c is
         when 'N' | 'R' | 'B' | 'J' | 'V' =>
            return TRUE;

         when others =>
            return FALSE;
      end case;
   end;
   
   ---------------------------------------------------------------------

   function est_fin_ligne(c : Character) return Boolean is
   begin
      return c = Ascii.LF or c = Ascii.CR;
   end;

   ---------------------------------------------------------------------

   function est_carre(chaine : String) return Boolean is
      carre : constant String := "carre";
   begin
      return chaine'length = carre'length and then chaine = carre;
   end;

   ---------------------------------------------------------------------

   function est_triangle(chaine : String) return Boolean is
      triangle : constant String := "triangle";
   begin
      return chaine'length = triangle'length and then chaine = triangle;
   end;
   
   ---------------------------------------------------------------------
   
   function est_plein(chaine : String) return Boolean is
      plein : constant String := "plein";
   begin
      return chaine'length = plein'length and then chaine = plein;
   end;
   
   ---------------------------------------------------------------------
   
   function est_vide(chaine : String) return Boolean is
      vide : constant String := "vide";
   begin
      return chaine'length = vide'length and then chaine = vide;
   end;
   
   ---------------------------------------------------------------------
   
   function est_rond(chaine : String) return Boolean is
      rond : constant String := "rond";
   begin
      return chaine'length = rond'length and then chaine = rond;
   end;
   
   ---------------------------------------------------------------------

   function est_quadrant(c : Character) return Boolean is
   begin
      return c in Symbole_Quadrant;
   end;

   ---------------------------------------------------------------------

   function quadrant(symbole : Symbole_Quadrant) return Nature_Lexeme is
   begin
      case symbole is
	      when '1' =>
			  return NE ;
	      when '2' =>
			  return NW ;
	      when '3' =>
			  return SW ;
		   when others =>
			  return SE ;
		end case ;
   end;
   
   ---------------------------------------------------------------------
   
   function couleur(symbole : Symbole_Couleur) return Nature_Lexeme is
   begin
      case symbole is
	      when 'R' =>
			  return ROUGE ;
	      when 'B' =>
			  return BLEU ;
		   when 'J' =>
			  return JAUNE ;
         when 'V' =>
			  return VERT ;
         when others =>
			  return NOIR ;
		end case ;
   end;

   ---------------------------------------------------------------------

   procedure afficher(l : Lexeme) is
   use Ada.Text_IO, Ada.Integer_Text_IO;
      TAB_NATURE : constant Count := col;
      TAB_LIGNE_COLONNE : constant Count := TAB_NATURE + 17;
      TAB_CHAINE : constant Count := TAB_LIGNE_COLONNE + 10;
      TAB_DESCRIPTION : constant Count := TAB_CHAINE + 10;
   begin
      put(Nature_Lexeme'image(l.nature));
      case l.nature is
         when FIN_SEQUENCE =>
            null;
         when others =>
            if col < TAB_LIGNE_COLONNE then
               set_col(TAB_LIGNE_COLONNE);
            else
               set_col(col + 1);
            end if;
            put(l.ligne, 1);
            put(':');
            put(l.colonne, 1);
            case l.nature is
               when FIN_LIGNE =>
                  null;
               when others =>
                  if col < TAB_CHAINE then
                     set_col(TAB_CHAINE);
                  else
                     set_col(col + 1);
                  end if;
                  put(l.chaine.all);
                  if col < TAB_DESCRIPTION then
                     set_col(TAB_DESCRIPTION);
                  else
                     set_col(col + 1);
                  end if;
            end case;
      end case;
   end afficher;

   ---------------------------------------------------------------------

   use Ada.Text_IO;
begin
   put("Patchwork : Machine_Lexemes. ");
   put_line("Copyright UJF - UFR IMAG.");
end machine_lexemes;
