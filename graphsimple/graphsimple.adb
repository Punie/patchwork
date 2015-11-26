------------------------------------------------------------------------
--
-- REALISATION ADA DE GRAPHSIMPLE
--
-- graphsimple.adb
--
-- P.Habraken 13/04/2006 : creation (d'apres graphsimple.c)
--
-- modifie par P.Habraken le 14/05/2007 :
-- - Ajout d'un parametre permettant de recuperer le numero de bouton
--   (AttendreClicXY, AttendreLacherXY)
-- - Ajout a la procedure AttendreTaper d'un parametre permettant de
--   recuperer le caractere correspondant a la touche tapee
------------------------------------------------------------------------
with graphlib_w2;
with Interfaces.C;
with Interfaces.C.Strings;

with Ada.Text_IO;

package body graphsimple is

use graphlib_w2;
use Interfaces.C;

   fenetreCourante : aliased Fenetre;

   XFen, YFen : Positive;     -- dimensions de la fenetre
   XCorner, YCorner : Natural;

   -- Change la couleur utilisee pour les traces
   procedure ChangerCouleur(c : Couleur) is
   begin
      case c is
         when Rouge =>
            set_red(fenetreCourante); 
         when Bleu =>
            set_blue(fenetreCourante); 
         when Vert =>
            set_green(fenetreCourante); 
         when Jaune =>
            set_yellow(fenetreCourante); 
         when Blanc =>
            set_white(fenetreCourante);
         when others =>
            set_black(fenetreCourante); 
      end case;
   end;

   -- Initialise la fenetre graphique
   procedure Initialiser(x, y : Positive) is
   begin
      -- if fenetreCourante /= NULL then
      --    fprintf(stderr, "Initialiser : erreur fenetre deja ouverte\n");
      --    exit(1);
      -- end if;

      if x < 0 or x > XSize then
       	XFen := XSize;
      else
       	XFen := x;
      end if;
      if y < 0 or y > XSize then
       	YFen := YSize;
      else
       	YFen := y;
      end if;
      XCorner := 10;
      YCorner := 10;
      gr_inits_2(fenetreCourante'access, int(XCorner), int(YCorner),
                                         int(XFen), int(YFen));
   end;

   -- Clot la fenetre graphique
   procedure Clore is
   begin
   	gr_close(fenetreCourante'access);
   end;
   
   -- Efface la fenetre graphique
   procedure Effacer is
   begin
   	clear_screen(fenetreCourante);
   end;

   -- Suspend l'execution du programme pendant un temps tps donne en ms
   procedure AttendreDelai(tps : Natural) is
   begin
      delai(long(tps));
   end;
   
   -- Suspend l'execution du programme jusqu'a la frappe d'une touche sur
   -- le clavier
   procedure AttendreTaper(c : out Character) is
      touche : Character;
   use Ada.Text_IO;
   begin
      put("-- Taper sur une touche (pointeur dans la fenetre) --");
      flush;
      touche := Character(consilent(fenetreCourante));
      while touche = ASCII.NUL loop
         AttendreDelai(10);
         touche := Character(consilent(fenetreCourante));
      end loop;
      c := touche;
      new_line;
   end;
   
   -- Si une touche du clavier vient d'etre enfoncee, retourne le caractere
   -- correspondant, sinon retourne le caractere null (\0)
   function Touche return Character is
      c : Character;
   use Ada.Text_IO;
   begin
      flush;
      c := Character(consilent(fenetreCourante));
      return c;
   end;

   -- Retourne la valeur vrai si une touche du clavier a ete enfonce,
   -- faux sinon
   function TestClavier return Boolean is
      t : int;
   begin
      t := cstat(fenetreCourante);
      return t = 1;
   end;

   -- Suspend l'execution du programme jusqu'a un appui du bouton de la
   -- souris
   procedure AttendreClic is
   use Ada.Text_IO;
   begin
      put("-- Cliquer --");
      flush;
      cliquer(fenetreCourante);
      new_line;
   end;

   -- Suspend l'exe'cution du programme jusqu'a un relachement du bouton de
   -- la souris
   procedure AttendreLacher is
   use Ada.Text_IO;
   begin
      put("-- Lacher --");
      flush;
      lacher(fenetreCourante);
      new_line;
   end;

   -- Attend un clic de la souris et recupere ses cordonnees en mettant a
   -- jour les valeurs designees par x et y
   procedure AttendreClicXY(x, y, b : out Natural) is
      xx, yy, bb : aliased int;
   use Ada.Text_IO;
   begin
      put("-- Cliquer --");
      flush;
      cliquer_xy(fenetreCourante, xx'access, yy'access, bb'access);
      x := Natural(xx); y := Natural(yy); b := Natural(bb);
      new_line;
   end;

   -- Attend un relachement de la souris et recupere ses coordonnees en
   -- mettant a jour les valeurs designees par x et y
   procedure AttendreLacherXY(x, y, b : out Natural) is
      xx, yy, bb : aliased int;
   use Ada.Text_IO;
   begin
      put("-- Lacher --");
      flush;
      lacher_xy(fenetreCourante, xx'access, yy'access, bb'access);
      x := Natural(xx); y := Natural(yy); b := Natural(bb);
      new_line;
   end;

   -- Attend un deplacement de la souris et recupere ses coordonnees en
   -- mettant a jour les valeurs designees par x et y
   procedure AttendreDeplacementXY(x, y : out Natural) is
      xx, yy : aliased int;
   begin
      glisser_xy(fenetreCourante, xx'access, yy'access);
      x := Natural(xx); y := Natural(yy);
   end;

   -- Retourne le numero de bouton si un bouton de la souris a ete enfonce,
   -- 0 sinon
   function BoutonAppuye return Natural is
   begin
      return Natural(bouton(fenetreCourante));
   end;

   -- Retourne le numero de bouton si un bouton de la souris a ete relache,
   -- 0 sinon
   function BoutonRelache return Natural is
   begin
      return Natural(bouton_relache(fenetreCourante));
   end;

   -- Retourne un numero de bouton (1, 2 ou 3) si la souris vient d'etre
   -- deplacee l'un des boutons etant appuye, 0 sinon
   function BoutonGlisse return Natural is
   begin
      return Natural(bouton_glisse(fenetreCourante));
   end;

   -- Trace une ligne entre les points (x1, y1) et (x2, y2)
   procedure Ligne(x1, y1, x2, y2 : Natural) is
   begin
      line(fenetreCourante, int(x1), int(y1), int(x2), int(y2));
   end;

   -- Efface une ligne entre les points (x1, y1) et (x2, y2)
   procedure SuppLigne(x1, y1, x2, y2 : Natural) is
   begin
      line_off(fenetreCourante, int(x1), int(y1), int(x2), int(y2));
   end;

   -- Trace un cercle de centre (x, y) et de rayon r
   procedure Cercle(x, y, r : Natural) is
   begin
      circle(fenetreCourante, int(x), int(y), int(r));
   end;

   -- Efface un cercle de centre (x, y) et de rayon r
   procedure SuppCercle(x, y, r : Natural) is
   begin
      circle_off(fenetreCourante, int(x), int(y), int(r));
   end;

   -- Remplit un cercle de centre (x, y) et de rayon r
   procedure CerclePlein(x, y, r : Natural) is
   begin
      fill_circle(fenetreCourante, int(x), int(y), int(r));
   end;
   
   -- Remplit un quart de cercle de centre (x, y) et de rayon r
   procedure QuartCerclePleinEst(x, y, r : Natural) is
   begin
      fill_quarter_circle_est(fenetreCourante, int(x), int(y), int(r));
   end;

   -- Remplit un quart de cercle de centre (x, y) et de rayon r
   procedure QuartCerclePleinNord(x, y, r : Natural) is
   begin
      fill_quarter_circle_nord(fenetreCourante, int(x), int(y), int(r));
   end;

   -- Remplit un quart de cercle de centre (x, y) et de rayon r
   procedure QuartCerclePleinOuest(x, y, r : Natural) is
   begin
      fill_quarter_circle_ouest(fenetreCourante, int(x), int(y), int(r));
   end;

   -- Remplit un quart de cercle de centre (x, y) et de rayon r
   procedure QuartCerclePleinSud(x, y, r : Natural) is
   begin
      fill_quarter_circle_sud(fenetreCourante, int(x), int(y), int(r));
   end;

   -- Trace un rectangle dont les extremites d'une de ses diagonales sont
   -- (x1, y1) et (x2, y2)
   procedure Rectangle(x1, y1, x2, y2 : Natural) is
   begin
      rectangle(fenetreCourante, int(x1), int(y1), int(x2), int(y2));
   end;

   -- Efface un rectangle dont les extremites d'une de ses diagonales sont
   -- (x1, y1) et (x2, y2)
   procedure SuppRectangle(x1, y1, x2, y2 : Natural) is
   begin
      rectangle_off(fenetreCourante, int(x1), int(y1),
                                     int(x2), int(y2));
   end;

   -- Remplit un rectangle dont les extremites d'une de ses diagonales sont
   -- (x1, y1) et (x2, y2)
   procedure RectanglePlein(x1, y1, x2, y2 : Natural) is
   begin
      fill_rectangle(fenetreCourante, int(x1), int(y1),
                                      int(x2), int(y2));
   end;

   -- Trace une ellipse de centre (x, y) et de rayons rx et ry
   procedure Ellipse(x, y, rx, ry : Natural) is
   begin
      ellipse(fenetreCourante, int(x), int(y), int(rx), int(ry));
   end;

   -- Efface une ellipse de centre (x, y) et de rayons rx et ry
   procedure SuppEllipse(x, y, rx, ry : Natural) is
   begin
      ellipse_off(fenetreCourante, int(x), int(y), int(rx), int(ry));
   end;

   -- Remplit une ellipse de centre (x, y) et de rayons rx et ry
   procedure EllipsePleine(x, y, rx, ry : Natural) is
   begin
      fill_ellipse(fenetreCourante, int(x), int(y), int(rx), int(ry));
   end;

   -- Trace un triangle dont les sommets sont les points (x1, y1),
   -- (x2, y2) et (x3, y3)
   procedure Triangle(x1, y1, x2, y2, x3, y3 : Natural) is
   begin
      line(fenetreCourante, int(x1), int(y1), int(x2), int(y2));
      line(fenetreCourante, int(x2), int(y2), int(x3), int(y3));
      line(fenetreCourante, int(x3), int(y3), int(x1), int(y1));
   end;

   -- Efface un triangle dont les sommets sont les points (x1, y1),
   -- (x2, y2) et (x3, y3)
   procedure SuppTriangle(x1, y1, x2, y2, x3, y3 : Natural) is
   begin
      line_off(fenetreCourante, int(x1), int(y1), int(x2), int(y2));
      line_off(fenetreCourante, int(x2), int(y2), int(x3), int(y3));
      line_off(fenetreCourante, int(x3), int(y3), int(x1), int(y1));
   end;

   -- Remplit un triangle dont les sommets sont les points (x1, y1),
   -- (x2, y2) et (x3, y3)
   procedure TrianglePlein(x1, y1, x2, y2, x3, y3 : Natural) is
   begin
      fill_triangle(fenetreCourante, int(x1), int(y1),
                                     int(x2), int(y2),
                                     int(x3), int(y3));
   end;

   -- Affiche un point de coordonnees (x, y)
   procedure Point(x, y : Natural) is
   begin
      point(fenetreCourante, int(x), int(y));
   end;
   
   -- Efface un point de coordonnees (x, y)
   procedure SuppPoint(x, y : Natural) is
   begin
      point_off(fenetreCourante, int(x), int(y));
   end;

   -- Initialise la couleur pour les traces et les textes a blanc et la
   -- couleur du fond des textes a noir
   procedure TextInverse is
   begin
      video_inv(fenetreCourante);
   end;

   -- Initialise la couleur pour les traces et les textes a noir et la
   -- couleur du fond des textes a blanc
   procedure TextNormal is
   begin
      video_nor(fenetreCourante);
   end;

   -- Initialise la couleur pour les traces a blanc, la couleur du fond a
   -- noir et colorie le fond de la fenetre en noir
   procedure GraphInverse is
   begin
      graph_inv(fenetreCourante);
   end;

   -- Initialise la couleur pour les traces a noir, la couleur du fond a
   -- blanc et colorie le fond de la fenetre en blanc
   procedure GraphNormal is
   begin
      graph_nor(fenetreCourante);
   end;

   -- Affiche le texte donne a partir du point de cordonnees (x, y)
   procedure Ecrire(x, y : Natural; texte : String) is
   use Interfaces.C.Strings;
      ps : chars_ptr := new_string(texte);
   begin
      write_gr(fenetreCourante, int(x), int(y), ps);
      free(ps);
   end;

   -- Affiche le texte donne a partir du point de cordonnees (x, y) en
   -- effacant ce qu'il y a dessous
   procedure EcrireDessus(x, y : Natural; texte : String) is
   use Interfaces.C.Strings;
      ps : chars_ptr := new_string(texte);
   begin
      overwrite_gr(fenetreCourante, int(x), int(y), ps);
      free(ps);
   end;
 
   -- Debute une sequence de traces. Le dessin effectue sera affiche lors
   -- de l'appel de FinDessin()
   procedure DebutDessin is
   begin
      draw_begin(fenetreCourante);
   end;

   -- Termine une sequence de traces. Le dessin effectue depuis l'appel de
   -- DebutDessin() est affiche
   procedure FinDessin is
   begin
      draw_end(fenetreCourante);
   end;

end graphsimple;
