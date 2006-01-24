/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		urn.c
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*		PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include <IttigUtil.h>
#include <IttigLogger.h>
#include "urn.h"

urn *urns[100000];
int nurns = 0;

/******************************************************************************/
/**************************************************************** URN INIT ****/
/******************************************************************************/

void urnInit(urn *u) {
	urnShift(u);
	u->fine = LONG_MIN;
	u->inizio = LONG_MAX;
}

void urnShift(urn *u) {
	u->inizio = u->ultimo;
//	u->fine = LONG_MIN;
	u->ultimo = LONG_MAX;
	u->autorita = NULL;
	u->provvedimento = NULL;
	u->data = NULL;
	u->numero = NULL;
	u->suddivisione = NULL;
	u->lib = NULL;
	u->prt = NULL;
	u->tit = NULL;
	u->cap = NULL;
	u->sez = NULL;
	u->art = NULL;
	u->com = NULL;
	u->let = NULL;
	u->num = NULL;
	u->prg = NULL;
}

void urnFree(urn *u) {
	free(u->autorita);
	free(u->provvedimento);
	free(u->data);
	free(u->numero);
	free(u->suddivisione);
	free(u->lib);
	free(u->prt);
	free(u->tit);
	free(u->cap);
	free(u->sez);
	free(u->art);
	free(u->com);
	free(u->let);
	free(u->num);
	free(u->prg);
}


/******************************************************************************/
/************************************************************* URN STRINGA ****/
/******************************************************************************/
char * urnStringa(urn u) {
	char * ret;
	char * pun;
	char cdc[50];
	int len = 0;

	ret = utilConcatena(5, "urn:nir:", u.autorita, ":", u.provvedimento, ":");

	if (u.numero) {
		if (!strcmp(u.autorita,"comunita.europee")) {
			if (!strncasecmp(u.numero,"n",1) || 
			    !strcmp(u.provvedimento,"regolamento"))
				len = 1;
			pun = utilCercaCifra(u.numero);
			strcpy(u.numero, pun);		/* tolgo n. */
			if (!u.data) {
				strcpy(cdc, u.numero);		/* salvo stringa */
				if (len) {
					pun = utilCercaNonNum(cdc);		/* skip numero */
					pun = utilCercaCifra(pun);		/* skip barra */
					strcpy(cdc, pun);		/* tolgo numero/ */
				}
				pun = utilCercaNonNum(cdc);		/* fine anno */
				if (pun) *pun = '\0';
				u.data = strdup(cdc);
			}
		}			
		for (pun = u.numero; pun = strpbrk(pun,"/#%:;,+@*"); *pun = '-');
	}

	if (u.data) {
		if (strlen(u.data) == 2) {		// anno di 2 cifre?
			strcpy(cdc, u.data);		// copio anno
			strcat(cdc, u.data);		// duplico anno
			if (*cdc == '0')	strncpy(cdc, "20", 2);
			else 			strncpy(cdc, "19", 2);
			u.data = strdup(cdc);
		}
		ret = utilConcatena(2, ret, u.data);
	}

	if (u.numero)
		ret = utilConcatena(3, ret, ";", u.numero);

	if (u.lib || u.prt || u.tit || u.cap || u.sez || u.art) {
		ret = utilConcatena(2, ret, "#");
		if (u.lib) ret = utilConcatena(4, ret, "lib", u.lib, "-");
		if (u.prt) ret = utilConcatena(4, ret, "prt", u.prt, "-");
		if (u.tit) ret = utilConcatena(4, ret, "tit", u.tit, "-");
		if (u.cap) ret = utilConcatena(4, ret, "cap", u.cap, "-");
		if (u.sez) ret = utilConcatena(4, ret, "sez", u.sez, "-");
		if (u.art) ret = utilConcatena(4, ret, "art", u.art, "-");
		if (u.art && u.com) 
			ret = utilConcatena(4, ret, "com", u.com, "-");
		if (u.art && u.com && u.let) 
			ret = utilConcatena(4, ret, "let", u.let, "-");
		if (u.art && u.com && u.let && u.num) 
			ret = utilConcatena(4, ret, "num", u.num, "-");
  		if (u.art && u.com && u.let && u.num && u.prg) 
			ret = utilConcatena(4, ret, "prg", u.prg, "-");
		len = strlen(ret);
		if (ret[len-1] == '-')
			ret[len-1] = 0;
	}
	utilStringToLower(ret);
	return ret;

}


/******************************************************************************/
/*********************************************************** URN MEMORIZZA ****/
/******************************************************************************/
void urnMemorizza(urn u) {
	urn *t = (urn *) malloc (sizeof(urn));
	loggerInfo("urn");
	memcpy(t, &u, sizeof(urn));
	urns[nurns++] = t;
}


