/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		config.c
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
******************************************************************************/

#include <stdio.h>
#include <string.h>
#include "config.h"
#include <IttigUtil.h>
#include <IttigLogger.h>
#include "parser.h"
#include "costanti.h"


tipoInput _configTipoInput = txt;
char* _configRegione = NULL;
char* _configEmanante = NULL;


/******************************************************************************/
/**************************************************** CONFIG CONFIG IN LOG ****/
/******************************************************************************/
void configConfigInLog(void) {
	loggerInfo("CONFIG configurazione usata per l'analisi");
	loggerInfo(utilConcatena(2, "CONFIG LogFile=", configGetLogFile()));
	loggerInfo(utilConcatena(2, "CONFIG TipoInput=", configGetTipoInput()));
	loggerInfo(utilConcatena(2, "CONFIG Regione=", configGetRegione()));
	loggerInfo(utilConcatena(2, "CONFIG Emanante=", configGetEmanante()));
}



/******************************************************************************/
/************************************************************ CONFIG LEGGI ****/
/******************************************************************************/
int configLeggi(char *fn) {
	FILE *fp;

	if (!(fp = fopen(fn, "r")))
		return 0;
	while (!feof(fp)) {
		char s[MAXLINE];
		char *r;
		fgets(s, MAXLINE, fp);
		r = strstr(s, "\n"); if (r) *r=0;
		r = strstr(s, "\r"); if (r) *r=0;
		if (strstr(s,"logfile=")){
			char tmp[MAXFILENAME];
			strncpy(tmp, strstr(s, "=")+1, MAXFILENAME);
			configSetLogFile(tmp);
		}
	}
	fclose(fp);
	return 1;
}



/******************************************************************************/
/***************************************************** CONFIG GET LOG FILE ****/
/******************************************************************************/
char *configGetLogFile(void) {
	return loggerGetFile();
}



/******************************************************************************/
/***************************************************** CONFIG SET LOG FILE ****/
/******************************************************************************/
void configSetLogFile(char *fn) {
	loggerSetFile(fn);
}



/******************************************************************************/
/*************************************************** CONFIG GET TIPO INPUT ****/
/******************************************************************************/
tipoInput configGetTipoInput(void) {
	return _configTipoInput;
}



/******************************************************************************/
/*************************************************** CONFIG SET TIPO INPUT ****/
/******************************************************************************/
void configSetTipoInput(tipoInput tipo) {
	_configTipoInput = tipo;
}



/******************************************************************************/
/****************************************************** CONFIG GET REGIONE ****/
/******************************************************************************/
char* configGetRegione(void) {
	return _configRegione;
}



/******************************************************************************/
/****************************************************** CONFIG SET REGIONE ****/
/******************************************************************************/
void configSetRegione(char* regione) {
	_configRegione = utilConcatena(2, "regione.", regione);		// strdup(regione);
}



/******************************************************************************/
/***************************************************** CONFIG GET EMANANTE ****/
/******************************************************************************/
char* configGetEmanante(void) {
	return _configEmanante;
}



/******************************************************************************/
/***************************************************** CONFIG SET EMANANTE ****/
/******************************************************************************/
void configSetEmanante(char* emanante) {
	_configEmanante = strdup(emanante);
}
