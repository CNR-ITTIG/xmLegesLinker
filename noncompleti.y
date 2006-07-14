/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		noncompleti.y
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigUtil.h>
#include <IttigLogger.h>
#include "parser.h"

#include "urn.h"

int errornc = 0;

int nocdebug = 0;		/* per debug */

urn urnTmp;

void nocInit() 
{
	urnInit(&urnTmp);
	urnTmp.tipo = 'n';	/* riferimenti non completi */
}

extern char * noctext;
extern int nocleng;

void nocerror(const char *str) {
	//loggerDebug(utilConcatena(3, str, " -> ", noctext));
	//fprintf(stderr, "error: %s -> %s\n", str, noctext);
}

int nocwrap() {
	return 1;
}

/* ------------------------------------
%token DETERMINA_GEN
	| DETERMINA_GEN		{ urnTmp.provvedimento = strdup("determinazione"); }
------------------------------------ */


%}

%debug

%token LIBRO
%token PARTE
%token TITOLO
%token CAPO
%token SEZIONE
%token ARTICOLO
%token COMMA
%token CAPOVERSO
%token LETTERA
%token NUMERO
%token PARAGRAFO
%token PERIODO

%token CODICE_GEN
%token DECRETO_GEN
%token DELIBERA_GEN
%token ORDINANZA_GEN
%token PROVVEDIMENTO_GEN
%token PROVVEDIMENTO_ORDINAMENTALE
%token STATUTO_GEN
%token TESTO_UNICO_GEN

%token DELIBERA_CONSIGLIO_MINISTRI
%token DELIBERA_CONSIGLIO

%token COSTITUZIONE
%token DECRETO_PRESIDENTE_REPUBBLICA
%token DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI
%token DECRETO_MINISTERIALE
%token DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI
%token ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI
%token LEGGE_COSTITUZIONALE
%token LEGGE
%token DECRETO_LEGGE
%token DECRETO_LEGISLATIVO
%token DISEGNO_LEGGE

%token DECRETO_PRESIDENTE_CNR
%token DECRETO_DIRETTORE_GENERALE_CNR
%token PROVVEDIMENTO_ORDINAMENTALE_CNR

%token REGIO_DECRETO
%token REGIO_DECRETO_LEGGE
%token REGIO_DECRETO_LEGISLATIVO

%token CODICE_CIVILE
%token CODICE_PROCEDURA_CIVILE
%token CODICE_PENALE
%token CODICE_PROCEDURA_PENALE

%token LEGGE_REGIONALE
%token REGOLAMENTO_REGIONALE
%token REGIONE
%token PAROLA_REGIONE

%token UE_NUM
%token UE_DEN
%token PARLAMENTO
%token CONSIGLIO
%token COMMISSIONE
%token DIRETTIVA
%token DECISIONE
%token REGOLAMENTO
%token REGOLAMENTO_UE

%token DATA_GG_MM_AAAA

%token NUMERO_CARDINALE
%token CITATO
%token DEL
%token DELL
%token DELLA
%token DELLO
%token E
%token IN_DATA
%token BARRA

%token PAROLA
%token BREAK

%%

/******************************************************************************/
/*************************************************************** DOCUMENTO ****/
/******************************************************************************/

documento:
	documento blocco	
	| error			{ urnFree(&urnTmp); urnShift(&urnTmp); 
				// loggerDebug(utilConcatena(2, "GRAM: documento=", $1)); 
				}
	;

blocco:
	riferimento	{ urnMemorizza(urnTmp); urnInit(&urnTmp); }
	| BREAK		{ urnFree(&urnTmp); urnShift(&urnTmp);}
	;

/******************************************************************************/
/************************************************************* RIFERIMENTO ****/
/******************************************************************************/

riferimento:
	normativo
	| costituzione
	| codice
	| comunitario
	| amministrativo

/*	| giurisprudenziale
*/	;

/******************************************************************************/
/************************************************************ COSTITUZIONE ****/
/******************************************************************************/

