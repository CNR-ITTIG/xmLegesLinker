/******************************************************************************
* Project:		xmLeges
* Module:		Linker
* File:			pre.lex
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:		GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:		Mirco Taddei (m.taddei@ittig.cnr.it)
*				PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

%{
#include <stdio.h>
#include <string.h>

#include "config.h"
#include <IttigLogger.h>
#include "pre.tab.h"

/* ----------------- pattern tolti

(<{HTML2MASK}(.|\n)*>(.|\n)*<\/{HTML2MASK}>)	{if (configGetTipoInput() != html) REJECT;
										prelval=preleng; return BREAK;
									}
						
(<\?[^?>]+\?>)			{ if (configGetTipoInput() == txt) REJECT;
						prelval=preleng; return SPACE;
					}
					
						puts(prelval); flush();

<procinstr>([^ ?>]+|[ ]+)	prelval=preleng; return BREAK;
<tag>([a-z0-9]+)			prelval=preleng; return BREAK;

----------------- */

%}

HTML2BL1	(b|i|u|q|em|sup|font|basefont|strong|big|small|strike|s|tt)
HTML2BL2	(span)
HTML2BL		({HTML2BL1}|{HTML2BL2})
HTML2MASK	(head|a)

XML2BL		(h:{HTML2BL1})
XML2BR		(h:{HTML2BL2})
XML2MASK	(mrif|meta|inlinemeta|num|tipoDoc)

S			[[:space:]]

%x	rif mrif head tag comment procinstr

%%

(l('|\?|\x92|&#146;|&apos;|\xe2\x80\x99))	prelval=preleng; return SPACE;

{S}+						prelval=preleng; return SPACE;
[\.\/\)\-]					prelval=(int)strdup(pretext); return COPY;

(\(cee?\))					prelval=(int)strdup(pretext); return COPY;

(&agrave;)					{ if (configGetTipoInput() == txt) REJECT;
							prelval=(int)strdup("a       "); return COPY; }

(&[^;]*;)					{ if (configGetTipoInput() == txt) REJECT;
							prelval=preleng; return SPACE; }

[;:(]						prelval=preleng; return BREAK;

(guce[ ]+([0-9]+[ ]+)?l)		prelval=preleng; return BREAK;

(<(h:)?sup>[oiae]<\/(h:)?sup>)	{ if (configGetTipoInput() == txt) REJECT;
								prelval=preleng; return SPACE;}
   /* ***********************
    * COMMENTO              *
    * ***********************/
(<!--)						{ if (configGetTipoInput() == txt) REJECT;
							BEGIN(comment); prelval=preleng; return SPACE;	}
<comment>([^\->]{1,256})	prelval=preleng; return SPACE;
<comment>(.|\n)				prelval=preleng; return SPACE;
<comment>(-->)				BEGIN(0); prelval=preleng; return SPACE;
   /* ************************
    * PROCESSING INSTRUCTION *
    * ************************/
(<\?)						{ if (configGetTipoInput() == txt) REJECT;
							BEGIN(procinstr); prelval=preleng; return BREAK; }
<procinstr>([^?>]{1,256})	prelval=preleng; return BREAK;
<procinstr>(.|\n)			prelval=preleng; return BREAK;
<procinstr>(\?>)			BEGIN(0); prelval=preleng; return BREAK;

(<\/?{XML2BL}([ ][^>]*)?>)	{ if (configGetTipoInput() != xml) REJECT;
							prelval=preleng; return SPACE; }

(<\/?{XML2BR}([ ][^>]*)?>)	{ if (configGetTipoInput() != xml) REJECT;
							prelval=preleng; return BREAK; }

(<\/?{HTML2BL}([ ][^>]*)?>)	{ if (configGetTipoInput() != html) REJECT;
							prelval=preleng; return SPACE; }

(<{XML2MASK}[ ]*\/>)		{ if (configGetTipoInput() != xml) REJECT;
							prelval=preleng; return BREAK; }
   /* ***********************
    * MRIF e HEAD           *
    * ***********************/
(<{XML2MASK}([ ][^>]*)?>)	{ if (configGetTipoInput() != xml) REJECT;
							BEGIN(mrif); prelval=preleng; return BREAK; }

(<{HTML2MASK}([ ][^>]*)?>)	{ if (configGetTipoInput() != html) REJECT;
							BEGIN(head); prelval=preleng; return BREAK; }

<mrif,head>([^<]{1,256})	|
<mrif,head>(.|\n)			prelval=preleng; return BREAK;
<mrif>(<\/{XML2MASK}>)		BEGIN(0); prelval=preleng; return BREAK;
<head>(<\/{HTML2MASK}>)		BEGIN(0); prelval=preleng; return BREAK;
   /* ***********************
    * RIF                   *
    * ***********************/
(<rif[^>]*>)				{ if (configGetTipoInput() != xml) REJECT;
							BEGIN(rif); prelval=preleng; return BREAK; }
<rif>([^<]{1,256})			|
<rif>(.|\n)					prelval=preleng; return BREAK;
<rif>(<\/rif>)				BEGIN(0); prelval=preleng; return BREAK;
   /* ***********************
    * A                     *
    * ***********************/
(<a[ ]+(name|id)[^>]*>)		{ if (configGetTipoInput() != html) REJECT;
							prelval=preleng; return BREAK; }
   /* ***********************
    * ALTRI TAG             *
    * ***********************/				
(<)						{ if (configGetTipoInput() == txt) REJECT;
						BEGIN(tag); prelval=preleng; return BREAK; }
<tag>([^>]{1,256})		prelval=preleng; return BREAK;
<tag>(>)				BEGIN(0); prelval=preleng; return BREAK;
   /* ***********************
    * NON SIGNIFICATIVI     *
    * ***********************/				
([a-km-z0-9]+)			|
(l+)					prelval=(int)strdup(pretext); return COPY;

.						prelval=preleng; return SPACE;

%%
