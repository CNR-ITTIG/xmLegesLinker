/******************************************************************************
* Project:		xmLeges
* Module:		Linker
* File:			interni.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:		GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:		PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
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
char* token;

void salvaIntpos() {
	salto = 0;
	urnTmp.ultimo = intpos;
	if (intpos < urnTmp.inizio)
		urnTmp.inizio = intpos;
	intpos += intleng;
	if (intpos > urnTmp.fine)
		urnTmp.fine = intpos;
}

void levaPrec() {
	token = strdup(inttext);
	utilCompact(token);
	utilSostStr(token, "precedente ","");
	utilSostStr(token, "successivo ","");
	utilSostStr(token, "successiva ","");
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
SPA		([ ]+)
PS		(\.|{SPA})
S		({SPA}*)
ST		({S}([\-]?){S})
SVB		({S}([\-,\/]?){S})
PTO		(\^|(\.?[oa]))

N		([0-9]+)
N12		([0-9]{1,2})
N4		([0-9]{4})

CONN	({S}del(la|lo|l)?{SPA})
PRSU	(precedente|successiv[oa])
CITAT	((gi.'?{SPA})?(cit(\.|at[ao])|medesim[ao]|stess[ao]|predett[ao]|{PRSU}))

LIB		(libro)
PAR		(parte|pt{PS}|p{PS})
TIT		(titolo|tit{PS})
CAP		(capo)
SEZ		(sezione|sez{PS})
ART		(articolo|art{PS})
COM		(comma|com{PS}|co?\.)
CAPOV	(capoverso|cpv{PS})
LET		(lettera|lett?{PS})
NUM		(numero|num{PS}|nr?{PS}|n\.o)

LAT39	(ter|quater|quinquies|sexies|septies|octies|novies)
LAT29	(bis|{LAT39})
LAT12	(un|duo)
LATX10	(decies|(de)?vicies)
LAT1129	(({LAT12}|{LAT39})?{ST}{LATX10})
LAT2129	(vicies{ST}(semel|{LAT29}))
LAT		({ST}({LAT29}|{LAT1129}|{LAT2129}))

ORD	((prim|second|terz|quart|quint|sest|settim|ottav|non|decim|(undic|dodic|tredic|quattordic|quindic|sedic|diciassett|diciott|diciannov|vent)esim)+[oa])

ROM	([ivx]+)

GU		(gazzetta{SPA}ufficiale|g\.?{S}u\.?)
REP		((della{SPA})?(repubblica|rep{PS}){SPA}(italiana|it{PS}))
GUREP	({GU}({S}{REP})?)
SUPO_E	((supplemento|suppl{PS}|s{PS}){S}(ordinario|ord{PS}|o{PS}))
SUPO	({SUPO_E}|so{PS})
SERG_E	((serie|s{PS}){S}(generale|gen{PS}|g{PS}))
SERG	({SERG_E}|sg{PS})

%s	sudd

%%

   /* =================================================== FALSI RIFERIMENTI ========================================== */

({GUREP}{S}{NUM}{S}{N})					|
({GUREP}({ST}{SUPO})?{ST}+{NUM}{S}{N})	|
({SUPO_E}{ST}{NUM}{S}{N})				|
({GUREP}({ST}{SERG})?{ST}{NUM}{S}{N})	|
({SERG_E}{ST}{NUM}{S}{N})				|
((protocollo|prot{PS}){S}{NUM}{S}{N})	|
((registro|foglio){SPA}+{NUM}{S}{N})	intpos+=intleng; return BREAK;

   /* =================================================== SUDDIVISIONI ========================================== */
   /* ***********************
    * LIBRO                 *
    * ***********************/
{LIB}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoDopo(inttext)); return LIBRO;
{ROM}{S}{LIB}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoPrima(inttext)); return LIBRO;
{LIB}{S}{ORD}{LAT}?				|
{ORD}{S}{LIB}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,0)); return LIBRO;
   /* ***********************
    * PARTE                 *
    * ***********************/
{PAR}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoDopo(inttext)); return PARTE;
{ROM}{S}{PAR}/{NOAN}			BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoPrima(inttext)); return PARTE;
{ORD}{S}{PAR}/{NOAN}			|
{PAR}{S}{ORD}{LAT}?				BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,0)); return PARTE;
   /* ***********************
    * TITOLO                *
    * ***********************/
{TIT}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoDopo(inttext)); return TITOLO;
{ROM}{S}{TIT}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoPrima(inttext)); return TITOLO;
{TIT}{S}{ORD}{LAT}?				|
{ORD}{S}{TIT}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,0)); return TITOLO;
   /* ***********************
    * CAPOVERSO             *
    * ***********************/
{CAPOV}{S}{N}{PTO}?{LAT}?/{NOAN}	|
{N}{PTO}?{S}{CAPOV}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvCardinale(inttext,1)); return CAPOVERSO;
{CAPOV}{S}{ORD}{LAT}?				|
{ORD}{LAT}?{S}{CAPOV}				BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,1)); return CAPOVERSO;
   /* ***********************
    * CAPO                  *
    * ***********************/
{CAP}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoDopo(inttext)); return CAPO;
{ROM}{S}{CAP}/{NOAN}			BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoPrima(inttext)); return CAPO;
{ORD}{S}{CAP}/{NOAN}			|
{CAP}{S}{ORD}{LAT}?				BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,0)); return CAPO;
   /* ***********************
    * SEZIONE               *
    * ***********************/
{SEZ}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoDopo(inttext)); return SEZIONE;
{ROM}{S}{SEZ}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvRomanoPrima(inttext)); return SEZIONE;
{SEZ}{S}{ORD}{LAT}?				|
{ORD}{S}{SEZ}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,0)); return SEZIONE;
   /* ***********************
    * ARTICOLO              *
    * ***********************/
