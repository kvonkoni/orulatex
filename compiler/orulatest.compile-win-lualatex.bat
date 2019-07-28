@ECHO OFF

TITLE Compile OrulaTest: %~n1%~x1 - lualatex

ECHO Compiling: %~n1%~x1
ECHO Variant of compile program: "lualatex"
ECHO Filesize: %~z1 bytes

SET filename=%~n1

IF NOT "%~x1" == ".tex" (
	ECHO Error: Can only compile files with extension .tex
	PAUSE
	EXIT /b
)

FIND /I "orulatest" %filename%.tex >nul
IF %errorlevel% EQU 1 (
	ECHO Error: Document does not appear to be a valid OrulaTest:
	ECHO Must contain "\documentclass[<options>]{orulatest}"
	PAUSE
	EXIT /b
)

set vers=A B C D
set tempext=aux bbl blg brf cut djs idx ilg ind lof log lol lot out toc sol qsl synctex.gz

FOR %%V in (%vers%) do (
	FOR /L %%G IN (1,1,3) DO (
		lualatex -jobname=%filename%%%V "\newcommand{\TestVersion}{%%V} \newif\ifanswerkey \input{%filename%.tex}"
	)
)

FOR %%V in (%vers%) do (
	FOR /L %%G IN (1,1,3) DO (
		lualatex -jobname=ANSWERKEY-%filename%%%V "\newcommand{\TestVersion}{%%V} \newif\ifanswerkey \answerkeytrue \input{%filename%.tex}"
	)
)

FOR %%E in (%tempext%) do (
	del *.%%E
)