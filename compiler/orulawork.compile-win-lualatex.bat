@ECHO OFF

TITLE Compile OrulaWork: %~n1%~x1 - lualatex

ECHO Compiling: %~n1%~x1
ECHO Variant of compile program: "lualatex"
ECHO Filesize: %~z1 bytes

SET filename=%~n1

IF NOT "%~x1" == ".tex" (
	ECHO Error: Can only compile files with extension .tex
	PAUSE
	EXIT /b
)

FIND /I "orulawork" %filename%.tex >nul
IF %errorlevel% EQU 1 (
	ECHO Error: Document does not appear to be a valid OrulaWork:
	ECHO Must contain "\documentclass[<options>]{orulawork}"
	PAUSE
	EXIT /b
)

set tempext=aux bbl blg brf cut djs idx ilg ind lof log lol lot out toc sol qsl synctex.gz

FOR /L %%G IN (1,1,3) DO (
	lualatex -jobname=%filename% "\input{%filename%.tex}"
)


FOR %%E in (%tempext%) do (
	del *.%%E
)