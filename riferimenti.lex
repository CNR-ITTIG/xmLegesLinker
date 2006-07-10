/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		riferimenti.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*			PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigLogger.h>
#include <IttigUtil.h>
#include "riferimenti.tab.h"
#include "parser.h"
#include "urn.h"

extern int pos;
extern urn urnTmp;

/*:
typedef int YYSTYPE;
extern YYSTYPE yylval;
*/

int salta = 1;

void salvaPos() 
{
	salta = 0;
	urnTmp.ultimo = pos;
	if (pos < urnTmp.inizio)
		urnTmp.inizio = pos;
	pos += yyleng;
	if (pos > urnTmp.fine)
		urnTmp.fine = pos;
}
/* ------------------------------------------------

UE	(cee|c\.e\.e\.|u\.?e\.?|unione{S}europea|comunita{S}economica{S}europea|e\.c\.c\.)
ROM	([ivxlcdm]+)	con 'l' riconosce "il capo"
NUM	(numero|num{PS}|n\.?o?)

------------------------------------------------ */
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

DECRETO	(decreto|decr{PS}|d{PS})
LEG		(legge|l{PS})
LGS		(legislativo|legisl{PS}|lgs{PS}vo|lgs{PS}|lgvo?|l{PS}vo)
REGIO	(regio|r{PS})

COD		(codice|cod{PS}|c{PS})
CIV		(civile|civ{PS}|c{PS})
PEN		(penale|pen{PS}|p{PS})
PRO		(procedura|proc{PS}|p{PS})
ODZ		(ordinanza|ord{PS}|o{PS})

REGOLAM	(regolamento|reg{PS}|r\.)
DIR		(direttiva|dir{PS}){SPA}
DECI		(decisione|dec{PS})

QLEG		(finanziaria|comunitaria|fallimentare|fall{PS})
COST		(costituzionale|cost{PS}|c{PS})
RGN		(regionale|reg{PS}|r{PS})
PROV		(provinciale|prov{PS}|p{PS})

PRES		(presidente|pres{PS}|p{PS})
PARLAM	(parlamento({SPA}europeo)?)
CONS		(consiglio|cons{PS}|c{PS})
MINIS	(ministri|min{PS}|m{PS})
COMMIS	(commissione|comm{PS})

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
PARA		(paragrafo|par{PS})
PERIO	(periodo|per{PS})


UE		(cee?|euratom|ceea|ceca)
UE_P		(\(?{UE}(({SVB}{UE}){1,2})?\)?)
UEDEN	(dell[ae']{S}(unione|comunit.'?){S}europe[ea])
UENUM_AN	(({N12}|{N4})\/{N}\/{UE}(({SVB}{UE}){1,2})?)
UENUM_NA	({N}\/({N12}|{N4})\/{UE}(({SVB}{UE}){1,2})?)

REGIONI	(abruzzo|basilicata|calabria|campania|lazio|liguria|lombardia|marche|molise|piemonte|puglia|sardegna|sicilia(na)?|toscana|umbria|veneto|v(\.|alle){S}d{S}'{S}aosta|(friuli(({ST}|{S}e{S})?{ST}venezia{ST}giulia)?))

MESI	(gennaio|gen|febbraio|feb|marzo|mar|aprile|apr|maggio|mag|giugno|giu|luglio|lug|agosto|ago|settembre|set|ottobre|ott|novembre|nov|dicembre|dic)

LAT09	(un|bis|duo|ter|quater|quinquies|sexies|septies|octies|novies)
LAT10	(decies|venies)
LAT		({ST}{LAT09}({LAT10})?)

ORD	((prim|second|terz|quart|quint|sest|settim|ottav|non|decim|(undic|dodic|tredic|quattordic|quindic|sedic|diciassett|diciott|diciannov|vent)esim)+[oa])

ROM	([ivx]+)

%s	sudd atto

%%

{LIB}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvRomanoDopo(yytext)); return LIBRO; }
{LIB}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return LIBRO; }
{ROM}{S}{LIB}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvRomanoPrima(yytext)); return LIBRO; }
{ORD}{S}{LIB}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return LIBRO; }

{PAR}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvRomanoDopo(yytext)); return PARTE; }
{PAR}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return PARTE; }
{ROM}{S}{PAR}/{NOAN}	{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvRomanoPrima(yytext)); return PARTE; }
{ORD}{S}{PAR}/{NOAN}	{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return PARTE; }

{TIT}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvRomanoDopo(yytext)); return TITOLO; }
{TIT}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return TITOLO; }
{ROM}{S}{TIT}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvRomanoPrima(yytext)); return TITOLO; }
{ORD}{S}{TIT}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return TITOLO; }

