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
package machine_lexemes is

   type Nature_Lexeme is (
      CARRE,            -- carre
      TRIANGLE,         -- triangle
      PLEIN,            -- plein
      VIDE,             -- vide
      ROND,             -- rond
      PLUS,             -- +
      TOURNER,          -- *
      ECLATER,          -- !
      ZOOMER,           -- ?
      NE,               -- 1
      NW,               -- 2
      SW,               -- 3
      SE,               -- 4
      NOIR,             -- n
      ROUGE,            -- r
      BLEU,             -- b
      JAUNE,            -- j
      VERT,             -- v
      PARENTH_OUVRANTE, -- (
      PARENTH_FERMANTE, -- )
      IDENTIFICATEUR,   -- sequence de lettres, chiffres et '_',
                        -- ne commencant pas par un chiffre
      AFFECTATION,      -- :=
      FIN_AFFECTATION,  -- ;
      FIN_DECLARATION,  -- %
      FIN_LIGNE,        -- retour a la ligne
      FIN_SEQUENCE,     -- pseudo lexeme ajoute en fin de sequence
      ERREUR            -- lexeme inconnu
   );

   type Pointeur_Chaine is access String;

   type Lexeme is record
      nature : Nature_Lexeme;    -- nature du lexeme
      ligne : Natural;           -- numero de ligne
      colonne : Natural;         -- numero de colonne
      chaine : Pointeur_Chaine;  -- chaine de caracteres lue
   end record;

   procedure afficher(l : Lexeme);

   procedure demarrer;
   -- e.i. : indifferent
   -- e.f. : la sequence de lexemes est lue au clavier
   --        fin_de_sequence <=> lexeme_courant.nature = FIN_SEQUENCE
   --        (non fin_de_sequence) => lexeme courant est le premier
   --        lexeme de la sequence

   procedure demarrer(nom_fichier : String);
   -- e.i. : indifferent
   -- e.f. : la sequence de lexemes est lue dans le fichier designe par
   --        nom_fichier
   --        fin_de_sequence <=> lexeme_courant.nature = FIN_SEQUENCE
   --        (non fin_de_sequence) => lexeme courant est le premier
   --        lexeme de la sequence

   procedure avancer;
   -- pre-condition : la machine sequentielle est demarree
   -- e.i. : on pose i = rang du lexeme_courant :
   --        (non fin_de_sequence)
   --        et (non lexeme_courant.nature = FIN_SEQUENCE)
   -- e.f. : fin_de_sequence <=> lexeme_courant.nature = FIN_SEQUENCE
   --        (non fin_de_sequence) => lexeme_courant est le lexeme i+1

   function lexeme_courant return Lexeme;
   -- pre-condition : la machine sequentielle est demarree
   -- lexeme_courant est :
   -- . le pseudo lexeme FIN_SEQUENCE si fin_de_sequence
   -- . le pseudo lexeme ERREUR si une erreur a ete detectee
   -- . le lexeme de rang i sinon

   function fin_de_sequence return Boolean;
   -- pre-condition : la machine sequentielle est demarree
   -- fin_de_sequence vaut :
   -- . vrai si tous les lexemes de la sequence ont ete reconnus
   -- . faux sinon

   procedure arreter;
   -- e.i. : la machine sequentielle est demarree
   -- e.f. : la machine sequentielle est arretee

end machine_lexemes;
