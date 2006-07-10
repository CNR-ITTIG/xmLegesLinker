/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		noncompleti.lex
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
#include "noncompleti.tab.h"
#include "parser.h"
#include "urn.h"

long int nocpos;
extern urn urnTmp;

// typedef int YYSTYPE;
extern YYSTYPE noclval;

int salti = 1;

void salvaNocPos() {
	salti = 0;
	urnTmp.ultimo = nocpos;
	if (nocpos < urnTmp.inizio)
		urnTmp.inizio = nocpos;
	nocpos += nocleng;
	if (nocpos > urnTmp.fine)
		urnTmp.fine = nocpos;
}
/* ------------------------------------------------

UE	(cee|c\.e\.e\.|u\.?e\.?|unione{S}europea|comunita{S}economica{S}europea|e\.c\.c\.)
ROM	([ivxlcdm]+)	con 'l' riconosce "il capo"

DETER	(determinazione|determ{PS})
{DETER}			BEGIN(0); salvaNocPos(); return DETERMINA_GEN;

------------------------------------------------ */
//NUM	(numero|num{PS}|n\.?o?)
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

DELIB	(delibera(zione)?|delib{PS})
PROVD	(provvedimento|provv{PS})
STATU	(statuto)
DISEG	((disegno|progetto|proposta){SPA}di)
MIN		(ministeriale|ministero|ministro|min{PS})
TU_E		(testo{SPA}unico|t{PS}u{PS})
TU_1		(tu)
TU		({TU_E}|{TU_1})

DECRETO_E	(decreto|decr{PS})
DECRETO_1	(d{PS})
DECRETO	({DECRETO_E}|{DECRETO_1})
DECRMIN	(d{PS}m{PS}|dm)
LEG		(legge|l{PS})
LGS		(legislativo|legisl{PS}|lgs{PS}vo|lgs{PS}|lgvo?|l{PS}vo)
REGIO	(regio|r{PS})

COD_E	(codice|cod{PS})
COD_1	(c{PS})
COD		({COD_E}|{COD_1})
CIV		(civile|civ{PS}|c{PS})
PEN		(penale|pen{PS}|p{PS})
PRO		(procedura|proc{PS}|p{PS})
ODZ_E	(ordinanza|ord{PS})
ODZ_1	(o{PS})
ODZ		({ODZ_E}|{ODZ_1})

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

(codice{SPA}(binario|fiscale|identificativo|sorgente))			nocpos+=nocleng; return BREAK;
((da|per){SPA}(legge|decreto|regolamento))					nocpos+=nocleng; return BREAK;
((effett[oi]|fin[ei]|norm[ae]){SPA}di{SPA}legge)				nocpos+=nocleng; return BREAK;
(legge{SPA}(italiana|(dello{SPA}stato)))					nocpos+=nocleng; return BREAK;
((disposizion[ei]|valore){SPA}di{SPA}legge)					nocpos+=nocleng; return BREAK;
((presente|seguente){SPA}(codice|legge|decreto|regolamento|testo{SPA}unico))	nocpos+=nocleng; return BREAK;
((u|ca)s[oi]{SPA}(consentit|indicat)[oi]{SPA}dalla{SPA}legge)	nocpos+=nocleng; return BREAK;
((decreto|provvedimento|regolamento){SPA}di{SPA}cui)			nocpos+=nocleng; return BREAK;

{LIB}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvRomanoDopo(noctext)); return LIBRO; }
{LIB}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return LIBRO; }
{ROM}{S}{LIB}			{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvRomanoPrima(noctext)); return LIBRO; }
{ORD}{S}{LIB}			{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return LIBRO; }

{PAR}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvRomanoDopo(noctext)); return PARTE; }
{PAR}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return PARTE; }
{ROM}{S}{PAR}/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvRomanoPrima(noctext)); return PARTE; }
{ORD}{S}{PAR}/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return PARTE; }

{TIT}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvRomanoDopo(noctext)); return TITOLO; }
{TIT}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return TITOLO; }
{ROM}{S}{TIT}			{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvRomanoPrima(noctext)); return TITOLO; }
{ORD}{S}{TIT}			{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return TITOLO; }

{CAPOV}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
								noclval=(int)strdup(utilConvCardinale(noctext,1)); return CAPOVERSO; }
{CAPOV}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvOrdinale(noctext,1)); return CAPOVERSO; }
{N}{PTO}?{S}{CAPOV}			{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvCardinale(noctext,1)); return CAPOVERSO; }
{ORD}{LAT}?{S}{CAPOV}		{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvOrdinale(noctext,1)); return CAPOVERSO; }

{CAP}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvRomanoDopo(noctext)); return CAPO; }
{CAP}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return CAPO; }
{ROM}{S}{CAP}/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvRomanoPrima(noctext)); return CAPO; }
{ORD}{S}{CAP}/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return CAPO; }

