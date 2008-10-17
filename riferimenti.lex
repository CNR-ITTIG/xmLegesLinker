/******************************************************************************
* Project:		xmLeges
* Module:		Linker
* File:			riferimenti.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:		GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:		Mirco Taddei (m.taddei@ittig.cnr.it)
*				PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
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
CONTAB	(contabilit(\xc3\xa0|\&agrave;|\xe0))
CONTAB	(contabilit((a\'?)|(\xe0)|(\xc3\xa0)))

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

ULTIMO	((pen|terz)?ultim(a|o))
UNICO 	(unico)

CONN1	({S}del(la|lo|l)?{SPA})
CONN2	({S}d(i|ei|gli){SPA})
CONN	({CONN1}|{CONN2})
INDAT	({S}in{SPA}data)
CITAT	((del(la|lo)?{SPA})?(gi.'?{SPA})?(cit(\.|at[ao])|medesim[ao]|stess[ao]|predett[ao]))

PROVD	(provvedimento|provv{PS})
STATU	(statuto)

DECR_E	(decreto|decr{PS})
DECR_1	(d{PS})
DECRETO	({DECR_E}|{DECR_1})
LEG		(legge|l{PS})
LGS		(legislativo|legisl{PS}|lgs{PS}vo|lgs{PS}|lgvo?|l{PS}vo)
REGIO	(regio|r{PS})

COD		(codice|cod{PS}|c{PS})
CIV		(civile|civ{PS}|c{PS})
PEN		(penale|pen{PS}|p{PS})
PRO		(procedura|proc{PS}|p{PS})
ODZ		(ordinanza|ord{PS}|o{PS})

REGOLAM	(regol({PS}|amento)|reg{PS}|r\.)
DIR		(direttiva|dir{PS}){SPA}
DECI	(decisione|dec{PS})

QLEG	(finanziaria|comunitaria|fallimentare|fall{PS}|urbanistica)
STATO	(statale|(dello{SPA})?stato)
COST	(costituzionale|cost{PS}|c{PS})
RGN		(regionale|reg{PS}|r{PS})
PROV	(provinciale|prov{PS}|p{PS})

PRES	(presidente|pres{PS}|p{PS})
REPUB	(repubblica)
PARLAM	(parlamento({SPA}europeo)?)
CONS	(consiglio|cons{PS}|c{PS})
MINIS	(ministri|min{PS}|m{PS})
COMIN	({CONS}({ST}dei)?{ST}{MINIS})
COMMIS	(commissione|comm{PS})

PROP	(proposta{SPA}di)
DELIB	(delibera(zione)?|delib{PS})
COMUNAL	(comunale|com{PS}|municipale)
CONSIL	(consiliare)
GIUNTA	(giunta)

PRORD	(provvedimento{S}ordinamentale)
CNR		(({CONS}{S}nazionale{S}(delle)?{S}ricerche)|(c{PS}?n{PS}?r{PS}?))
DIRET	(direttore|dir{PS})
GENER	(generale|gen{PS})
DIRGEN	({DIRET}{S}{GENER}|d{PS}g{PS}|dg)
COMSTR	(commissario({S}straordinario)?)

EDILIZ	(edilizi(o|a))
POLIZ	((polizia({S}municipale)?)|(p\.?m\.?))
QUARTI	((consiglio?({S}di)?{S}quartiere)|(c\.?d\.?q\.?))
CONTAB	(contabilit..)

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
PARA	(paragrafo|par{PS})
PERIO	(periodo|per{PS})
PUNTO	(punto|trattino)

UE			(cee?|euratom|ceea|ceca)
UE_P		(\(?{UE}(({SVB}{UE}){1,2})?\)?)
UEDEN		(dell[ae']{S}(unione|comunit.'?){S}europe[ea])
EUROP		(europe[ao])
UENUM_AN	(({N12}|{N4})\/{N}(\/|{S}){UE}(({SVB}{UE}){1,2})?)
UENUM_NA	({N}\/({N12}|{N4})(\/|{S}){UE}(({SVB}{UE}){1,2})?)
UENUM		({NUM}?{S}({UENUM_NA}|{UENUM_AN}))	

REGIONI1	(abruzzo|basilicata|calabria|campania|emilia{ST}romagna|lazio|liguria|lombardia|marche|molise)
REGIONI2	(piemonte|puglia|sardegna|sicilia(na)?|toscana|umbria|veneto|v(\.|alle){S}d{S}'{S}aosta)
REGIONI3	((friuli(({ST}|{S}e{S})?{ST}venezia{ST}giulia)?))
REGIONI		({REGIONI1}|{REGIONI2}|{REGIONI3})
CONNREG		({CONN}?{S}{REGIONI})

MESI_E	(gennaio|febbraio|marzo|aprile|maggio|giugno|luglio|agosto|settembre|ottobre|novembre|dicembre)
MESI_3	(gen|feb|mar|apr|mag|giu|lug|ago|set|ott|nov|dic)
MESI	({MESI_E}|{MESI_3})

LAT39	(ter|quater|quinquies|sexies|septies|octies|novies)
LAT29	(bis|{LAT39})
LAT12	(un|duo)
LATX10	(decies|(de)?vicies)
LAT1129	(({LAT12}|{LAT39})?{ST}{LATX10})
LAT2129	(vicies{ST}(semel|{LAT29}))
LAT		({ST}({LAT29}|{LAT1129}|{LAT2129}))

ORD	((prim|second|terz|quart|quint|sest|settim|ottav|non|decim|(undic|dodic|tredic|quattordic|quindic|sedic|diciassett|diciott|diciannov|vent)esim)+[oa])

ROM	([ivx]+)

%s	sudd atto
%x	data nume

%%

   /* =================================================== SUDDIVISIONI ========================================== */
   /* ***********************
    * LIBRO                 *
    * ***********************/
{LIB}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoDopo(yytext)); return LIBRO;
{ROM}{S}{LIB}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoPrima(yytext)); return LIBRO;
{LIB}{S}{ORD}{LAT}?				|
{ORD}{S}{LIB}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return LIBRO;
   /* ***********************
    * PARTE                 *
    * ***********************/
{PAR}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoDopo(yytext)); return PARTE;
{ROM}{S}{PAR}/{NOAN}			BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoPrima(yytext)); return PARTE;
{ORD}{S}{PAR}/{NOAN}			|
{PAR}{S}{ORD}{LAT}?				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return PARTE;
   /* ***********************
    * TITOLO                *
    * ***********************/
{TIT}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoDopo(yytext)); return TITOLO;
{ROM}{S}{TIT}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoPrima(yytext)); return TITOLO;
{TIT}{S}{ORD}{LAT}?				|
{ORD}{S}{TIT}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return TITOLO;
   /* ***********************
    * CAPOVERSO             *
    * ***********************/
{CAPOV}{S}{N}{PTO}?{LAT}?/{NOAN}	|
{N}{PTO}?{S}{CAPOV}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,1)); return CAPOVERSO;
{CAPOV}{S}{ORD}{LAT}?				|
{ORD}{LAT}?{S}{CAPOV}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,1)); return CAPOVERSO;
   /* ***********************
    * CAPO                  *
    * ***********************/
{CAP}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoDopo(yytext)); return CAPO;
{ROM}{S}{CAP}/{NOAN}			BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoPrima(yytext)); return CAPO;
{ORD}{S}{CAP}/{NOAN}			|
{CAP}{S}{ORD}{LAT}?				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return CAPO;
   /* ***********************
    * SEZIONE               *
    * ***********************/
{SEZ}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoDopo(yytext)); return SEZIONE;
{ROM}{S}{SEZ}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoPrima(yytext)); return SEZIONE;
{SEZ}{S}{ORD}{LAT}?				|
{ORD}{S}{SEZ}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return SEZIONE;
   /* ***********************
    * ARTICOLO              *
    * ***********************/
{ART}{S}{N}{PTO}?{LAT}?/{NOAN}	|
{N}{PTO}?{S}{ART}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return ARTICOLO;
{ART}{S}{ORD}{LAT}?				|
{ORD}{S}{ART}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return ARTICORD;
{ART}{S}{ULTIMO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,2)); return ARTICULT;
{ULTIMO}{S}{ART}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,1)); return ARTICULT;
{ART}{S}{UNICO}					|
{UNICO}{S}{ART}					BEGIN(sudd); salvaPos(); yylval=(int)strdup("1"); return ARTICOLO;
   /* ***********************
    * COMMA                 *
    * ***********************/
{COM}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoDopo(yytext)); return COMMAORD;
{ROM}{S}{COM}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvRomanoPrima(yytext)); return COMMAORD;
{COM}{S}{N}{PTO}?{LAT}?/{NOAN}	|
{N}{PTO}?{S}{COM}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return COMMA;
{COM}{S}{ORD}{LAT}?				|
{ORD}{S}{COM}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return COMMAORD;
{COM}{S}{ULTIMO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,2)); return COMMAULT;
{ULTIMO}{S}{COM}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,1)); return COMMAULT;
   /* ***********************
    * LETTERA               *
    * ***********************/
{LET}{S}[a-z][a-z]?{LAT}?\)?	BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilCalcLettera(yytext)); return LETTERA;
{LET}{S}{ULTIMO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,2)); return LETTULT;
{ULTIMO}{S}{LET}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,1)); return LETTULT;
   /* ***********************
    * NUMERO                *
    * ***********************/
