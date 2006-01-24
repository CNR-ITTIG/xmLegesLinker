/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		util.h
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
******************************************************************************/

#ifndef __UTIL__
#define __UTIL__

#define MAX_AUTORITA		50
#define MAX_PROVVEDIMENTO	50


//new
void utilPercPrint(void);
void utilPercSet(int pPerc);
void utilPercAdd(int pPerc);
void utilPercBlockSetLen(int pPosLen);
void utilPercBlockFromPos(int PosCurr);
void utilPercBlockCalc(int pPerc, int PosCurr);
void utilPercNumBlockSet(int pNumAnnessi);
//--


#endif
