/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		config.h
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
******************************************************************************/

#ifndef __CONFIG_H__
#define __CONFIG_H__

#include "parser.h"

void configConfigInLog(void);

int configLeggi(char *fn);

char *configGetLogFile(void);
void configSetLogFile(char *fn);

tipoInput configGetTipoInput(void);
void configSetTipoInput(tipoInput tipo);

char *configGetRegione(void);
void configSetRegione(char* regione);

char *configGetEmanante(void);
void configSetEmanante(char* emanante);

int configGetRifFra(void);
void configSetRifFra(int frammento);

#endif
