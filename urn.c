/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		urn.c
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*			PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include <IttigUtil.h>
#include <IttigLogger.h>
#include "util.h"
#include "urn.h"

urn *urns[10000];
int nurns = 0;

ids *tabSupIds[10000];
int nSupIds = 0;

ids *tabInfIds[10000];
int nInfIds = 0;

/******************************************************************************/
/**************************************************************** IDS CLOSE ****/
/******************************************************************************/

void urnCloseIds() 
{
	int i;
	ids *tab = (ids *) malloc (sizeof(ids));
	tabSupIds[nSupIds] = tab;
	tabSupIds[nSupIds] -> posiz = LONG_MAX;
	tabSupIds[nSupIds] -> value = strdup("zzzzz");
	for (i=0; i<nSupIds; i++)
			tabSupIds[i] -> posiz = tabSupIds[i+1] -> posiz;
	tabInfIds[nInfIds] = tab;
	tabInfIds[nInfIds] -> posiz = LONG_MAX;
	tabInfIds[nInfIds] -> value = strdup("zzzzz");
	for (i=0; i<nInfIds; i++)
			tabInfIds[i] -> posiz = tabInfIds[i+1] -> posiz;
}

/******************************************************************************/
/**************************************************************** URN INIT ****/
/******************************************************************************/

void urnInit(urn *u) 
{
	urnShift(u);
	u->fine = LONG_MIN;
	u->inizio = LONG_MAX;
}