<INITIAL,sudd>{NUM}{S}{N}{PTO}?{LAT}?		BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO;
{N}{PTO}{S}{NUM}{SPA}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO;
{NUM}{S}{ORD}{LAT}?					|
{ORD}{S}{NUM}						BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return NUMORD;
{NUM}{S}{ULTIMO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,2)); return NUMULT;
{ULTIMO}{S}{NUM}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,1)); return NUMULT;
   /* ***********************
    * PUNTO                 *
    * ***********************/
{ORD}{S}{PUNTO}					|
{PUNTO}{S}{ORD}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return PUNTORD;
{ULTIMO}{S}{PUNTO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,1)); return PUNTULT;
{PUNTO}{S}{ULTIMO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,2)); return PUNTULT;
   /* ***********************
    * PARAGRAFO             *
    * ***********************/
{PARA}{S}{N}					|
{ORD}{S}{PARA}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(yytext); return PARAGRAFO;
   /* ***********************
    * PERIODO               *
    * ***********************/
{ORD}{S}{PERIO}					|
{PERIO}{S}{ORD}					BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilConvOrdinale(yytext,0)); return PERIODO;
{ULTIMO}{S}{PERIO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,1)); return PERIODO;
{PERIO}{S}{ULTIMO}				BEGIN(sudd); salvaPos(); yylval=(int)strdup(utilEstraiUltimo(yytext,2)); return PERIODO;

   /* =================================================== ATTI ========================================== */

   /* ----------------------------- COSTITUZIONE E CODICI ---------------------------- */

