------------------------------------------------------------------------
-- paquetage Table_Symboles
--
-- rangement des symboles dans un tableau et recuperation
--
-- H. Saracino & G. Frumy : 20 avril 2009
--
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Arbre_Abstrait, Machine_Lexemes;
with Ada.Text_IO;
use Arbre_Abstrait, Machine_Lexemes;
use Ada.Text_IO;

package body Table_Symboles is

	type Sous_Motif;
   
	type Tab_Symboles is access Sous_Motif;
   
	type Sous_Motif is record
		Nom : Pointeur_Chaine;
		Arbre : Ast;
		Suivant : Tab_Symboles;
	end record;
   
	tab : Tab_Symboles;
   
	---------------------------------------------------------------------
	-- pre-declaration /specification des sous-programmes
	-- utilises / appeles par les procedures inserer et rechercher
	---------------------------------------------------------------------
	
	procedure Init;
	procedure creer_noeud (id : in Pointeur_Chaine ; exp : in Ast ; tab : out Tab_Symboles);
	function est_present (id : Pointeur_Chaine ; tab : Tab_Symboles) return Boolean;
	procedure ajouter_en_tete (id : in Pointeur_Chaine ; exp : in Ast ; tab : in out Tab_Symboles);
	
	---------------------------------------------------------------------
	-- realisation des procedures locales au package
	---------------------------------------------------------------------
	
	procedure Init is
	begin
		tab := new Sous_Motif;
		tab := null;
	end;
    
	procedure creer_noeud (id : in Pointeur_Chaine ; exp : in Ast ; tab : out Tab_Symboles) is
	begin
		tab := new Sous_Motif;
		tab.Nom := new string'(id.all);
		tab.Arbre := exp;
		tab.Suivant := null;
	end;
   
	function est_present (id : Pointeur_Chaine ; tab : Tab_Symboles) return Boolean is
		present : Boolean;
		parcours : Tab_Symboles;
	begin
		present := false;
		parcours := tab;
		while parcours.Suivant /= null and not present loop
			present := parcours.Nom = id;
			parcours := parcours.Suivant;
		end loop;
		return present;
	end;
   
	procedure ajouter_en_tete (id : in Pointeur_Chaine ; exp : in Ast ; tab : in out Tab_Symboles) is
		noeud : Tab_Symboles;
	begin
		creer_noeud(id,exp,noeud);
		noeud.Suivant := tab;
		tab := noeud;
	end;
   
	---------------------------------------------------------------------
	-- procedure inserer
	---------------------------------------------------------------------
	
	procedure inserer (id : in Pointeur_Chaine ; exp : in Ast) is
	begin
		if tab = null then
			creer_noeud(id,exp,tab);
		else
			if not est_present(id,tab) then
				ajouter_en_tete(id,exp,tab);
			end if;
		end if;
	end;
   
	---------------------------------------------------------------------
	-- procedure rechercher
	---------------------------------------------------------------------
	
	procedure rechercher (id : in Pointeur_Chaine ; exp : out Ast) is
		present : Boolean;
		adresse : Tab_Symboles;
	begin
		present := false;
		adresse := tab;
		
		while adresse /= null and not present loop
			present := adresse.Nom.all = id.all;
			if present then
				exp := adresse.Arbre;
			end if;
			adresse := adresse.Suivant;
		end loop;
        
	end;

end Table_Symboles;

