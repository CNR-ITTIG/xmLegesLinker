/******************************************************************************
* Project:	xmLeges
* Module:		Linker
* File:		parser.c
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
*			PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
******************************************************************************/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <search.h>

#include <IttigUtil.h>
#include <IttigLogger.h>
#include "parser.h"
#include "uscita.h"
#include "config.h"
#include "urn.h"

const char *versione = "1.11";

extern FILE * yyin;
extern urn *urns[];
extern int nurns;
extern ids *tabSupIds[];
extern int nSupIds;
extern ids *tabInfIds[];
extern int nInfIds;

char  *fpTmpMem = NULL;
size_t fpTmpSize = 1000000;
char *	fpPreMem = NULL;
size_t	fpPreSize;
int 	fpPrePos;

int posComp(urn **a, urn **b);
void help(void);
//void closeLogFile();

int main(int argc, char *argv[]) {
	register int i;
	int c;

	tipoInput paramInput = txt;
	trattamentoLink paramLink = keep;
	char *paramPrima = "<a href=\"http://www.nir.it/cgi-bin/N2Ln?__URN__\">";
	char *paramDopo = "</a>";
	char *paramNocPrima = "<?rif <rif xlink:href=\"__URN__\">";
	char *paramNocDopo = "</rif>?>";
	int paramRifNoc = 0; 	// riferimenti non completi = no
	int paramRifInt = 0; 	// riferimenti interni = no
	int paramRifFra = 0; 	// commento frammento = no
	int param1stRif = 0; 	// ignora primo riferimento = no
	int markDtdNir = 0;		// marcatura con dtd nir

	tipoUscita paramUscita = doc;
	char *paramRegione = NULL;
	char *paramMinistero = NULL;
	char *paramEmanante = NULL;
	char *paramFile = NULL;
	char *paramFileOut = NULL;
//	FILE *fileout = stdout;

	int fpTmpInc = 1000000;

	opterr = 0;
	while ((c = getopt (argc, argv, "i:l:b:a:m:o:r:R:E:L:M:f:F:v:h1c:g")) != -1)
		switch (c) 
		{
			case 'i':	// TIPO DI INPUT
				if (!strcmp(optarg, "txt")) 		paramInput = txt;
				else if (!strcmp(optarg, "html")) 	paramInput = html;
				else if (!strcmp(optarg, "xml")) 	paramInput = xml;
				else help();
				configSetTipoInput(paramInput);
				break;
			case '1':	// IGNORA PRIMO RIFERIMENTO TROVATO
				param1stRif = 1;
				break;
			case 'l':	// TIPO TRATTAMENTO LINK
				if (!strcmp(optarg, "keep")) 		paramLink = keep;
				else if (!strcmp(optarg, "replace")) 	paramLink = replace;
				else help();
				break;
			case 'b':	// STRINGA PRIMA DELLA CITAZIONE
				paramPrima = strdup(optarg);
				if (!paramPrima)
					help();
				break;
			case 'a':	// STRINGA DOPO LA CITAZIONE
				paramDopo = strdup(optarg);
				if (!paramDopo)
					help();
				break;
			case 'm':	// IMPOSTAZIONE AUTOMATICA DI -b E -a
				if (!strcmp(optarg, "htmlnir")) ;
				else if (!strcmp(optarg, "dtdnir")) 
				{
					paramPrima = "<rif xlink:href=\"__URN__\">";
					paramDopo = "</rif>";
					markDtdNir = 1;
				} 
				else if (!strcmp(optarg, "urn")) 
				{
					paramPrima = "<urn urn=\"__URN__\">";
					paramDopo = "</urn>";
				} 
				else
					help();
				break;
			case 'r':	// TIPO RIFERIMENTI: non completi, interni
				if (strchr(optarg, 'n')) 	paramRifNoc = 1;
				if (strchr(optarg, 'i')) 	paramRifInt = 1;
				if (strchr(optarg, 'f')) 	paramRifFra = 1;
				break;
			case 'o':	// TIPO DI USCITA
				if (!strcmp(optarg, "doc")) 		paramUscita = doc;
				else if (!strcmp(optarg, "rif")) 	paramUscita = rif;
					else if (!strcmp(optarg, "list")) 	paramUscita = list;
						else help();
				break;
			case 'R':	// REGIONE
				paramRegione = (char *)strdup(optarg);
				if (!strlen(paramRegione))
					help();
				configSetRegione(paramRegione);
				break;
			case 'M':	// MINISTERO
				paramMinistero = (char *)strdup(optarg);
				if (!strlen(paramMinistero))
					help();
				break;
			case 'E':	// EMANANTE
				paramEmanante = (char *)strdup(optarg);
				if (!strlen(paramEmanante))
					help();
				configSetEmanante(paramEmanante);
				break;
			case 'f':	// FILE di INPUT
				paramFile = (char *)strdup(optarg);
				if (!(yyin = fopen(paramFile, "r"))) 
				{
					printf("Errore apertura file input: %s\n", paramFile);
					exit(1);
				}
				break;
			case 'F':	// FILE di OUTPUT
				paramFileOut = (char *)strdup(optarg);
				if (!(stdout = fopen(paramFileOut, "w"))) 
				{
					printf("Errore apertura file output: %s\n", paramFileOut);
					exit(1);
				}
				break;
			case 'v':	// Livello Logger
				if (!loggerInit(optarg))	help();
				break;
			case 'L':	//Disattiva output
				if (!loggerSetOutputEnabled(optarg))	help();
				break;
			case 'h':
				help();
				break;
			case 'g':	// GUI (chiamata da Nirvana)
				break;
			case 'c':	// CONFIGURAZIONE
				break;
			case '?':
				if (isprint (optopt))
					printf ("Opzione sconosciuta `-%c'.\n", optopt);
				else
					printf ("Carattere opzione sconosciuto `\\x%x'.\n", optopt);
				help();
				break;
			default:
				abort ();
		}

	// congruità parametri rif. non completi, interni e frammento

	if (paramUscita == doc)
	{
		if (!markDtdNir || paramInput != xml)	paramRifNoc, paramRifInt = 0;
	}
	if (paramRifFra == 1)
	{
		if (!markDtdNir || paramInput == html || !(paramUscita == doc))	paramRifFra = 0;
	}
	configSetRifFra(paramRifFra);				

	if (paramInput == xml)	// non ignora primo riferimento 
		param1stRif = 0;
	
	//loggerImpostaLivello(none);
	loggerInfo("-------------------------------------------");
	loggerInfo("START");
	loggerVersion((char *)versione);

	utilPercSet(0);	

	if (!paramFile)
		yyin = stdin;

	fpTmpMem = malloc(sizeof(char) * fpTmpSize);
	for (i = 0; !feof(yyin); i++) 
	{
		if (i == fpTmpSize) 
		{
			fpTmpSize += fpTmpInc;
			fpTmpMem = realloc(fpTmpMem, sizeof(char) * fpTmpSize);
		}
		fpTmpMem[i] = fgetc(yyin);
		if (fpTmpMem[i] == EOF)
			break;
	}
	fpTmpMem[i] = 0;
	fclose(yyin);
	fpPreSize = fpTmpSize = i;

// eliminazione riferimenti non completi gia' presenti

	if (paramInput == xml)
	{
		lev_scan_bytes(fpTmpMem, fpTmpSize);
		levlex();
		fpPreSize = fpTmpSize;
		fpTmpMem[fpTmpSize] = 0;
	}

// pre-elaborazione del documento

	fpPreMem = malloc(sizeof(char) * fpPreSize);
	pre_scan_bytes(fpTmpMem, fpTmpSize);
	preparse();

	utilPercAdd(4);
	
	utilPercNumBlockSet(0);
	utilPercBlockSetLen(fpPreSize);
	
// riconoscimento dei riferimenti esterni completi

	rifInit();
	yy_scan_bytes(fpPreMem, fpPreSize);
	yyparse();
	uscitaMascheraRif(fpPreMem, urns, nurns);	// mascheramento completi

// riconoscimento dei riferimenti non completi

	if (paramRifNoc + paramRifInt)
	{
		nocInit();
		noc_scan_bytes(fpPreMem, fpPreSize);
		nocparse();
		uscitaMascheraRif(fpPreMem, urns, nurns);	// mascheramento non completi
	}

// riconoscimento dei riferimenti interni

	if (paramRifInt)
	{
		ids_scan_bytes(fpTmpMem, fpTmpSize);		// carica tabella id delle partizioni
		idslex();
		urnCloseIds();

		intInit();
		int_scan_bytes(fpPreMem, fpPreSize);
		intparse();
	}

// ordina urns per posizione

	qsort(urns, nurns, sizeof(urn *), posComp);

// completa riferimenti interni e controlla esistenza id

	if (paramRifInt)
	{
		urnCheckMod();
		urnCheckVirg();
		urnCompletaId();
	}

	switch (paramUscita) 
	{
		case doc:
			uscitaInserimento(fpTmpMem, urns, param1stRif, nurns, paramPrima, paramDopo, paramRifNoc, paramNocPrima, paramNocDopo);
			break;
		case rif:
			uscitaListaConTesto(fpTmpMem, urns, param1stRif, nurns, paramRifNoc, paramNocPrima, paramNocDopo);
			break;
		case list:
			uscitaLista(urns, param1stRif, nurns);
			break;
	}
	loggerInfo("END");

	utilPercSet(100);

	fflush(stdout);
	return 0;
}

