GCC = gcc
GNATCC = gnatmake

CCOPTS =
GNATCCOPTS =

%.o: %.c %.h
	$(GCC) -c -g -Wall $(CCOPTS) $<

%.ali: %.ads
	$(GNATCC) -c -g $(GNATCCOPTS) $<
	/bin/rm -f `basename $@ .ali`.o

%.o: %.adb
	/bin/rm -f `basename $@ .o`.ali
	$(GNATCC) -c -g $(GNATCCOPTS) $<

all: libgraphsimple.a
	/bin/rm -f *.o
	chmod -w *.ali *.a

libgraphsimple.a: graphsimple.o graphlib_w2.ali graphlib_w2.o
	/bin/rm -f libgraphsimple.a
	ar rc libgraphsimple.a graphsimple.o graphlib_w2.o

clean:
	/bin/rm -fR *.o *.a *.ps *~ b~* *.ali