{SEZ}{S}{ROM}{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvRomanoDopo(noctext)); return SEZIONE; }
{SEZ}{S}{ORD}{LAT}?		{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return SEZIONE; }
{ROM}{S}{SEZ}			{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvRomanoPrima(noctext)); return SEZIONE; }
{ORD}{S}{SEZ}			{ BEGIN(sudd); salvaNocPos(); 
						noclval=(int)strdup(utilConvOrdinale(noctext,0)); return SEZIONE; }

{ART}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
								noclval=(int)strdup(utilConvCardinale(noctext,0)); return ARTICOLO; }
{ART}{S}{ORD}{LAT}?			{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvOrdinale(noctext,0)); return ARTICOLO; }
{N}{PTO}?{S}{ART}			{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvCardinale(noctext,0)); return ARTICOLO; }
{ORD}{S}{ART}				{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvOrdinale(noctext,0)); return ARTICOLO; }
{COM}{S}{N}{PTO}?{LAT}?/{NOAN}	{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvCardinale(noctext,0)); return COMMA; }
{COM}{S}{ORD}{LAT}?			{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvOrdinale(noctext,0)); return COMMA; }
{N}{PTO}?{S}{COM}			{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvCardinale(noctext,0)); return COMMA; }
{ORD}{S}{COM}				{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvOrdinale(noctext,0)); return COMMA; }

{LET}{S}[a-z][a-z]?{LAT}?\)?	{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilCalcLettera(noctext)); return LETTERA; }

{NUM}{S}{N}{PTO}?{LAT}?		salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO;
{NUM}{S}{ORD}{LAT}?			salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return NUMERO;
{N}{PTO}{S}{NUM}{SPA}		{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO; }
{ORD}{S}{NUM}				{ BEGIN(sudd); salvaNocPos(); 
							noclval=(int)strdup(utilConvOrdinale(noctext,0)); return NUMERO; }

{PARA}{S}{N}			BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(noctext); return PARAGRAFO;
{ORD}{S}{PARA}			BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(noctext); return PARAGRAFO;
{ORD}{S}{PERIO}		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(noctext); return PERIODO;

cost(\.|ituz(\.|ione))? 	BEGIN(0); salvaNocPos(); return COSTITUZIONE;

{DECRETO}({ST}del{ST})?{PRES}({ST}del{ST})?{CONS}({ST}dei{ST})?{MINIS}	{ BEGIN(atto); salvaNocPos();
												return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DECRETO}{ST}{PRES}{ST}{CONS}{ST}{MINIS}			{ BEGIN(atto); salvaNocPos(); 
												return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI; }

