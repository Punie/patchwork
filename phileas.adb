------------------------------------------------------------------------
-- procedure Phileas
--
-- Construction et affichage de motifs
--
-- H. Saracino & G. Frumy : 5 Avril 2009
--
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Type_Patchwork, Arbre_Abstrait, Construction_Motif, Affichage_Motif, Graphsimple, Parcours_Ast, Analyseur_Syntaxique;
with Ada.Text_IO, Ada.Command_Line, Ada.Integer_Text_Io, Actions_Affichage, Affichage_Boutons;
use Type_Patchwork, Arbre_Abstrait, Construction_Motif, Affichage_Motif, Graphsimple, Parcours_Ast, Analyseur_Syntaxique;
use Ada.Text_IO, Ada.Command_Line, Ada.Integer_Text_Io, Actions_Affichage, Affichage_Boutons;

procedure Phileas is

	expression : Ast;
	motif : Patchwork;

	tailleH, tailleV, tailleH_motif, tailleV_motif : Natural;
   
	x, y, b : Natural;
   
begin
	
	-- analyse syntaxique et construction de l'AST
	if argument_count = 0 then
		analyser(expression); 
	else
		analyser(argument(1),expression); 
	end if;
   
	construire(expression,motif); -- construction du motif
   
	recuperer_motif(motif);
	
	-- mise en place de la taille du motif et de la fenetre graphique
	tailleH_motif := 512;
	tailleV_motif := 512;
	tailleH := 576;
	tailleV := 1056;
   
	Initialiser(tailleV, tailleH);
   
	afficher_boutons;	-- affichage des boutons
	chargement; 		-- affichage de l'écran de chargement
   
	-- affichage du motif
	afficher(motif, 32, 32, tailleV_motif, tailleH_motif);
	-- démarrage de l'intéraction avec l'utilisateur
	effectuer_action(tailleV_motif, tailleH_motif, motif);
   
   
end Phileas;
