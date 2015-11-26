-----------------------------------------------------------------------
-- Interface ADA pour la bibliotheque graphlib_w2
--
-- 04/04/2006 (P. Habraken) : creation (d'apres graphlib_w2.h)
--
-- 14/05/2007 (P. Habraken) : creation (d'apres graphlib_w2.h)
-- - Ajout d'un parametre permettant de recuperer le numero de bouton
--   (cliquer_xy, cliquer_xy_dans, lacher_xy, lacher_xy_dans)
-----------------------------------------------------------------------
with System;
with Interfaces.C;
with Interfaces.C.Strings;

package graphlib_w2 is

   XSize : constant Natural := 1099;
   YSize : constant Natural := 749;

   NB_MAX_FENETRES : constant Natural := 256;
   NB_MAX_IMAGES : constant Natural := 256;

   type Fenetre is private;
   type Image is private;

   type Couleur_glw2 is (
      BLANC, ROUGE, BLEU_FONCE, SAUMON_FONCE, JAUNE, BEIGE, BLEU_CLAIR,
      ORANGE, MAGENTA, CYAN_FONCE, BLEU_VERT, NOIR, BLEU, VERT
   );

   type access_uchar is access all Interfaces.C.unsigned_char;
   type access_access_uchar is access all access_uchar;

use Interfaces.C;
use Interfaces.C.Strings;

   ---------------------------------------------------------------------
   -- gr_inits : initialisation de l'e'cran graphique
   ---------------------------------------------------------------------
   procedure gr_inits(f : access Fenetre; xcorner : int; ycorner : int);

   ---------------------------------------------------------------------
   -- gr_inits_2 : initialisation de l'e'cran graphique
   -- cree une fenetre X-Window de taille larg X haut
   ---------------------------------------------------------------------
   procedure gr_inits_2(f : access Fenetre;
                        xcorner, ycorner : int; larg, haut : int);

   ---------------------------------------------------------------------
   -- gr_inits_w : initialisation de l'e'cran graphique
   -- cree une fenetre X-Window de taille larg x haut avec un titre
   ---------------------------------------------------------------------
   procedure gr_inits_w(f : access Fenetre;
                        xcorner, ycorner : int; larg, haut : int;
                        titre : chars_ptr);

   ---------------------------------------------------------------------
   -- gr_close : fermeture de l'e'cran graphique
   ---------------------------------------------------------------------
   procedure gr_close(f : access Fenetre);

   ---------------------------------------------------------------------
   -- creer_image_bitmap : creation d'une image a partir de donnees au
   -- format bitmap
   ---------------------------------------------------------------------
   procedure creer_image_bitmap(im : access Image;
                                donnees : access_uchar;
                                largeur, hauteur : unsigned);

   ---------------------------------------------------------------------
   -- charger_fichier_bitmap : chargement des donnees d'une image a
   -- partir d'un fichier au format bitmap
   ---------------------------------------------------------------------
   procedure charger_fichier_bitmap(nomFichier : chars_ptr;
                                    donnees : access access_uchar;
                                    largeur, hauteur : access unsigned);

   ---------------------------------------------------------------------
   -- creer_image_xpm : creation d'une image a partir de donnees au
   -- format xpm
   ---------------------------------------------------------------------
   procedure creer_image_xpm(im : access Image;
                             donnees : access access_uchar);

   ---------------------------------------------------------------------
   -- charger_fichier_xpm : chargement des donnees d'une image a
   -- partir d'un fichier au format xpm
   ---------------------------------------------------------------------
   procedure charger_fichier_xpm(nomFichier : chars_ptr;
                                 donnees : access access_access_uchar);

   ---------------------------------------------------------------------
   -- set_blue : changement de couleur
   ---------------------------------------------------------------------
   procedure set_blue(f : Fenetre);

   ---------------------------------------------------------------------
   -- set_red : changement de couleur
   ---------------------------------------------------------------------
   procedure set_red(f : Fenetre);

   ---------------------------------------------------------------------
   -- set_green : changement de couleur
   ---------------------------------------------------------------------
   procedure set_green(f : Fenetre);

   ---------------------------------------------------------------------
   -- set_yellow : changement de couleur
   ---------------------------------------------------------------------
   procedure set_yellow(f : Fenetre);

   ---------------------------------------------------------------------
   -- set_black : changement de couleur
   ---------------------------------------------------------------------
   procedure set_black(f : Fenetre);

   ---------------------------------------------------------------------
   -- set_white : changement de couleur
   ---------------------------------------------------------------------
   procedure set_white(f : Fenetre);

   ---------------------------------------------------------------------
   -- set_color : changement de couleur
   ---------------------------------------------------------------------
   procedure set_color(f : Fenetre; c : Couleur_glw2);

   ---------------------------------------------------------------------
   -- ecriture de texte en blanc sur fond noir
   ---------------------------------------------------------------------
   procedure video_inv(f : Fenetre);

   ---------------------------------------------------------------------
   -- dessin en blanc sur fond noir
   ---------------------------------------------------------------------
   procedure graph_inv(f : Fenetre);

   ---------------------------------------------------------------------
   -- ecriture de texte en noir sur fond blanc
   ---------------------------------------------------------------------
   procedure video_nor(f : Fenetre);

   ---------------------------------------------------------------------
   -- dessin en noir sur fond blanc
   ---------------------------------------------------------------------
   procedure graph_nor(f : Fenetre);

   ---------------------------------------------------------------------
   -- clear_screen : effacement de l'e'cran
   ---------------------------------------------------------------------
   procedure clear_screen(f : Fenetre);

   ---------------------------------------------------------------------
   -- afficher_image : affiche une image prealablement creee
   ---------------------------------------------------------------------
   procedure afficher_image(f : Fenetre; i : Image; x, y : int);

   ---------------------------------------------------------------------
   -- effacer_image : efface une image prealablement affichee
   ---------------------------------------------------------------------
   procedure effacer_image(f : Fenetre; i : Image; x, y : int);

   ---------------------------------------------------------------------
   -- line : trace une ligne
   ---------------------------------------------------------------------
   procedure line(f : Fenetre; x1, y1, x2, y2 : int);

   ---------------------------------------------------------------------
   -- line_off : efface une ligne
   ---------------------------------------------------------------------
   procedure line_off(f : Fenetre; x1, y1, x2, y2 : int);

   ---------------------------------------------------------------------
   -- point :  affichage du point (x,y)
   ---------------------------------------------------------------------
   procedure point(f : Fenetre; x, y : int);

   ---------------------------------------------------------------------
   -- point_off : effacement du point (x,y)
   ---------------------------------------------------------------------
   procedure point_off(f : Fenetre; x, y : int);

   ---------------------------------------------------------------------
   -- fill_triangle: remplit un triangle
   ---------------------------------------------------------------------
   procedure fill_triangle(f : Fenetre; x1, y1, x2, y2, x3, y3 : int);

   ---------------------------------------------------------------------
   -- circle : trace un cercle
   ---------------------------------------------------------------------
   procedure circle(f : Fenetre; x, y, R : int);

   ---------------------------------------------------------------------
   -- fill_circle : remplit un cercle
   ---------------------------------------------------------------------
   procedure fill_circle(f : Fenetre; x, y, R : int);
   
   ---------------------------------------------------------------------
   -- fill_quarter_circle_est : remplit un cercle
   ---------------------------------------------------------------------
   procedure fill_quarter_circle_est(f : Fenetre; x, y, R : int);

   ---------------------------------------------------------------------
   -- fill_quarter_circle_nord : remplit un cercle
   ---------------------------------------------------------------------
   procedure fill_quarter_circle_nord(f : Fenetre; x, y, R : int);
   
   ---------------------------------------------------------------------
   -- fill_quarter_circle_ouest : remplit un cercle
   ---------------------------------------------------------------------
   procedure fill_quarter_circle_ouest(f : Fenetre; x, y, R : int);
   
   ---------------------------------------------------------------------
   -- fill_quarter_circle_sud : remplit un cercle
   ---------------------------------------------------------------------
   procedure fill_quarter_circle_sud(f : Fenetre; x, y, R : int);
   
   ---------------------------------------------------------------------
   -- circle_off : efface un cercle
   ---------------------------------------------------------------------
   procedure circle_off(f : Fenetre; x, y, R : int);

   ---------------------------------------------------------------------
   -- trace d'un rectangle dont les extremites de la diagonale sont
   -- (x1, y1) et (x2, y2)
   ---------------------------------------------------------------------
   procedure rectangle(f : Fenetre; x1, y1, x2, y2 : int);

   ---------------------------------------------------------------------
   -- remplit un rectangle dont les extremites de la diagonale sont
   -- (x1, y1) et (x2, y2)
   ---------------------------------------------------------------------
   procedure fill_rectangle(f : Fenetre; x1, y1, x2, y2 : int);

   ---------------------------------------------------------------------
   -- effacement d'un rectangle dont les extremites de la diagonale sont
   -- (x1, y1) et (x2, y2)
   ---------------------------------------------------------------------
   procedure rectangle_off(f : Fenetre; x1, y1, x2, y2 : int);

   ---------------------------------------------------------------------
   -- ellipse : trace une ellipse de centre (x,y) et de rayons rx et ry
   ---------------------------------------------------------------------
   procedure ellipse(f : Fenetre; x, y, rx, ry : int);

   ---------------------------------------------------------------------
   -- fill_ellipse : remplit une ellipse de centre (x,y) et de rayons rx
   -- et ry
   ---------------------------------------------------------------------
   procedure fill_ellipse(f : Fenetre; x, y, rx, ry : int);

   ---------------------------------------------------------------------
   -- ellipse_off : efface l'ellipse de centre (x,y) et de rayons rx et
   -- ry
   ---------------------------------------------------------------------
   procedure ellipse_off(f : Fenetre; x, y, rx, ry : int);

   ---------------------------------------------------------------------
   -- write_gr : ecriture sur l'ecran graphique en superposition
   ---------------------------------------------------------------------
   procedure write_gr(f : Fenetre; x, y : int; str : chars_ptr);

   ---------------------------------------------------------------------
   -- overwrite_gr : e'criture sur l'e'cran graphique avec effacement
   ---------------------------------------------------------------------
   procedure overwrite_gr(f : Fenetre; x, y : int; str : chars_ptr);

   ---------------------------------------------------------------------
   -- draw_begin : debut d'une sequence de traces graphiques
   ---------------------------------------------------------------------
   procedure draw_begin(f : Fenetre);

   ---------------------------------------------------------------------
   -- draw_end : fin d'une sequence de traces graphiques
   ---------------------------------------------------------------------
   procedure draw_end(f : Fenetre);

   ---------------------------------------------------------------------
   -- cliquer : Suspend l'execution du programme jusqu'a un clic de la
   -- souris
   ---------------------------------------------------------------------
   procedure cliquer(f : Fenetre);

   ---------------------------------------------------------------------
   -- cliquer_dans : Suspend l'execution du programme jusqu'a un clic de
   -- la souris
   ---------------------------------------------------------------------
   procedure cliquer_dans(f : access Fenetre);

   ---------------------------------------------------------------------
   -- lacher : Suspend l'execution du programme jusqu'a un relachement
   -- de la souris
   ---------------------------------------------------------------------
   procedure lacher(f : Fenetre);

   ---------------------------------------------------------------------
   -- lacher_dans : Suspend l'execution du programme jusqu'a un
   -- relachement de la souris
   ---------------------------------------------------------------------
   procedure lacher_dans(f : access Fenetre);

   ---------------------------------------------------------------------
   -- cliquer_xy(f, x, y, b) : Met a jour x, y, b et f avec les
   -- coordonnees du dernier clic souris, le numero du bouton clique et
   -- l'identificateur de la fenetre concernee
   ---------------------------------------------------------------------
   procedure cliquer_xy(f : Fenetre; x, y, b : access int);

   ---------------------------------------------------------------------
   -- cliquer_xy_dans(f, x, y, b) : Met a jour x, y, b et f avec les
   -- coordonnees du dernier clic souris, le numero du bouton clique et
   -- l'identificateur de la fenetre concernee
   ---------------------------------------------------------------------
   procedure cliquer_xy_dans(f : access Fenetre; x, y, b : access int);

   ---------------------------------------------------------------------
   -- lacher_xy(f, x, y, b) : Met a jour x, y et b avec les coordonnees
   -- du dernier relache de bouton de souris et le numero du bouton
   -- relache
   ---------------------------------------------------------------------
   procedure lacher_xy(f : Fenetre; x, y, b : access int);

   ---------------------------------------------------------------------
   -- lacher_xy_dans(f, x, y, b) : Met a jour x, y, b et f avec les
   -- coordonnees du relache de bouton de souris, le numero du bouton
   -- clique et l'identificateur de la fenetre concernee
   ---------------------------------------------------------------------
   procedure lacher_xy_dans(f : access Fenetre; x, y, b : access int);

   ---------------------------------------------------------------------
   -- glisser_xy : Met a jour les coordonnees x et y avec les dernieres
   -- coordonnees de la souris
   ---------------------------------------------------------------------
   procedure glisser_xy(f : Fenetre; x, y : access int);

   ---------------------------------------------------------------------
   -- glisser_xy_dans : Met a jour les coordonnees x et y avec les
   -- dernieres coordonnees de la souris
   ---------------------------------------------------------------------
   procedure glisser_xy_dans(f : access Fenetre; x, y : access int);

   ---------------------------------------------------------------------
   -- pour la compatibilite avec Atari
   ---------------------------------------------------------------------
   procedure wait_kbd(f : Fenetre);

   ---------------------------------------------------------------------
   -- pour la compatibilite avec Atari
   ---------------------------------------------------------------------
   procedure wait_kbd_dans(f : access Fenetre);

   ---------------------------------------------------------------------
   -- cstat teste l'enfoncement d'une touche du clavier
   ---------------------------------------------------------------------
   function cstat(f : Fenetre) return int;

   ---------------------------------------------------------------------
   -- cstat_dans teste l'enfoncement d'une touche du clavier
   ---------------------------------------------------------------------
   function cstat_dans(f : access Fenetre) return int;

   ---------------------------------------------------------------------
   -- consilent fournit le caractere present s'il y en a un, le
   -- caractere nul sinon
   -- return | entree -> ascii CR  (0x0D # '\r')
   -- backspace       -> ascii BS  (0x08 # '\b')
   -- tab             -> ascii HT  (0x09 # '\t')
   -- echap           -> ascii ESC (0x1B)
   -- suppr/del       -> ascii DEL (0x7F)
   -- defil. gauche   -> ascii SOH (0x01)
   -- defil. droite   -> ascii STX (0x02)
   -- defil. haut     -> ascii ETX (0x03)
   -- defil. bas      -> ascii EOT (0x04)
   ---------------------------------------------------------------------
   function consilent(f : Fenetre) return char;

   ---------------------------------------------------------------------
   -- consilent_dans fournit le caractere present s'il y en a un, le
   -- caractere nul sinon
   -- (voir consilent)
   ---------------------------------------------------------------------
   function consilent_dans(f : access Fenetre) return char;

   ---------------------------------------------------------------------
   -- bouton fournit le numero de bouton si un bouton de la souris a ete
   -- enfonce, 0 sinon
   ---------------------------------------------------------------------
   function bouton(f : Fenetre) return int;

   ---------------------------------------------------------------------
   -- bouton_dans fournit le numero de bouton si un bouton de la souris
   -- a ete enfonce, 0 sinon
   ---------------------------------------------------------------------
   function bouton_dans(f : access Fenetre) return int;

   ---------------------------------------------------------------------
   -- bouton_relache fournit le numero de bouton si un bouton de la
   -- souris a ete relache, 0 sinon
   ---------------------------------------------------------------------
   function bouton_relache(f : Fenetre) return int;

   ---------------------------------------------------------------------
   -- bouton_relache_dans fournit le numero de bouton si un bouton de la
   -- souris a ete relache, 0 sinon
   ---------------------------------------------------------------------
   function bouton_relache_dans(f : access Fenetre) return int;

   ---------------------------------------------------------------------
   -- bouton_glisse retourne un numero de bouton (1, 2 ou 3) si la
   -- souris a ete deplacee l'un des boutons etant appuye, 0 sinon
   ---------------------------------------------------------------------
   function bouton_glisse(f : Fenetre) return int;

   ---------------------------------------------------------------------
   -- bouton_glisse_dans retourne un numero de bouton (1, 2 ou 3) si la
   -- souris a ete deplacee l'un des boutons etant appuye, 0 sinon
   ---------------------------------------------------------------------
   function bouton_glisse_dans(f : access Fenetre) return int;

   ---------------------------------------------------------------------
   -- delai bloque l'execution pendant millis millisecondes
   ---------------------------------------------------------------------
   procedure delai(millis : long);

private

   type Fenetre is new System.Address;
   type Image is new System.Address;

   pragma Import(C, gr_inits, "gr_inits");
   pragma Import(C, gr_inits_2, "gr_inits_2");
   pragma Import(C, gr_inits_w, "gr_inits_w");
   pragma Import(C, gr_close, "gr_close");
   pragma Import(C, creer_image_bitmap, "creer_image_bitmap");
   pragma Import(C, charger_fichier_bitmap, "charger_fichier_bitmap");
   pragma Import(C, creer_image_xpm, "creer_image_xpm");
   pragma Import(C, charger_fichier_xpm, "charger_fichier_xpm");
   pragma Import(C, set_blue, "set_blue");
   pragma Import(C, set_red, "set_red");
   pragma Import(C, set_green, "set_green");
   pragma Import(C, set_yellow, "set_yellow");
   pragma Import(C, set_black, "set_black");
   pragma Import(C, set_white, "set_white");
   pragma Import(C, set_color, "set_color");
   pragma Import(C, video_inv, "video_inv");
   pragma Import(C, graph_inv, "graph_inv");
   pragma Import(C, video_nor, "video_nor");
   pragma Import(C, graph_nor, "graph_nor");
   pragma Import(C, clear_screen, "clear_screen");
   pragma Import(C, afficher_image, "afficher_image");
   pragma Import(C, effacer_image, "effacer_image");
   pragma Import(C, line, "line");
   pragma Import(C, line_off, "line_off");
   pragma Import(C, point, "point");
   pragma Import(C, point_off, "point_off");
   pragma Import(C, fill_triangle, "fill_triangle");
   pragma Import(C, circle, "circle");
   pragma Import(C, fill_circle, "fill_circle");
   pragma Import(C, fill_quarter_circle_est, "fill_quarter_circle_est");
   pragma Import(C, fill_quarter_circle_nord, "fill_quarter_circle_nord");
   pragma Import(C, fill_quarter_circle_ouest, "fill_quarter_circle_ouest");
   pragma Import(C, fill_quarter_circle_sud, "fill_quarter_circle_sud");
   pragma Import(C, circle_off, "circle_off");
   pragma Import(C, rectangle, "rectangle");
   pragma Import(C, fill_rectangle, "fill_rectangle");
   pragma Import(C, rectangle_off, "rectangle_off");
   pragma Import(C, ellipse, "ellipse");
   pragma Import(C, fill_ellipse, "fill_ellipse");
   pragma Import(C, ellipse_off, "ellipse_off");
   pragma Import(C, write_gr, "write_gr");
   pragma Import(C, overwrite_gr, "overwrite_gr");
   pragma Import(C, draw_begin, "draw_begin");
   pragma Import(C, draw_end, "draw_end");
   pragma Import(C, cliquer, "cliquer");
   pragma Import(C, cliquer_dans, "cliquer_dans");
   pragma Import(C, lacher, "lacher");
   pragma Import(C, lacher_dans, "lacher_dans");
   pragma Import(C, cliquer_xy, "cliquer_xy");
   pragma Import(C, cliquer_xy_dans, "cliquer_xy_dans");
   pragma Import(C, lacher_xy, "lacher_xy");
   pragma Import(C, lacher_xy_dans, "lacher_xy_dans");
   pragma Import(C, glisser_xy, "glisser_xy");
   pragma Import(C, glisser_xy_dans, "glisser_xy_dans");
   pragma Import(C, wait_kbd, "wait_kbd");
   pragma Import(C, wait_kbd_dans, "wait_kbd_dans");
   pragma Import(C, cstat, "cstat");
   pragma Import(C, cstat_dans, "cstat_dans");
   pragma Import(C, consilent, "consilent");
   pragma Import(C, consilent_dans, "consilent_dans");
   pragma Import(C, bouton, "bouton");
   pragma Import(C, bouton_dans, "bouton_dans");
   pragma Import(C, bouton_relache, "bouton_relache");
   pragma Import(C, bouton_relache_dans, "bouton_relache_dans");
   pragma Import(C, bouton_glisse, "bouton_glisse");
   pragma Import(C, bouton_glisse_dans, "bouton_glisse_dans");
   pragma Import(C, delai, "delai");

end graphlib_w2;