// compara posizione urn

int posComp(urn **a, urn **b)
{
	return ((*a)->inizio - (*b)->inizio);
}

void appendStringToPreprocess(char *s) 
{
	int len = strlen(s);
	if (len + fpPrePos <= fpPreSize) 
	{
		memcpy(fpPreMem + fpPrePos, s, len);
		fpPrePos += len;
	}
}

void appendCharsToPreprocess(int n, int c) 
{
	register int i;
	if (n + fpPrePos <= fpPreSize) 
	{
		for (i = 0; i < n; i++)
			*(fpPreMem + fpPrePos + i) = c;
		fpPrePos += n;
	}
}

void erroreParserToLog(char *str, char *text) 
{
	loggerDebug(utilConcatena(3, str, " -> ", text));
}



void help(void) 
{
	puts("SINTASSI:");
	puts("xmLeges-Linker [opzioni] [-f file] [-F file] ...");
	puts("");
	puts("DESCRIZIONE:");
	puts("Il programma riconosce i riferimenti all'interno di un testo, costruisce il nome uniforme (URN) del provvedimento citato ed effettua la richiesta marcatura (es. link ipertestuale in Html) del riferimento stesso con la URN calcolata.");
	puts("Il programma si comporta come un filtro: legge da standard input e scrive su standard output.");
	puts("E' possibile effettuare una qualsiasi marcatura dei riferimenti, utilizzando la keyword \"__URN__\" per l'inserimento delle URN calcolate.");
	puts("Esempio:");
	puts("xmLeges-Linker -b \"<norma urn=\"__URN__\">\" -a \"</norma>\" <legge.txt >legge.out");
	puts("");
	puts("OPZIONI:        [N.B. il primo elemento delle liste e' il valore default]");
	puts("-f <file>: legge da file invece che da standard input");
	puts("-F <file>: scrive su file invece che su standard output");
	puts("-i <txt|html|xml>: formato del documento da analizzare:");
	puts("                     - txt:  testo ascii, senza nessuna marcatura");
	puts("                     - html: testo marcato in HTML");
	puts("                     - xml:  testo marcato in XML, secondo il DTD-NIR");
	puts("-1: se input non xml, ignora il primo riferimento trovato (intestazione)");
	puts("-b <str>: tag di inizio marcatura del riferimento");
	puts("-a <str>: tag di fine marcatura del riferimento");
	puts("-m <htmlnir|dtdnir|urn>: marcatura richiesta (impostazione automatica di -a -b):");
	puts("                     - htmlnir: tag HTML per accedere al risolutore di Norme in Rete:");
	puts("                         -b \"<a href=\"http://www.nir.it/cgi-bin/N2Ln?__URN__\">\"");
	puts("                         -a \"</a>\"");
	puts("                     - dtdnir:  tag XML conformi alla DTD-NIR:");
	puts("                         -b \"<rif xlink:href=\"__URN__\">\"");
	puts("                         -a \"</rif>\"");
	puts("                     - urn:  tag <urn></urn> per test");
	puts("                         -b \"<urn urn=\"__URN__\">\"");
	puts("                         -a \"</urn>\"");
	puts("-o <doc|rif|list>: tipo di uscita:");
	puts("                     - doc:  inserimento della marcatura nel testo");
	puts("                     - rif:  lista dei riferimenti trovati, con URN, posizioni e contesti:");
	puts("                             URN   inizio   fine   ante   rif   post");
	puts("                     - list: lista dei soli URN trovati, con relative posizioni:");
	puts("                             URN   inizio   fine");
	puts("-r <ni>: tipo di riferimenti:");
	puts("                     - n:  segnalazione dei riferimenti non completi (solo dtdnir)");
	puts("                     - i:  marcatura dei riferimenti interni (solo dtdnir)");
	puts("                     - f:  inserisce in commento partizioni non convertite in ID del frammento");
	puts("-R <regione>:   regione di default se non specificata (per L.R. o REGOL.REG.)");
	puts("-M <ministero>: [non attivato] ministero di default se non specificato (per D.M. o O.M.)");
	puts("-E <emanante>:  istituzione emanante di default se non specificata (altri atti)");
	puts("-v: livello di log: error, warn, info, debug");
	puts("-L <stderr|file=nome> : attiva i log indicati(ripetibile)");
	puts("                        Esempio1: -L strerr");
	puts("                        Esempio2: -L strerr -L file=xmLeges-Link.log");
	puts("-l <keep|replace>: trattamento dei link gia' presenti:");
	puts("                     - keep:    mantiene i link, non analizza il testo compreso");
	puts("                     - replace: [non ancora attivo]");
	puts("-h: visualizza l'help");
	puts("");
	puts("Software sviluppato dall'ITTIG/CNR sugli standard del progetto \"Norme in Rete\".");
	puts("Copyright: ITTIG/CNR - Firenze - Italy.");
	puts("Licence: GNU/GPL (http://www.gnu.org/licenses/gpl.html)");
	printf("Versione %s\n",versione);

	exit(1);
}
