/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		interni.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigLogger.h>
#include <IttigUtil.h>
#include "interni.tab.h"
#include "parser.h"
#include "urn.h"

long int intpos = 0;
extern urn urnTmp;

// typedef int YYSTYPE;
extern YYSTYPE intlval;

int salto = 1;

void salvaIntpos() {
	salto = 0;
	urnTmp.ultimo = intpos;
	if (intpos < urnTmp.inizio)
		urnTmp.inizio = intpos;
	intpos += intleng;
	if (intpos > urnTmp.fine)
		urnTmp.fine = intpos;
}

/*----------------------------------------- pattern tolti
PARA				(paragrafo|par{PS})
PERIO			(periodo|per{PS})
{PARA}{S}{N}		BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(inttext); return PARAGRAFO;
{ORD}{S}{PARA}		BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(inttext); return PARAGRAFO;
{ORD}{S}{PERIO}	BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(inttext); return PERIODO;
  ----------------------------------------- pattern tolti */

%}

NOAN	([^a-z0-9])
SPA	([ ]+)
PS	(\.|{SPA})
S	({SPA}*)
ST	({S}([\-]?){S})
SVB	({S}([\-,\/]?){S})
PTO	(\^|(\.?[oa]))

N	([0-9]+)
N12	([0-9]{1,2})
N4	([0-9]{4})

LIB		(libro)
PAR		(parte|pt{PS}|p{PS})
TIT		(titolo|tit{PS})
CAP		(capo)
SEZ		(sezione|sez{PS})
ART		(articolo|art{PS})
COM		(comma|com{PS}|co?{PS})
CAPOV	(capoverso|cpv{PS})
LET		(lettera|lett?{PS})
NUM		(numero|num{PS}|nr?{PS}|n\.o)

LAT09	(un|bis|duo|ter|quater|quinquies|sexies|septies|octies|novies)
LAT10	(decies|venies)
LAT		({ST}{LAT09}({LAT10})?)

ORD	((prim|second|terz|quart|quint|sest|settim|ottav|non|decim|(undic|dodic|tredic|quattordic|quindic|sedic|diciassett|diciott|diciannov|vent)esim)+[oa])

ROM	([ivx]+)

%s	sudd

%%

((gazzetta{SPA}+ufficiale|g\.?{S}u\.?){SPA}+{NUM}{S}{N})	intpos+=intleng; return BREAK;
((registro|foglio){SPA}+{NUM}{S}{N})					intpos+=intleng; return BREAK;

{LIB}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvRomanoDopo(inttext)); return LIBRO; }
{LIB}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return LIBRO; }
{ROM}{S}{LIB}			{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvRomanoPrima(inttext)); return LIBRO; }
{ORD}{S}{LIB}			{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return LIBRO; }

{PAR}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvRomanoDopo(inttext)); return PARTE; }
{PAR}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return PARTE; }
{ROM}{S}{PAR}/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvRomanoPrima(inttext)); return PARTE; }
{ORD}{S}{PAR}/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return PARTE; }

{TIT}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvRomanoDopo(inttext)); return TITOLO; }
{TIT}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return TITOLO; }
{ROM}{S}{TIT}			{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvRomanoPrima(inttext)); return TITOLO; }
{ORD}{S}{TIT}			{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return TITOLO; }

{CAPOV}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
								intlval=(int)strdup(utilConvCardinale(inttext,1)); return CAPOVERSO; }
{CAPOV}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvOrdinale(inttext,1)); return CAPOVERSO; }
{N}{PTO}?{S}{CAPOV}			{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvCardinale(inttext,1)); return CAPOVERSO; }
{ORD}{LAT}?{S}{CAPOV}		{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvOrdinale(inttext,1)); return CAPOVERSO; }

{CAP}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvRomanoDopo(inttext)); return CAPO; }
{CAP}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return CAPO; }
{ROM}{S}{CAP}/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvRomanoPrima(inttext)); return CAPO; }
{ORD}{S}{CAP}/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return CAPO; }

{SEZ}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvRomanoDopo(inttext)); return SEZIONE; }
{SEZ}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return SEZIONE; }
{ROM}{S}{SEZ}			{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvRomanoPrima(inttext)); return SEZIONE; }
{ORD}{S}{SEZ}			{ BEGIN(sudd); salvaIntpos(); 
						intlval=(int)strdup(utilConvOrdinale(inttext,0)); return SEZIONE; }

{ART}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
								intlval=(int)strdup(utilConvCardinale(inttext,0)); return ARTICOLO; }
{ART}{S}{ORD}{LAT}?			{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvOrdinale(inttext,0)); return ARTICOLO; }
{N}{PTO}?{S}{ART}			{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvCardinale(inttext,0)); return ARTICOLO; }
{ORD}{S}{ART}				{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvOrdinale(inttext,0)); return ARTICOLO; }
{COM}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaIntpos(); 
								intlval=(int)strdup(utilConvCardinale(inttext,0)); return COMMA; }
{COM}{S}{ORD}{LAT}?			{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvOrdinale(inttext,0)); return COMMA; }
{N}{PTO}?{S}{COM}			{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvCardinale(inttext,0)); return COMMA; }
{ORD}{S}{COM}				{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvOrdinale(inttext,0)); return COMMA; }

{LET}{S}[a-z][a-z]?{LAT}?\)?	{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilCalcLettera(inttext)); return LETTERA; }

{NUM}{S}{N}({PTO}|\))?{LAT}?	salvaIntpos(); intlval=(int)strdup(utilConvCardinale(inttext,0)); return NUMERO;
{NUM}{S}{ORD}{LAT}?			salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,0)); return NUMERO;
{N}{PTO}{S}{NUM}{SPA}		{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvCardinale(inttext,0)); return NUMERO; }
{ORD}{S}{NUM}				{ BEGIN(sudd); salvaIntpos(); 
							intlval=(int)strdup(utilConvOrdinale(inttext,0)); return NUMERO; }

<sudd>(del(la|lo)?{SPA}(cit(\.|at[ao])|medesim[ao]|stess[ao]|predett[ao]))	{ intpos+=intleng; return CITATO; }

<sudd>della{SPA}			intpos+=intleng; return DELLA;
<sudd>dell{SPA}			intpos+=intleng; return DELL;
<sudd>del{SPA}				intpos+=intleng; return DEL;

[a-z0-9_]+				{ BEGIN(0); intpos+=intleng; intlval=(int)strdup(inttext); 
							if (!salto) { salto = 1; return BREAK; } }
[#]+						{ BEGIN(0); intpos+=intleng; intlval=(int)strdup(inttext); 
							if (!salto) { salto = 1; return BREAK; } }

{SPA}					intpos+=intleng;
\.						{ BEGIN(0); intpos++; intlval=(int)strdup(inttext); 
						if (!salto) { salto = 1; return BREAK; } }

.						intpos++;

%%


