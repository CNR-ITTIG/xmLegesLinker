/******************************************************************************
* Project:		xmLeges
* Module:		Linker
* File:			noncompleti.lex
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
NUM	(numero|num{PS}|n\.?o?)

DETER	(determinazione|determ{PS})
{DETER}			BEGIN(0); salvaNocPos(); return DETERMINA_GEN;

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

CONN1	({S}del(la|lo|l)?{SPA})
CONN2	({S}d(i|ei|gli){SPA})
CONN	({CONN1}|{CONN2})
INDAT	({S}in{SPA}data)
CITAT	((del(la|lo)?{SPA})?(gi.'?{SPA})?(cit(\.|at[ao])|medesim[ao]|stess[ao]|predett[ao]))

PROVD	(provvedimento|provv{PS})
STATU	(statuto)

DISEG	((disegno|progetto|proposta){SPA}di)
MIN		(ministeriale|ministero|ministro|min{PS})
TU_E	(testo{SPA}unico|t{PS}u{PS})
TU_1	(tu)
TU		({TU_E}|{TU_1})

DECR_E	(decreto|decr{PS})
DECR_1	(d{PS})
DECRETO	({DECR_E}|{DECR_1})
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

UE			(cee?|euratom|ceea|ceca)
UE_P		(\(?{UE}(({SVB}{UE}){1,2})?\)?)
UEDEN		(dell[ae']{S}(unione|comunit.'?){S}europe[ea])
EUROP		(europe[ao])
UENUM_AN	(({N12}|{N4})\/{N}\/{UE}(({SVB}{UE}){1,2})?)
UENUM_NA	({N}\/({N12}|{N4})\/{UE}(({SVB}{UE}){1,2})?)
UENUM		({NUM}?{S}({UENUM_NA}|{UENUM_AN}))	

REGIONI1	(abruzzo|basilicata|calabria|campania|emilia{ST}romagna|lazio|liguria|lombardia|marche|molise)
REGIONI2	(piemonte|puglia|sardegna|sicilia(na)?|toscana|umbria|veneto|v(\.|alle){S}d{S}'{S}aosta)
REGIONI3	((friuli(({ST}|{S}e{S})?{ST}venezia{ST}giulia)?))
REGIONI		({REGIONI1}|{REGIONI2}|{REGIONI3})
CONNREG		({CONN}?{S}{REGIONI})
SPAREG		({S}{REGIONI})

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

   /* =================================================== FALSI RIFERIMENTI ========================================== */