{CAPOV}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
								yylval=(int)strdup(utilConvCardinale(yytext,1)); return CAPOVERSO; }
{CAPOV}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvOrdinale(yytext,1)); return CAPOVERSO; }
{N}{PTO}?{S}{CAPOV}			{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvCardinale(yytext,1)); return CAPOVERSO; }
{ORD}{LAT}?{S}{CAPOV}		{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvOrdinale(yytext,1)); return CAPOVERSO; }

{CAP}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvRomanoDopo(yytext)); return CAPO; }
{CAP}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return CAPO; }
{ROM}{S}{CAP}/{NOAN}	{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvRomanoPrima(yytext)); return CAPO; }
{ORD}{S}{CAP}/{NOAN}	{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return CAPO; }

{SEZ}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvRomanoDopo(yytext)); return SEZIONE; }
{SEZ}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return SEZIONE; }
{ROM}{S}{SEZ}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvRomanoPrima(yytext)); return SEZIONE; }
{ORD}{S}{SEZ}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return SEZIONE; }

{ART}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
								yylval=(int)strdup(utilConvCardinale(yytext,0)); return ARTICOLO; }
{ART}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return ARTICOLO; }
{N}{PTO}?{S}{ART}		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvCardinale(yytext,0)); return ARTICOLO; }
{ORD}{S}{ART}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return ARTICOLO; }
{COM}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaPos(); 
								yylval=(int)strdup(utilConvCardinale(yytext,0)); return COMMA; }
{COM}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return COMMA; }
{N}{PTO}?{S}{COM}		{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvCardinale(yytext,0)); return COMMA; }
{ORD}{S}{COM}			{ BEGIN(sudd); salvaPos(); 
						yylval=(int)strdup(utilConvOrdinale(yytext,0)); return COMMA; }

{LET}{S}[a-z][a-z]?{LAT}?\)?		{ BEGIN(sudd); salvaPos(); 
								yylval=(int)strdup(utilCalcLettera(yytext)); return LETTERA; }

{NUM}{S}{N}{PTO}?{LAT}?		salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO;
{NUM}{S}{ORD}{LAT}?			salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return NUMERO;
{N}{PTO}{S}{NUM}{SPA}		{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO; }
{ORD}{S}{NUM}				{ BEGIN(sudd); salvaPos(); 
							yylval=(int)strdup(utilConvOrdinale(yytext,0)); return NUMERO; }

{PARA}{S}{N}			BEGIN(sudd); salvaPos(); yylval=(int)strdup(yytext); return PARAGRAFO;
{ORD}{S}{PARA}			BEGIN(sudd); salvaPos(); yylval=(int)strdup(yytext); return PARAGRAFO;
{ORD}{S}{PERIO}		BEGIN(sudd); salvaPos(); yylval=(int)strdup(yytext); return PERIODO;

cost(\.|ituz(\.|ione))? 	BEGIN(0); salvaPos(); return COSTITUZIONE;

{DECRETO}({ST}del{ST})?{PRES}({ST}del{ST})?{CONS}({ST}dei{ST})?{MINIS}	{ BEGIN(atto); salvaPos();
										return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DECRETO}{ST}{PRES}{ST}{CONS}{ST}{MINIS}	{ BEGIN(atto); salvaPos(); 
										return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI; }