({PRSU}{S})?{ART}{S}{N}{PTO}?{LAT}?/{NOAN}	|
({PRSU}{S})?{N}{PTO}?{S}{ART}				BEGIN(sudd); salvaIntpos(); levaPrec(); intlval=(int)strdup(utilConvCardinale(token,0)); return ARTICOLO;
({PRSU}{S})?{ART}{S}{ORD}{LAT}?				|
({PRSU}{S})?{ORD}{S}{ART}					BEGIN(sudd); salvaIntpos(); levaPrec(); intlval=(int)strdup(utilConvOrdinale(token,0)); return ARTICOLO;
{ART}{S}{PRSU}								|
{PRSU}{S}{ART}								BEGIN(sudd); salvaIntpos(); intlval=(int)"0"; return ARTICOLO;
   /* ***********************
    * COMMA                 *
    * ***********************/
{PRSU}{S}{COM}/{S}i{SPA}					BEGIN(sudd); salvaIntpos(); intlval=(int)"0"; return COMMA;	// falso rif.
({PRSU}{S})?{COM}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaIntpos(); levaPrec(); intlval=(int)strdup(utilConvRomanoDopo(token)); return COMMA;
({PRSU}{S})?{ROM}{S}{COM}					BEGIN(sudd); salvaIntpos(); levaPrec(); intlval=(int)strdup(utilConvRomanoPrima(token)); return COMMA;
({PRSU}{S})?{COM}{S}{N}{PTO}?{LAT}?/{NOAN}	|
({PRSU}{S})?{N}{PTO}?{S}{COM}				BEGIN(sudd); salvaIntpos(); levaPrec(); intlval=(int)strdup(utilConvCardinale(token,0)); return COMMA;
({PRSU}{S})?{COM}{S}{ORD}{LAT}?				|
({PRSU}{S})?{ORD}{S}{COM}					BEGIN(sudd); salvaIntpos(); levaPrec(); intlval=(int)strdup(utilConvOrdinale(token,0)); return COMMA;
{COM}{S}{PRSU}								|
{PRSU}{S}{COM}								BEGIN(sudd); salvaIntpos(); intlval=(int)"0"; return COMMA;
   /* ***********************
    * LETTERA               *
    * ***********************/
({PRSU}{S})?{LET}{S}[a-z][a-z]?{LAT}?\)?	BEGIN(sudd); salvaIntpos(); levaPrec(); intlval=(int)strdup(utilCalcLettera(token)); return LETTERA;
{PRSU}{S}{LET}								|
{LET}{S}{PRSU}								BEGIN(sudd); salvaIntpos(); intlval=(int)"0"; return LETTERA;
   /* ***********************
    * NUMERO                *
    * ***********************/
{NUM}{S}{N}({PTO}|\))?{LAT}?	|
{N}{PTO}{S}{NUM}{SPA}			BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvCardinale(inttext,0)); return NUMERO;
{NUM}{S}{ORD}{LAT}?				|
{ORD}{S}{NUM}					BEGIN(sudd); salvaIntpos(); intlval=(int)strdup(utilConvOrdinale(inttext,0)); return NUMERO;

{SPA}							intpos+=intleng;
<sudd>({SPA}e{SPA}seguenti)		intpos+=intleng;
<sudd>{CONN}					intpos+=intleng;
<sudd>{CITAT}					intpos+=intleng;
   /* *******************************
    * NON SIGNIFICATIVI             *
    * *******************************/
[a-z0-9_]+						|
[#]+							|
\.								BEGIN(0); intpos+=intleng; if (!salto) { salto = 1; return BREAK; }

.								intpos++;

%%