(codice{SPA}(binario|fiscale|identificativo|sorgente))										|
((da|per){SPA}(legge({SPA}o{SPA}regolamento)?|decreto|regolamento))							|
((effett[oi]|fin[ei]|norm[ae]){SPA}di{SPA}legge)											|
(legge{SPA}(italiana|(dello{SPA}stato)))													|
((disposizion[ei]|valore){SPA}di{SPA}legge({SPA}[eo]{SPA}di{SPA}regolamento)?)				|
((u|ca)s[oi]{SPA}(consentit|indicat)[oi]{SPA}dalla{SPA}legge)								|
((con|adotta(re)?({SPA}un)?){SPA}apposito{SPA}regolamento)									|
((decreto|provvedimento|regolamento)({SPA}((del{SPA}governo)|governativo))?{SPA}di{SPA}cui)	|
((presente|seguente){SPA}(codice|legge|decreto|provvedimento|regolamento|testo{SPA}unico))	nocpos+=nocleng; return BREAK;

   /* =================================================== SUDDIVISIONI ========================================== */
   /* ***********************
    * LIBRO                 *
    * ***********************/
{LIB}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoDopo(noctext)); return LIBRO;
{ROM}{S}{LIB}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoPrima(noctext)); return LIBRO;
{LIB}{S}{ORD}{LAT}?				|
{ORD}{S}{LIB}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return LIBRO;
   /* ***********************
    * PARTE                 *
    * ***********************/
{PAR}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoDopo(noctext)); return PARTE;
{ROM}{S}{PAR}/{NOAN}			BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoPrima(noctext)); return PARTE;
{ORD}{S}{PAR}/{NOAN}			|
{PAR}{S}{ORD}{LAT}?				BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return PARTE;
   /* ***********************
    * TITOLO                *
    * ***********************/
{TIT}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoDopo(noctext)); return TITOLO;
{ROM}{S}{TIT}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoPrima(noctext)); return TITOLO;
{TIT}{S}{ORD}{LAT}?				|
{ORD}{S}{TIT}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return TITOLO;
   /* ***********************
    * CAPOVERSO             *
    * ***********************/
{CAPOV}{S}{N}{PTO}?{LAT}?/{NOAN}	|
{N}{PTO}?{S}{CAPOV}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,1)); return CAPOVERSO;
{CAPOV}{S}{ORD}{LAT}?				|
{ORD}{LAT}?{S}{CAPOV}				BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,1)); return CAPOVERSO;
   /* ***********************
    * CAPO                  *
    * ***********************/
{CAP}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoDopo(noctext)); return CAPO;
{ROM}{S}{CAP}/{NOAN}			BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoPrima(noctext)); return CAPO;
{ORD}{S}{CAP}/{NOAN}			|
{CAP}{S}{ORD}{LAT}?				BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return CAPO;
   /* ***********************
    * SEZIONE               *
    * ***********************/
{SEZ}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoDopo(noctext)); return SEZIONE;
{ROM}{S}{SEZ}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoPrima(noctext)); return SEZIONE;
{SEZ}{S}{ORD}{LAT}?				|
{ORD}{S}{SEZ}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return SEZIONE;
   /* ***********************
    * ARTICOLO              *
    * ***********************/
{ART}{S}{N}{PTO}?{LAT}?/{NOAN}	|
{N}{PTO}?{S}{ART}				BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return ARTICOLO;
{ART}{S}{ORD}{LAT}?				|
{ORD}{S}{ART}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return ARTICOLO;
   /* ***********************
    * COMMA                 *
    * ***********************/
{COM}{S}{ROM}{LAT}?/{NOAN}		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoDopo(noctext)); return COMMA;
{ROM}{S}{COM}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvRomanoPrima(noctext)); return COMMA;
{COM}{S}{N}{PTO}?{LAT}?/{NOAN}	|
{N}{PTO}?{S}{COM}				BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return COMMA;
{COM}{S}{ORD}{LAT}?				|
{ORD}{S}{COM}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return COMMA;
   /* ***********************
    * LETTERA               *
    * ***********************/
{LET}{S}[a-z][a-z]?{LAT}?\)?	BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilCalcLettera(noctext)); return LETTERA;
   /* ***********************
    * NUMERO                *
    * ***********************/
<INITIAL,sudd>{NUM}{S}{N}{PTO}?{LAT}?		BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO;
{N}{PTO}{S}{NUM}{SPA}				BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO;
{NUM}{S}{ORD}{LAT}?					|
{ORD}{S}{NUM}						BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(utilConvOrdinale(noctext,0)); return NUMERO;
   /* ***********************
    * PARAGRAFO             *
    * ***********************/
{PARA}{S}{N}					|
{ORD}{S}{PARA}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(noctext); return PARAGRAFO;
   /* ***********************
    * PERIODO               *
    * ***********************/
{ORD}{S}{PERIO}					BEGIN(sudd); salvaNocPos(); noclval=(int)strdup(noctext); return PERIODO;

   /* =================================================== ATTI ========================================== */

   /* ----------------------------- COSTITUZIONE E CODICI ---------------------------- */

