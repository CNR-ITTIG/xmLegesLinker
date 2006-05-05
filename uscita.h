/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		uscita.h
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
******************************************************************************/

#ifndef __USCITA_H__
#define __USCITA_H__

#include "urn.h"

void uscitaLista(urn *u[], int n);
void uscitaListaConTesto(char *buf, urn *u[], int n, int noc, char *nocprima, char *nocdopo );
void uscitaInserimento(char *buf, urn *u[], int n, char *prima, char *dopo, int noc, char *nocprima, char *nocdopo);
void uscitaMascheraRif(char *buf, urn *u[], int n);

#endif /* __USCITA_H__ */
