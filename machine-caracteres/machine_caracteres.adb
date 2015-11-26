------------------------------------------------------------------------
-- paquetage machine_caracteres
--
-- sequence de caracteres
--
-- J-P. Peyrin, G. Serasset (version initiale) : janvier 1999
-- P. Habraken : 12 novembre 2002
------------------------------------------------------------------------
with Ada.Text_IO; 

package body machine_caracteres is

use Ada.Text_IO;

   ---------------------------------------------------------------------

   fichier : File_Type;
   console : Boolean;
   active : Boolean;
   dernier_car_lu : Boolean;
   fin : Boolean;
   caractere_lu : Character;
   no_ligne, no_colonne : Positive;

   ---------------------------------------------------------------------

   procedure demarrer is
   begin
      demarrer("");
   end demarrer;

   ---------------------------------------------------------------------

   procedure demarrer(nom_fichier : in String) is
   -- selon EOF, EOL
   --    EOF                : { le fichier est vide ou ne contient
   --                           qu'une ligne vide unique }
   --                         fin <- vrai
   --    non EOF et EOL     : { le fichier debute par une ligne vide et
   --                           contient deux lignes au moins }
   --                         caractere_lu <- LF
   --                         passer a la ligne suivante
   --                         dernier_car_lu <- faux
   --                         fin <- faux
   --    non EOF et non EOL : { le fichier contient un caractere au
   --                           moins }
   --                         lire(caractere_lu)
   --                         dernier_car_lu <- faux
   --                         fin <- faux
   begin
      if active then
         raise SEQUENCE_DEJA_DEMARREE;
      end if;
      active := true;
      if nom_fichier'length = 0 then
         console := true;
      else
         console := false;
         open(fichier, IN_FILE, nom_fichier);
	      set_input(fichier);
      end if;
      if end_of_file then
         fin := true;
      else
         dernier_car_lu := false;
         fin := false;
         if end_of_line then
            caractere_lu := Ascii.LF;
         else
            get(caractere_lu); 
         end if;        
         no_ligne := 1;
         no_colonne := 1;
      end if;
   end demarrer;

   ---------------------------------------------------------------------

   procedure avancer is
   -- si dernier_car_lu alors
   --    { la fin de fichier a ete atteinte lors du precedent appel a
   --      avancer }
   --    fin <- vrai
   -- sinon
   --    selon EOF, EOL
   --       EOF                : { la fin de fichier est atteinte, il
   --                              n'y a plus de caracteres a lire }
   --                            caractere_lu <- LF
   --                            dernier_car_lu <- vrai
   --       non EOF et EOL     : { une fin de ligne a ete atteinte mais
   --                              pas la fin de fichier }
   --                            caractere_lu <- LF
   --                            passer a la ligne suivante
   --       non EOF et non EOL : { il reste un caractere a lire au
   --                              moins }
   --                            lire(caractere_lu)
   begin
      if not active then
         raise SEQUENCE_NON_DEMARREE;
      end if;
      if dernier_car_lu then
         fin := true;
      else
         if caractere_lu = Ascii.LF then
            skip_line;
            no_ligne := no_ligne + 1;
            no_colonne := 1;
         else
            no_colonne := no_colonne + 1;
         end if;
         if end_of_line then
            caractere_lu := Ascii.LF;
            if end_of_file then
               dernier_car_lu := true;
            end if;
         else
            get(caractere_lu);
         end if;
      end if;
   end avancer;

   ---------------------------------------------------------------------

   function caractere_courant return Character is
   begin
      if not active then
         raise SEQUENCE_NON_DEMARREE;
      end if;
      return caractere_lu;
   end caractere_courant;

   ---------------------------------------------------------------------

   function fin_de_sequence return Boolean is
   begin
      if not active then
         raise SEQUENCE_NON_DEMARREE;
      end if;
      return fin;
   end fin_de_sequence;

   ---------------------------------------------------------------------

   procedure arreter is
   begin
      if not active then
         raise SEQUENCE_NON_DEMARREE;
      end if;
      active := false;
      if not console then
         close(fichier);
      end if;
   end arreter;

   ---------------------------------------------------------------------

   function numero_ligne return Positive is
   begin
      return no_ligne;
   end numero_ligne;

   ---------------------------------------------------------------------

   function numero_colonne return Positive is
   begin
      return no_colonne;
   end numero_colonne;

   ---------------------------------------------------------------------

begin
   put("Patchwork : Machine_Caracteres. ");
   put_line("Copyright UJF - UFR IMAG.");
end machine_caracteres;
