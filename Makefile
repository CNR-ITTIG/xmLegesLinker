#******************************************************************************
# Project:	xmLeges
# Module:		Linker
# File:		Makefile
# Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
# Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
# Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
#*****************************************************************************/

PREFIX=../compile
BINDIR=$(PREFIX)/bin
ETCDIR=$(PREFIX)/etc
LIBDIR=$(PREFIX)/lib
INCLUDEDIR = $(PREFIX)/include

CFLAGS=-O3 -I$(INCLUDEDIR)		# produzione
#CFLAGS=-ggdb -I$(INCLUDEDIR)
#CFLAGS=-Wall -O3 -ggdb 
CC=gcc
LIBS=-L$(LIBDIR) -littig-1.0

all: riferimenti

riferimenti: pre.lex.yy.c pre.tab.c riferimenti.lex.yy.c riferimenti.tab.c levarif.lex.yy.c \
				 ids.lex.yy.c noncompleti.lex.yy.c noncompleti.tab.c interni.lex.yy.c interni.tab.c \
				 util.o parser.o urn.o uscita.o config.o
	$(CC) $(CFLAGS) -o xmLeges-Linker.exe \
				 pre.lex.yy.c pre.tab.c riferimenti.lex.yy.c riferimenti.tab.c levarif.lex.yy.c \
				 ids.lex.yy.c noncompleti.lex.yy.c noncompleti.tab.c interni.lex.yy.c interni.tab.c \
				 util.o parser.o urn.o uscita.o config.o $(LIBS)

pre.lex.yy.c: pre.lex
	flex -i -8 -Ce -Ppre -opre.lex.yy.c pre.lex		# produzione
	# per debug
	#flex -d -i -8 -Ce -Ppre -opre.lex.yy.c pre.lex

pre.tab.c: pre.y
	# per debug (con predebug=1)
	bison -td -ppre pre.y

ids.lex.yy.c: ids.lex urn.h
	flex -i -8 -CFe -Pids -oids.lex.yy.c ids.lex		# produzione
	# per debug
	#flex -d -i -8 -CFe -Pids -oids.lex.yy.c ids.lex

levarif.lex.yy.c: levarif.lex parser.h
	flex -i -8 -CFe -Plev -olevarif.lex.yy.c levarif.lex		# produzione
	# per debug
	#flex -d -i -8 -CFe -Plev -olevarif.lex.yy.c levarif.lex

riferimenti.lex.yy.c: riferimenti.lex
	flex -i -8 -Ce -oriferimenti.lex.yy.c riferimenti.lex		# produzione
	# per debug
	#flex -d -i -8 -Ce -oriferimenti.lex.yy.c riferimenti.lex

riferimenti.tab.c: riferimenti.y
	bison -g -v -td riferimenti.y
	# per debug yydebug=1

noncompleti.lex.yy.c: noncompleti.lex
	flex -i -8 -Ce -Pnoc -ononcompleti.lex.yy.c noncompleti.lex		# produzione
	# per debug
	#flex -d -i -8 -Ce -Pnoc -ononcompleti.lex.yy.c noncompleti.lex

noncompleti.tab.c: noncompleti.y
	# per debug (con yydebug=1)
	bison -g -v -td -pnoc noncompleti.y

interni.lex.yy.c: interni.lex
	flex -i -8 -Ce -Pint -ointerni.lex.yy.c interni.lex		# produzione
	# per debug
	# flex -d -i -8 -Ce -Pint -ointerni.lex.yy.c interni.lex

interni.tab.c: interni.y
	# per debug (con yydebug=1)
	bison -g -v -td -pint interni.y

parser.o: parser.c parser.h urn.h
	$(CC) $(CFLAGS) -c parser.c

urn.o: urn.c urn.h
	$(CC) $(CFLAGS) -c urn.c

util.o: util.c util.h
	$(CC) $(CFLAGS) -c util.c

uscita.o: uscita.c uscita.h
	$(CC) $(CFLAGS) -c uscita.c

config.o: config.c config.h
	$(CC) $(CFLAGS) -c config.c

clean:
	rm -f *.o xmLeges-Linker.exe riferimenti.lex.yy.c riferimenti.tab.* levarif.lex.yy.c \
			ids.lex.yy.c noncompleti.lex.yy.c noncompleti.tab.* \
			interni.lex.yy.c interni.tab.* \
			pre.lex.yy.c pre.tab.* \
			*.output *.vcg *~

install: all

