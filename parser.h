/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		parser.h
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
******************************************************************************/

#include <stdio.h>
#include "urn.h"


#ifndef __PARSER_H__
#define __PARSER_H__

typedef enum _tipoInput {txt, html, xml} tipoInput;
typedef enum _trattamentoLink {keep, replace} trattamentoLink;
typedef enum _tipoUscita {doc, rif, list} tipoUscita;

//FILE *getLogFile(void);
void appendStringToPreprocess(char *s);
void appendCharsToPreprocess(int n, int c);

void erroreParserToLog(char *str, char *text);

#endif
