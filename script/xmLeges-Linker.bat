@echo off
REM ******************************************************************************
REM Project:	xmLeges
REM Module:		Linker
REM File:		xmLeges-Linker.bat
REM Copyright:	ITTIG/CNR - Firenze - Italy (http://www.ittig.cnr.it)
REM Licence:	GNU/GPL (http://www.gnu.org/licenses/gpl.html)
REM Authors:	PierLuigi Spinosa (pierluigi.spinosa@ittig.cnr.it)
REM ******************************************************************************
setlocal
REM -------------------------------------------------- default x personalizzazione
REM 						path del programma
set d_path=\programmi\xmleges
REM 						directory input
set d_dinp=\dati\testi
REM 						directory output
set d_dout=linker
REM 						tipo file
set d_tipo=html
REM 						creazione directory output
set d_crdi=si
REM 						riferimenti interni
set d_inte=si
REM 						elenco file
set d_elen=no
REM 						elaborazione
set d_elab=no
echo ***********************************************************************
echo *                         xmLeges-Linker.bat                          *
echo *       Trasforma i riferimenti normativi in link ipertestuali        * 
echo *                         per gruppi di file                          *
echo *           ITTIG / CNR - Firenze (ver. 1.1 - 30 giu 2006)            *
echo ***********************************************************************
REM ------------------------------------------------------------------------ directory programma
set prpath=
set /P prpath=Cartella dove risiede il programma xmLeges-Linker:[%d_path%]
if "%prpath%"=="" set prpath=%d_path%
if NOT EXIST "%prpath%" (
	echo *** ERRORE: Cartella del programma ^(%prpath%^) non esiste ***
	echo *** ELABORAZIONE FERMATA ***
	goto fine
)
if NOT EXIST "%prpath%\xmLeges-Linker.exe" (
	echo *** ERRORE: Il programma ^(xmLeges-Linker.exe^) non esiste nella cartella ^(%prpath%^) ***
	echo *** ELABORAZIONE FERMATA ***
	goto fine
)
REM ------------------------------------------------------------------------ directory input
set dirinp=
set /P dirinp=Cartella di lettura dei file da elaborare:[%d_dinp%]
if "%dirinp%"=="" set dirinp=%d_dinp%
if NOT EXIST "%dirinp%" (
	echo *** ERRORE: Cartella di lettura dei file ^(%dirinp%^) non esiste ***
	echo *** ELABORAZIONE FERMATA ***
	goto fine
)
REM ------------------------------------------------------------------------ directory output
set dirout=
set /P dirout=Cartella di scrittura dei file elaborati:[%d_dout%]
if "%dirout%"=="" set dirout=%d_dout%
set car1=%dirout:~1,1%
if "%car1%" EQU ":" goto abs
set car1=%dirout:~0,1%
if "%car1%" EQU "." goto abs
if "%car1%" NEQ "\" set dirout=%dirinp%\%d_dout%
:abs
set sino=
if EXIST "%dirout%" goto desi
set /P sino=Cartella di scrittura ^(%dirout%^) non esiste: creare? ^(si^|no^):[%d_crdi%]
if [%sino%]==[] set sino=%d_crdi%
if %sino%==si (
	mkdir "%dirout%"
	goto dok
) else (
	echo *** ELABORAZIONE FERMATA ***
	goto fine
)
:desi
if "%dirinp%"=="%dirout%" (
	echo *** ERRORE: Cartella di lettura uguale a quella di scrittura ^(%dirinp%^) ***
	echo *** ELABORAZIONE FERMATA ***
	goto fine
)
echo *** ATTENZIONE: La cartella di scrittura ^(%dirout%^) esiste ***
echo *** ATTENZIONE: I file di uguale nome saranno sovrascritti   ***
REM -------------------------------------------------------------------------- tipo files
:dok
set extens=
set /P extens=Tipo di file da elaborare ^(html^|xml^):[%d_tipo%]
if [%extens%]==[] set extens=%d_tipo%
if %extens%==html goto tok
if %extens%==xml goto tok
	echo *** ERRORE: Tipo file ^(%extens%^) non previsto; indicare 'html' o 'xml' ***
	echo *** ELABORAZIONE FERMATA ***
	goto fine
:tok
if %extens%==html set extens=htm*
REM -------------------------------------------------------------------------- rif interni
set inter=
if %extens% NEQ xml goto nam
set /P inter=Trasformare anche i riferimenti interni? ^(si^|no^):[%d_inte%]
if [%inter%]==[] set inter=%d_inte%
REM -------------------------------------------------------------------------- nomi files
:nam
set /P names=Nomi dei file da trasformare ^(nome*^):[*]
if "%names%"=="" set names=*
set /A numfil=0
for %%i in ("%dirinp%\%names%.%extens%") do set /A numfil+=1
if %numfil% EQU 0 (
	echo *** ERRORE: nessun file ^(%names%.%extens%^) trovato nella cartella %dirinp% ***
	echo *** ELABORAZIONE FERMATA ***
	goto fine
)
echo Numero dei file da trasformare = %numfil%
REM -------------------------------------------------------------------------- lista dei files
set sino=
set /P sino=Visualizzare elenco? ^(si^|no^):[%d_elen%]
if [%sino%]==[] set sino=%d_elen%
if %sino%==si (
	echo ***********************************************************************
	echo *                  Elenco dei file da trasformare                     *
	echo ***********************************************************************
	for %%i in ("%dirinp%\%names%.%extens%") do dir /B "%%i"
)
echo ***********************************************************************
echo *                Riepilogo parametri di elaborazione                  *
echo ***********************************************************************
echo Cartella di lettura dei file     = %dirinp%
echo Cartella di scrittura dei file   = %dirout%
echo Estensione dei file da elaborare = %extens%
if %extens%==xml (
echo Riferimenti interni              = %inter%
)
echo Nomi dei file da elaborare       = %names%.%extens%
echo Numero dei file da elaborare     = %numfil%
echo ***********************************************************************
set sino=
set /P sino=Confermi elaborazione? ^(si^|no^):[%d_elab%]
if [%sino%]==[] set sino=%d_elab%
if %sino% NEQ si (
	echo *** ELABORAZIONE FERMATA ***
	goto fine
)
if %extens% NEQ xml (
	set param=-i html -m htmlnir
	goto run
)
if %extens%==xml set param=-i xml -m dtdnir
if %inter%==si set param=%param% -r i
REM -------------------------------------------------------------------------- esecuzione
:run
echo *** Inizia l'elaborazione ....
for %%i in ("%dirinp%\%names%.%extens%") do (
	@echo File=%%~nxi
REM	@echo "%prpath%\xmLeges-Linker.exe" -f "%%i" -F "%dirout%\%%~nxi" %param%
	"%prpath%\xmLeges-Linker.exe" -f "%%i" -F "%dirout%\%%~nxi" %param%
)
echo *** ELABORAZIONE TERMINATA.
:fine
