/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		pre.y
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*		PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include <IttigLogger.h>
#include "parser.h"
#include "util.h"
#include "urn.h"

int predebug = 0;		/* per debug */

int prewrap() {
	return 1;
}

void preerror(const char *str) {
}

%}

%token COPY
%token SPACE
%token BREAK

%%

documento:
	/* vuoto */
	|
	documento parola
	;


parola:
	COPY
		{ appendStringToPreprocess((char *)$1); }
	|
	SPACE
		{ appendCharsToPreprocess($1, ' '); }
	|
	BREAK
		{ appendCharsToPreprocess($1, '#'); }
;

%%