cost(\.|ituz(\.|ione))? 			BEGIN(0); salvaNocPos(); return COSTITUZIONE;
{COD}{S}(di)?{S}{PRO}{S}{CIV}		BEGIN(0); salvaNocPos(); return CODICE_PROCEDURA_CIVILE;
{COD}{S}(di)?{S}{PRO}{S}{PEN}		BEGIN(0); salvaNocPos(); return CODICE_PROCEDURA_PENALE;
{COD}{S}{CIV}/{NOAN}				BEGIN(0); salvaNocPos(); return CODICE_CIVILE;
{COD}{S}{PEN}/{NOAN}				BEGIN(0); salvaNocPos(); return CODICE_PENALE;

   /* ----------------------------- ATTI NORMATIVI -------------------------------- */
   /* *******************************
    * PRESIDENTE CONSIGLIO MINISTRI *
    * *******************************/
{DECRETO}({ST}del)?{ST}{PRES}({ST}del)?{ST}{COMIN}	|
d[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?				BEGIN(atto); salvaNocPos(); return DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI;

{DIR}({ST}del)?{ST}{PRES}({ST}del)?{ST}{COMIN}		|
dir[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?				BEGIN(atto); salvaNocPos(); return DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI;

{ODZ}({ST}del)?{ST}{PRES}({ST}del)?{ST}{COMIN}		|
o(rd)?[\.]?{ST}p[\.]?{ST}c[\.]?{ST}m[\.]?			BEGIN(atto); salvaNocPos(); return ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI;
   /* *******************************
    * PRESIDENTE REPUBBLICA         *
    * *******************************/
{DECRETO}{ST}(del{ST})?{PRES}{ST}(della{ST})?{REPUB}	|
d[\.]?{ST}p[\.]?{ST}r[\.]? 								BEGIN(atto); salvaNocPos(); return DECRETO_PRESIDENTE_REPUBBLICA;
   /* *******************************
    * DECRETI MINISTERIALI          *
    * *******************************/
{DECRETO}{ST}(del{ST})?{MIN}					|
{DECRMIN}{ST}(del{ST})?{MIN}?					BEGIN(atto); salvaNocPos(); return DECRETO_MINISTERIALE;
   /* *******************************
    * ATTI REGI                     *
    * *******************************/
{REGIO}{ST}{DECRETO}{ST}{LGS}					BEGIN(atto); salvaNocPos(); return REGIO_DECRETO_LEGISLATIVO;
r\.d\.l\.										|
rdl												|
{REGIO}{ST}{DECRETO}{ST}{LEG}					BEGIN(atto); salvaNocPos(); return REGIO_DECRETO_LEGGE;
{REGIO}{ST}{DECRETO}							|
rd												BEGIN(atto); salvaNocPos(); return REGIO_DECRETO;
   /* *******************************
    * ATTI GOVERNO                  *
    * *******************************/
{DECRETO}{ST}{LGS}								|
d{LGS}											BEGIN(atto); salvaNocPos(); return DECRETO_LEGISLATIVO;
{DECRETO}{ST}{LEG}								BEGIN(atto); salvaNocPos(); return DECRETO_LEGGE;
   /* *******************************
    * ATTI REGIONI                  *
    * *******************************/
(lr|({LEG}({ST}{RGN})?)){CONN}?{S}regione		|
(lr|({LEG}{ST}{RGN}))							BEGIN(atto); salvaNocPos(); return LEGGE_REGIONALE;

{REGOLAM}({ST}{RGN})?{CONN}?{S}regione			|
{REGOLAM}{ST}{RGN}								BEGIN(atto); salvaNocPos(); return REGOLAMENTO_REGIONALE;
   /* *******************************
    * LEGGI                         *
    * *******************************/
{LEG}{ST}{COST}									BEGIN(atto); salvaNocPos(); return LEGGE_COSTITUZIONALE;
{LEG}({S}{QLEG})?								|
{LEG}{S}{STATO}									|
{LEG}({S}della)?{S}{REPUB}						BEGIN(atto); salvaNocPos(); return LEGGE;
{DISEG}{S}{LEG}									BEGIN(atto); salvaNocPos(); return DISEGNO_LEGGE;
   /* *******************************
    * REGOLAMENTI COMUNALI          *
    * *******************************/
{REGOLAM}{CONN}?{S}{EDILIZ}						{ BEGIN(atto); salvaNocPos(); return REGOLAMENTO_EDILIZIO; }
{REGOLAM}{CONN}?{S}{POLIZ}						{ BEGIN(atto); salvaNocPos(); return REGOLAMENTO_POLIZIA; }
{REGOLAM}{CONN}?{S}{QUARTI}						{ BEGIN(atto); salvaNocPos(); return REGOLAMENTO_QUARTIERE; }
{REGOLAM}{CONN}?{S}{CONS}{S}{COMUNAL}			{ BEGIN(atto); salvaNocPos(); return REGOLAMENTO_CONSIGLIO; }
{REGOLAM}{CONN}?{S}{CONTAB}						{ BEGIN(atto); salvaNocPos(); return REGOLAMENTO_CONTABILITA; }
   /* *******************************
    * ATTI COMUNITARI               *
    * *******************************/
{REGOLAM}{S}{UE_P}								|
{REGOLAM}{S}({UEDEN}|{EUROP})					|
{REGOLAM}/{S}{UENUM}							BEGIN(atto); salvaNocPos(); return REGOLAMENTO_UE;
{REGOLAM}										{ BEGIN(atto); salvaNocPos(); return REGOLAMENTO; }

{DIR}{S}({UEDEN}|{EUROP})								|
{DIR}/{CONN}({PARLAM}|{CONS}|{COMMIS})({S}{EUROP})?		|
{DIR}/{S}{UENUM}										BEGIN(atto); salvaNocPos(); return DIRETTIVA_UE;
{DIR}													{ BEGIN(atto); salvaNocPos(); return DIRETTIVA; }

{DECI}{S}({UEDEN}|{EUROP})								|
{DECI}/{CONN}({PARLAM}|{CONS}|{COMMIS})({S}{EUROP})?	|
{DECI}/{S}{UENUM}										BEGIN(atto); salvaNocPos(); return DECISIONE_UE;
{DECI}													{ BEGIN(atto); salvaNocPos(); return DECISIONE; }
   /* *******************************
    * STATUTI                       *
    * *******************************/
{STATU}({ST}{RGN})?{CONN}?{S}regione			|
{STATU}{ST}{RGN}								BEGIN(atto); salvaNocPos(); return STATUTO_REGIONALE;
{STATU}											BEGIN(atto); salvaNocPos(); return STATUTO;

   /* ----------------------------- ATTI AMMINISTRATIVI ----------------------------- */
   /* ***********************
    * CNR                   *
    * ***********************/
{DECRETO}({S}del)?{S}{PRES}({S}del)?{S}{CNR}	|
d[\.]?{ST}p[\.]?{ST}{CNR}						BEGIN(atto); salvaNocPos(); return DECRETO_PRESIDENTE_CNR;

{DECRETO}({S}del)?{S}{DIRGEN}({S}del)?{S}{CNR}	|
d[\.]?{ST}d[\.]?g[\.]?{ST}{CNR}					BEGIN(atto); salvaNocPos(); return DECRETO_DIRETTORE_GENERALE_CNR;

{PRORD}({S}del)?{S}{COMSTR}({S}del)?{S}{CNR}	|
{PRORD}({S}del)?{S}{CNR}						BEGIN(atto); salvaNocPos(); return PROVVEDIMENTO_ORDINAMENTALE_CNR;
   /* *******************************
    * PROVVEDIMENTI                 *
    * *******************************/
{PRORD}(({S}del)?{S}{PRES})?					|
{PRORD}(({S}del)?{S}{DIRGEN})?					|
{PRORD}(({S}del)?{S}{COMSTR})?					BEGIN(atto); salvaNocPos(); return PROVVEDIMENTO_ORDINAMENTALE;
   /* *******************************
    * DELIBERE                      *
    * *******************************/
{PROP}{SPA}{DELIB}								BEGIN(atto); salvaNocPos(); return PROPOSTA_DELIBERA;
{DELIB}({ST}(di|del))?{ST}{COMIN}				BEGIN(atto); salvaNocPos(); return DELIBERA_CONSIGLIO_MINISTRI;
{DELIB}({PS}(di|del))?{PS}c{PS}c{PS}			|
{DELIB}{ST}{CONSIL}								|
{DELIB}({ST}(di|del))?{ST}{CONS}({S}{COMUNAL})?	BEGIN(atto); salvaNocPos(); return DELIBERA_CONSIGLIO;
{DELIB}({PS}(di|della))?{PS}{GIUNTA}({S}{COMUNAL})?		|
{DELIB}({PS}(di|della))?{PS}g{PS}m{PS}					{ BEGIN(atto); salvaNocPos(); return DELIBERA_GIUNTA; }
{DELIB}											BEGIN(atto); salvaNocPos(); return DELIBERA;
   /* *******************************
    * GENERICI                      *
    * *******************************/
{DECR_E}										BEGIN(atto); salvaNocPos(); return DECRETO_GEN;
{PROVD}											BEGIN(atto); salvaNocPos(); return PROVVEDIMENTO_GEN;
{ODZ_E}											BEGIN(atto); salvaNocPos(); return ORDINANZA_GEN;

{COD_E}											BEGIN(0); salvaNocPos(); return CODICE_GEN;
{TU_E}											BEGIN(0); salvaNocPos(); return TESTO_UNICO_GEN;

   /* =================================================== ESTREMI ========================================== */

<*>{SPA}							nocpos+=nocleng;
<sudd>{SPA}e{SPA}seguenti			nocpos+=nocleng;
<sudd,atto>{CONN}					nocpos+=nocleng;
<sudd,atto>{CITAT}					nocpos+=nocleng;

<atto>{
{INDAT}								|
{SPA}e{SPA}							nocpos+=nocleng;
{REGIONI}							salvaNocPos(); noclval=(int)strdup(noctext); return REGIONE;
}
   /* *******************************
    * COMUNITARI                    *
    * *******************************/
<atto>{
{UENUM}								salvaNocPos(); noclval=(int)strdup(noctext); return UE_NUM;
{UEDEN}								salvaNocPos(); return UE_DEN;
{PARLAM}({S}{EUROP})?				salvaNocPos(); return PARLAMENTO;
{CONS}({S}{EUROP})?					salvaNocPos(); return CONSIGLIO;
{COMMIS}({S}{EUROP})?				salvaNocPos(); return COMMISSIONE;
}
   /* *******************************
    * DATA PRIMA DI NUMERO          *
    * *******************************/
<atto>{
{N12}[/\.-]{N12}[/\.-]({N4}|{N12})/[^0-9]	{ BEGIN(data); salvaNocPos(); 
											  noclval=(int)utilConvDataNumerica(noctext); return DATA_GG_MM_AAAA; }
{N12}{ST}{MESI}{ST}({N4}|{N12})/[^0-9]		{ BEGIN(data); salvaNocPos(); 
											  noclval=(int)utilConvDataEstesa(noctext); return DATA_GG_MM_AAAA; }
}
   /* *******************************
    * NUMERO DOPO DATA              *
    * *******************************/
<data>{
{NUM}?{S}{N}({S}\/{S}{N}){0,2}				BEGIN(0); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO_ESTESO;
{NUM}?{S}{N}{S}\/c\/{S}{N}					BEGIN(0); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO_CONSIGLIO;
{NUM}?{S}{N}{S}\/g\/{S}{N}					BEGIN(0); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO_GIUNTA;
.											BEGIN(0); unput(*noctext); return BREAK;
}
   /* *******************************
    * NUMERO PRIMA DI DATA          *
    * *******************************/
<atto>{NUM}?{S}{N}{S}\/c\/{S}{N}		BEGIN(nume); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO_CONSIGLIO;
<atto>{NUM}?{S}{N}{S}\/g\/{S}{N}		BEGIN(nume); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO_GIUNTA;
<atto>{NUM}{S}{N}						BEGIN(nume); salvaNocPos(); noclval=(int)strdup(utilConvCardinale(noctext,0)); return NUMERO_ATTO;
<nume>[/]{S}/{N}						nocpos+=nocleng; noclval=(int)strdup(noctext); return BARRA;
<atto,nume>{N}							BEGIN(nume); salvaNocPos(); noclval=(int)strdup(noctext); return NUMERO_CARDINALE;
   /* *******************************
    * DATA DOPO NUMERO              *
    * *******************************/
<nume>{
{N12}[/\.-]{N12}[/\.-]({N4}|{N12})/[^0-9]	{ BEGIN(0); salvaNocPos(); 
											  noclval=(int)utilConvDataNumerica(noctext); return DATA_GG_MM_AAAA; }
{N12}{ST}{MESI}{ST}({N4}|{N12})/[^0-9]		{ BEGIN(0); salvaNocPos(); 
											  noclval=(int)utilConvDataEstesa(noctext); return DATA_GG_MM_AAAA; }
{CONN}										|
{INDAT}										nocpos+=nocleng;
.											BEGIN(0); unput(*noctext); return BREAK;
}
   /* *******************************
    * NON SIGNIFICATIVI             *
    * *******************************/
<INITIAL,sudd,atto>{
[a-z0-9_]+							|
([#]{1,256})						|
\.									BEGIN(0); nocpos+=nocleng; if (!salti) { salti = 1; return BREAK; }

.									nocpos++;
}

%%