d[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?				{ BEGIN(atto); salvaNocPos();
												return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DIR}({ST}del{ST})?{PRES}({ST}del{ST})?{CONS}({ST}dei{ST})?{MINIS}	{ BEGIN(atto); salvaNocPos(); 
												return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DIR}{ST}{PRES}{ST}{CONS}{ST}{MINIS}			{ BEGIN(atto); salvaNocPos();
											return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI; }

dir[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?			{ BEGIN(atto); salvaNocPos();
											return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{ODZ}({ST}del{ST})?{PRES}({ST}del{ST})?{CONS}({ST}dei{ST})?{MINIS}	{ BEGIN(atto); salvaNocPos(); 
											return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{ODZ}{ST}{PRES}{ST}{CONS}{ST}{MINIS}			{ BEGIN(atto); salvaNocPos();
											return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

ord[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?			{ BEGIN(atto); salvaNocPos();
											return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

o[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?			{ BEGIN(atto); salvaNocPos();
											return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI; }

{DECRETO}{ST}(del{ST})?{PRES}{ST}(della{ST})?repubblica	{ BEGIN(atto); salvaNocPos(); 
													return DECRETO_PRESIDENTE_REPUBBLICA; }

d[\.]?{ST}p[\.]?{ST}r[\.]? 			{ BEGIN(atto); salvaNocPos(); 
									return DECRETO_PRESIDENTE_REPUBBLICA; }

{DECRETO}{ST}(del{ST})?{MIN}			{ BEGIN(atto); salvaNocPos(); 
									return DECRETO_MINISTERIALE; }

{DECRMIN}{ST}(del{ST})?{MIN}?			{ BEGIN(atto); salvaNocPos(); 
									return DECRETO_MINISTERIALE; }

{REGIO}{ST}{DECRETO}{ST}{LGS}		{ BEGIN(atto); salvaNocPos(); 
								return REGIO_DECRETO_LEGISLATIVO; }
r\.d\.l\.						BEGIN(atto); salvaNocPos(); return REGIO_DECRETO_LEGGE;
{REGIO}{ST}{DECRETO}{ST}{LEG}		BEGIN(atto); salvaNocPos(); return REGIO_DECRETO_LEGGE;
{REGIO}{ST}{DECRETO}			BEGIN(atto); salvaNocPos(); return REGIO_DECRETO;

{LEG}{ST}{RGN}				BEGIN(atto); salvaNocPos(); return LEGGE_REGIONALE;
{REGOLAM}{ST}{RGN}			BEGIN(atto); salvaNocPos(); return REGOLAMENTO_REGIONALE;
{REGIONI}					{ BEGIN(atto); salvaNocPos(); 
							noclval=(int)strdup(noctext); return REGIONE; }

{DECRETO}{ST}{LGS}			BEGIN(atto); salvaNocPos(); return DECRETO_LEGISLATIVO;
{DECRETO}{ST}{LEG}			BEGIN(atto); salvaNocPos(); return DECRETO_LEGGE;
{DISEG}{S}{LEG}			BEGIN(atto); salvaNocPos(); return DISEGNO_LEGGE;
{LEG}{ST}{COST}			BEGIN(atto); salvaNocPos(); return LEGGE_COSTITUZIONALE;
{LEG}({S}{QLEG})?			BEGIN(atto); salvaNocPos(); return LEGGE;

{COD}{S}(di)?{S}{PRO}{S}{CIV}		BEGIN(0); salvaNocPos(); return CODICE_PROCEDURA_CIVILE;
{COD}{S}(di)?{S}{PRO}{S}{PEN}		BEGIN(0); salvaNocPos(); return CODICE_PROCEDURA_PENALE;
{COD}{S}{CIV}/{NOAN}			BEGIN(0); salvaNocPos(); return CODICE_CIVILE;
{COD}{S}{PEN}/{NOAN}			BEGIN(0); salvaNocPos(); return CODICE_PENALE;

{DIR}					BEGIN(atto); salvaNocPos(); return DIRETTIVA;
{DECI}					BEGIN(atto); salvaNocPos(); return DECISIONE;
{REGOLAM}					BEGIN(atto); salvaNocPos(); return REGOLAMENTO;
{REGOLAM}{S}{UE_P}			BEGIN(atto); salvaNocPos(); return REGOLAMENTO_UE;

{COD_E}			BEGIN(0); salvaNocPos(); return CODICE_GEN;
{DECRETO_E}		BEGIN(0); salvaNocPos(); return DECRETO_GEN;
{DELIB}			BEGIN(0); salvaNocPos(); return DELIBERA_GEN;
{ODZ_E}			BEGIN(0); salvaNocPos(); return ORDINANZA_GEN;
{PROVD}			BEGIN(0); salvaNocPos(); return PROVVEDIMENTO_GEN;
{STATU}			BEGIN(0); salvaNocPos(); return STATUTO_GEN;
{TU_E}			BEGIN(0); salvaNocPos(); return TESTO_UNICO_GEN;

<atto>{NUM}?{S}({UENUM_NA}|{UENUM_AN})		{ salvaNocPos(); noclval=(int)strdup(noctext); return UE_NUM; }
<atto>{UEDEN}				salvaNocPos(); return UE_DEN;
<atto>{PARLAM}				salvaNocPos(); return PARLAMENTO;
<atto>{CONS}				salvaNocPos(); return CONSIGLIO;
<atto>{COMMIS}				salvaNocPos(); return COMMISSIONE;

<sudd,atto>((del(la|lo)?{SPA})?(gi.'?{SPA})?(cit(\.|at[ao])|medesim[ao]|stess[ao]|predett[ao]))	{ nocpos+=nocleng; return CITATO; }

<sudd,atto>della{SPA}		nocpos+=nocleng; return DELLA;
<sudd,atto>dello{SPA}		nocpos+=nocleng; return DELLO;
<sudd,atto>dell{SPA}		nocpos+=nocleng; return DELL;
<sudd,atto>del{SPA}			nocpos+=nocleng; return DEL;
<atto>in{SPA}data			nocpos+=nocleng; return IN_DATA;
<atto>regione{SPA}			nocpos+=nocleng; return PAROLA_REGIONE;

<atto>{N12}[/\.-]{N12}[/\.-]({N4}|{N12})/[^0-9]	{ salvaNocPos(); noclval=(int)utilConvDataNumerica(noctext); 
											return DATA_GG_MM_AAAA; }

<atto>{N12}{ST}{MESI}{ST}({N4}|{N12})/[^0-9]		{ salvaNocPos(); noclval=(int)utilConvDataEstesa(noctext); 
											return DATA_GG_MM_AAAA; }

<atto>{N}			salvaNocPos(); noclval=(int)strdup(noctext); return NUMERO_CARDINALE;

<atto>[/]			nocpos++; noclval=(int)strdup(noctext); return BARRA;

<atto>{SPA}e{SPA}	nocpos+=nocleng; return E;

[a-z0-9_]+		{ BEGIN(0); nocpos+=nocleng; noclval=(int)strdup(noctext); 
					if (!salti) { salti = 1; return BREAK; } }
[#]+				{ BEGIN(0); nocpos+=nocleng; noclval=(int)strdup(noctext); 
					if (!salti) { salti = 1; return BREAK; } }

{SPA}			nocpos+=nocleng;
\.				{ BEGIN(0); nocpos++; noclval=(int)strdup(noctext); 
					if (!salti) { salti = 1; return BREAK; } }

.				nocpos++;

%%


