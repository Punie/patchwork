------------------------------------------------------------------------
-- paquetage Affichage_Boutons
--
-- Affichage des boutons de l'interface graphique
--
-- H. Saracino & G. Frumy : 23 avril 2009
--
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Graphsimple, Construction_Motif, Affichage_Motif, Type_Patchwork;
use Graphsimple, Construction_Motif, Affichage_Motif, Type_Patchwork;
	
package body Affichage_Boutons is
	
	procedure afficher_quitter;
	procedure afficher_restaurer_undo;
	procedure afficher_tourner;
	procedure afficher_eclater;
	procedure afficher_zoomer;
	procedure afficher_couleurs;
	procedure afficher_assembler;
	procedure afficher_workzoom;
	procedure afficher_coin;
	
	
	c, t, r, p, v : Patchwork;
	primitif : NaturePrimitif;
	
	procedure afficher_quitter is
	begin
		Rectangle(576,32,704,96);
		Ecrire(620,64,"QUITTER");
	end;
	
	procedure afficher_restaurer_undo is
	begin
		Rectangle(576,128,704,192);
		Ecrire(615,150,"RESTAURER");
		Ligne(576,160,704,160);
		Ecrire(630,180,"UNDO");
	end;
	
	procedure afficher_tourner is
	begin
		Rectangle(576,224,704,288);
		Ecrire(620,256,"TOURNER");
	end;
	
	procedure afficher_eclater is
	begin
		Rectangle(576,320,704,384);
		Ecrire(620,352,"ECLATER");
	end;
	
	procedure afficher_zoomer is
	begin
		Rectangle(576,416,704,480);
		Ecrire(620,448,"ZOOMER");
	end;
	
	procedure afficher_couleurs is
	begin
		ChangerCouleur(Noir);
		RectanglePlein(736,32,864,96);
		ChangerCouleur(Rouge);
		RectanglePlein(736,128,864,192);
		ChangerCouleur(Bleu);
		RectanglePlein(736,224,864,288);
		ChangerCouleur(Vert);
		RectanglePlein(736,320,864,384);
		ChangerCouleur(Jaune);
		RectanglePlein(736,416,864,480);
		ChangerCouleur(Noir);
	end;
	
	procedure afficher_assembler is
	begin
		Rectangle(896,32,1024,96);
		Ecrire(940,64,"ASSEMBLER");
		primitif := CARRE;
		creerPrimitif(primitif,c);
		primitif := TRIANGLE;
		creerPrimitif(primitif,t);
		primitif := ROND;
		creerPrimitif(primitif,r);
		primitif := PLEIN;
		creerPrimitif(primitif,p);
		primitif := VIDE;
		creerPrimitif(primitif,v);
		afficher(c,928,128,64,64);
		afficher(t,928,224,64,64);
		afficher(p,608,496,64,64);
		afficher(r,768,496,64,64);
		ChangerCouleur(Noir);
		Rectangle(928,496,992,560);
	end;
	
	procedure afficher_workzoom is
	begin
		ChangerCouleur(Noir);
		Rectangle(896,416,1024,480);
		Ecrire(920,436,"ZOOM DE TRAVAIL");
		Ligne(896,448,1024,448);
		Ecrire(945,468,"RETOUR");
	end;
	
	procedure afficher_coin is
	begin
		ChangerCouleur(Noir);
		RectanglePlein(0,0,32,32);
		ChangerCouleur(Blanc);
		Ecrire(9,20,"ALL");
	end;
	
	procedure afficher_boutons is
	begin
		ChangerCouleur(Noir);
		afficher_quitter;
		afficher_restaurer_undo;
		afficher_tourner;
		afficher_eclater;
		afficher_zoomer;
		afficher_couleurs;
		afficher_assembler;
		afficher_workzoom;
		afficher_coin;
		-- Ecrire(20,20,"Thomas my dear baby love"); -- message subliminal 
   end;

end Affichage_Boutons;
