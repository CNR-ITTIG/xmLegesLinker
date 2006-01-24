/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		uscita.c
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
******************************************************************************/

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "config.h"
#include "uscita.h"
#include <IttigUtil.h>
#include "urn.h"

void uscitaOneSpace(int c, int *spazio);

char * uscitaCalcolaStringa(char *str, urn *u) {
	char *s;
	char * t;
	char * r = NULL;

	s = strdup(str);
	while ((t = strstr(s, "__URN__"))) {
		*t = 0;
		r = utilConcatena(3, r, s, urnStringa(*u));
		*t = '_';
		s = t + 7;
	}
	r = utilConcatena(2, r, s);
	return r;
}



void uscitaDaFile(char *buf, urn *u[], int n, char *prima, char *dopo, int tutto, int nl) {
	register int i = 0;
	register int j = 0;
	register int blocco = 0;
	int spazio = 1;
	int tag = 0;

	for (i = 0; *buf; i++, buf++) {
		if (j<n)
			if (i == u[j]->inizio) {
				printf("%s", uscitaCalcolaStringa(prima, u[j]));
				blocco = 1;
			}
		if (blocco || tutto) {
			int c = *buf;
			if (nl)				// duplica input
				putchar(c);
			else {				// toglie spazi e tag
				if (configGetTipoInput() != txt) {	// html o xml
					if (c == '<') tag = 1;
					if (!tag) uscitaOneSpace(c, &spazio);
					if (c == '>') tag = 0;
				}
				else uscitaOneSpace(c, &spazio);
			}
		}
		if (j < n && blocco)
			if (i == u[j]->fine-1) {
				printf("%s", uscitaCalcolaStringa(dopo, u[j]));
				j++;
				blocco = 0;
			}
	}
}



void uscitaOneSpace(int c, int *spazio) {

	if (!isspace(c)) {
		putchar(c);
		*spazio = 0;
	}
	else if (!*spazio) {
		putchar(' ');
		*spazio = 1;
	}
}



void uscitaLista(urn *u[], int n) {
	register int i;

	for (i=0; i < n; i++)
		printf("%-60s\t%6ld\t%6ld\n", urnStringa(*(u[i])), u[i]->inizio, u[i]->fine);
}



void uscitaListaConTesto(char *buf, urn *u[], int n) {
	uscitaDaFile(buf, u, n, "__URN__\t", "\n", 0, 0);
}



void uscitaInserimento(char *buf, urn *u[], int n, char *prima, char *dopo) {
	uscitaDaFile(buf, u, n, prima, dopo, 1, 1);
}

