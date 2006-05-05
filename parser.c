/******************************************************************************
* Project:	xmLeges
* Module:	Linker
* File:		parser.c
* Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
* Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
* Authors:	Mirco Taddei (m.taddei@ittig.cnr.it)
******************************************************************************/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "config.h"
#include <IttigUtil.h>
#include <IttigLogger.h>
#include "parser.h"
#include "uscita.h"

const char *versione = "1.0";

extern FILE * yyin;
extern urn *urns[];
extern int nurns;

char *	fpPreMem = NULL;
size_t	fpPreSize;
int 	fpPrePos;


void help(void);
//void closeLogFile();

int main(int argc, char *argv[]) {
	register int i;
	int c;

	tipoInput paramInput = txt;
	trattamentoLink paramLink = keep;
	char *paramPrima = "<a href=\"http://www.nir.it/cgi-bin/N2Ln?__URN__\">";
	char *paramDopo = "</a>";

	tipoUscita paramUscita = doc;
	char *paramRegione = NULL;
	char *paramMinistero = NULL;
	char *paramFile = NULL;
	char *paramFileOut = NULL;
//	FILE *fileout = stdout;

	char  *fpTmpMem = NULL;
	size_t fpTmpSize = 1000000;
	int fpTmpInc = 1000000;

	opterr = 0;
	while ((c = getopt (argc, argv, "i:l:b:a:m:o:R:L:M:f:F:v:hc:g")) != -1)
		switch (c) {
			case 'i':	// TIPO DI INPUT
				if (!strcmp(optarg, "txt")) 		paramInput = txt;
				else if (!strcmp(optarg, "html")) 	paramInput = html;
				else if (!strcmp(optarg, "xml")) 	paramInput = xml;
				else help();
				configSetTipoInput(paramInput);
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
				  else if (!strcmp(optarg, "dtdnir")) {
					paramPrima = "<rif xlink:href=\"__URN__\">";
					paramDopo = "</rif>";
				} else if (!strcmp(optarg, "urn")) {
					paramPrima = "<urn urn=\"__URN__\">";
					paramDopo = "</urn>";
				} else
					help();
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
			case 'f':	// FILE di INPUT
				paramFile = (char *)strdup(optarg);
				if (!(yyin = fopen(paramFile, "r"))) {
					printf("Errore apertura file input: %s\n", paramFile);
					exit(1);
				}
				break;
			case 'F':	// FILE di OUTPUT
				paramFileOut = (char *)strdup(optarg);
				if (!(stdout = fopen(paramFileOut, "w"))) {
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


	//loggerImpostaLivello(none);
	loggerInfo("-------------------------------------------");
	loggerInfo("START");
	loggerVersion((char *)versione);

	utilPercSet(0);	

	if (!paramFile)
		yyin = stdin;

	fpTmpMem = malloc(sizeof(char) * fpTmpSize);
	for (i = 0; !feof(yyin); i++) {
		if (i == fpTmpSize) {
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

	fpPreMem = malloc(sizeof(char) * fpPreSize);
	pre_scan_bytes(fpTmpMem, fpTmpSize);
	/*puts("---------------DOPO PRESCANBYTES------------------");

	puts(fpTmpMem);
	puts("---------------PRIMA PREPARSE------------------");*/
	
	preparse();
	/*puts("------------------DOPO PREPARSE----------------");
	puts(fpPreMem);
	puts("------------------FINE PREPARSE----------------");*/
	utilPercAdd(4);
	//printf("================== PRE\n%s\n================== PRE\n",fpPreMem);
	
	utilPercNumBlockSet(0);
	utilPercBlockSetLen(fpPreSize);

	yy_scan_bytes(fpPreMem, fpPreSize);
	yyparse();
	switch (paramUscita) {
		case doc:
			uscitaInserimento(fpTmpMem, urns, nurns, paramPrima, paramDopo);
			break;
		case rif:
			uscitaListaConTesto(fpTmpMem, urns, nurns);
			break;
		case list:
			uscitaLista(urns, nurns);
			break;
	}
	loggerInfo("END");

	utilPercSet(100);

	fflush(stdout);
	return 0;
}

void appendStringToPreprocess(char *s) {
	int len = strlen(s);
	if (len + fpPrePos <= fpPreSize) {
		memcpy(fpPreMem + fpPrePos, s, len);
		fpPrePos += len;
	}
}

void appendCharsToPreprocess(int n, int c) {
	register int i;
	if (n + fpPrePos <= fpPreSize) {
		for (i = 0; i < n; i++)
			*(fpPreMem + fpPrePos + i) = c;
		fpPrePos += n;
	}
}

void erroreParserToLog(char *str, char *text) {
	loggerDebug(utilConcatena(3, str, " -> ", text));
}



void help(void) {
	puts("SINTASSI:");
	puts("xmLeges-Link [opzioni] [-f file] [-F file] ...");
	puts("");
	puts("DESCRIZIONE:");
	puts("Il programma riconosce i riferimenti all'interno di un testo, costruisce il nome uniforme (URN) del provvedimento citato ed effettua la richiesta marcatura (es. link ipertestuale in Html) del riferimento stesso con la URN calcolata.");
	puts("Il programma si comporta come un filtro: legge da standard input e scrive su standard output.");
	puts("E' possibile effettuare una qualsiasi marcatura dei riferimenti, utilizzando la keyword \"__URN__\" per l'inserimento delle URN calcolate.");
	puts("Esempio:");
	puts("xmLeges-Link -b \"<norma urn=\"__URN__\">\" -a \"</norma>\" <legge.txt >legge.out");
	puts("");
	puts("OPZIONI:        [N.B. il primo elemento delle liste e' il valore default]");
	puts("-f <file>: legge da file invece che da standard input");
	puts("-F <file>: scrive su file invece che su standard output");
	puts("-i <txt|html|xml>: formato del documento da analizzare:");
	puts("                     - txt:  testo ascii, senza nessuna marcatura");
	puts("                     - html: testo marcato in HTML");
	puts("                     - xml:  testo marcato in XML, secondo il DTD-NIR");
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
	puts("-R <regione>: indica la regione di default se non specificata nella citazione");
	puts("-M <ministero>: [non ancora attivo]");
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
	printf("Versione %s\n",versione);

	exit(1);
}