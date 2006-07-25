/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		riferimenti.y
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*			PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigUtil.h>
#include <IttigLogger.h>
#include "parser.h"

#include "urn.h"

int errore = 0;

int yydebug = 0;		/* per debug */

urn urnTmp;

void rifInit() 
{
	urnTmp.tipo = 'e';	/* riferimenti esterni */
}


int pos = 0;
extern char * yytext;
extern int yyleng;

void yyerror(const char *str) {
	//loggerDebug(utilConcatena(3, str, " -> ", yytext));
	//fprintf(stderr, "error: %s -> %s\n", str, yytext);
}

int yywrap() {
	return 1;
}


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

%token DECRETO_GEN
%token PROVVEDIMENTO_GEN
%token PROVVEDIMENTO_ORDINAMENTALE
%token STATUTO_GEN

%token COSTITUZIONE
%token DECRETO_PRESIDENTE_REPUBBLICA
%token DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI
%token DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI
%token ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI
%token LEGGE_COSTITUZIONALE
%token LEGGE
%token DECRETO_LEGGE
%token DECRETO_LEGISLATIVO

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
%token STATUTO_REGIONALE
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

%token DATA_GG_MM_AAAA

%token NUMERO_CARDINALE
%token BARRA

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
	| BREAK		{ urnFree(&urnTmp); urnShift(&urnTmp); }
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
	leggiOrdinarie					{ urnTmp.autorita = strdup("stato"); }
	| attiPresidenteRepubblica		{ urnTmp.autorita = strdup("presidente.repubblica"); }
	| attiPresidenteConsiglioMinistri	{ urnTmp.autorita = strdup("presidente.consiglio.ministri"); }
	| attiRegi					{ urnTmp.autorita = strdup("stato"); }
	| attiRegionali
	| attiGenerici					{ if (configGetEmanante()) 
									urnTmp.autorita = strdup(configGetEmanante()); }

/*	| leggeProvinciale				{ $autorita = "provincia.$provincia"; }
	| regolamento
	| statuto
*/	;

/******************************************************************************/
/*********************************************************** ATTI GENERICI ****/
/******************************************************************************/

attiGenerici:
	DECRETO_GEN			{ urnTmp.provvedimento = strdup("decreto"); }
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
	regionaleTipoRegionale regioneNomeOpz
	| regionaleTipoGenerico regioneParolaNome
	;

regionaleTipoRegionale:
	LEGGE_REGIONALE			{ urnTmp.provvedimento = strdup("legge"); }
	| REGOLAMENTO_REGIONALE		{ urnTmp.provvedimento = strdup("regolamento"); }
	| STATUTO_REGIONALE			{ urnTmp.provvedimento = strdup("statuto"); }
	;

regionaleTipoGenerico:
	LEGGE					{ urnTmp.provvedimento = strdup("legge"); }
	| REGOLAMENTO				{ urnTmp.provvedimento = strdup("regolamento"); }
	| STATUTO_GEN				{ urnTmp.provvedimento = strdup("statuto"); }
	;

regioneParolaNome:
	PAROLA_REGIONE	regioneNome
	| regioneNome
	| PAROLA_REGIONE		{ if (configGetRegione()) 
							  urnTmp.autorita = utilConcatena(2, "regione.", configGetRegione());
					  	  else urnTmp.autorita = strdup("regione."); }
	;

regioneNomeOpz:
	regioneNome
	| /* vuoto */ 		{ if (configGetRegione()) 
							urnTmp.autorita = utilConcatena(2, "regione.", configGetRegione());
					  else	urnTmp.autorita = strdup("regione."); }
	;

regioneNome:
	REGIONE			{ urnTmp.autorita = utilConcatena(2, "regione.", $1); }
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
	suddivisioneOpz comunitarioTipo dataOpz
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
	comunitarioOrgano comunitarioOrgano
	;

comunitarioOrgano:
	PARLAMENTO | CONSIGLIO | COMMISSIONE | /* vuoto */
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
	REGOLAMENTO comunitarioDenominazione comunitarioEstremi
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
	suddivisionePartizioneSupArt
	| suddivisioneArticolo
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
	LIBRO suddivisionePartizioneSupArtOpz		{ urnTmp.lib = (char *)$1; }
	;

suddivisioneParte:
	PARTE suddivisionePartizioneSupArtOpz		{ urnTmp.prt = (char *)$1; }
	;

suddivisioneTitolo:
	TITOLO suddivisionePartizioneSupArtOpz		{ urnTmp.tit = (char *)$1; }
	;

suddivisioneCapo:
	CAPO suddivisionePartizioneSupArtOpz		{ urnTmp.cap = (char *)$1; }
	;

suddivisioneSezione:
	SEZIONE suddivisionePartizioneSupArtOpz		{ urnTmp.sez = (char *)$1; }
	;

suddivisioneArticolo:
	ARTICOLO suddivisionePartizioneInfArtOpz	{ urnTmp.art = (char *)$1; }
	| suddivisionePartizioneInfArtOpz ARTICOLO	{ urnTmp.art = (char *)$2; }
	;

suddivisioneComma:
	COMMA suddivisionePartizioneInfArtOpz		{ urnTmp.com = (char *)$1; }
	;

suddivisioneCapoverso:
	CAPOVERSO suddivisionePartizioneInfArtOpz	{ urnTmp.com = (char *)$1; }
	;

suddivisioneLettera:
	LETTERA suddivisionePartizioneInfArtOpz		{ urnTmp.let = (char *)$1; }
	;

suddivisioneNumero:
	NUMERO suddivisionePartizioneInfArtOpz		{ urnTmp.num = (char *)$1; }
	;

suddivisioneParagrafo:
	PARAGRAFO suddivisionePartizioneInfArtOpz	{ urnTmp.prg = (char *)$1; }
	;

suddivisionePeriodo:
	PERIODO suddivisionePartizioneInfArtOpz
	;

/******************************************************************************/
/****************************************************************** ESTREMI ***/
/******************************************************************************/

estremi:
	estremiEstesi
	| estremiAbbreviati
	;
	
estremiEstesi:
	data estremiNumero
	| estremiNumero data
	| data
	;

estremiAbbreviati:
	estremiNumero BARRA NUMERO_CARDINALE		{ urnTmp.data = (char *) $3; }
	| estremiNumero NUMERO_CARDINALE			{ urnTmp.data = (char *) $2; }
	| NUMERO_CARDINALE NUMERO				{ urnTmp.data = (char *) $1; urnTmp.numero = (char *) $2;}
/*	| NUMERO_CARDINALE estremiNumero */
	;

estremiNumero:
	NUMERO			{ urnTmp.numero = (char *) $1; }
	| NUMERO_CARDINALE	{ urnTmp.numero = (char *) $1; }
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
