------------------------------------------------------------------------
-- paquetage machine_caracteres
--
-- sequence de caracteres
--
-- J-P. Peyrin, G. Serasset (version initiale) : janvier 1999
-- P. Habraken : 12 novembre 2002
------------------------------------------------------------------------
package machine_caracteres is

   SEQUENCE_DEJA_DEMARREE : exception;
   SEQUENCE_NON_DEMARREE : exception;

   procedure demarrer;

   procedure demarrer(nom_fichier : String);

   procedure avancer;

   function caractere_courant return Character;

   function fin_de_sequence return Boolean;

   procedure arreter;

   function numero_ligne return Positive;

   function numero_colonne return Positive;

end machine_caracteres;