costituzione:
	suddivisione COSTITUZIONE	{ urnTmp.autorita = strdup("stato"); 
	  				urnTmp.provvedimento = strdup("costituzione"); 
	  				urnTmp.data = strdup("1947-12-27"); }
	;

/******************************************************************************/
/*************************************************************** NORMATIVO ****/
/******************************************************************************/

normativo:
	suddivisioneOpz normativoTipo estremi
	;

normativoTipo:
	leggiOrdinarie						{ urnTmp.autorita = strdup("stato"); }
	| attiPresidenteRepubblica			{ urnTmp.autorita = strdup("presidente.repubblica"); }
	| attiPresidenteConsiglioMinistri		{ urnTmp.autorita = strdup("presidente.consiglio.ministri"); }
	| attiRegi						{ urnTmp.autorita = strdup("stato"); }
	| attiRegionali					{ urnTmp.autorita = strdup("regione."); }
	| attiGenerali
	| attiGenerici						{ if (configGetEmanante()) 
										urnTmp.autorita = strdup(configGetEmanante()); }

/*	| leggeProvinciale					{ $autorita = "provincia.$provincia"; }
	| regolamento
	| statuto
*/	;

/******************************************************************************/
/*********************************************************** ATTI GENERALI ****/
/******************************************************************************/

attiGenerali:
	CODICE_GEN			{ urnTmp.autorita = strdup("stato"); 
							urnTmp.provvedimento = strdup("codice"); }
	| DECRETO_MINISTERIALE	{ urnTmp.autorita = strdup("ministero."); 
							urnTmp.provvedimento = strdup("decreto"); }
	| DELIBERA_CONSIGLIO_MINISTRI		{ urnTmp.autorita = strdup("consiglio.ministri"); 
									urnTmp.provvedimento = strdup("delibera"); }
	| DELIBERA_CONSIGLIO	{ urnTmp.autorita = strdup(";consiglio"); 
									urnTmp.provvedimento = strdup("delibera"); }
	| DISEGNO_LEGGE		{ urnTmp.autorita = strdup("senato.repubblica"); 
							urnTmp.provvedimento = strdup("disegno.legge"); }
	| TESTO_UNICO_GEN		{ urnTmp.autorita = strdup("stato"); 
							urnTmp.provvedimento = strdup("testo.unico"); }
	;

/******************************************************************************/
/*********************************************************** ATTI GENERICI ****/
/******************************************************************************/

attiGenerici:
	DECISIONE				{ urnTmp.provvedimento = strdup("decisione"); }
	| DECRETO_GEN			{ urnTmp.provvedimento = strdup("decreto"); }
	| DELIBERA_GEN			{ urnTmp.provvedimento = strdup("delibera"); }
	| DIRETTIVA			{ urnTmp.provvedimento = strdup("direttiva"); }
	| ORDINANZA_GEN		{ urnTmp.provvedimento = strdup("ordinanza"); }
	| PROVVEDIMENTO_GEN		{ urnTmp.provvedimento = strdup("provvedimento"); }
	| STATUTO_GEN			{ urnTmp.provvedimento = strdup("statuto"); }
	;

/******************************************************************************/
/********************************************** ATTI PRESIDENTE REPUBBLICA ****/
/******************************************************************************/

attiPresidenteRepubblica:
	DECRETO_PRESIDENTE_REPUBBLICA		{ urnTmp.provvedimento = strdup("decreto"); }
	;

/******************************************************************************/
/************************************** ATTI PRESIDENTE CONSIGLIO MINISTRI ****/
/******************************************************************************/

attiPresidenteConsiglioMinistri:
	DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI		{ urnTmp.provvedimento = strdup("decreto"); }
	| DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI	{ urnTmp.provvedimento = strdup("direttiva"); }
	| ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI	{ urnTmp.provvedimento = strdup("ordinanza"); }
	;

/******************************************************************************/
/********************************************************* LEGGI ORDINARIE ****/
/******************************************************************************/

