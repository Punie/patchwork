# chemins d'acces a la machine caracteres
CARINCDIR = ./machine-caracteres

# chemins d'acces a graphsimple
GRAPHSIMPLEINCDIR = ./graphsimple

# chemin d'acces aux librairies (sources)
INCDIR = $(CARINCDIR):$(GRAPHSIMPLEINCDIR)

# chemin d'acces aux librairies (binaires)
LIBDIR = $(INCDIR)

GNATINSTALLDIR =
GNATMAKE = gnatmake
GDB = gdb

GNATLDOPTS = -L$(LIBDIR) -lmachcar -lgraphsimple \
             -L/usr/X11R6/lib -lX11

%: %.o

CIBLE = phileas

all: $(CIBLE)

.PHONY: $(CIBLE)
$(CIBLE):
	cd $(CARINCDIR) && (make ; chmod -w *)
	cd $(GRAPHSIMPLEINCDIR) && (make ; chmod -w *)
	ADA_INCLUDE_PATH=$(INCDIR) \
	ADA_OBJECTS_PATH=$(LIBDIR) \
	$(GNATMAKE) $(CIBLE) -g -largs $(GNATLDOPTS)

gdb:
	$(GDB) $(CIBLE)

.PHONY: machine-caracteres
machine-caracteres:
	cd $(CARINCDIR) && make

.PHONY: graphsimple
graphsimple:
	cd $(GRAPHSIMPLEINCDIR) && make

clean:
	/bin/rm -fR `basename $(CIBLE) .adb` *.o *.ps *~ *.ali b~*

cleanall: clean
	cd $(CARINCDIR) && make clean
	cd $(GRAPHSIMPLEINCDIR) && make clean
