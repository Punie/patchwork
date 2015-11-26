GNATCC = gnatmake

GNATCCOPTS =

%.o: %.adb
	/bin/rm -f `basename $@ .o`.ali
	ADA_INCLUDE_PATH=$(GRAPHLIBDIR) $(GNATCC) -c -g $(GNATCCOPTS) $<

all: libmachcar.a
	/bin/rm -f *.o
	chmod -w *.ali *.a

libmachcar.a: machine_caracteres.o
	/bin/rm -f libmachcar.a
	ar rc libmachcar.a machine_caracteres.o

clean:
	/bin/rm -fR *.o *.a *.ps *~ b~* *.ali