leggiOrdinarie:
	LEGGE_COSTITUZIONALE	{ urnTmp.provvedimento = strdup("legge.costituzionale"); }
	| LEGGE				{ urnTmp.provvedimento = strdup("legge"); }
	| DECRETO_LEGGE		{ urnTmp.provvedimento = strdup("decreto.legge"); }
	| DECRETO_LEGISLATIVO	{ urnTmp.provvedimento = strdup("decreto.legislativo"); }
	;

/******************************************************************************/
/******************************************************************* REGIO ****/
/******************************************************************************/

attiRegi:
	REGIO_DECRETO				{ urnTmp.provvedimento = strdup("regio.decreto"); }
	| REGIO_DECRETO_LEGGE		{ urnTmp.provvedimento = strdup("regio.decreto.legge"); }
	| REGIO_DECRETO_LEGISLATIVO	{ urnTmp.provvedimento = strdup("regio.decreto.legislativo"); }
	;

/******************************************************************************/
/*************************************************************** REGIONALE ****/
/******************************************************************************/

attiRegionali:
	regionaleTipo regionaleConnettivo regioneParola regioneNome 
	;

regioneParola:
	PAROLA_REGIONE | /* vuoto */
	;

regioneNome:
	REGIONE			{ urnTmp.autorita = utilConcatena(1, $1); }
	| /* vuoto */ 		{ if (configGetRegione()) 
						urnTmp.autorita = utilConcatena(1, configGetRegione());}
	;

regionaleTipo:
	LEGGE_REGIONALE			{ urnTmp.provvedimento = strdup("legge"); }
//	| leggeRegionale			{ urnTmp.provvedimento = strdup("legge"); }
	| REGOLAMENTO_REGIONALE		{ urnTmp.provvedimento = strdup("regolamento"); }
//	| regolamentoRegionale		{ urnTmp.provvedimento = strdup("regolamento"); }
	;

/* ----------
leggeRegionale:
	LEGGE regionaleConnettivo PAROLA_REGIONE
	;

regolamentoRegionale:
	REGOLAMENTO regionaleConnettivo PAROLA_REGIONE
	;
---------- */

regionaleConnettivo:
	DEL | DELL | DELLA | /* vuoto */ 
	;

/******************************************************************************/
/****************************************************************** CODICE ****/
/******************************************************************************/

codice:
	suddivisioneOpz codiceTipo		{ urnTmp.autorita = strdup("stato"); }
	;

codiceTipo:
	CODICE_CIVILE				{ urnTmp.provvedimento = strdup("codice.civile");
					  			urnTmp.data = strdup("1942-03-16");
					  			urnTmp.numero = strdup("262"); }
	| CODICE_PROCEDURA_CIVILE	{ urnTmp.provvedimento = strdup("codice.procedura.civile"); 
					  			urnTmp.data = strdup("1940-10-28");
					  			urnTmp.numero = strdup("1443"); }
	| CODICE_PENALE			{ urnTmp.provvedimento = strdup("codice.penale"); 
					  			urnTmp.data = strdup("1930-10-19");
					  			urnTmp.numero = strdup("1398"); }
	| CODICE_PROCEDURA_PENALE	{ urnTmp.provvedimento = strdup("codice.procedura.penale"); 
					  			urnTmp.data = strdup("1988-09-22");
					  			urnTmp.numero = strdup("447"); }
	;

/******************************************************************************/
/************************************************************* COMUNITARIO ****/
/******************************************************************************/

comunitario:
	suddivisioneOpz comunitarioTipo estremiConnettivo dataOpz
	;

comunitarioTipo:
	comunitarioDirettiva		{ urnTmp.autorita = strdup("comunita.europee"); 
								urnTmp.provvedimento = strdup("direttiva"); }

	| comunitarioDecisione		{ urnTmp.autorita = strdup("comunita.europee"); 
								urnTmp.provvedimento = strdup("decisione"); }

	| comunitarioRegolamento		{ urnTmp.autorita = strdup("comunita.europee"); 
								urnTmp.provvedimento = strdup("regolamento"); }
	;

