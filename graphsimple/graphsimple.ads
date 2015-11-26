------------------------------------------------------------------------
--
-- INTERFACE ADA POUR GRAPHSIMPLE
--
-- graphsimple.ads
--
-- mettre la directive : with graphsimple;
-- apres l'entete de programme dans le programme l'utilisant
--
-- P.Habraken 13/04/2006 : creation (d'apres graphsimple.h)
--
-- modifie par P.Habraken le 14/05/2007 :
-- - Ajout d'un parametre permettant de recuperer le numero de bouton
--   (AttendreClicXY, AttendreLacherXY)
-- - Ajout a la procedure AttendreTaper d'un parametre permettant de
--   recuperer le caractere correspondant a la touche tapee
------------------------------------------------------------------------

package graphsimple is

-- Constante definissant les couleurs
   type Couleur is (Noir, Blanc, Rouge, Bleu, Vert, Jaune);

   -- Initialise la fenetre graphique
   procedure Initialiser(x, y : Positive);
 
   -- Clot la fenetre graphique
   procedure Clore;
 
   -- Efface la fenetre graphique
   procedure Effacer;
  
   -- Affiche un point de coordonnees (x, y)
   procedure Point(x, y : Natural);
 
   -- Efface un point de coordonnees (x, y)
   procedure SuppPoint(x, y : Natural);
 
   -- Trace une ligne entre les points (x1, y1) et (x2, y2)
   procedure Ligne(x1, y1, x2, y2 : Natural);
 
   -- Efface une ligne entre les points (x1, y1) et (x2, y2)
   procedure SuppLigne(x1, y1, x2, y2 : Natural);
 
   -- Trace un cercle de centre (x, y) et de rayon r
   procedure Cercle(x, y, r : Natural);
 
   -- Efface un cercle de centre (x, y) et de rayon r
   procedure SuppCercle(x, y, r : Natural);
 
   -- Remplit un cercle de centre (x, y) et de rayon r
   procedure CerclePlein(x, y, r : Natural);
   
   -- Remplit un quart de cercle de centre (x,y) et de rayon r
   procedure QuartCerclePleinEst(x,y,r : Natural);
   
   -- Remplit un quart de cercle de centre (x,y) et de rayon r
   procedure QuartCerclePleinNord(x,y,r : Natural);
   
   -- Remplit un quart de cercle de centre (x,y) et de rayon r
   procedure QuartCerclePleinOuest(x,y,r : Natural);
   
   -- Remplit un quart de cercle de centre (x,y) et de rayon r
   procedure QuartCerclePleinSud(x,y,r : Natural);
   
   -- Trace un rectangle dont les extremites d'une de ses diagonales sont
   -- (x1, y1) et (x2, y2)
   procedure Rectangle(x1, y1, x2, y2 : Natural);
 
   -- Efface un rectangle dont les extremites d'une de ses diagonales sont
   -- (x1, y1) et (x2, y2)
   procedure SuppRectangle(x1, y1, x2, y2 : Natural);
 
   -- Remplit un rectangle dont les extremites d'une de ses diagonales sont
   -- (x1, y1) et (x2, y2)
   procedure RectanglePlein(x1, y1, x2, y2 : Natural);
 
   -- Trace une ellipse de centre (x, y) et de rayons rx et ry
   procedure Ellipse(x, y, rx, ry : Natural);
 
   -- Efface une ellipse de centre (x, y) et de rayons rx et ry
   procedure SuppEllipse(x, y, rx, ry : Natural);
 
   -- Remplit une ellipse de centre (x, y) et de rayons rx et ry
   procedure EllipsePleine(x, y, rx, ry : Natural);
 
   -- Trace un triangle dont les sommets sont les points (x1, y1),
   -- (x2, y2) et (x3, y3)
   procedure Triangle(x1, y1, x2, y2, x3, y3 : Natural);
 
   -- Efface un triangle dont les sommets sont les points (x1, y1),
   -- (x2, y2) et (x3, y3)
   procedure SuppTriangle(x1, y1, x2, y2, x3, y3 : Natural);
 
   -- Remplit un triangle dont les sommets sont les points (x1, y1),
   -- (x2, y2) et (x3, y3)
   procedure TrianglePlein(x1, y1, x2, y2, x3, y3 : Natural);

   -- Debute une sequence de traces. Le dessin effectue sera affiche lors
   -- de l'appel de FinDessin
   procedure DebutDessin;

   -- Termine une sequence de traces. Le dessin effectue depuis l'appel de
   -- DebutDessin est affiche
   procedure FinDessin;
 
   -- Suspend l'execution du programme pendant un temps tps donne en ms
   procedure AttendreDelai(tps : Natural);
 
   -- Suspend l'execution du programme jusqu'a la frappe d'une touche sur
   -- le clavier
   procedure AttendreTaper(c : out Character);
 
   -- Si une touche du clavier vient d'etre enfoncee, retourne le caractere
   -- correspondant, sinon retourne le caractere null (\0)
   function Touche return Character;
 
   -- Retourne la valeur vrai si une touche du clavier a ete enfonce,
   -- faux sinon
   function TestClavier return Boolean;
 
   -- Suspend l'execution du programme jusqu'a un appui du bouton de la
   -- souris
   procedure AttendreClic;

   -- Suspend l'exe'cution du programme jusqu'a un relachement du bouton de
   -- la souris
   procedure AttendreLacher;
 
   -- Attend un clic de la souris et recupere ses cordonnees ainsi que le
   -- numero du bouton clique en mettant a jour les valeurs designees par
   -- x, y et b.
   procedure AttendreClicXY(x, y, b : out Natural);

   -- Attend un relachement de la souris et recupere ses coordonnees ainsi
   -- que le numero du bouton relache en mettant a jour les valeurs
   -- designees par x, y et b.
   procedure AttendreLacherXY(x, y, b : out Natural);
 
   -- Attend un deplacement de la souris et recupere ses coordonnees en
   -- mettant a jour les valeurs designees par x et y
   procedure AttendreDeplacementXY(x, y : out Natural);

   -- Retourne le numero de bouton si un bouton de la souris a ete enfonce,
   -- 0 sinon
   function BoutonAppuye return Natural;

   -- Retourne le numero de bouton si un bouton de la souris a ete relache,
   -- 0 sinon
   function BoutonRelache return Natural;
 
   -- Retourne un numero de bouton (1, 2 ou 3) si la souris vient d'etre
   -- deplacee l'un des boutons etant appuye, 0 sinon
   function BoutonGlisse return Natural;

   -- Initialise la couleur pour les traces et les textes a blanc et la
   -- couleur du fond des textes a noir
   procedure TextInverse;
 
   -- Initialise la couleur pour les traces et les textes a noir et la
   -- couleur du fond des textes a blanc
   procedure TextNormal;
 
   -- Initialise la couleur pour les traces a blanc, la couleur du fond a
   -- noir et colorie le fond de la fenetre en noir
   procedure GraphInverse;
 
   -- Initialise la couleur pour les traces a noir, la couleur du fond a
   -- blanc et colorie le fond de la fenetre en blanc
   procedure GraphNormal;
 
   -- Affiche le texte donne a partir du point de cordonnees (x, y)
   procedure Ecrire(x, y : Natural; texte : String);
 
   -- Affiche le texte donne a partir du point de cordonnees (x, y) en
   -- effacant ce qu'il y a dessous
   procedure EcrireDessus(x, y : Natural; texte : String);
 
   -- Change la couleur utilisee pour les traces avec la convention
   -- suivante :
   -- Noir   0
   -- Blanc  1
   -- Rouge  2
   -- Bleu   3
   -- Vert   4
   -- Jaune  5
   procedure ChangerCouleur(c : Couleur);

   -- anciens noms de certaines operations
   procedure Attendre(tps : Natural)
             renames AttendreDelai;
   procedure Taper(c : out Character)
             renames AttendreTaper;
   procedure Cliquer
             renames AttendreClic;
   procedure Lacher
             renames AttendreLacher;
   procedure CliquerXY(x, y, b : out Natural)
             renames AttendreClicXY;
   procedure LacherXY(x, y, b : out Natural)
             renames AttendreLacherXY;
   procedure GlisserXY(x, y : out Natural)
             renames AttendreDeplacementXY;
   function  Clic return Natural
             renames BoutonAppuye;
   function  Relache return Natural
             renames BoutonRelache;
   function  Glisse return Natural
             renames BoutonGlisse;
   procedure ChangeCouleur(c : Couleur)
             renames ChangerCouleur;

end graphsimple;
