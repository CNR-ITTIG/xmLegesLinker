/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		pre.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*		PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigLogger.h>
#include "pre.tab.h"

/* -----------------

(<{HTML2MASK}(.|\n)*>(.|\n)*<\/{HTML2MASK}>)	{if (configGetTipoInput() != html) REJECT;
						prelval=preleng; return BREAK;
						}
						
						
(<\?[^?>]+\?>)				{ if (configGetTipoInput() == txt) REJECT;
					prelval=preleng; return SPACE;
					}
					
puts(prelval);
					flush();
					
						puts(prelval); flush();
----------------- */

%}

HTML2BL		(b|i|u|q|em|sup|span|font|basefont|strong|big|small|strike|s|tt)
HTML2MASK	(head|a)

XML2BL		(h:{HTML2BL})
XML2MASK	(mrif|meta|inlinemeta|num)
XMLRIF		(rif)

%x	mrif head tag comment procinstr

%%

(l('|\x92|&#146;|&apos;))		prelval=preleng; return SPACE;

[[:space:]]+				prelval=preleng; return SPACE;
[\.\/\)\-]				prelval=(int)strdup(pretext); return COPY;

(\(cee?\))				prelval=(int)strdup(pretext); return COPY;

(&agrave;)				{ if (configGetTipoInput() == txt) REJECT;
					prelval=(int)strdup("a       "); return COPY;
					}

(&[^;]*;)				{ if (configGetTipoInput() == txt) REJECT;
					prelval=preleng; return SPACE;
					}

[;:(]					prelval=preleng; return BREAK;

(guce[ ]+([0-9]+[ ]+)?l)		prelval=preleng; return BREAK;

(<(h:)?sup>[oiae]<\/(h:)?sup>)		{ if (configGetTipoInput() == txt) REJECT;
					prelval=preleng; return SPACE;}
					

(<!--)				{ if (configGetTipoInput() == txt) REJECT;
					BEGIN(comment); prelval=preleng; return SPACE;	}
					
<comment>([^>])		{ prelval=preleng; return SPACE; }
					
<comment>(-->)		{ BEGIN(0); prelval=preleng; return SPACE; }
									

(<\?)				{ if (configGetTipoInput() == txt) REJECT;
					BEGIN(procinstr); prelval=preleng; return BREAK; }
					
<procinstr>([^ ?>]+|[ ]+)	{prelval=preleng; return BREAK;}
<procinstr>(.|\n)	{prelval=preleng; return BREAK;}

<procinstr>(\?>)		{ BEGIN(0); prelval=preleng; return BREAK; }



(<\/?{XML2BL}([ ][^>]*)?>)		{ if (configGetTipoInput() != xml) REJECT;
					prelval=preleng; return SPACE;
					}

(<\/?{HTML2BL}([ ][^>]*)?>)		{ if (configGetTipoInput() != html) REJECT;
					prelval=preleng; return SPACE;
					}

(<{XML2MASK}([ ][^>]*)?>)		{ if (configGetTipoInput() != xml) REJECT;
					BEGIN(mrif); prelval=preleng; return BREAK;
					}

<mrif>(<\/{XML2MASK}>)			BEGIN(0); prelval=preleng; return BREAK;

(<{HTML2MASK}([ ][^>]*)?>)		{ if (configGetTipoInput() != html) REJECT;
					BEGIN(head); prelval=preleng; return BREAK;
					}

<head>(<\/{HTML2MASK}>)			BEGIN(0); prelval=preleng; return BREAK;

<mrif,head>([a-z0-9]+|.|\n)		prelval=preleng; return BREAK;

(<{XMLRIF}[^>]*>[^<]*<\/{XMLRIF}>)	{ if (configGetTipoInput() != xml) REJECT;
					prelval=preleng; return BREAK;
					}

(<a[ ]+(name|id)[^>]*>)			{ if (configGetTipoInput() != html) REJECT;
					prelval=preleng; return BREAK; }
					
					
(<)					{ if (configGetTipoInput() == txt) REJECT;
					BEGIN(tag); prelval=preleng; return BREAK; }

<tag>([^>])				{ prelval=preleng; return BREAK; }

<tag>(>)				{ BEGIN(0); prelval=preleng; return BREAK; }



([a-z0-9]+)				prelval=(int)strdup(pretext); return COPY;

.					prelval=preleng; return SPACE;

%%