comunitarioNumero:
	UE_NUM					{ urnTmp.numero = (char *) $1; }
	;

comunitarioEmanante:
	comunitarioConnettivo comunitarioOrgano comunitarioEmananteAltri
	;

comunitarioConnettivo:
	DEL | DELLA | /* vuoto */
	;

comunitarioOrgano:
	PARLAMENTO | CONSIGLIO | COMMISSIONE | /* vuoto */
	;

comunitarioEmananteAltri:
	comunitarioAltri comunitarioConnettivo comunitarioOrgano comunitarioEmananteAltri
	| /* vuoto */
	;

comunitarioAltri:
	E | /* vuoto */
	;

/******************************************************************************/
/*************************************************** COMUNITARIO DIRETTIVA ****/
/******************************************************************************/

comunitarioDirettiva:
	DIRETTIVA comunitarioEstremi comunitarioEmanante comunitarioDenominazione
	| DIRETTIVA comunitarioEmanante comunitarioDenominazione comunitarioEstremi
	;

comunitarioDenominazione:
	UE_DEN | /* vuoto */
	;

comunitarioEstremi:
	comunitarioNumero
	| estremi
	;

/******************************************************************************/
/*************************************************** COMUNITARIO DECISIONE ****/
/******************************************************************************/

comunitarioDecisione:
	DECISIONE comunitarioEstremi comunitarioEmanante comunitarioDenominazione
	| DECISIONE comunitarioEmanante comunitarioDenominazione comunitarioEstremi
	;

/******************************************************************************/
/************************************************* COMUNITARIO REGOLAMENTO ****/
/******************************************************************************/

comunitarioRegolamento:
	REGOLAMENTO_UE comunitarioDenominazione comunitarioEstremi
	| REGOLAMENTO comunitarioDenominazione comunitarioNumero
	;
	
	
/******************************************************************************/
/********************************************************** AMMINISTRATIVO ****/
/******************************************************************************/

amministrativo:
	suddivisioneOpz amministrativoTipo estremi
	;

amministrativoTipo:
	decretoCnr					{ urnTmp.provvedimento = strdup("decreto"); }
	| PROVVEDIMENTO_ORDINAMENTALE_CNR	{ urnTmp.provvedimento = strdup("provvedimento"); 
									urnTmp.autorita = strdup("consiglio.nazionale.ricerche"); }
	| PROVVEDIMENTO_ORDINAMENTALE		{ urnTmp.provvedimento = strdup("provvedimento"); 
									if (configGetEmanante()) 
									urnTmp.autorita = strdup(configGetEmanante()); }
	;

/******************************************************************************/
/************************************************************* DECRETO CNR ****/
/******************************************************************************/

decretoCnr:
	DECRETO_PRESIDENTE_CNR		{ urnTmp.autorita = strdup("consiglio.nazionale.ricerche;presidente"); }
	| DECRETO_DIRETTORE_GENERALE_CNR	
					{ urnTmp.autorita = strdup("consiglio.nazionale.ricerche;direttore.generale"); }
	;

/******************************************************************************/
/************************************************************ SUDDIVISIONE ****/
/******************************************************************************/

suddivisioneOpz:
	suddivisione
	| /* vuoto */
	;

suddivisione:
	suddivisioni connettivoAtto
	;

suddivisioni:
	suddivisionePartizioneSupArt
	| suddivisioneArticolo
	;

connettivoAtto:
	CITATO | DEL | DELL | DELLA | DELLO | /* vuoto */ 
	;


suddivisioneConnettivo:
	connettivoAtto
	;

suddivisionePartizioneSupArtOpz:
	suddivisionePartizioneSupArt
	| /* vuoto */
	;

suddivisionePartizioneSupArt:
	suddivisioneLibro
	| suddivisioneParte
	| suddivisioneTitolo
	| suddivisioneCapo
	| suddivisioneSezione
	;

suddivisionePartizioneInfArtOpz:
	suddivisionePartizioneInfArt
	| /* vuoto */
	;