d[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?		{ BEGIN(atto); salvaPos();
										return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DIR}({ST}del{ST})?{PRES}({ST}del{ST})?{CONS}({ST}dei{ST})?{MINIS}	{ BEGIN(atto); salvaPos(); 
										return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DIR}{ST}{PRES}{ST}{CONS}{ST}{MINIS}		{ BEGIN(atto); salvaPos();
										return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI; }

dir[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?		{ BEGIN(atto); salvaPos();
										return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{ODZ}({ST}del{ST})?{PRES}({ST}del{ST})?{CONS}({ST}dei{ST})?{MINIS}	{ BEGIN(atto); salvaPos(); 
										return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{ODZ}{ST}{PRES}{ST}{CONS}{ST}{MINIS}		{ BEGIN(atto); salvaPos();
										return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

ord[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?		{ BEGIN(atto); salvaPos();
										return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

o[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?		{ BEGIN(atto); salvaPos();
										return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DECRETO}{ST}(del{ST})?{PRES}{ST}(della{ST})?repubblica	{ BEGIN(atto); salvaPos(); 
													return DECRETO_PRESIDENTE_REPUBBLICA; }

d[\.]?{ST}p[\.]?{ST}r[\.]? 							{ BEGIN(atto); salvaPos(); 
													return DECRETO_PRESIDENTE_REPUBBLICA; }

{REGIO}{ST}{DECRETO}{ST}{LGS}		{ BEGIN(atto); salvaPos(); 
								return REGIO_DECRETO_LEGISLATIVO; }
r\.d\.l\.						BEGIN(atto); salvaPos(); return REGIO_DECRETO_LEGGE;
{REGIO}{ST}{DECRETO}{ST}{LEG}		BEGIN(atto); salvaPos(); return REGIO_DECRETO_LEGGE;
{REGIO}{ST}{DECRETO}			BEGIN(atto); salvaPos(); return REGIO_DECRETO;

{LEG}{ST}{RGN}				BEGIN(atto); salvaPos(); return LEGGE_REGIONALE;
{REGOLAM}{ST}{RGN}			BEGIN(atto); salvaPos(); return REGOLAMENTO_REGIONALE;
{REGIONI}					{ BEGIN(atto); salvaPos(); 
							yylval=(int)strdup(yytext); return REGIONE; }

{DECRETO}{ST}{LGS}			BEGIN(atto); salvaPos(); return DECRETO_LEGISLATIVO;
{DECRETO}{ST}{LEG}			BEGIN(atto); salvaPos(); return DECRETO_LEGGE;
{LEG}{ST}{COST}			BEGIN(atto); salvaPos(); return LEGGE_COSTITUZIONALE;
{LEG}({S}{QLEG})?			BEGIN(atto); salvaPos(); return LEGGE;

{COD}{S}(di)?{S}{PRO}{S}{CIV}		BEGIN(0); salvaPos(); return CODICE_PROCEDURA_CIVILE;
{COD}{S}(di)?{S}{PRO}{S}{PEN}		BEGIN(0); salvaPos(); return CODICE_PROCEDURA_PENALE;
{COD}{S}{CIV}/{NOAN}			BEGIN(0); salvaPos(); return CODICE_CIVILE;
{COD}{S}{PEN}/{NOAN}			BEGIN(0); salvaPos(); return CODICE_PENALE;

{DIR}					BEGIN(atto); salvaPos(); return DIRETTIVA;
{DECI}					BEGIN(atto); salvaPos(); return DECISIONE;
{REGOLAM}					BEGIN(atto); salvaPos(); return REGOLAMENTO;
{REGOLAM}{S}{UE_P}			BEGIN(atto); salvaPos(); return REGOLAMENTO;

<atto>{NUM}?{S}({UENUM_NA}|{UENUM_AN})		{ salvaPos(); yylval=(int)strdup(yytext); return UE_NUM; }
<atto>{UEDEN}				salvaPos(); return UE_DEN;
<atto>{PARLAM}				salvaPos(); return PARLAMENTO;
<atto>{CONS}				salvaPos(); return CONSIGLIO;
<atto>{COMMIS}				salvaPos(); return COMMISSIONE;

<sudd,atto>((del(la|lo)?{SPA})?(gi.'?{SPA})?(cit(\.|at[ao])|medesim[ao]|stess[ao]|predett[ao]))	{ pos+=yyleng; return CITATO; }

<sudd,atto>della{SPA}		pos+=yyleng; return DELLA;
<sudd,atto>dello{SPA}		pos+=yyleng; return DELLO;
<sudd,atto>dell{SPA}		pos+=yyleng; return DELL;
<sudd,atto>del{SPA}			pos+=yyleng; return DEL;
<atto>in{SPA}data			pos+=yyleng; return IN_DATA;
<atto>regione{SPA}			pos+=yyleng; return PAROLA_REGIONE;

<atto>{N12}[/\.-]{N12}[/\.-]({N4}|{N12})/[^0-9]	{ salvaPos(); yylval=(int)utilConvDataNumerica(yytext); 
											return DATA_GG_MM_AAAA; }

<atto>{N12}{ST}{MESI}{ST}({N4}|{N12})/[^0-9]		{ salvaPos(); yylval=(int)utilConvDataEstesa(yytext); 
											return DATA_GG_MM_AAAA; }

<atto>{N}				salvaPos(); yylval=(int)strdup(yytext); return NUMERO_CARDINALE;

<atto>[/]				pos++; yylval=(int)strdup(yytext); return BARRA;

<atto>{SPA}e{SPA}		pos+=yyleng; return E;

[a-z0-9_]+			{ BEGIN(0); pos+=yyleng; yylval=(int)strdup(yytext); 
						if (!salta) { salta = 1; return BREAK; } }
[#]+					{ BEGIN(0); pos+=yyleng; yylval=(int)strdup(yytext); 
						if (!salta) { salta = 1; return BREAK; } }

{SPA}				pos+=yyleng;
\.					{ BEGIN(0); pos++; yylval=(int)strdup(yytext); 
						if (!salta) { salta = 1; return BREAK; } }

.					pos++;

%%


