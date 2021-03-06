/******************************************************************************
* Project:		xmLeges
* Module:		Linker
* File:			riferimenti.y
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:		GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:		Mirco Taddei (m.taddei@ittig.cnr.it)
*				PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
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

int yydebug = 0;		/* 1 per debug */

urn urnTmp;

void rifInit() 
{
	urnTmp.tipo = 'e';	/* riferimenti esterni */
	urnTmp.mod  = 'n';	/* no mod */
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

%token ARTICULT
%token COMMAULT
%token LETTULT
%token NUMULT
%token PUNTULT

%token ARTICORD
%token COMMAORD
%token NUMORD
%token PUNTORD

%token DECRETO_GEN
%token PROVVEDIMENTO_GEN
%token PROVVEDIMENTO_ORDINAMENTALE
%token STATUTO

%token COSTITUZIONE
%token DECRETO_PRESIDENTE_REPUBBLICA
%token DECRETO_PRESIDENTE_CONSIGLIO_MINISTRI
%token DIRETTIVA_PRESIDENTE_CONSIGLIO_MINISTRI
%token ORDINANZA_PRESIDENTE_CONSIGLIO_MINISTRI
%token LEGGE_COSTITUZIONALE
%token LEGGE
%token DECRETO_LEGGE
%token DECRETO_LEGISLATIVO

%token DELIBERA_UFF_PRESIDENZA
%token DELIBERA_CONS_REGIONALE
%token DELIBERA_GIUNTA_COMUNALE
%token DELIBERA_CONSIGLIO_COMUNALE
%token DELIBERA
%token PROPOSTA_DELIBERA
%token DETERMINA

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

%token LEGGE_REGIONE
%token LEGGE_REGIONALE
%token REGOLAMENTO_REGIONE
%token REGOLAMENTO_REGIONALE
%token STATUTO_REGIONE
%token STATUTO_REGIONALE
%token REGIONE

%token REGOLAMENTO_EDILIZIO
%token REGOLAMENTO_POLIZIA
%token REGOLAMENTO_QUARTIERE
%token REGOLAMENTO_CONSIGLIO
%token REGOLAMENTO_CONTABILITA

%token UE_NUM
%token UE_DEN
%token PARLAMENTO
%token CONSIGLIO
%token COMMISSIONE
%token DIRETTIVA
%token DIRETTIVA_UE
%token DECISIONE
%token DECISIONE_UE
%token REGOLAMENTO
%token REGOLAMENTO_UE

%token DATA_GG_MM_AAAA

%token NUMERO_ATTO
%token NUMERO_BARRA_ERRE
%token NUMERO_CON_TRATTINO
%token NUMERO_DETERMINA
%token NUMERO_CARDINALE
%token NUMERO_ESTESO
%token NUMERO_CONSIGLIO
%token NUMERO_GIUNTA
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
	| statuto
	| amministrativo
	| regolamento

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
	| attiPresidenteConsiglioMinistri	{ urnTmp.autorita = strdup("presidente.consiglio.ministri"); }
	| attiRegi							{ urnTmp.autorita = strdup("stato"); }
	| attiRegionali
	| attiGenerici						{ if (configGetEmanante()) 
										urnTmp.autorita = strdup(configGetEmanante()); }

/*	| leggeProvinciale					{ $autorita = "provincia.$provincia"; }
*/	;

/******************************************************************************/
/*********************************************************** ATTI GENERICI ****/
/******************************************************************************/

attiGenerici:
	DECRETO_GEN				{ urnTmp.provvedimento = strdup("decreto"); }
	| PROVVEDIMENTO_GEN		{ urnTmp.provvedimento = strdup("provvedimento"); }
	| DIRETTIVA				{ urnTmp.provvedimento = strdup("direttiva"); }
	| DECISIONE				{ urnTmp.provvedimento = strdup("decisione"); }
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
	| LEGGE					{ urnTmp.provvedimento = strdup("legge"); }
	| DECRETO_LEGGE			{ urnTmp.provvedimento = strdup("decreto.legge"); }
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
/***************************************************************** STATUTO ****/
/******************************************************************************/

statuto:
	suddivisioneOpz statutoTipo		{ urnTmp.provvedimento = strdup("statuto"); }
	;
	
statutoTipo:
	statutoRegionale
	| statutoGenerico
	;
	
statutoRegionale:
	STATUTO_REGIONE regioneNome
	| STATUTO_REGIONALE				{ urnTmp.autorita = strdup(configGetRegione()); }
	;
	
statutoGenerico:
	STATUTO							{ if (configGetEmanante()) 
										{ urnTmp.autorita = strdup(configGetEmanante());
										utilEstrai(urnTmp.autorita,strdup(configGetEmanante()),"",";"); } // solo 1.o livello
									else 
										{ if (configGetRegione()) urnTmp.autorita = strdup(configGetRegione()); }
									}
	;

/******************************************************************************/
/*************************************************************** REGIONALE ****/
/******************************************************************************/

attiRegionali:
	regionaleTipoRegionale regioneNomeOpz
	| regionaleTipoGenerico regioneNome
	;

regionaleTipoRegionale:
	LEGGE_REGIONALE				{ urnTmp.provvedimento = strdup("legge"); }
	| REGOLAMENTO_REGIONALE		{ urnTmp.provvedimento = strdup("regolamento"); }
	;

regionaleTipoGenerico:
	LEGGE_REGIONE				{ urnTmp.provvedimento = strdup("legge"); }
	| REGOLAMENTO_REGIONE		{ urnTmp.provvedimento = strdup("regolamento"); }
	;

regioneNomeOpz:
	regioneNome
	| /* vuoto */ 				{ urnTmp.autorita = strdup(configGetRegione()); }
	;

regioneNome:
	REGIONE						{ urnTmp.autorita = utilConcatena(2, "regione.", $1); }
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
	| CODICE_PENALE				{ urnTmp.provvedimento = strdup("codice.penale"); 
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

	| comunitarioRegolamento	{ urnTmp.autorita = strdup("comunita.europee"); 
								urnTmp.provvedimento = strdup("regolamento"); }
	;

comunitarioNumero:
	UE_NUM						{ urnTmp.numero = (char *) $1; }
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
	DIRETTIVA_UE comunitarioEstremi comunitarioEmanante comunitarioDenominazione
	| DIRETTIVA_UE comunitarioEmanante comunitarioDenominazione comunitarioEstremi
	;

comunitarioDenominazione:
	UE_DEN
	| /* vuoto */
	;

comunitarioEstremi:
	comunitarioNumero
	| estremi
	;

/******************************************************************************/
/*************************************************** COMUNITARIO DECISIONE ****/
/******************************************************************************/

comunitarioDecisione:
	DECISIONE_UE comunitarioEstremi comunitarioEmanante comunitarioDenominazione
	| DECISIONE_UE comunitarioEmanante comunitarioDenominazione comunitarioEstremi
	;

/******************************************************************************/
/************************************************* COMUNITARIO REGOLAMENTO ****/
/******************************************************************************/

comunitarioRegolamento:
	REGOLAMENTO_UE comunitarioDenominazione comunitarioEstremi
/*	| REGOLAMENTO_UE comunitarioDenominazione comunitarioNumero */
	;
	
/******************************************************************************/
/************************************************************* REGOLAMENTO ****/
/******************************************************************************/

regolamento:
/*	suddivisioneOpz regolamentoTipo */
	suddivisioneOpz regolamentoTipo estremiOpz		{ urnTmp.autorita = strdup(configGetEmanante());
													utilEstrai(urnTmp.autorita,strdup(configGetEmanante()),"",";"); } // solo 1.o livello
	| suddivisioneOpz regolamentoGen estremi		{ urnTmp.autorita = strdup(configGetEmanante());
													utilEstrai(urnTmp.autorita,strdup(configGetEmanante()),"",";"); } // solo 1.o livello
	;

regolamentoTipo:
	REGOLAMENTO_EDILIZIO				{ urnTmp.provvedimento = strdup("regolamento;edilizia"); }
	| REGOLAMENTO_POLIZIA				{ urnTmp.provvedimento = strdup("regolamento;polizia.municipale"); }
	| REGOLAMENTO_QUARTIERE				{ urnTmp.provvedimento = strdup("regolamento;consigli.quartiere"); }
	| REGOLAMENTO_CONSIGLIO				{ urnTmp.provvedimento = strdup("regolamento;consiglio.comunale"); }
	| REGOLAMENTO_CONTABILITA			{ urnTmp.provvedimento = strdup("regolamento;contabilita"); }
	;

regolamentoGen:
	REGOLAMENTO							{ urnTmp.provvedimento = strdup("regolamento"); }
	;


/******************************************************************************/
/********************************************************** AMMINISTRATIVO ****/
/******************************************************************************/

amministrativo:
	suddivisioneOpz amministrativoTipo estremi
	| suddivisioneOpz amministrativoTipo estremiDelibere
	;

amministrativoTipo:
	decretoCnr							{ urnTmp.provvedimento = strdup("decreto"); }
	| PROVVEDIMENTO_ORDINAMENTALE_CNR	{ urnTmp.provvedimento = strdup("provvedimento"); 
										urnTmp.autorita = strdup("consiglio.nazionale.ricerche"); }
	| PROVVEDIMENTO_ORDINAMENTALE		{ urnTmp.provvedimento = strdup("provvedimento"); 
										urnTmp.autorita = strdup(configGetEmanante()); }
	| DELIBERA_CONS_REGIONALE			{ urnTmp.provvedimento = strdup("deliberazione"); 
										urnTmp.autorita = strdup(configGetEmanante()); }
	| DELIBERA_UFF_PRESIDENZA			{ urnTmp.provvedimento = strdup("deliberazione"); 
										urnTmp.autorita = strdup(configGetEmanante()); }
	| DELIBERA_CONSIGLIO_COMUNALE		{ urnTmp.provvedimento = strdup("deliberazione"); 
										urnTmp.autorita = malloc(sizeof(char) * (strlen(configGetEmanante()) + 12)); // dim. x consiglio
										utilEstrai(urnTmp.autorita,strdup(configGetEmanante()),"",";");
										strcat(urnTmp.autorita, ";consiglio");  }
	| DELIBERA_GIUNTA_COMUNALE			{ urnTmp.provvedimento = strdup("deliberazione"); 
										urnTmp.autorita = malloc(sizeof(char) * (strlen(configGetEmanante()) + 12)); // dim. x consiglio
										utilEstrai(urnTmp.autorita,strdup(configGetEmanante()),"",";");
										strcat(urnTmp.autorita, ";giunta"); }
	| DELIBERA							{ urnTmp.provvedimento = strdup("deliberazione"); 
										urnTmp.autorita = strdup(configGetEmanante()); }
	| PROPOSTA_DELIBERA					{ urnTmp.provvedimento = strdup("proposta.deliberazione"); 
										urnTmp.autorita = strdup(configGetEmanante()); }
	| DETERMINA							{ urnTmp.provvedimento = strdup("determinazione"); 
										urnTmp.autorita = strdup(configGetEmanante()); }
	;

/******************************************************************************/
/************************************************************* DECRETO CNR ****/
/******************************************************************************/

decretoCnr:
	DECRETO_PRESIDENTE_CNR				{ urnTmp.autorita = strdup("consiglio.nazionale.ricerche;presidente"); }
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
	| suddivisionePunto
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
	Articolo suddivisionePartizioneInfArtOpz
	| suddivisionePartizioneInfArtOpz Articolo
	;

Articolo:
	ARTICOLO									{ urnTmp.art = (char *)$1; }
	| ARTICORD 									{ urnTmp.art = (char *)$1; urnTmp.artord = (char *)$1; }
	| ARTICULT 									{ urnTmp.artord = (char *)$1; }
	;

suddivisioneComma:
	Comma suddivisionePartizioneInfArtOpz
	;

Comma:
	COMMA									{ urnTmp.com = (char *)$1; }
	| COMMAORD 								{ urnTmp.com = (char *)$1; urnTmp.comord = (char *)$1; }
	| COMMAULT 								{ urnTmp.comord = (char *)$1; }
	;

suddivisioneCapoverso:
	CAPOVERSO suddivisionePartizioneInfArtOpz	{ urnTmp.com = (char *)$1; }
	;

suddivisioneLettera:
	Lettera suddivisionePartizioneInfArtOpz
	;

Lettera:
	LETTERA									{ urnTmp.let = (char *)$1; }
	| LETTULT 								{ urnTmp.letord = (char *)$1; }
	;

suddivisioneNumero:
	Numero suddivisionePartizioneInfArtOpz
	;

Numero:
	NUMERO									{ urnTmp.num = (char *)$1; }
	| NUMORD 								{ urnTmp.num = (char *)$1; urnTmp.numord = (char *)$1; }
	| NUMULT 								{ urnTmp.numord = (char *)$1; }
	;

suddivisionePunto:
	Punto suddivisionePartizioneInfArtOpz
	;

Punto:
	PUNTORD									{ urnTmp.pun = (char *)$1; urnTmp.punord = (char *)$1; }
	| PUNTULT 								{ urnTmp.punord = (char *)$1; }
	;

suddivisioneParagrafo:
	PARAGRAFO suddivisionePartizioneInfArtOpz	{ urnTmp.prg = (char *)$1; }
	;

suddivisionePeriodo:
	PERIODO suddivisionePartizioneInfArtOpz		{ urnTmp.perord = (char *)$1; }
	;

/******************************************************************************/
/****************************************************************** ESTREMI ***/
/******************************************************************************/

estremiOpz:
	estremi
	| /* vuoto */
	;

estremi:
	estremiEstesi
	| estremiAbbreviati
	;
	
estremiEstesi:
	data estremiNumeroEstesoOpz
	| estremiNumeroEsteso data
	;

estremiAbbreviati:
	estremiNumero BARRA estremiAnno
	| estremiNumero estremiAnno
	| estremiAnno NUMERO_ATTO				{ urnTmp.numero = (char *) $2;}
/*	| NUMERO_CARDINALE estremiNumero */
	;

estremiNumeroEstesoOpz:
	NUMERO_ESTESO							{ urnTmp.numero = (char *) $1; }
	| NUMERO_BARRA_ERRE						{ urnTmp.numero = (char *) $1; }
	| /* vuoto */
	;

estremiNumeroEsteso:
	estremiNumero estremiNumeroBarraOpz
	;

estremiNumeroBarraOpz:
	BARRA NUMERO_CARDINALE					{ strcat(urnTmp.numero, (char *) $1); strcat(urnTmp.numero, (char *) $2);}
	| /* vuoto */
	;

estremiNumero:
	NUMERO_ATTO								{ urnTmp.numero = (char *) $1; }
	| NUMERO_CARDINALE						{ urnTmp.numero = (char *) $1; }
	| NUMERO_BARRA_ERRE						{ urnTmp.numero = (char *) $1; }
	;

estremiAnno:
	NUMERO_CARDINALE						{ urnTmp.data = (char *) $1; }
	;

/******************************************************************************/
/********************************************************* ESTREMI DELIBERE ***/
/******************************************************************************/

estremiDelibere:
	data estremiNumeroDelibere
	| estremiNumeroDelibere data
	;

estremiNumeroDelibere:
	NUMERO_CON_TRATTINO						{ urnTmp.numero = (char *) $1; }
	| NUMERO_DETERMINA						{ urnTmp.numero = (char *) $1; }
	| NUMERO_CONSIGLIO						{ urnTmp.numero = (char *) $1; }
	| NUMERO_GIUNTA							{ urnTmp.numero = (char *) $1; }
	;

/******************************************************************************/
/********************************************************************* DATA ***/
/******************************************************************************/

dataOpz:
	data
	| /* vuoto */
	;

data:
	DATA_GG_MM_AAAA							{ urnTmp.data = (char *) $1; }
	;

%%