suddivisionePartizioneInfArt:
	suddivisioneComma
	| suddivisioneCapoverso
	| suddivisioneLettera
	| suddivisioneNumero
	| suddivisionePeriodo
	| suddivisioneParagrafo
	;

suddivisioneLibro:
	LIBRO suddivisioneConnettivo suddivisionePartizioneSupArtOpz
				{ urnTmp.lib = (char *)$1; }
	;

suddivisioneParte:
	PARTE suddivisioneConnettivo suddivisionePartizioneSupArtOpz
				{ urnTmp.prt = (char *)$1; }
	;

suddivisioneTitolo:
	TITOLO suddivisioneConnettivo suddivisionePartizioneSupArtOpz
				{ urnTmp.tit = (char *)$1; }
	;

suddivisioneCapo:
	CAPO suddivisioneConnettivo suddivisionePartizioneSupArtOpz
				{ urnTmp.cap = (char *)$1; }
	;

suddivisioneSezione:
	SEZIONE suddivisioneConnettivo suddivisionePartizioneSupArtOpz
				{ urnTmp.sez = (char *)$1; }
	;

suddivisioneArticolo:
	ARTICOLO suddivisioneConnettivo suddivisionePartizioneInfArtOpz
				{ urnTmp.art = (char *)$1; }
	| suddivisionePartizioneInfArtOpz suddivisioneConnettivo ARTICOLO 
				{ urnTmp.art = (char *)$3; }
	;

suddivisioneComma:
	COMMA suddivisioneConnettivo suddivisionePartizioneInfArtOpz
				{ urnTmp.com = (char *)$1; }
	;

suddivisioneCapoverso:
	CAPOVERSO suddivisioneConnettivo suddivisionePartizioneInfArtOpz
				{ urnTmp.com = (char *)$1; }
	;

suddivisioneLettera:
	LETTERA suddivisioneConnettivo suddivisionePartizioneInfArtOpz
				{ urnTmp.let = (char *)$1; }
	;

suddivisioneNumero:
	NUMERO suddivisioneConnettivo suddivisionePartizioneInfArtOpz
				{ urnTmp.num = (char *)$1; }
	;

suddivisioneParagrafo:
	PARAGRAFO suddivisioneConnettivo suddivisionePartizioneInfArtOpz
				{ urnTmp.prg = (char *)$1; }
	;

suddivisionePeriodo:
	PERIODO suddivisioneConnettivo suddivisionePartizioneInfArtOpz
	;

/******************************************************************************/
/****************************************************************** ESTREMI ***/
/******************************************************************************/

//estremi:
//	estremiConnettivo estremiEstesi
//	| estremiAbbreviati
//	;

estremi:
	estremiConnettivo estremiTipo
	;

estremiTipo:
	estremiEstesi
	| estremiAbbreviati
	| /* vuoto */
	;
	
estremiEstesi:
	data estremiNumero
	| estremiNumero estremiConnettivo data
	| data
	;

estremiAbbreviati:
	estremiNumero
	| estremiNumero BARRA NUMERO_CARDINALE				{ urnTmp.data = (char *) $3; }
	| estremiNumero estremiConnettivo NUMERO_CARDINALE	{ urnTmp.data = (char *) $3; }
	| NUMERO_CARDINALE NUMERO						{ urnTmp.data = (char *) $1; urnTmp.numero = (char *) $2;}
/*	| NUMERO_CARDINALE estremiNumero */
	;

estremiNumero:
	NUMERO			{ urnTmp.numero = (char *) $1; }
	| NUMERO_CARDINALE	{ urnTmp.numero = (char *) $1; }
	;

estremiConnettivo:
	DEL | DELL | IN_DATA | /* vuoto */
	;

/******************************************************************************/
/********************************************************************* DATA ***/
/******************************************************************************/

dataOpz:
	data
	| /* vuoto */
	;

data:
	dataTipo	{ urnTmp.data = (char *) $1; }
	;

dataTipo:
	DATA_GG_MM_AAAA				{ $$ = $1; }
	;

%%
