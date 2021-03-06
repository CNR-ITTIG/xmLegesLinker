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
extern int nVirPos;
extern vir *tabVirPos[];
extern int nModPos;
extern mod *tabModPos[];

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

void salvaVirPos(int ini)
{
	if (ini)
	{
		vir *tab = (vir *) malloc (sizeof(vir));
		tabVirPos[nVirPos] = tab;
		tabVirPos[nVirPos] -> inizio = idpos;
	}
	else
	{
		tabVirPos[nVirPos] -> fine = idpos;
		nVirPos++;
	}
}

void salvaModPos(int ini)
{
	if (ini)
	{
		mod *tab = (mod *) malloc (sizeof(mod));
		tabModPos[nModPos] = tab;
		tabModPos[nModPos] -> inizio = idpos;
	}
	else
	{
		tabModPos[nModPos] -> fine = idpos;
		nModPos++;
	}
}


%}

PARSUP		(libro|parte|titolo|capo|sezione)
PARINF		(articolo|comma|el|en|ep)
SP			([[:space:]])

%x	supstart supend infstart infend virgol mod

%%
   /* ***********************
    * TAG MOD               *
    * ***********************/
(<mod[^>]*>)				BEGIN(mod); idpos+=idsleng; salvaModPos(1);

<mod>[a-z0-9]+				|
<mod>.|\n					idpos+=idsleng;
<mod>(<\/mod>)				BEGIN(0); salvaModPos(0); idpos+=idsleng;
   /* ***********************
    * TAG VIRGOLETTE        *
    * ***********************/
<mod>(<virgolette[^>]*>)	BEGIN(virgol); idpos+=idsleng; salvaVirPos(1);

<virgol>[a-z0-9]+			|
<virgol>.|\n				idpos+=idsleng;
<virgol>(<\/virgolette>)	BEGIN(mod); salvaVirPos(0); idpos+=idsleng;
   /* *******************************
    * PARTIZIONI SUPERIORI ARTICOLO *
    * *******************************/
(<{PARSUP}{SP}+[^>]*id=\"?)	BEGIN(supstart); idpos+=idsleng;

<supstart>([^ ">]+)			BEGIN(supend); idslval=strdup(idstext); idpos+=idsleng; salvaSupPos();
<supstart>[ ">]				BEGIN(supend); unput(*idstext);

<supend>([^>]*>)			BEGIN(0); idpos+=idsleng; 
   /* *******************************
    * PARTIZIONI INFERIORI ARTICOLO *
    * *******************************/
(<{PARINF}{SP}+[^>]*id=\"?)	BEGIN(infstart); idpos+=idsleng;

<infstart>([^ ">]+)			BEGIN(infend); idslval=strdup(idstext); idpos+=idsleng; salvaInfPos();
<infstart>[ ">]				BEGIN(infend); unput(*idstext);

<infend>([^>]*>)			BEGIN(0); idpos+=idsleng; 
   /* *******************************
    * NON SIGNIFICATIVI             *
    * *******************************/
[a-z0-9]+					|
.|\n						idpos+=idsleng;

%%

int idswrap()
{
	return 1;
}

