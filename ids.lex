/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		ids.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigLogger.h>
#include "urn.h"

//typedef int YYSTYPE;
//extern YYSTYPE idslval;
char* idslval;

extern int nSupIds;
extern ids *tabSupIds[];
extern int nInfIds;
extern ids *tabInfIds[];

int long idpos=0;

void salvaSupPos()
{
	ids *tab = (ids *) malloc (sizeof(ids));
	tabSupIds[nSupIds] = tab;
	tabSupIds[nSupIds] -> posiz = idpos;
	tabSupIds[nSupIds] -> value = idslval;
	nSupIds++;
}

void salvaInfPos()
{
	ids *tab = (ids *) malloc (sizeof(ids));
	tabInfIds[nInfIds] = tab;
	tabInfIds[nInfIds] -> posiz = idpos;
	tabInfIds[nInfIds] -> value = idslval;
	nInfIds++;
}

%}

PARSUP		(libro|parte|titolo|capo|sezione)
PARINF		(articolo|comma|el|en|ep)
SP				([[:space:]])

%x	supstart supend infstart infend

%%

(<{PARSUP}{SP}+[^>]*id=\"?)	BEGIN(supstart); idpos+=idsleng;

<supstart>([^ "]+)		BEGIN(supend); idslval=strdup(idstext); idpos+=idsleng; salvaSupPos();

<supend>(\"?[^>]*>)		BEGIN(0); idpos+=idsleng; 

(<{PARINF}{SP}+[^>]*id=\"?)	BEGIN(infstart); idpos+=idsleng;

<infstart>([^ "]+)		BEGIN(infend); idslval=strdup(idstext); idpos+=idsleng; salvaInfPos();

<infend>(\"?[^>]*>)		BEGIN(0); idpos+=idsleng; 

([a-z0-9]+)			idpos+=idsleng;

.|\n				idpos+=idsleng;

%%

int idswrap()
{
	return 1;
}

