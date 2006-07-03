#!/bin/sh

# ******************************************************************************
# Project:	xmLeges
# Module:		Linker
# File:		xmLeges-Linker.sh
# Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
# Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
# Authors:	PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
# ******************************************************************************
# ------------------------------------------------------------------------------ default x personalizzazione
declare d_path="$HOME/xmLegesLinker"		# path del programma
declare d_dinp="$HOME/Testi"				# directory input
declare d_dout='linker'					# directory output
declare d_tipo='html'					# tipo file
declare d_crdi='si'						# creazione directory
declare d_inte='si'						# riferimenti interni
declare d_elen='si'						# elenco file
declare d_elab='si'						# elaborazione
printf "***********************************************************************\n"
printf "*                         xmLeges-Linker.sh                           *\n"
printf "*       Trasforma i riferimenti normativi in link ipertestuali        *\n"  
printf "*                      per gruppi di file                             *\n"  
printf "*        ITTIG / CNR - Firenze (ver. 1.1 - 03 lug 2006)               *\n"
printf "***********************************************************************\n"
# ------------------------------------------------------------------------------ directory programma
printf "Cartella dove risiede il programma xmLeges-Linker:[$d_path]"
read prpath
if [ -z "$prpath" ]; then prpath=$d_path; fi
if [ ! -d "$prpath" ]; then
	printf "*** ERRORE: Cartella del programma ($prpath) non esiste ***\n"
	printf "*** ELABORAZIONE FERMATA ***\n"
	exit
fi
if [ ! -f "$prpath/xmLeges-Linker.exe" ]; then
	printf "*** ERRORE: Il programma (xmLeges-Linker.exe) non esiste nella cartella ($prpath) ***\n"
	printf "*** ELABORAZIONE FERMATA ***\n"
	exit
fi
declare car1=$(expr substr "$prpath" 1 1)
if [ "$car1" != '/' ]; then prpath="$PWD/$prpath"; fi
# ------------------------------------------------------------------------------ directory input
printf "Cartella di lettura dei file da elaborare:[$d_dinp]"
read dirinp
if [ -z "$dirinp" ]; then dirinp=$d_dinp; fi
if [ ! -d "$dirinp" ]; then
	printf "*** ERRORE: Cartella di lettura dei file ($dirinp) non esiste ***\n"
	printf "*** ELABORAZIONE FERMATA ***\n"
	exit
fi
car1=$(expr substr "$dirinp" 1 1)
if [ "$car1" != '/' ]; then dirinp="$PWD/$dirinp"; fi
# ------------------------------------------------------------------------------ directory output
printf "Cartella di scrittura dei file elaborati:[$d_dout]"
read dirout
if [ -z "$dirout" ]; then dirout="$d_dout"; fi
car1=$(expr substr "$dirout" 1 1)
if [ "$car1" != '.' -a "$car1" != '/' ]; then dirout="$dirinp/$dirout"; fi
if [ "$car1" == '.'  ]; then dirout="$PWD/$dirout"; fi
if [ ! -d "$dirout" ]; then 
	printf "Cartella di scrittura ($dirout) non esiste: creare? (si|no):[$d_crdi]"
	read sino
	if [ -z "$sino" ]; then sino=$d_crdi; fi
	if [ "$sino" == 'si' ]; 	
		then mkdir "$dirout"
		else printf "*** ELABORAZIONE FERMATA ***\n"; exit
	fi
else
	printf "*** ATTENZIONE: La cartella di scrittura ($dirout) esiste ***\n"
	printf "*** ATTENZIONE: I file di uguale nome saranno sovrascritti ***\n"
fi
if [ "$dirinp" == "$dirout" ]; then
	printf "*** ERRORE: Cartella di lettura uguale a quella di scrittura ($dirinp) ***\n"
	printf "*** ELABORAZIONE FERMATA ***\n"
	exit
fi
# ------------------------------------------------------------------------------ tipo files
printf "Tipo di file da elaborare (html|xml):[$d_tipo]" 
read extens
if [ -z "$extens" ]; then extens=$d_tipo; fi
if [ "$extens" != 'html' -a "$extens" != 'xml' ]; then
	printf "*** ERRORE: Tipo di file ($extens) non previsto; indicare 'html' o 'xml' ***\n"
	printf "*** ELABORAZIONE FERMATA ***\n"
	exit
fi
if [ "$extens" == 'html' ]; then extens='htm*'; fi
# ------------------------------------------------------------------------------ rif interni
declare inter='no'
if [ $extens == 'xml' ]; then
	printf "Trasformare anche i riferimenti interni? (si|no):[$d_inte]"
	read inter
	if [ -z "$inter" ]; then inter=$d_inte; fi
fi
# ------------------------------------------------------------------------------ nomi files
printf "Nomi dei file da trasformare (nome*):[*]" 
read names
if [ -z "$names" ]; then names='*'; fi
declare numfil=$(find "$dirinp" -maxdepth 1 -iname "$names.$extens" -printf "%f\n" | wc -l)
if [ $numfil == 0 ]; then
	printf "*** ERRORE: nessun file ($names.$extens) trovato nella cartella ($dirinp) ***\n"
	printf "*** ELABORAZIONE FERMATA ***\n"
	exit
fi	
printf "Numero dei file da trasformare = $numfil\n" 
# ------------------------------------------------------------------------------ lista dei files
printf "Visualizzare elenco? (si|no):[$d_elen]"
read sino
if [ -z "$sino" ]; then sino=$d_elen; fi
if [ "$sino" == 'si' ]; then
	printf "***********************************************************************\n"
	printf "*                  Elenco dei file da trasformare                     *\n"
	printf "***********************************************************************\n"
	find "$dirinp" -maxdepth 1 -iname "$names.$extens" -printf "%f\n"
fi
# ------------------------------------------------------------------------------ riepilogo
printf "***********************************************************************\n"
printf "*                Riepilogo parametri di elaborazione                  *\n"
printf "***********************************************************************\n"
printf "Cartella di lettura dei file     = $dirinp\n" 
printf "Cartella di scrittura dei file   = $dirout\n" 
printf "Estensione dei file da elaborare = $extens\n" 
if [ $extens == 'xml' ]; then
printf "Riferimenti interni              = $inter\n"
fi
printf "Nomi dei file da elaborare       = $names.$extens\n"
printf "Numero dei file da elaborare     = $numfil\n" 
printf "***********************************************************************\n"
printf "Confermi elaborazione? (si|no):[$d_elab]"
read sino
if [ -z "$sino" ]; then sino=$d_elab; fi
if [ "$sino" != 'si' ]; then 
	printf "*** ELABORAZIONE FERMATA ***\n"
	exit
fi
declare param
if [ "$extens" == 'xml' ]; 
	then param="-i xml -m dtdnir"
	else param="-i html -m htmlnir"
fi
if [ "$inter" == 'si' ]; then 
	param="$param -r i"
fi
printf "*** Inizia l'elaborazione ....\n"

cd $dirinp

find . -maxdepth 1 -iname "$names.$extens" -type f -printf "%f\n" -exec "$prpath/xmLeges-Linker.exe" -f '{}' -F "$dirout"/'{}' $param \; 

cd $OLDPWD

printf "*** ELABORAZIONE TERMINATA ***\n"