void urnShift(urn *u) 
{
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

void urnFree(urn *u) 
{
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
char * urnStringa(urn u) 
{
	char * ret;
	char * pun;
	char cdc[100];
	int len = 0;
	int i;

	ret = utilConcatena(1, "");
	if (u.tipo != 'i')		// riferimenti non interni
	{
		if (u.autorita) {						// converto ' ' e '-' in '.'
			utilSostStr(u.autorita, "-", " ");
			utilCompact(u.autorita);
			utilSostStr(u.autorita, " ", ".");
		}

		if (u.autorita) 	ret = utilConcatena(5, "urn:nir:", u.autorita, ":", u.provvedimento, ":");
		else 			ret = utilConcatena(3, "urn:nir::", u.provvedimento, ":");

		if (u.numero) {
			if (u.autorita && !strcmp(u.autorita,"comunita.europee")) {
				if (!strncasecmp(u.numero,"n",1) || 
				    (u.provvedimento && !strcmp(u.provvedimento,"regolamento")))
					len = 1;
				pun = utilCercaCifra(u.numero);
				strcpy(u.numero, pun);					/* tolgo n. */
				if (!u.data) {
					strcpy(cdc, u.numero);				/* salvo stringa */
					if (len) {
						pun = utilCercaNonNum(cdc);		/* skip numero */
						pun = utilCercaCifra(pun);		/* skip barra */
						strcpy(cdc, pun);				/* tolgo numero/ */
					}
					pun = utilCercaNonNum(cdc);			/* fine anno */
					if (pun) *pun = '\0';
					u.data = strdup(cdc);
				}
			}			
			for (pun = u.numero; pun = strpbrk(pun,"/#%:;,+@*"); *pun = '-');	// converto car. non ammessi

			for (i = 0; u.numero[i] == '0'; i++);		// tolgo zeri iniziali
			if (i) strcpy(u.numero, u.numero + 1);
		}

		if (u.data) {
			if (strlen(u.data) == 2) {					// anno di 2 cifre?
				strcpy(cdc, u.data);					// copio anno
				strcat(cdc, u.data);					// duplico anno
				if (*cdc == '0')	strncpy(cdc, "20", 2);
				else 			strncpy(cdc, "19", 2);
				u.data = strdup(cdc);
			}
			ret = utilConcatena(2, ret, u.data);
		}

		if (u.numero)
			ret = utilConcatena(3, ret, ";", u.numero);
	}

	strcpy(cdc, urnPartizioni(u));
	if (cdc[0])
		ret = utilConcatena(3, ret, "#", cdc);
	utilStringToLower(ret);
	return ret;

}


/******************************************************************************/
/********************************************************** URN PARTIZIONI ****/
/******************************************************************************/
char * urnPartizioni(urn u) {
	char * ret;
	int len = 0;
	int i;

//	if (u.lib || u.prt || u.tit || u.cap || u.sez || u.art) 
//	{
		ret = utilConcatena(1, "");
		if (u.lib) ret = utilConcatena(4, ret, "lib", u.lib, "-");
		if (u.prt) ret = utilConcatena(4, ret, "prt", u.prt, "-");
		if (u.tit) ret = utilConcatena(4, ret, "tit", u.tit, "-");
		if (u.cap) ret = utilConcatena(4, ret, "cap", u.cap, "-");
		if (u.sez) ret = utilConcatena(4, ret, "sez", u.sez, "-");
		if (u.art) ret = utilConcatena(4, ret, "art", u.art, "-");
		if (u.tipo == 'e')
		{
			if (u.art && u.com) 		ret = utilConcatena(4, ret, "com", u.com, "-");
			if (u.art && u.com && u.let)	ret = utilConcatena(4, ret, "let", u.let, "-");
			if (u.art && u.com && u.num)	ret = utilConcatena(4, ret, "num", u.num, "-"); 
//			if (u.art && u.com && u.prg)	ret = utilConcatena(4, ret, "prg", u.prg, "-");
		}
		else
		{
			if (u.com) ret = utilConcatena(4, ret, "com", u.com, "-");
			if (u.let) ret = utilConcatena(4, ret, "let", u.let, "-");
			if (u.num) ret = utilConcatena(4, ret, "num", u.num, "-");
//  			if (u.prg) ret = utilConcatena(4, ret, "prg", u.prg, "-");
		}
		len = strlen(ret);
		if (ret[len-1] == '-')
			ret[len-1] = 0;
		
//	}

	return ret;
}


/******************************************************************************/
/*********************************************************** URN MEMORIZZA ****/
/******************************************************************************/
void urnMemorizza(urn u) 
{
	urn *t = (urn *) malloc (sizeof(urn));
	loggerInfo("urn");
	memcpy(t, &u, sizeof(urn));
	urns[nurns++] = t;
}


/******************************************************************************/
/************************************************************ URN COMPLETA ****/
/******************************************************************************/
void urnCompletaId() 
{
	register int i=0, ji=0, js=0, k=0;
	char* p;
	char tmp[100];
	char lab[100];
	char idc[100];
	int nc = 0;		// numero caratteri
	for (i=0; i<nurns; i++)
	{
		if (urns[i]->tipo == 'i')
		{
			strcpy(tmp, urnPartizioni(*urns[i]));	// costruisco id dal rif.
			if (strstr(tmp, "art"))				// presente articolo: id completo
			{
				if (urnCercaId(tabInfIds, nInfIds, tmp))	// non trovato id uguale
					urns[i]->tipo = 'n';				// trasformo in rif. non completo
			}
			else								// manca articolo: id forse incompleto
			{
				if (strstr(tmp, "com") || strstr(tmp, "let") || strstr(tmp, "num")) // inferiore: id incompleto
				{
					for ( ; tabInfIds[ji]->posiz < urns[i]->inizio; ji++); // cerco id subito prima
												// ji = indice elemento contenitore
					strncpy(lab, tmp, 3);			// estraggo prima label
					lab[3] = 0;					// chiudo stringa
					nc = 1;
					p = strstr(tabInfIds[ji]->value, lab); 	// cerco in id prima label
					if (p)							// esiste un id con la partizione citata
					{
						nc = (p - tabInfIds[ji]->value);		// calcolo lunghezza testa id
						strncpy(lab, tabInfIds[ji]->value, nc);	// copio testa id
						lab[nc] = 0;						// chiudo stringa
						strcpy(idc, lab);
						strcat(idc, tmp);			// id completo

						nc = urnCercaId(tabInfIds, nInfIds, idc);
						if (!nc)					// trovato id uguale
						{
							utilEstrai(tmp, lab, "art", "-");
							urns[i]->art = strdup(tmp);
							utilEstrai(tmp, lab, "com", "-");
							if (*tmp && !urns[i]->com) urns[i]->com = strdup(tmp);
							utilEstrai(tmp, lab, "let", "-");
							if (*tmp && !urns[i]->let) urns[i]->let = strdup(tmp);
							utilEstrai(tmp, lab, "num", "-");
							if (*tmp && !urns[i]->num) urns[i]->num = strdup(tmp);
						}
					}
					if (!p || nc)				// non trovato id uguale
						urns[i]->tipo = 'n';	// trasformo in rif. non completo
				}
				else		// partizione superiore all'articolo: id completo o no
				{
					for ( ; tabSupIds[js]->posiz < urns[i]->inizio; js++); // cerco id subito prima
												// js = indice elemento contenitore
					strncpy(lab, tmp, 3);			// estraggo prima label
					lab[3] = 0;					// chiudo stringa
					nc = 1;
					p = strstr(tabSupIds[js]->value, lab); 	// cerco in id prima label
					if (p)							// esiste un id con la partizione citata
					{
						nc = (p - tabSupIds[js]->value);		// calcolo lunghezza testa id
						strncpy(lab, tabSupIds[js]->value, nc);	// copio testa id
						lab[nc] = 0;						// chiudo stringa
						strcpy(idc, lab);
						strcat(idc, tmp);					// id completo

						nc = urnCercaId(tabSupIds, nSupIds, idc);
						if (!nc)				// trovato id uguale
						{
							utilEstrai(tmp, lab, "lib", "-");
							if (*tmp && !urns[i]->lib) urns[i]->lib = strdup(tmp);
							utilEstrai(tmp, lab, "prt", "-");
							if (*tmp && !urns[i]->prt) urns[i]->prt = strdup(tmp);
							utilEstrai(tmp, lab, "tit", "-");
							if (*tmp && !urns[i]->tit) urns[i]->tit = strdup(tmp);
							utilEstrai(tmp, lab, "cap", "-");
							if (*tmp && !urns[i]->cap) urns[i]->cap = strdup(tmp);
							utilEstrai(tmp, lab, "sez", "-");
							if (*tmp && !urns[i]->sez) urns[i]->sez = strdup(tmp);
						}
					}
					if (!p || nc)				// non trovato id uguale
						urns[i]->tipo = 'n';	// trasformo in rif. non completo
				}
			}
		}
	}
}

/******************************************************************************/
/************************************************************ URN CERCA ID ****/
/******************************************************************************/
// cerca id del riferimento in tabella id del documento

int urnCercaId(ids *tab[], int nt, char str[])
{
	int k , nc;

	nc = 1;
	for (k=0; k<nt; k++)		// scorro tabelle id
	{
		nc = strcmp(tab[k]->value, str);
		if (!nc)		break;
	}
	return(nc);
}


