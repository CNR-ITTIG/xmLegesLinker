#******************************************************************************
# Project:	xmLeges
# Module:	Linker
# File:		Makefile
# Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
# Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
# Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
#*****************************************************************************/

PREFIX=/usr/local/
BINDIR=$(PREFIX)/bin
ETCDIR=$(PREFIX)/etc
LIBDIR=$(PREFIX)/lib
INCLUDEDIR = $(PREFIX)/include

CFLAGS=-O3 -I$(INCLUDEDIR)
#CFLAGS=-Wall -O3 -ggdb 
#CFLAGS=-ggdb -I$(INCLUDEDIR)
CC=gcc
LIBS=-L$(LIBDIR) -littig-1.0

all: riferimenti

riferimenti: pre.lex.yy.c pre.tab.c riferimenti.lex.yy.c riferimenti.tab.c util.o parser.o urn.o uscita.o config.o
	$(CC) $(CFLAGS) -o xmLeges-Linker.exe pre.lex.yy.c pre.tab.c riferimenti.lex.yy.c riferimenti.tab.c util.o parser.o urn.o uscita.o config.o $(LIBS)

pre.lex.yy.c: pre.lex
	flex -i -8 -Ce -Ppre -opre.lex.yy.c pre.lex
	# per debug
	#flex -di8 -Ce -Ppre -opre.lex.yy.c pre.lex

pre.tab.c: pre.y
	# per debug (con predebug=1)
	bison -td -ppre pre.y

riferimenti.lex.yy.c: riferimenti.lex
	flex -i -8 -CFe -oriferimenti.lex.yy.c riferimenti.lex
	# per debug
	#flex -di8 -CFe -oriferimenti.lex.yy.c riferimenti.lex

riferimenti.tab.c: riferimenti.y
	# per debug (con yydebug=1)
	bison -g -v -td riferimenti.y

parser.o: parser.c parser.h
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
	rm -f *.o riferimenti.lex.yy.c riferimenti.tab.* xmLeges-Linker.exe pre.lex.yy.c pre.tab.* *~

install: all

