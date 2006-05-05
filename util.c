/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		util.c
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*			PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

#include "util.h"
#define _XOPEN_SOURCE
#include <IttigUtil.h>
#include <IttigLogger.h>


//-----------------------FUNZIONI USATE PER IL CALCOLO DELLE PERCENTUALI------------------

static float mPercSingoloElemento=100;
static float mCurrPerc=0;	//Percentuale di esecuzione Corrente
static int mLastPerc=0;	//Percentuale di esecuzione Corrente
static int mLastPos=0;
static int mPosLen=0;

void utilPercPrint(void)
{
	loggerPerc((char *)utilItoa((int)mCurrPerc));
}

//Forza la percentuale corrente
void utilPercSet(int pPerc)
{
	mCurrPerc=pPerc;
	utilPercPrint();
}

//Aggiunge alla percentuale corrente
void utilPercAdd(int pPerc)
{
	mCurrPerc+=pPerc;
	utilPercPrint();
}

void utilPercBlockSetLen(int pPosLen)
{
	mPosLen=pPosLen;
}

void utilPercBlockFromPos(int PosCurr)
{
	if (mPosLen>0){
		mCurrPerc=100.0f*((float)PosCurr/(float)mPosLen);

		if ((mCurrPerc-mLastPerc)>5.0f)
		{
			mLastPerc=mCurrPerc;
			utilPercPrint();
		}
	}
}

//void utilPercBlockCalc(int pPerc,int PosCurr)
//{
//	mCurrPerc+= (mPercSingoloElemento/100.0f)*pPerc;
//	//if (mCurrPerc>100.0f )mCurrPerc=100.0f;
//	if ((mCurrPerc-mLastPerc)>5.0f)
//	{
//		mLastPerc=mCurrPerc;
//
//		utilPercPrint();
//	}
//}

//imposta la percentuale per ogni blocco
void utilPercNumBlockSet(int pNumAnnessi)
{
	mPercSingoloElemento= (100.0f-mCurrPerc) /(pNumAnnessi + 1);
}

//----------------------------------------------------------------------------------------
