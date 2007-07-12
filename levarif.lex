/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		levarif.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigLogger.h>
#include "parser.h"

int long levpos=0;

extern char * fpTmpMem;
extern size_t fpTmpSize;

void levAppendString(char *s) 
{
	int len = strlen(s);
	if (len + levpos <= fpTmpSize) 
	{
		memcpy(fpTmpMem + levpos, s, len);
		levpos += len;
	}
}

// <txtrif>(\<\/rif)			BEGIN(finrif); 			/* escludo */
// <finrif>(\?\>)				BEGIN(0); 				/* escludo */
// <finrif>[ a-z0-9]+			 						/* escludo */
// <finrif>(.|\n)				 						/* escludo */

%}

%x	inirif txtrif finrif

%%

(\<\?rif)					BEGIN(inirif); 			/* escludo */

<inirif>[>]				BEGIN(txtrif); 			/* escludo */
<inirif>[ a-z0-9]+			 						/* escludo */
<inirif>(.|\n)				 						/* escludo */

<txtrif>(\<\/rif>[ ]*\?>)	BEGIN(0); 				/* escludo */
<txtrif>[ a-z0-9]+			levAppendString(levtext);  	/* copio */
<txtrif>(.|\n)				levAppendString(levtext);  	/* copio */

[ a-z0-9]+				levAppendString(levtext);  	/* copio */

(.|\n)					levAppendString(levtext);  	/* copio */

<<EOF>>					fpTmpSize = levpos; yyterminate();

%%

int levwrap()
{
	return 1;
}

