/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		interni.y
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include <IttigUtil.h>
#include <IttigLogger.h>
#include "urn.h"
#include "config.h"
#include "parser.h"

int errori = 0;

int intdebug = 0;		/* per debug */

extern urn urnTmp;

extern char * inttext;
extern int intleng;

void interror(const char *str) {
	//loggerDebug(utilConcatena(3, str, " -> ", inttext));
	//fprintf(stderr, "error: %s -> %s\n", str, inttext);
}

int intwrap() {
	return 1;
}

void intInit() 
{
	urnInit(&urnTmp);
	urnTmp.tipo = 'i';	/* riferimenti interni */
}

/*----------------------------------------- pattern tolti
%token PARAGRAFO
%token PERIODO
  ----------------------------------------- pattern tolti */


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

%token CITATO
%token DEL
%token DELL
%token DELLA

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
	suddivisione
	;

/******************************************************************************/
/************************************************************ SUDDIVISIONE ****/
/******************************************************************************/

suddivisione:
	suddivisioni
	;

suddivisioni:
	suddivisionePartizioneSupArt
	| suddivisioneArticolo
	;

connettivoAtto:
	CITATO | DEL | DELL | DELLA | /* vuoto */ 
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
/*	| suddivisionePeriodo
	| suddivisioneParagrafo
*/	;

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
	articolo suddivisioneConnettivo suddivisionePartizioneInfArtOpz
	| suddivisionePartizioneInfArtOpz suddivisioneConnettivo articolo 
	;

articolo:
	ARTICOLO		{ urnTmp.art = (char *)$1; }
	| /* vuoto */
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

/* ---
suddivisioneParagrafo:
	PARAGRAFO suddivisioneConnettivo suddivisionePartizioneInfArtOpz
				{ urnTmp.prg = (char *)$1; }
	;

suddivisionePeriodo:
	PERIODO suddivisioneConnettivo suddivisionePartizioneInfArtOpz
	;
--- */

%%