cost(\.|ituz(\.|ione))? 			BEGIN(0); salvaPos(); return COSTITUZIONE;
{COD}{S}(di)?{S}{PRO}{S}{CIV}		BEGIN(0); salvaPos(); return CODICE_PROCEDURA_CIVILE;
{COD}{S}(di)?{S}{PRO}{S}{PEN}		BEGIN(0); salvaPos(); return CODICE_PROCEDURA_PENALE;
{COD}{S}{CIV}/{NOAN}				BEGIN(0); salvaPos(); return CODICE_CIVILE;
{COD}{S}{PEN}/{NOAN}				BEGIN(0); salvaPos(); return CODICE_PENALE;

   /* ----------------------------- ATTI NORMATIVI -------------------------------- */
   /* *******************************
    * PRESIDENTE CONSIGLIO MINISTRI *
    * *******************************/
{DECRETO}({ST}del)?{ST}{PRES}({ST}del)?{ST}{COMIN}	|
d[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?				BEGIN(atto); salvaPos(); return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI;

{DIR}({ST}del)?{ST}{PRES}({ST}del)?{ST}{COMIN}		|
dir[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?				BEGIN(atto); salvaPos(); return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI;

{ODZ}({ST}del)?{ST}{PRES}({ST}del)?{ST}{COMIN}		|
o(rd)?[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?			BEGIN(atto); salvaPos(); return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI;
   /* *******************************
    * PRESIDENTE REPUBBLICA         *
    * *******************************/
{DECRETO}{ST}(del{ST})?{PRES}{ST}(della{ST})?{REPUB}	|
d[\.]?{ST}p[\.]?{ST}r[\.]? 								BEGIN(atto); salvaPos(); return DECRETO_PRESIDENTE_REPUBBLICA;
   /* *******************************
    * ATTI REGI                     *
    * *******************************/
{REGIO}{ST}{DECRETO}{ST}{LGS}					BEGIN(atto); salvaPos(); return REGIO_DECRETO_LEGISLATIVO;
r\.d\.l\.										|
rdl												|
{REGIO}{ST}{DECRETO}{ST}{LEG}					BEGIN(atto); salvaPos(); return REGIO_DECRETO_LEGGE;
{REGIO}{ST}{DECRETO}							|
rd												BEGIN(atto); salvaPos(); return REGIO_DECRETO;
   /* *******************************
    * ATTI GOVERNO                  *
    * *******************************/
{DECRETO}{ST}{LGS}								|
d{LGS}											BEGIN(atto); salvaPos(); return DECRETO_LEGISLATIVO;
{DECRETO}{ST}{LEG}								BEGIN(atto); salvaPos(); return DECRETO_LEGGE;
   /* *******************************
    * ATTI REGIONI                  *
    * *******************************/
(lr|({LEG}({ST}{RGN})?)){CONN}?{S}regione/{CONNREG}	|
(lr|({LEG}({ST}{RGN})?))/{CONNREG}					BEGIN(atto); salvaPos(); return LEGGE_REGIONE;
(lr|({LEG}({ST}{RGN})?)){CONN}?{S}regione			|
(lr|({LEG}{ST}{RGN}))								{ if (configGetRegione()) { BEGIN(atto); salvaPos(); return LEGGE_REGIONALE; }
										  			else { BEGIN(0); pos+=yyleng; return BREAK; } }

{REGOLAM}({ST}{RGN})?{CONN}?{S}regione/{CONNREG}	|
{REGOLAM}({ST}{RGN})?/{CONNREG}						BEGIN(atto); salvaPos(); return REGOLAMENTO_REGIONE;
{REGOLAM}({ST}{RGN})?{CONN}?{S}regione				|
{REGOLAM}{ST}{RGN}									{ if (configGetRegione()) { BEGIN(atto); salvaPos(); return REGOLAMENTO_REGIONALE; }
								  	  	  			else { BEGIN(0); pos+=yyleng; return BREAK; } }
   /* *******************************
    * LEGGI                         *
    * *******************************/
{LEG}{ST}{COST}									BEGIN(atto); salvaPos(); return LEGGE_COSTITUZIONALE;
{LEG}({S}{QLEG})?								|
{LEG}{S}{STATO}									|
{LEG}({S}della)?{S}{REPUB}						BEGIN(atto); salvaPos(); return LEGGE;
   /* *******************************
    * REGOLAMENTI COMUNALI          *
    * *******************************/
{REGOLAM}{CONN}?{S}{EDILIZ}						{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return REGOLAMENTO_EDILIZIO; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
{REGOLAM}{CONN}?{S}{POLIZ}						{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return REGOLAMENTO_POLIZIA; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
{REGOLAM}{CONN}?{S}{QUARTI}						{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return REGOLAMENTO_QUARTIERE; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
{REGOLAM}{CONN}?{S}{CONS}{S}{COMUNAL}			{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return REGOLAMENTO_CONSIGLIO; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
{REGOLAM}{CONN}?{S}{CONTAB}						{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return REGOLAMENTO_CONTABILITA; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
   /* *******************************
    * ATTI COMUNITARI               *
    * *******************************/
{REGOLAM}{S}{UE_P}								|
{REGOLAM}{S}({UEDEN}|{EUROP})					|
{REGOLAM}/{S}{UENUM}							BEGIN(atto); salvaPos(); return REGOLAMENTO_UE;
{REGOLAM}										{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return REGOLAMENTO; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
{DIR}{S}({UEDEN}|{EUROP})								|
{DIR}/{CONN}({PARLAM}|{CONS}|{COMMIS})({S}{EUROP})?		|
{DIR}/{S}{UENUM}										BEGIN(atto); salvaPos(); return DIRETTIVA_UE;
{DIR}													{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return DIRETTIVA; }
							  							else { BEGIN(0); pos+=yyleng; return BREAK; } }

{DECI}{S}({UEDEN}|{EUROP})								|
{DECI}/{CONN}({PARLAM}|{CONS}|{COMMIS})({S}{EUROP})?	|
{DECI}/{S}{UENUM}										BEGIN(atto); salvaPos(); return DECISIONE_UE;
{DECI}													{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return DECISIONE; }
							  							else { BEGIN(0); pos+=yyleng; return BREAK; } }
   /* *******************************
    * STATUTI             			*
    * *******************************/
presente{SPA}{STATU}												|
{STATU}{CONN}(associazione|centro|comunit|consorzio|ente|istituto)	|
{STATU}(tipo|ordinario|speciale)									BEGIN(0); pos+=yyleng; return BREAK;
{STATU}({ST}{RGN})?{CONN}?{S}regione/{CONNREG}		|
{STATU}({ST}{RGN})?/{CONNREG}						BEGIN(atto); salvaPos(); return STATUTO_REGIONE;
{STATU}({ST}{RGN})?{CONN}?{S}regione				|
{STATU}{ST}{RGN}									{ if (configGetRegione()) { BEGIN(atto); salvaPos(); return STATUTO_REGIONALE; }
								  	  	  			else { BEGIN(0); pos+=yyleng; return BREAK; } }
{STATU}												{ if (configGetEmanante()||configGetRegione()) { BEGIN(atto); salvaPos(); return STATUTO; }
													else { BEGIN(0); pos+=yyleng; return BREAK; } }
								  	  	  			
   /* ----------------------------- ATTI AMMINISTRATIVI ----------------------------- */
   /* ***********************
    * CNR                   *
    * ***********************/
{DECRETO}({S}del)?{S}{PRES}({S}del)?{S}{CNR}	|
d[\.]?{ST}p[\.]?{ST}{CNR}						BEGIN(atto); salvaPos(); return DECRETO_PRESIDENTE_CNR;

{DECRETO}({S}del)?{S}{DIRGEN}({S}del)?{S}{CNR}	|
d[\.]?{ST}d[\.]?g[\.]?{ST}{CNR}					BEGIN(atto); salvaPos(); return DECRETO_DIRETTORE_GENERALE_CNR;

{PRORD}({S}del)?{S}{COMSTR}({S}del)?{S}{CNR}	|
{PRORD}({S}del)?{S}{CNR}						BEGIN(atto); salvaPos(); return PROVVEDIMENTO_ORDINAMENTALE_CNR;
   /* *******************************
    * PROVVEDIMENTI                 *
    * *******************************/
{PRORD}(({S}del)?{S}{PRES})?					|
{PRORD}(({S}del)?{S}{DIRGEN})?					|
{PRORD}(({S}del)?{S}{COMSTR})?					{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return PROVVEDIMENTO_ORDINAMENTALE; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
   /* *******************************
    * DELIBERE                      *
    * *******************************/
{PROP}{SPA}{DELIB}								{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return PROPOSTA_DELIBERA; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
{DELIB}({PS}(di|del))?{PS}{CONS}({S}{COMUNAL})?	|
{DELIB}{PS}{CONSIL}								|
{DELIB}({PS}(di|del))?{PS}c{PS}c{PS}			{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return DELIBERA_CONSIGLIO_COMUNALE; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
{DELIB}({PS}(di|della))?{PS}{GIUNTA}({S}{COMUNAL})?		|
{DELIB}({PS}(di|della))?{PS}g{PS}m{PS}					{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return DELIBERA_GIUNTA_COMUNALE; }
							  							else { BEGIN(0); pos+=yyleng; return BREAK; } }
{DELIB}											{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return DELIBERA; }
							  					else { BEGIN(0); pos+=yyleng; return BREAK; } }
   /* *******************************
    * GENERICI                      *
    * *******************************/
{DECR_E}							{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return DECRETO_GEN; }
									else { BEGIN(0); pos+=yyleng; return BREAK; } }
{PROVD}								{ if (configGetEmanante()) { BEGIN(atto); salvaPos(); return PROVVEDIMENTO_GEN; }
									else { BEGIN(0); pos+=yyleng; return BREAK; } }
									
   /* =================================================== ESTREMI ========================================== */

<*>{SPA}							pos+=yyleng;
<sudd>{SPA}e{SPA}seguenti			pos+=yyleng;
<sudd,atto>{CONN}					pos+=yyleng;
<sudd,atto>{CITAT}					pos+=yyleng;

<atto>{
{INDAT}								|
{SPA}e{SPA}							pos+=yyleng;
{REGIONI}							salvaPos(); yylval=(int)strdup(yytext); return REGIONE;
}
   /* *******************************
    * COMUNITARI                    *
    * *******************************/
<atto>{
{UENUM}								salvaPos(); yylval=(int)strdup(yytext); return UE_NUM;
{UEDEN}								salvaPos(); return UE_DEN;
{PARLAM}({S}{EUROP})?				salvaPos(); return PARLAMENTO;
{CONS}({S}{EUROP})?					salvaPos(); return CONSIGLIO;
{COMMIS}({S}{EUROP})?				salvaPos(); return COMMISSIONE;
}
   /* *******************************
    * DATA PRIMA DI NUMERO          *
    * *******************************/
<atto>{
{N12}[/\.-]{N12}[/\.-]({N4}|{N12})/[^0-9]	{ BEGIN(data); salvaPos(); 
											  yylval=(int)utilConvDataNumerica(yytext); return DATA_GG_MM_AAAA; }
{N12}{ST}{MESI}{ST}({N4}|{N12})/[^0-9]		{ BEGIN(data); salvaPos(); 
											  yylval=(int)utilConvDataEstesa(yytext); return DATA_GG_MM_AAAA; }
}
   /* *******************************
    * NUMERO DOPO DATA              *
    * *******************************/
<data>{
{NUM}?{S}{N}({S}\/{S}{N}){0,2}				BEGIN(0); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO_ESTESO;
{NUM}?{S}{N}{S}\/c\/{S}{N}					BEGIN(0); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO_CONSIGLIO;
{NUM}?{S}{N}{S}\/g\/{S}{N}					BEGIN(0); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO_GIUNTA;
.											BEGIN(0); unput(*yytext); return BREAK;
}
   /* *******************************
    * NUMERO PRIMA DI DATA          *
    * *******************************/
<atto>{NUM}?{S}{N}{S}\/c\/{S}{N}		BEGIN(nume); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO_CONSIGLIO;
<atto>{NUM}?{S}{N}{S}\/g\/{S}{N}		BEGIN(nume); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO_GIUNTA;
<atto>{NUM}{S}{N}						BEGIN(nume); salvaPos(); yylval=(int)strdup(utilConvCardinale(yytext,0)); return NUMERO_ATTO;
<nume>[/]{S}/{N}						pos+=yyleng; yylval=(int)strdup(yytext); return BARRA;
<atto,nume>{N}							BEGIN(nume); salvaPos(); yylval=(int)strdup(yytext); return NUMERO_CARDINALE;
   /* *******************************
    * DATA DOPO NUMERO              *
    * *******************************/
<nume>{
{N12}[/\.-]{N12}[/\.-]({N4}|{N12})/[^0-9]	{ BEGIN(0); salvaPos(); 
											  yylval=(int)utilConvDataNumerica(yytext); return DATA_GG_MM_AAAA; }
{N12}{ST}{MESI}{ST}({N4}|{N12})/[^0-9]		{ BEGIN(0); salvaPos(); 
											  yylval=(int)utilConvDataEstesa(yytext); return DATA_GG_MM_AAAA; }
{CONN}										|
{INDAT}										pos+=yyleng;
.											BEGIN(0); unput(*yytext); return BREAK;
}
   /* *******************************
    * NON SIGNIFICATIVI             *
    * *******************************/
<INITIAL,sudd,atto>{
[a-z0-9_]+							|
([#]{1,256})							|
\.									BEGIN(0); pos+=yyleng; if (!salta) { salta = 1; return BREAK; }

.									pos++;
}

%%


