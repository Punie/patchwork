------------------------------------------------------------------------
-- paquetage Actions_Affichage
--
-- Recuperations des actions demandées par l'utilisateur et mise à jour
-- du motif en conséquence
--
-- H. Saracino & G. Frumy : 23 avril 2009
--
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Type_Patchwork, Affichage_Motif, Graphsimple, Construction_Motif, Arbre_Abstrait;
use Type_Patchwork, Affichage_Motif, Graphsimple, Construction_Motif, Arbre_Abstrait;

package body Actions_Affichage is
   
	type Action is (QUITTER, RESTAURER, UNDO, REDO, TOURNER, COULEUR, ECLATER, ZOOMER, ASSEMBLER, WORKZOOM, WORKDEZOOM, DORMIR);
    
	-- Type chaine de sauvegarde de l'historique
	type NoeudHistorique;
	type Historique is access NoeudHistorique;
	
	type NoeudHistorique is record
		suivant : Historique := null;
		etat : Patchwork := null;
	end record;
	
	-- Type chaine de sauvegarde pour le Zoom de Travail
	type NoeudWork_Zoom;
	type Work_Zoom is access NoeudWork_Zoom;
	
	type NoeudWork_Zoom is record
		saveNE, saveNW, saveSW, saveSE : Patchwork;
		choix_quadrant_work : TypeQuadrant;
		suivant : Work_Zoom := null;
	end record;
	
	-- Variables de l'historique et de la restauration
	hist : Historique;
	motif_save : Patchwork;
	
	-- Variable du Zoom de Travail
	work : Work_Zoom := null;
	
	-- Variables d'action
	action_courante : Action;
	action_precedente : Action := DORMIR;
	
	-- Variables des sélecteurs de quadrant, couleur, carrés primitifs..
	choix_couleur : CouleurCarre;
	motif_complet : Boolean;
	choix_quadrant : TypeQuadrant;
	choix_ne, choix_nw, choix_sw, choix_se : Patchwork;
	choix_primitif : NaturePrimitif;
	
	-- Declaration des procedures locales
	procedure recuperer_action (motif : in Patchwork);
	procedure init_historique(motif : in Patchwork);
	procedure mise_en_historique(motif : in Patchwork);
	procedure verification_tourner (motif : in Patchwork);
	procedure verification_couleur(motif : in Patchwork);
	procedure verification_eclater(motif : in Patchwork);
	procedure verification_zoomer;
	procedure verification_assembler(motif : in Patchwork);
	procedure verification_workzoom;
	procedure avancer_workzoom(motif : in Patchwork ; quad : TypeQuadrant);
	procedure work_zoomer(motif : in Patchwork ; quad : in TypeQuadrant ; motifCree : out Patchwork);
	procedure work_dezoomer(motif : in out Patchwork);
	procedure selection_bouton(x1,y1,x2,y2 : in Natural ; nom : in string);
	procedure deselection_bouton(x1,y1,x2,y2 : in Natural ; nom : in string);
	procedure selection_bouton_couleur(nom : in string);
	procedure deselection_bouton_couleur;
	procedure encadrer;
	procedure desencadrer;
	
	-- Sauvegarde du motif d'origine pour la restauration et initialisation de l'historique
	procedure recuperer_motif(motif : in Patchwork) is
	begin
		-- sauvegarde de motif_save pour action Restaurer
		motif_save := new NoeudPatchwork;
		motif_save := new NoeudPatchwork'(motif.all);
		-- sauvegarde du premier etat de l'historique
		init_historique(motif_save);
	end;
	
	-- Initialisation de l'historique
	procedure init_historique(motif : in Patchwork) is
	begin
		hist := new NoeudHistorique;
		hist.etat := new NoeudPatchwork'(motif.all);
	end;
	
	-- Mise en Historique
	procedure mise_en_historique(motif : in Patchwork) is
		nhist : Historique;
	begin
		nhist := new NoeudHistorique;
		nhist.etat := new NoeudPatchwork'(motif.all);
		nhist.suivant := hist;
		hist := nhist;
	end;
	
	-- Procedure qui détermine l'action à effectuer 
	-- (ainsi que les parametres attendus pour certaines actions)
	procedure recuperer_action (motif : in Patchwork) is
		x,y,b : Natural;
	begin
		action_precedente := action_courante;
		AttendreClicXY(x,y,b);
		-- bouton Quitter
		if x >= 576 and then x <= 704 and then y >= 32 and then y <= 96 then
			action_courante := QUITTER;
		-- bouton Restaurer
		elsif x >= 576 and then x <= 704 and then y >= 128 and then y < 160 then
			action_courante := RESTAURER;
		-- bouton Undo
		elsif x >= 576 and then x <= 704 and then y >= 160 and then y <= 192 then
			action_courante := UNDO;
		-- bouton Tourner
		elsif x >= 576 and then x <= 704 and then y >= 224 and then y <= 288 then
			action_courante := TOURNER;
			verification_tourner(motif); -- verification du champ d'application
		-- bouton Eclater
		elsif x >= 576 and then x <= 704 and then y >= 320 and then y <= 384 then
			action_courante := ECLATER;
			verification_eclater(motif); -- verification du champ d'application
		-- bouton Zoomer
		elsif x >= 576 and then x <= 704 and then y >= 416 and then y <= 480 then
			action_courante := ZOOMER;
         if estFeuille(motif) then
            action_courante := DORMIR;
         else
   			verification_zoomer; -- verification du champ d'application
         end if;
		-- bouton Noir
		elsif x >= 736 and then x <= 864 and then y >= 32 and then y <= 96 then
			action_courante := COULEUR;
			choix_couleur := NOIR;
			verification_couleur(motif); -- verification du champ d'application
		-- bouton Rouge
		elsif x >= 736 and then x <= 864 and then y >= 128 and then y <= 192 then
			action_courante := COULEUR;
			choix_couleur := ROUGE;
			verification_couleur(motif); -- verification du champ d'application
		-- bouton Bleu
		elsif x >= 736 and then x <= 864 and then y >= 224 and then y <= 288 then
			action_courante := COULEUR;
			choix_couleur := BLEU;
			verification_couleur(motif); -- verification du champ d'application
		-- bouton Vert
		elsif x >= 736 and then x <= 864 and then y >= 320 and then y <= 384 then
			action_courante := COULEUR;
			choix_couleur := VERT;
			verification_couleur(motif); -- verification du champ d'application
		-- bouton Jaune
		elsif x >= 736 and then x <= 864 and then y >= 416 and then y <= 480 then
			action_courante := COULEUR;
			choix_couleur := JAUNE;
			verification_couleur(motif); -- verification du champ d'application
		-- bouton Assembler
		elsif x >= 896 and then x <= 1024 and then y >= 32 and then y <= 96 then
			action_courante := ASSEMBLER;
			verification_assembler(motif); -- attente des elements a assembler
		-- bouton WorkZoom
		elsif x >= 896 and then x <= 1024 and then y >= 416 and then y <= 448 then
			action_courante := WORKZOOM;
			verification_workzoom; -- verification du champ d'application
		-- bouton WorkDezoom
		elsif x >= 896 and then x <= 1024 and then y > 448 and then y <= 480 then
			action_courante := WORKDEZOOM;
		-- clic hors d'un bouton
		else
			action_courante := DORMIR;
		end if;
	end;
	
	-- Attente d'un quadrant à tourner, retour à l'état DORMIR sinon
	procedure verification_tourner (motif : in Patchwork) is
		x,y,b : Natural;
	begin
		-- Etat "cliqué" du bouton tourner
		selection_bouton(576,224,704,288,"TOURNER");
		-- Décomposition en quadrants si le motif n'est pas un primitif
		if not estFeuille(motif) then
			encadrer;
		end if;
		AttendreClicXY(x,y,b);
		-- tout le motif est modifie
		if x >= 0 and then x <= 32 and then y >= 0 and then y <= 32 then
			motif_complet := true;
		-- seulement l'un des quadrants est modifie
		else
			motif_complet := false;
			-- Quadrant NE selectionne
			if x > 288 and then x < 544 and then y > 32 and then y < 288 then
				choix_quadrant := NE;
				-- cas d'un carré primitif : on considère la totalité du motif
				if estFeuille(motif) then
					motif_complet := true;
				end if;
			-- Quadrant NW selectionne
			elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
				choix_quadrant := NW;
				-- cas d'un carré primitif : on considère la totalité du motif
				if estFeuille(motif) then
					motif_complet := true;
				end if;
			-- Quadrant SW selectionne
			elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
				choix_quadrant := SW;
				-- cas d'un carré primitif : on considère la totalité du motif
				if estFeuille(motif) then
				motif_complet := true;
				end if;
			-- Quadrant SE selectionne
			elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
				choix_quadrant := SE;
				-- cas d'un carré primitif : on considère la totalité du motif
				if estFeuille(motif) then
					motif_complet := true;
				end if;
			-- retour a DORMIR si clic hors d'un quadrant
			else
				action_courante := DORMIR;
				-- Etat "non-cliqué" du bouton tourner
				deselection_bouton(576,224,704,288,"TOURNER");
				-- effacer le découpage de la fenetre du motif
				desencadrer;
			end if;
		end if;
	end;
	
	-- Attente d'un quadrant à colorier, retour à l'état DORMIR sinon
	procedure verification_couleur (motif : in Patchwork) is
		x,y,b : Natural;
	begin
		-- Etat "cliqué" du bouton adéquat
		case choix_couleur is
			when NOIR => selection_bouton_couleur("NOIR");
			when ROUGE => selection_bouton_couleur("ROUGE");
			when BLEU => selection_bouton_couleur("BLEU");
			when VERT => selection_bouton_couleur("VERT");
			when JAUNE => selection_bouton_couleur("JAUNE");
			when others => null;
		end case;
		-- Décomposition en quadrants si le motif n'est pas un primitif
		if not estFeuille(motif) then
			encadrer;
		end if;
		AttendreClicXY(x,y,b);
		-- Etat "non-cliqué" des bouton de couleur
		deselection_bouton_couleur;
		-- effacer le découpage de la fenetre du motif
		desencadrer;
		-- tout le motif est modifie
		if x >= 0 and then x <= 32 and then y >= 0 and then y <= 32 then
			motif_complet := true;
		-- seulement l'un des quadrants est modifie
		else
			motif_complet := false;
			if x > 288 and then x < 544 and then y > 32 and then y < 288 then
				choix_quadrant := NE;
			elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
				choix_quadrant := NW;
			elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
				choix_quadrant := SW;
			elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
				choix_quadrant := SE;
			-- retour a DORMIR si clic hors d'un quadrant
			else
				action_courante := DORMIR;
			end if;
		end if;
	end;
	
	-- Attente du quadrant à éclater, retour à l'état DORMIR sinon
	procedure verification_eclater (motif : in Patchwork) is
		x,y,b : Natural;
	begin
		-- Etat "cliqué" du bouton eclater
		selection_bouton(576,320,704,384,"ECLATER");
		-- Décomposition en quadrants si le motif n'est pas un primitif
		if not estFeuille(motif) then
			encadrer;
		end if;
		AttendreClicXY(x,y,b);
		-- choix du quadrant ou s'effectue l'eclatement / zoom
		if x > 288 and then x < 544 and then y > 32 and then y < 288 then
			choix_quadrant := NE;
		elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
			choix_quadrant := NW;
		elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
			choix_quadrant := SW;
		elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
			choix_quadrant := SE;
		-- retour a DORMIR si clic hors d'un quadrant
		else
			action_courante := DORMIR;
			-- Etat "non-cliqué" du bouton eclater
			deselection_bouton(576,320,704,384,"ECLATER");
			-- effacer le découpage de la fenetre du motif
			desencadrer;
		end if;
	end;
	
	-- Attente du quadrant à zoomer, retour à l'état DORMIR sinon
	procedure verification_zoomer is
		x,y,b : Natural;
	begin
		-- Etat "cliqué" du bouton zoomer
		selection_bouton(576,416,704,480,"ZOOMER");
		-- Décomposition en quadrants si le motif n'est pas un primitif
		encadrer;
		AttendreClicXY(x,y,b);
		-- choix du quadrant ou s'effectue l'eclatement / zoom
		if x > 288 and then x < 544 and then y > 32 and then y < 288 then
			choix_quadrant := NE;
		elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
			choix_quadrant := NW;
		elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
			choix_quadrant := SW;
		elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
			choix_quadrant := SE;
		-- retour a DORMIR si clic hors d'un quadrant
		else
			action_courante := DORMIR;
			-- Etat "non-cliqué" du bouton zoomer
			deselection_bouton(576,416,704,480,"ZOOMER");
			-- effacer le découpage de la fenetre du motif
			desencadrer;
		end if;
	end;
	
	-- Attente des éléments à assembler, retour à DORMIR sinon
	procedure verification_assembler (motif : in Patchwork) is
		x,y,b : Natural;
	begin
		-- Etat "cliqué" du bouton assembler
		selection_bouton(896,32,1024,96,"ASSEMBLER");
		-- Décomposition en quadrants si le motif n'est pas un primitif
		if not estFeuille(motif) then
			encadrer;
		end if;
		
		-- Affichage du motif d'aperçu et du texte indicatif
		ChangerCouleur(Noir);
		Rectangle(928,320,992,384);
		Rectangle(960,320,992,352);
		Ecrire(32,560,"Selectionnez le quadrant Nord-Est de votre assemblage.");
		
		-- Choix de l'élément NE
		AttendreClicXY(x,y,b);
		-- Selection du quadrant NE
		if x > 288 and then x < 544 and then y > 32 and then y < 288 then
			choix_ne := new NoeudPatchwork;
			-- Si le motif est primitif, choisit la totalité
			if estFeuille(motif) then
				choix_ne := new NoeudPatchwork'(hist.etat.all);
			else
				choix_ne := new NoeudPatchwork'(hist.etat.ne.all);
			end if;
		-- Selection du quadrant NW
		elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
			choix_ne := new NoeudPatchwork;
			if estFeuille(motif) then
				choix_ne := new NoeudPatchwork'(hist.etat.all);
			else         
				choix_ne := new NoeudPatchwork'(hist.etat.nw.all);
			end if;
		-- Selection du quadrant SW
		elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
			choix_ne := new NoeudPatchwork;
			if estFeuille(motif) then
				choix_ne := new NoeudPatchwork'(hist.etat.all);
			else         
				choix_ne := new NoeudPatchwork'(hist.etat.sw.all);
			end if;
		-- Selection du quadrant SE
		elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
			choix_ne := new NoeudPatchwork;
			if estFeuille(motif) then
				choix_ne := new NoeudPatchwork'(hist.etat.all);
			else
				choix_ne := new NoeudPatchwork'(hist.etat.se.all);
			end if;
		-- Selection de la totalité du motif courant
		elsif x > 0 and then x <= 32 and then y > 0 and then y <= 32 then
			choix_ne := new NoeudPatchwork;
			choix_ne := new NoeudPatchwork'(hist.etat.all);
		-- Selection des primitifs
		elsif x >= 928 and then x <= 992 and then y >= 128 and then y <= 192 then
			choix_ne := new NoeudPatchwork;
			creerPrimitif(CARRE,choix_ne);
		elsif x >= 928 and then x <= 992 and then y >= 224 and then y <= 288 then
			choix_ne := new NoeudPatchwork;
			creerPrimitif(TRIANGLE,choix_ne);
		elsif x >= 608 and then x <= 672 and then y >= 496 and then y <= 560 then
			choix_ne := new NoeudPatchwork;
			creerPrimitif(PLEIN,choix_ne);
		elsif x >= 768 and then x <= 832 and then y >= 496 and then y <= 560 then
			choix_ne := new NoeudPatchwork;
			creerPrimitif(ROND,choix_ne);
		elsif x >= 928 and then x <= 992 and then y >= 496 and then y <= 560 then
			choix_ne := new NoeudPatchwork;
			creerPrimitif(VIDE,choix_ne);
		-- retour a DORMIR si clic hors d'un quadrant
		else
			action_courante := DORMIR;
		end if;
		
		if action_courante /= DORMIR then
			
			-- Mise à jour du motif d'aperçu et du texte indicatif
			ChangerCouleur(Rouge);
			RectanglePlein(960,320,992,353);
			ChangerCouleur(Noir);
			Rectangle(928,320,992,384);
			Rectangle(928,320,959,352);
			ChangerCouleur(Blanc);
			RectanglePlein(0,550,576,575);
			ChangerCouleur(Noir);
			Ecrire(32,560,"Selectionnez le quadrant Nord-Ouest de votre assemblage.");
			
			-- Choix de l'élément NW
			AttendreClicXY(x,y,b);
			if x > 288 and then x < 544 and then y > 32 and then y < 288 then
				choix_nw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_nw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_nw := new NoeudPatchwork'(hist.etat.ne.all);
				end if;
			elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
				choix_nw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_nw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_nw := new NoeudPatchwork'(hist.etat.nw.all);
				end if;
			elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
				choix_nw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_nw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_nw := new NoeudPatchwork'(hist.etat.sw.all);
				end if;
			elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
				choix_nw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_nw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_nw := new NoeudPatchwork'(hist.etat.se.all);
				end if;
			elsif x > 0 and then x <= 32 and then y > 0 and then y <= 32 then
				choix_nw := new NoeudPatchwork;
				choix_nw := new NoeudPatchwork'(hist.etat.all);
			elsif x >= 928 and then x <= 992 and then y >= 128 and then y <= 192 then
				choix_nw := new NoeudPatchwork;
				creerPrimitif(CARRE,choix_nw);
			elsif x >= 928 and then x <= 992 and then y >= 224 and then y <= 288 then
				choix_nw := new NoeudPatchwork;
				creerPrimitif(TRIANGLE,choix_nw);
			elsif x >= 608 and then x <= 672 and then y >= 496 and then y <= 560 then
				choix_nw := new NoeudPatchwork;
				creerPrimitif(PLEIN,choix_nw);
			elsif x >= 768 and then x <= 832 and then y >= 496 and then y <= 560 then
				choix_nw := new NoeudPatchwork;
				creerPrimitif(ROND,choix_nw);
			elsif x >= 928 and then x <= 992 and then y >= 496 and then y <= 560 then
				choix_nw := new NoeudPatchwork;
				creerPrimitif(VIDE,choix_nw);
			-- retour a DORMIR si clic hors d'un quadrant
			else
				action_courante := DORMIR;
			end if;
			
		end if;
		
		if action_courante /= DORMIR then
			
			-- Mise à jour du motif d'aperçu et du texte indicatif
			ChangerCouleur(Rouge);
			RectanglePlein(928,320,960,352);
			ChangerCouleur(Noir);
			Rectangle(928,320,992,384);
			Rectangle(928,353,959,384);
			ChangerCouleur(Blanc);
			RectanglePlein(0,550,576,575);
			ChangerCouleur(Noir);
			Ecrire(32,560,"Selectionnez le quadrant Sud-Ouest de votre assemblage.");
			
			-- Choix de l'élément SW
			AttendreClicXY(x,y,b);
			if x > 288 and then x < 544 and then y > 32 and then y < 288 then
				choix_sw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_sw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_sw := new NoeudPatchwork'(hist.etat.ne.all);
				end if;
			elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
				choix_sw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_sw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_sw := new NoeudPatchwork'(hist.etat.nw.all);
				end if;
			elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
				choix_sw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_sw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_sw := new NoeudPatchwork'(hist.etat.sw.all);
				end if;
			elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
				choix_sw := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_sw := new NoeudPatchwork'(hist.etat.all);
				else
					choix_sw := new NoeudPatchwork'(hist.etat.se.all);
				end if;
			elsif x > 0 and then x <= 32 and then y > 0 and then y <= 32 then
				choix_sw := new NoeudPatchwork;
				choix_sw := new NoeudPatchwork'(hist.etat.all);
			elsif x >= 928 and then x <= 992 and then y >= 128 and then y <= 192 then
				choix_sw := new NoeudPatchwork;
				creerPrimitif(CARRE,choix_sw);
			elsif x >= 928 and then x <= 992 and then y >= 224 and then y <= 288 then
				choix_sw := new NoeudPatchwork;
				creerPrimitif(TRIANGLE,choix_sw);
			elsif x >= 608 and then x <= 672 and then y >= 496 and then y <= 560 then
				choix_sw := new NoeudPatchwork;
				creerPrimitif(PLEIN,choix_sw);
			elsif x >= 768 and then x <= 832 and then y >= 496 and then y <= 560 then
				choix_sw := new NoeudPatchwork;
				creerPrimitif(ROND,choix_sw);
			elsif x >= 928 and then x <= 992 and then y >= 496 and then y <= 560 then
				choix_sw := new NoeudPatchwork;
				creerPrimitif(VIDE,choix_sw);
			-- retour a DORMIR si clic hors d'un quadrant
			else
				action_courante := DORMIR;
			end if;
			
		end if;
		
		if action_courante /= DORMIR then
			
			-- Mise à jour du motif d'aperçu et du texte indicatif
			ChangerCouleur(Rouge);
			RectanglePlein(928,352,960,384);
			ChangerCouleur(Noir);
			Rectangle(928,320,992,384);
			Rectangle(960,353,992,384);
			ChangerCouleur(Blanc);
			RectanglePlein(0,550,576,575);
			ChangerCouleur(Noir);
			Ecrire(32,560,"Selectionnez le quadrant Sud-Est de votre assemblage.");
			
			-- Choix de l'élément SE
			AttendreClicXY(x,y,b);
			if x > 288 and then x < 544 and then y > 32 and then y < 288 then
				choix_se := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_se := new NoeudPatchwork'(hist.etat.all);
				else
					choix_se := new NoeudPatchwork'(hist.etat.ne.all);
				end if;
			elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
				choix_se := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_se := new NoeudPatchwork'(hist.etat.all);
				else
					choix_se := new NoeudPatchwork'(hist.etat.nw.all);
				end if;
			elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
				choix_se := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_se := new NoeudPatchwork'(hist.etat.all);
				else
					choix_se := new NoeudPatchwork'(hist.etat.sw.all);
				end if;
			elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
				choix_se := new NoeudPatchwork;
				if estFeuille(motif) then
					choix_se := new NoeudPatchwork'(hist.etat.all);
				else
					choix_se := new NoeudPatchwork'(hist.etat.se.all);
				end if;
			elsif x > 0 and then x <= 32 and then y > 0 and then y <= 32 then
				choix_se := new NoeudPatchwork;
				choix_se := new NoeudPatchwork'(hist.etat.all);
			elsif x >= 928 and then x <= 992 and then y >= 128 and then y <= 192 then
				choix_se := new NoeudPatchwork;
				creerPrimitif(CARRE,choix_se);
			elsif x >= 928 and then x <= 992 and then y >= 224 and then y <= 288 then
				choix_se := new NoeudPatchwork;
				creerPrimitif(TRIANGLE,choix_se);
			elsif x >= 608 and then x <= 672 and then y >= 496 and then y <= 560 then
				choix_se := new NoeudPatchwork;
				creerPrimitif(PLEIN,choix_se);
			elsif x >= 768 and then x <= 832 and then y >= 496 and then y <= 560 then
				choix_se := new NoeudPatchwork;
				creerPrimitif(ROND,choix_se);
			elsif x >= 928 and then x <= 992 and then y >= 496 and then y <= 560 then
				choix_se := new NoeudPatchwork;
				creerPrimitif(VIDE,choix_se);
			-- retour a DORMIR si clic hors d'un quadrant
			else
				action_courante := DORMIR;
			end if;
			
		end if;
		
		-- Etat "non-cliqué" du bouton assembler
		deselection_bouton(896,32,1024,96,"ASSEMBLER");
		-- effacer le découpage de la fenetre du motif
		desencadrer;
      
	end;
	
	-- Attente d'un quadrant dans lequel travailler, retour à l'état DORMIR sinon
	procedure verification_workzoom is
		x,y,b : Natural;
	begin
		AttendreClicXY(x,y,b);
		if x > 288 and then x < 544 and then y > 32 and then y < 288 then
			choix_quadrant := NE;
		elsif x > 32 and then x < 288 and then y > 32 and then y < 288 then
			choix_quadrant := NW;
		elsif x > 32 and then x < 288 and then y > 288 and then y < 544 then
			choix_quadrant := SW;
		elsif x > 288 and then x < 544 and then y > 288 and then y < 544 then
			choix_quadrant := SE;
		end if;
	end;
	
	-- Sauvegarde des assemblage successifs dans la chaine work
	procedure avancer_workzoom(motif : in Patchwork ; quad : TypeQuadrant) is
		nwork : Work_Zoom;
	begin
		nwork := new NoeudWork_Zoom;
		nwork.saveNE := new NoeudPatchwork'(motif.ne.all);
		nwork.saveNW := new NoeudPatchwork'(motif.nw.all);
		nwork.saveSW := new NoeudPatchwork'(motif.sw.all);
		nwork.saveSE := new NoeudPatchwork'(motif.se.all);
		nwork.choix_quadrant_work := quad;
		nwork.suivant := work;
		work := nwork;
	end;
	
	-- Selection du motif de travail, sauvegarde de l'assemblage et de l'indicatif quadrant du motif de travail
	procedure work_zoomer (motif : in Patchwork ; quad : in TypeQuadrant ; motifCree : out Patchwork) is
	begin
		avancer_workzoom(motif,quad);
		case work.choix_quadrant_work is
			when NE =>
				motifCree := work.saveNE;
			when NW =>
				motifCree := work.saveNW;
			when SW =>
				motifCree := work.saveSW;
			when SE =>
				motifCree := work.saveSE;
		end case;
	end;
	
	-- Retour (re-assemblage des motifs superieurs avec celui modifié)
	procedure work_dezoomer (motif : in out Patchwork) is
		motif_save : Patchwork;
	begin
		if work /= null then
			case work.choix_quadrant_work is
				when NE =>
					creerAssemblage(motif,work.saveNW,work.saveSW,work.saveSE,motif);
				when NW =>
					creerAssemblage(work.saveNE,motif,work.saveSW,work.saveSE,motif);
				when SW =>
					creerAssemblage(work.saveNE,work.saveNW,motif,work.saveSE,motif);
				when SE =>
					creerAssemblage(work.saveNE,work.saveNW,work.saveSW,motif,motif);
			end case;
			
			work := work.suivant;
			
			if work /= null then
				case work.choix_quadrant_work is
					when NE =>
						work.saveNE := motif;
					when NW =>
						work.saveNW := motif;
					when SW =>
						work.saveSW := motif;
					when SE =>
						work.saveSE := motif;
				end case;
			end if;
			
		end if;
	end;
	
	-- Etat "cliqué" du bouton sélectionné et texte d'indications
	procedure selection_bouton (x1,y1,x2,y2 : in Natural ; nom : in string) is
	begin
		ChangerCouleur(Rouge);
		RectanglePlein(x1+1,y1+1,x2,y2);
		ChangerCouleur(Noir);
		Ecrire(x1+44,y1+32,nom);
		case action_courante is
			when TOURNER =>
				Ecrire(32,560,"Selectionnez le quadrant à tourner ou la totalité du motif.");
			when ECLATER =>
				Ecrire(32,560,"Selectionnez le quadrant à eclater.");
			when ZOOMER => 
				Ecrire(32,560,"Selectionnez le quadrant à zoomer.");
			when others => 
				null;
		end case;
	end;
	
	-- Retour à l'état "non-cliqué" du bouton considéré et effacement du texte d'indications
	procedure deselection_bouton (x1,y1,x2,y2 : in Natural ; nom : in string) is
	begin
		ChangerCouleur(Blanc);
		RectanglePlein(x1+1,y1+1,x2,y2);
		RectanglePlein(927,319,993,385);
		RectanglePlein(0,550,576,575);
		ChangerCouleur(Noir);
		Ecrire(x1+44,y1+32,nom);
	end;
	
	-- Selection des boutons couleur
	procedure selection_bouton_couleur (nom : in string) is
		x1, y1 : Natural;
	begin
		x1 := 736;
		ChangerCouleur(Noir);
		Ecrire(32,560,"Selectionnez le quadrant à colorier ou la totalité du motif.");
		case choix_couleur is
			when NOIR =>
				y1 := 32;
				ChangerCouleur(Blanc);
			when ROUGE =>
				y1 := 128;
			when BLEU => 
				y1 := 224;
				ChangerCouleur(Blanc);
			when VERT =>
				y1 := 320;
			when JAUNE =>
				y1 := 416;
			when others => 
				null;
		end case;
		Ecrire(x1+55,y1+32,nom);
		ChangerCouleur(Noir);
	end;
	
	-- Désélection des boutons couleur
	procedure deselection_bouton_couleur is
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
		ChangerCouleur(Blanc);
		RectanglePlein(0,550,576,575);
		ChangerCouleur(Noir);
	end;
	
	-- Découpage du motif en quadrants pour les selections
	procedure encadrer is
	begin
		ChangerCouleur(Noir);
		Rectangle(31,31,544,544);
		Rectangle(32,32,543,543);
		Rectangle(30,30,545,545);
		Ligne(289,32,289,543);
		Ligne(288,32,288,543);
		Ligne(287,32,287,543);
		Ligne(32,288,543,288);
		Ligne(32,287,543,287);
		Ligne(32,289,543,289);
	end;
	
	-- Effacement du découpage
	procedure desencadrer is
	begin
		ChangerCouleur(Blanc);
		Rectangle(31,31,544,544);
		Rectangle(32,32,543,543);
		Rectangle(30,30,545,545);
		Ligne(289,32,289,543);
		Ligne(288,32,288,543);
		Ligne(287,32,287,543);
		Ligne(32,288,543,288);
		Ligne(32,287,543,287);
		Ligne(32,289,543,289);
	end;
	
	-- Ecran de chargement
	procedure chargement is
	begin
		ChangerCouleur(Blanc);
		RectanglePlein(32,32,544,544);
		ChangerCouleur(Noir);
		Ecrire(270,280,"Chargement...");
	end;
	
	-- Effectue la suite des actions demandées par l'utilisateur
	procedure effectuer_action (tailleV, tailleH : in Natural ; motif : in Patchwork) is
		motifCree : Patchwork;
	begin
		recuperer_action(motif);
		motifCree := motif;
		while action_courante /= QUITTER loop
			case action_courante is
				-- Action TOURNER
				when TOURNER =>
					while action_courante = TOURNER loop
						chargement;
						if motif_complet then
							if action_precedente = UNDO then
								init_historique(motifCree);
							else
								null;
							end if;
							creerRotation(motifCree,motifCree);
							afficher(motifCree, 32, 32, tailleV, tailleH);
							mise_en_historique(motifCree);
						else
							if action_precedente = UNDO then
								init_historique(motifCree);
							else
								null;
							end if;
							case choix_quadrant is
								when NE =>
									creerRotation(motifCree.ne,motifCree.ne);
								when NW =>
									creerRotation(motifCree.nw,motifCree.nw);
								when SW =>
									creerRotation(motifCree.sw,motifCree.sw);
								when SE =>
									creerRotation(motifCree.se,motifCree.se);
								when others =>
									null;
							end case;
							afficher(motifCree, 32, 32, tailleV, tailleH);
							mise_en_historique(motifCree);
						end if;
						verification_tourner(motifCree);
					end loop;
					deselection_bouton(576,224,704,288,"TOURNER");
					desencadrer;
					afficher(motifCree, 32, 32, tailleV, tailleH);
				-- Action COULEUR
				when COULEUR =>
					if motif_complet then
						if action_precedente = UNDO then
							init_historique(motifCree);
						else
							null;
						end if;
						creerColoration(motifCree,choix_couleur,motifCree);
						afficher(motifCree, 32, 32, tailleV, tailleH);
						mise_en_historique(motifCree);
					else
						if action_precedente = UNDO then
							init_historique(motifCree);
						else
							null;
						end if;
						if EstFeuille(motifCree) then
							creerColoration(motifCree,choix_couleur,motifCree);
						else
							case choix_quadrant is
								when NE =>
									creerColoration(motifCree.ne,choix_couleur,motifCree.ne);
								when NW =>
									creerColoration(motifCree.nw,choix_couleur,motifCree.nw);
								when SW =>
									creerColoration(motifCree.sw,choix_couleur,motifCree.sw);
								when SE =>
			    					creerColoration(motifCree.se,choix_couleur,motifCree.se);
								when others =>
									null;
							end case;
						end if;
						afficher(motifCree, 32, 32, tailleV, tailleH);
						mise_en_historique(motifCree);
					end if;
				-- Action ECLATER
				when ECLATER =>
					while action_courante = ECLATER loop
						chargement;
						if action_precedente = UNDO then
							init_historique(motifCree);
						else
							null;
						end if;
						creerEclatement(motifCree,choix_quadrant,motifCree);
						afficher(motifCree, 32, 32, tailleV, tailleH);
						mise_en_historique(motifCree);
						verification_eclater(motifCree);
					end loop;
					deselection_bouton(576,320,704,384,"ECLATER");
					desencadrer;
					afficher(motifCree, 32, 32, tailleV, tailleH);
				-- Action ZOOMER
				when ZOOMER =>
					while action_courante = ZOOMER loop
						chargement;
						if action_precedente = UNDO then
							init_historique(motifCree);
						else
							null;
						end if;
						creerZoom(motifCree,choix_quadrant,motifCree);
						afficher(motifCree, 32, 32, tailleV, tailleH);
						mise_en_historique(motifCree);
						if estFeuille(motifCree) then
							null;
							action_courante := DORMIR;
						else
						verification_zoomer;
						end if;
					end loop;
					deselection_bouton(576,416,704,480,"ZOOMER");
					desencadrer;
					afficher(motifCree, 32, 32, tailleV, tailleH);
				-- Action ASSEMBLER
				when ASSEMBLER =>
					chargement;
					if action_precedente = UNDO then
						init_historique(motifCree);
					else
						null;
					end if;
					creerAssemblage(choix_ne,choix_nw,choix_sw,choix_se,motifCree);
					afficher(motifCree, 32, 32, tailleV, tailleH);
					mise_en_historique(motifCree);
				-- Action WORKZOOM
				when WORKZOOM =>
					chargement;
					if action_precedente = UNDO then
						init_historique(motifCree);
					else
				  		null;
					end if;
					work_zoomer(motifCree,choix_quadrant,motifCree);
					afficher(motifCree, 32, 32, tailleV, tailleH);
					mise_en_historique(motifCree);
				when WORKDEZOOM =>
					chargement;
					if action_precedente = UNDO then
						init_historique(motifCree);
					else
				  		null;
					end if;
					work_dezoomer(motifCree);
					afficher(motifCree, 32, 32, tailleV, tailleH);
					mise_en_historique(motifCree);
				-- Action RESTAURER
				when RESTAURER =>
					chargement;
					motifCree := motif_save;
					afficher(motifCree, 32, 32, tailleV, tailleH);
					recuperer_motif(motif_save);
				-- Action UNDO
				when UNDO =>
					if hist.suivant /= null then
						chargement;
						hist := hist.suivant;
						motifCree := hist.etat;
						afficher(motifCree, 32, 32, tailleV, tailleH);
					end if;
				when DORMIR =>
					null;
				when others =>
					null;
			end case;
			recuperer_action(motifCree);
		end loop;
		Clore;
	end;
	
end Actions_Affichage;
