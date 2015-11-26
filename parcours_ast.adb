------------------------------------------------------------------------
-- paquetage Type_Patchwork
--
-- Description d'un motif
--
-- H. Saracino : 2 avril 2009
--
-- 
-- langage de motifs representes sous forme de quadtree
------------------------------------------------------------------------

with Ada.Text_IO;
with Arbre_Abstrait;
with Type_Patchwork;
with Construction_Motif;

package body Parcours_Ast is
   
   use Ada.Text_IO;
   use Arbre_Abstrait;
   use Type_Patchwork;
   use Construction_Motif;
   
   procedure afficher(expr : Ast ; notation : OrdreAst := PREFIXE) is
   begin
      put_line("Coucou, je vais faire un Patchwork");
   end afficher;
   
   
   procedure construire(expr : Ast ; motif : out Patchwork) is
      sousmotif, smne, smnw, smsw, smse : Patchwork;
   begin
      if expr.nature = VALEUR then
         creerPrimitif(expr.valeur,motif);
      else
         if expr.operateur = ROTATION then
            construire(expr.ne,sousmotif);
            creerRotation(sousmotif,motif);
		   elsif expr.operateur = NOIR then
			   construire(expr.ne,sousmotif);
   			creerColoration(sousmotif,NOIR,motif);
         elsif expr.operateur = ROUGE then
			   construire(expr.ne,sousmotif);
   			creerColoration(sousmotif,ROUGE,motif);
         elsif expr.operateur = BLEU then
		   	construire(expr.ne,sousmotif);
			   creerColoration(sousmotif,BLEU,motif);
         elsif expr.operateur = VERT then
			   construire(expr.ne,sousmotif);
   			creerColoration(sousmotif,VERT,motif);
         elsif expr.operateur = JAUNE then
			   construire(expr.ne,sousmotif);
   			creerColoration(sousmotif,JAUNE,motif);
         elsif expr.operateur = ECLATEMENT then
            construire(expr.ne,sousmotif);
            creerEclatement(sousmotif,expr.quadrant,motif);
         elsif expr.operateur = ZOOM then
            construire(expr.ne,sousmotif);
            creerZoom(sousmotif,expr.quadrant,motif);
         elsif expr.operateur = ASSEMBLAGE then
            construire(expr.ne,smne);
            construire(expr.nw,smnw);
            construire(expr.sw,smsw);
            construire(expr.se,smse);
            creerAssemblage(smne,smnw,smsw,smse,motif);
         end if;
      end if;
      
      
   end construire;

end Parcours_Ast;


