/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		urn.h
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*			PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

#ifndef __URN_H__
#define __URN_H__

typedef struct _ids {
	long posiz;
	char *value;
} ids;

typedef struct _vir {
	long inizio;
	long fine;
} vir;

typedef struct _urn {
	long inizio;
	long fine;
	long ultimo;
	char tipo;
	char *autorita;
	char *provvedimento;
	char *data;
	char *numero;
	char *suddivisione;
	char *lib;
	char *prt;
	char *tit;
	char *cap;
	char *sez;
	char *art;
	char *com;
	char *let;
	char *num;
	char *prg;
} urn;

void urnVisualizza(urn *u);
void urnCompletaId();
void urnCheckVirg();
int  urnCercaId(ids *tab[], int nt, char str[]);
void urnCloseIds();

void urnInit(urn *u);
void urnShift(urn *u);
void urnFree(urn *u);
char * urnStringa(urn u);
char * urnPartizioni(urn u);
void urnMemorizza(urn u);

#endif /* __URN_H__ */
