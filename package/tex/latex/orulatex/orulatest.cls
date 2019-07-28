%==============================================
% ORULATEX TEST CLASS
% CREATED BY: Kier von Konigslow
% EMAIL: kvonkonigslow@gmail.com
% DATE: March 28, 2018
%==============================================

%==============================================
% BEGINNING OF CLASS
%==============================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{orulatest}[2018/03/26 v0.5 OrulaTest document class]

%==============================================
% OPTION HANDLING AND PACKAGES
%==============================================

\LoadClass[12pt,oneside]{article}

\RequirePackage{amsmath}
\RequirePackage{ifluatex,ifxetex}

\newif\ifxetexorluatex
\ifxetex
	\RequirePackage{mathspec}
	\xetexorluatextrue
\fi
\ifluatex
	\RequirePackage[no-math]{fontspec}
	\xetexorluatextrue
\fi

% Setting boolean for colour.
\newif\ifcolorenabled
% Setting boolean for tagged
\newif\iftagged
% Setting boolean for including extra worksheet.
\newif\ifworksheet

% Passing paper sizes to the article class.
\DeclareOption{letterpaper}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{a4paper}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{a5paper}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{b5paper}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{executivepaper}{\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{legalpaper}{\PassOptionsToClass{\CurrentOption}{article}}

% Passing the draft option to the article class.
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{article}}

% Setting the font to be Open Dyslexic if the dyslexiafont option is defined.
% NOTE: This option is EXPERIMENTAL.
% NOTE: This option will only work if compiled using xelatex or lualatex.
\DeclareOption{dyslexiafont}{%
	\ifxetex
		\setmainfont[Scale=0.76]{OpenDyslexic3}
		\setmathfont(Digits,Latin,Greek)[Scale=0.76]{OpenDyslexic3}
	\fi
	\ifluatex
		\setmainfont[Scale=0.76]{OpenDyslexic3}
	\fi
	\ifxetexorluatex\else
		\ClassWarningNoLine{orulatest}{Option dyslexiafont can only be selected using XeTeX or LuaTeX. Reverting to default font}
	\fi
}
% Setting the document to be tagged.
% NOTE: Settings derived from this options are EXPERIMENTAL
\DeclareOption{tagged}{\taggedtrue}
% Setting an option for a blank worksheet with an editable form.
\DeclareOption{worksheet}{\worksheettrue}

% Passing colour option to eqexam while also setting ifcolourenabled to true.
\DeclareOption{color}{\colorenabledtrue\PassOptionsToClass{forcolorpaper}{eqexam}}
\DeclareOption{greyscale}{\colorenabledfalse\PassOptionsToClass{forpaper}{eqexam}}

% Passing all residual options to the eqexam package.
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{eqexam}}
\ProcessOptions\relax

% Setting all the required packages for this class.
\RequirePackage[nomessages]{fp}
\RequirePackage[british]{babel}
\RequirePackage{datetime2}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{fmtcount}
\RequirePackage{graphicx}
\ifanswerkey
	\RequirePackage[allowrandomize,pointsonboth,useforms,online,answerkey]{eqexam}
\else
	\RequirePackage[allowrandomize,pointsonboth,useforms,online,nosolutions]{eqexam}
\fi
\RequirePackage{hyperxmp}
\RequirePackage{numdef}
\RequirePackage{xparse}
\RequirePackage{tikz}
\ifluatex
	\RequirePackage{mathastext}
\fi
% Loading the accessibilityMeta package
% ENSURE CORRECT LICENSING.
%\iftagged
%	\RequirePackage[tagged]{accessibilityMeta}%
%\fi

% If hyperref is not already loaded, require hyperref.
\@ifpackageloaded{hyperref}{}{\RequirePackage{hyperref}}

%==============================================
% AUTHOR AND METADATA COMMANDS
%==============================================

% Defining the test metadata commands.
\newcommand{\testmonth}[1]{\newcommand{\TestMonth}{#1}}
\newcommand{\testyear}[1]{\newcommand{\TestYear}{#1}}
\newcommand{\course}[1]{\newcommand{\Course}{#1}}
\newcommand{\test}[1]{\newcommand{\Test}{#1}}
\newcommand{\testauthor}[1]{\newcommand{\TestAuthor}{#1}}
\newcommand{\randseed}[1]{\newcommand{\RandSeed}{#1}}
\newcommand{\formulasheet}[1]{\newcommand{\FormulaSheet}{#1}}
\newcommand{\school}[1]{\newcommand{\School}{#1}}
\newcommand{\institution}[1]{\newcommand{\Institution}{#1}}
\newcommand{\timelimit}[1]{\newcommand{\TimeLimit}{#1}}
\newcommand{\coverpage}[1]{\newcommand{\CoverPage}{#1}}

%==============================================
% GLOBAL DOCUMENT SETTINGS AND MACROS
%==============================================

% Forcing eqexam to try to preserve the vertical space if solutions are shown.
\vspacewithkeyOn

% Forcing eqexam to add annotation if a problem is continued on the next page.
\turnContAnnotOn

% Setting a boolean for colour.
\ifcolorenabled\else
	\selectcolormodel{gray}
\fi

%Customizing the eqexam package.
% Setting default colours. Requires eqexam package.
\proofingsymbolColor{red}
\fillinColor{red}

%Removes the 'solution:' from the beginning of the solutions in answerkey mode.
\renameSolnAfterTo{}

% Setting the header (different than that of eqexam) using the fancyhdr package.
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\setlength{\headheight}{15pt} 
\lhead{\shortwebsubject/\shortwebtitle}
\chead{-- Page \arabic{page}\space of \nPagesOnExam\space--}
\rhead{\eq@ExamFull}
\pagestyle{fancy}

% Defining a new macro for the "Given" name.
\newcommand\examGivenLabel[1]{\gdef\@examGivenLabel{#1\@examAnsKeyLabel}}
\examGivenLabel{Given:}
\newcommand\eqExamGiven[2][]{%
	\def\eqExamGiven@argi{#1}\def\eqExamGiven@argii{#2}}
\def\eq@ExamGiven{\bgroup
	\settowidth\eq@tmplengthA{\@examGivenLabel\ }%
	\@tempdima=\eqExamGiven@argii\relax
	\advance\@tempdima by-\eq@tmplengthA
	\eqe@idinfohl{\makebox[\eqExamGiven@argii][l]{\@examGivenLabel}}%
	\expandafter\insTxtFieldIdInfo\expandafter[\eqExamGiven@argi]%
	{\@tempdima}{IdInfo.Given}\egroup}
%    \end{macrocode}
% Here we set the field to be a required field with width of $2.25$ inches
%    \begin{macrocode}
\eqExamGiven[\Ff\FfRequired]{2.25in}

% Defining a new macro for the "Full" name.
\newcommand\examFullLabel[1]{\gdef\@examFullLabel{#1\@examAnsKeyLabel}}
\examFullLabel{Name:}
\newcommand\eqExamFull[2][]{%
	\def\eqExamFull@argi{#1}\def\eqExamFull@argii{#2}}
\def\eq@ExamFull{\bgroup
	\settowidth\eq@tmplengthA{\@examFullLabel\ }%
	\@tempdima=\eqExamFull@argii\relax
	\advance\@tempdima by-\eq@tmplengthA
	\eqe@idinfohl{\makebox[\eqExamFull@argii][l]{\@examFullLabel}}%
	\expandafter\insTxtFieldIdInfo\expandafter[\eqExamFull@argi]%
	{\@tempdima}{IdInfo.Full}\egroup}
%    \end{macrocode}
% Here we set the field to be a required field with width of $2.25$ inches
%    \begin{macrocode}
\eqExamFull{2.25in}

% Defining the coverpage fields.
\eqExamName[\Ff\FfRequired]{2.0in}
\examNameLabel{}
\eqExamGiven[\Ff\FfRequired]{1.8in}
\examGivenLabel{}
\eqExamFull{1.75in}
\eqSID[\Ff\FfRequired]{3.9in}
\examSIDLabel{}

% Redefining the right header.
\rheadeqe{\eq@ExamFull}

% Adding class, class author information.
\edef\@pdfcreator{\@pdfcreator, OrulaTest (c) 2018 Kier von Konigslow}

% Defining some universal spacing commands.
\newcommand{\afterquestionspace}{\vspace{0.25in}}
\newcommand{\betweenmultiplechoicespace}{\vspace{0.25in}} % Alternative \vspace{0.25in}
\newcommand{\betweenproblemspace}{\vfill} % Alternative \vspace{0.25in}

% Defining commands to allow changes to universal spacing commands.
\newcommand{\newafterquestionspace}[1]{\renewcommand{\afterquestionspace}{\vspace{#1}}}
\newcommand{\newbetweenmultiplechoicespace}[1]{\renewcommand{\betweenmultiplechoicespace}{\vspace{#1}}}
\newcommand{\newbetweenproblemspace}[1]{\renewcommand{\betweenproblemspace}{\vspace{#1}}}

% Redefining the default coverpage.
\ifcolorenabled
\newcommand{\HeaderImage}{orulatest_header_col}%
\else
\newcommand{\HeaderImage}{orulatest_header}%
\fi
\renewcommand{\eqexcoverpagedesign}
{%
	\begingroup
	\parindent0pt
	\thispagestyle{empty}
	\optionalpagematter
	\addtolength\textwidth{\oddsidemargin}
	
	\hspace{-0.4in} \includegraphics[height=0.4575in]{\HeaderImage}
	
	\begin{center}
		\large\underline{\textsc{\Institution}} \\
		\vspace{6pt}
		\large\underline{\textsc{\School}}
	\end{center}
	
	\vspace{16pt}
	
	\begin{minipage}[t]{0.35\linewidth}
		\normalsize Print your full name: \\
		\vspace{16pt}
		
		Signature: \\
		\vspace{12pt}
		
		Student Number:
	\end{minipage}
	\begin{minipage}[t]{0.6\linewidth}
		\eq@ExamName , \eq@ExamGiven \\
		\phantom{x} \hspace{0.55in}(LAST)\hspace{1.5in}(FIRST)
		\vspace{14pt}
		
		\rule[-2pt]{3.9in}{0.4pt}
		\vspace{14pt}
		
		\eq@SID
	\end{minipage} \\
	
	\vspace{6pt}
	
	\begin{center}
		\textbf{\Course \ - \Test \  (Version \TestVersion)}
	\end{center}
	\textbf{\MonthName{TestMonth}, \TestYear} \\
	
	INSTRUCTIONS:
	\begin{enumerate}[topsep=6pt,itemsep=6pt,label=\Alph*.]
		\ifdefined\FormulaSheet
		\item A formula sheet is attached. No notes or other papers are allowed.
		\else
		\item No notes or other papers are allowed.
		\fi
		\item No talking during the test.
		\item The only materials you should have on your desk are those your instructor allows.
		\item You must show all work to support your answers.
		\item No part marks will be given for multiple choice answers.
		\item You can only leave your desk with the permission of the instructor.
		\item This exam consists of \nQuesInExam[exam1] questions and contains \nPagesOnExam \ pages (including any formula sheets). Please check to be sure you have all pages.
		\begin{itemize}
			\item All calculations should be done on the exam paper.
			\item Show complete work to get full marks.
			\item Record all of your answers on the exam paper.
		\end{itemize}
	\end{enumerate}
	
	Time limit on this test is \numberstringnum{\TimeLimit} (\TimeLimit) minutes. \\
	
	Total marks: \textbf{\underline{\boldmath\totalForPart{exam1} marks}}
	\sumryAnnots    
	\endgroup
}

%==============================================
% REDEFINING EQEXAM MACROS
%==============================================

% Redefining the problem environment to allow \betweenquestionspace.
\newenvironment{newproblem}{\refstepcounter{currentproblem}\begin{problem}}{\addquestion{\thecurrentproblem,\thestepsinproblem}\end{problem}\betweenproblemspace}

% Redefining the problem* environment to allow \betweenquestionspace.
\newenvironment{newproblem*}{\refstepcounter{currentproblem}\begin{problem*}}{\addquestion{\thecurrentproblem,\thestepsinproblem}\end{problem*}\betweenproblemspace}

% Defining a question macro for that includes afterquestionspace for the problem environment.
\NewDocumentCommand{\question}{o m}{%
	\IfNoValueTF{#1}{#2\afterquestionspace}{\csname #1\endcsname{#2\afterquestionspace}}%
}

% Defining a part macro for the parts environment.
\NewDocumentCommand{\newpart}{o m}{%
	\IfNoValueTF{#1}{\item #2}{\csname #1\endcsname{\item #2}}%
}

% Defining a multiple choice part macro for the parts environment.
\NewDocumentCommand{\newmultiplechoicepart}{o m m}{%
	\IfNoValueTF{#1}{\item \question{#2} #3\betweenmultiplechoicespace}{\csname #1\endcsname{\item \question{#2} #3\betweenmultiplechoicespace}}%
}

% Set the version names. Requires macros \TestVersion, \test to be defined.
\numVersions{26}%
\forVersion{\TestVersion}%
\longTitleText%
{\test A}%
{\test B}%
{\test C}%
{\test D}%
{\test E}%
{\test F}%
{\test G}%
{\test H}%
{\test I}%
{\test J}%
{\test K}%
{\test L}%
{\test M}%
{\test N}%
{\test O}%
{\test P}%
{\test Q}%
{\test R}%
{\test S}%
{\test T}%
{\test U}%
{\test V}%
{\test W}%
{\test X}%
{\test Y}%
{\test Z}%
\endlongTitleText%
\shortTitleText%
{A}%
{B}%
{C}%
{D}%
{E}%
{F}%
{G}%
{H}%
{I}%
{J}%
{K}%
{L}%
{M}%
{N}%
{O}%
{P}%
{Q}%
{R}%
{S}%
{T}%
{U}%
{V}%
{W}%
{X}%
{Y}%
{Z}%
\endshortTitleText%
\newcommand{\testVersion}{\sExam}%

%==============================================
% STEPS AND SUMMARY PAGE MACROS
%==============================================

% Defining counters.
\newcounter{totalsteps} % counting the steps.
\newcounter{currentproblem} % counting the problems.
\newcounter{stepsinproblem}[currentproblem]

% A command that takes a sentence and removes spaces so that it can become a counter.
\def\RemoveSpaces#1{\zap@space#1 \@empty}

% Defining a summary table command.
\newcommand\TopicSummaryTable{%
	\begin{tabular}{ |c|c| }
		\hline
		Topic & Number of Steps \\ \hline %
		\ListOfTopics
		\hline
	\end{tabular}
}

% Defining a summary table command.
\newcommand\QuestionSummaryTable{%
	\begin{tabular}{ |c|c| }
		\hline
		Question & Number of Steps \\ \hline %
		\ListOfQuestions
		\hline
	\end{tabular}
}

% Empty commands to contain the rows of the summary table
\newcommand\ListOfTopics{}
\newcommand\ListOfQuestions{}

% Defining a command to add rows to the topic summary table.
\newcommand\addtopic[1]{%
	\g@addto@macro\ListOfTopics{\@gobble}%
	\@for\tmp:=#1\do{%
		\expandafter\g@addto@macro\expandafter\ListOfTopics
		\expandafter{\expandafter&\tmp}%
	}%
	\g@addto@macro\ListOfTopics{\\}%
}

% Defining a command to add rows to the question summary table.
\newcommand\addquestion[1]{%
	\g@addto@macro\ListOfQuestions{\@gobble}%
	\@for\tmp:=#1\do{%
		\expandafter\g@addto@macro\expandafter\ListOfQuestions
		\expandafter{\expandafter&\tmp}%
	}%
	\g@addto@macro\ListOfQuestions{\\}%
}

% A command that checks if a counter exists.
% \ifcounter{<countername>}{<then>}{<else>}
\newcommand*\ifcounter[1]{%
	\ifcsname c@#1\endcsname
	\expandafter\@firstoftwo
	\else
	\expandafter\@secondoftwo
	\fi
}

% Defining a steps command to record the steps required in a given question.
% Each math step should be associated with exactly 1 topic.
% The number of steps per topic should be stored.
\NewDocumentCommand{\Step}{m o}{%
	\ifcounter{#1}{}{\newcounter{#1}\addtopic{#1,\csname the#1\endcsname}}
	\IfNoValueTF{#2}{%
		\refstepcounter{#1}%
		\refstepcounter{totalsteps}%
		\refstepcounter{stepsinproblem}%
	}{%
		\addtocounter{#1}{#2}%
		\addtocounter{totalsteps}{#2}%
		\addtocounter{stepsinproblem}{#2}%
	}%
}

%==============================================
% DATE AND TIME MACROS
%==============================================

% Defining functions to turn month numbers into proper names.
\newcommand{\MONTH}{%
	\ifcase\the\month
	\or January% 1
	\or February% 2
	\or March% 3
	\or April% 4
	\or May% 5
	\or June% 6
	\or July% 7
	\or August% 8
	\or September% 9
	\or October% 10
	\or November% 11
	\or December% 12
	\fi%
}
\newcommand{\MonthName}[1]{%
	\ifcase\csname #1\endcsname
	\or January% 1
	\or February% 2
	\or March% 3
	\or April% 4
	\or May% 5
	\or June% 6
	\or July% 7
	\or August% 8
	\or September% 9
	\or October% 10
	\or November% 11
	\or December% 12
	\fi%
}
\newcommand{\SemesterName}[1]{%
	\ifcase\csname #1\endcsname
	\or Winter% 1
	\or Winter% 2
	\or Winter% 3
	\or Winter% 4
	\or Spring% 5
	\or Spring% 6
	\or Spring% 7
	\or Spring% 8
	\or Fall% 9
	\or Fall% 10
	\or Fall% 11
	\or Fall% 12
	\fi%
}

%==============================================
% MATH AND PSEUDO-RANDOM NUMBER GENERATOR MACROS
%==============================================

% Defining a command to set the random seed of each version based on a universal seed.
\newcommand{\setRandomSeed}[1]{%
\newcommand{\seed}{0}
\vA{%
	\FPeval{\seed}{clip(#1+11298)}%
}
\vB{%
	\FPeval{\seed}{clip(#1+44517)}%
}
\vC{%
	\FPeval{\seed}{clip(#1+67397)}%
}
\vD{%
	\FPeval{\seed}{clip(#1+21357)}%
}
\vE{%
	\FPeval{\seed}{clip(#1+2603)}%
}
\vF{%
	\FPeval{\seed}{clip(#1+12642)}%
}
\vG{%
	\FPeval{\seed}{clip(#1+22603)}%
}
\vH{%
	\FPeval{\seed}{clip(#1+32604)}%
}
\vI{%
	\FPeval{\seed}{clip(#1+2605)}%
}
\vJ{%
	\FPeval{\seed}{clip(#1+12606)}%
}
\vK{%
	\FPeval{\seed}{clip(#1+22607)}%
}
\vL{%
	\FPeval{\seed}{clip(#1+32608)}%
}
\vL{%
	\FPeval{\seed}{clip(#1+2609)}%
}
\vN{%
	\FPeval{\seed}{clip(#1+12610)}%
}
\vO{%
	\FPeval{\seed}{clip(#1+22611)}%
}
\vP{%
	\FPeval{\seed}{clip(#1+32612)}%
}
\vQ{%
	\FPeval{\seed}{clip(#1+2613)}%
}
\vR{%
	\FPeval{\seed}{clip(#1+12614)}%
}
\vS{%
	\FPeval{\seed}{clip(#1+22615)}%
}
\vT{%
	\FPeval{\seed}{clip(#1+32616)}%
}
\vU{%
	\FPeval{\seed}{clip(#1+2617)}%
}
\vV{%
	\FPeval{\seed}{clip(#1+12618)}%
}
\vW{%
	\FPeval{\seed}{clip(#1+22619)}%
}
\vX{%
	\FPeval{\seed}{clip(#1+32620)}%
}
\vY{%
	\FPeval{\seed}{clip(#1+2621)}%
}
\vZ{%
	\FPeval{\seed}{clip(#1+12622)}%
}
\useRandomSeed{\seed}%
\FPseed=\seed%
}

% Defining a command to evaluate and print a mathematical expression. Uses fp package.
\newcommand\Eval[1]{\FPeval{\result}{clip(#1)}{\result}}

% Defining a command to set a variable to a given numerical value. Uses fp package.
\newcommand\Set[2]{\FPeval{#1}{clip(#2)}}

% Defining an operation that calculates the modulo (#2 % #3) and assigns that value to the variable #1.
\newcommand\Modulo[3]{%
	\FPeval{#1}{trunc((#2)-(#3)*trunc((#2)/(#3),0),0)}%
}

% Defining a command that generates a random decimal number #1 between the bounds #2 and #3 inclusive. Uses fp package.
\newcommand\RandomNumber[3]{%
	\FPrandom{\n}%
	\FPeval{#1}{((#3)-(#2))*n+(#2)}%
}

% Defining a command that generates a random integer number #1 between the bounds #2 and #3 inclusive. Uses fp package.
\newcommand\RandomInteger[3]{%
	\FPrandom{\n}%
	\FPeval{#1}{trunc(((#3+0.99)-(#2))*n+(#2),0)}%
}

% Defining a command that randomly selects -1 or +1 and sets the variable #1 to that value.
\newcommand\PlusOneOrMinusOne[1]{%
	\RandomInteger{n}{1}{2}
	\ifcase\n
	\or \FPeval{#1}{round(-1,0)}%
	\or \FPeval{#1}{round(1,0)}%
	\fi%
}

% Defining a command that randomly selects a unit of length and assigns it to variable #1.
\newcommand\RandomSILength[1]{%
	\FPeval{#1}{clip(0)}%
	\RandomInteger{n}{1}{8}%
	\ifcase\n
	\or \expandafter\def\csname #1\endcsname{in}%
	\or \expandafter\def\csname #1\endcsname{ft}%
	\or \expandafter\def\csname #1\endcsname{yd}%
	\or \expandafter\def\csname #1\endcsname{mi}%
	\or \expandafter\def\csname #1\endcsname{mm}%
	\or \expandafter\def\csname #1\endcsname{cm}%
	\or \expandafter\def\csname #1\endcsname{m}%
	\or \expandafter\def\csname #1\endcsname{km}%
	\fi%
}

% Defining a command that randomly generates a prime number from the set of the smallest #1 primes. Currently only allows for the first 12 primes.
\newcommand\RandomPrime[3]{%
	\RandomInteger{n}{#2}{#3}
	\ifcase\n
	\or \FPeval{#1}{2}%
	\or \FPeval{#1}{3}%
	\or \FPeval{#1}{5}%
	\or \FPeval{#1}{7}%
	\or \FPeval{#1}{11}%
	\or \FPeval{#1}{13}%
	\or \FPeval{#1}{17}%
	\or \FPeval{#1}{19}%
	\or \FPeval{#1}{23}%
	\or \FPeval{#1}{29}%
	\or \FPeval{#1}{31}%
	\or \FPeval{#1}{37}%
	\fi%
}

% Defining a command that randomly generates a lower case letter macro \#1 between letter number #2 and #3 in the alphabet.
\newcommand\RandomLCLetter[3]{%
	\FPeval{#1}{clip(0)}%
	\RandomInteger{n}{#2}{#3}%
	\ifcase\n
	\or \expandafter\def\csname #1\endcsname{a}%
	\or \expandafter\def\csname #1\endcsname{b}%
	\or \expandafter\def\csname #1\endcsname{c}%
	\or \expandafter\def\csname #1\endcsname{d}%
	\or \expandafter\def\csname #1\endcsname{e}%
	\or \expandafter\def\csname #1\endcsname{f}%
	\or \expandafter\def\csname #1\endcsname{g}%
	\or \expandafter\def\csname #1\endcsname{h}%
	\or \expandafter\def\csname #1\endcsname{i}%
	\or \expandafter\def\csname #1\endcsname{j}%
	\or \expandafter\def\csname #1\endcsname{k}%
	\or \expandafter\def\csname #1\endcsname{l}%
	\or \expandafter\def\csname #1\endcsname{m}%
	\or \expandafter\def\csname #1\endcsname{n}%
	\or \expandafter\def\csname #1\endcsname{o}%
	\or \expandafter\def\csname #1\endcsname{p}%
	\or \expandafter\def\csname #1\endcsname{q}%
	\or \expandafter\def\csname #1\endcsname{r}%
	\or \expandafter\def\csname #1\endcsname{s}%
	\or \expandafter\def\csname #1\endcsname{t}%
	\or \expandafter\def\csname #1\endcsname{u}%
	\or \expandafter\def\csname #1\endcsname{v}%
	\or \expandafter\def\csname #1\endcsname{w}%
	\or \expandafter\def\csname #1\endcsname{x}%
	\or \expandafter\def\csname #1\endcsname{y}%
	\or \expandafter\def\csname #1\endcsname{z}%
	\fi%
}

% Defining a command that randomly generates an upper case letter macro \#1 between letter number #2 and #3 in the alphabet.
\newcommand\RandomUCLetter[3]{%
	\FPeval{#1}{clip(0)}%
	\RandomInteger{n}{#2}{#3}%
	\ifcase\n
	\or \expandafter\def\csname #1\endcsname{A}%
	\or \expandafter\def\csname #1\endcsname{B}%
	\or \expandafter\def\csname #1\endcsname{C}%
	\or \expandafter\def\csname #1\endcsname{D}%
	\or \expandafter\def\csname #1\endcsname{E}%
	\or \expandafter\def\csname #1\endcsname{F}%
	\or \expandafter\def\csname #1\endcsname{G}%
	\or \expandafter\def\csname #1\endcsname{H}%
	\or \expandafter\def\csname #1\endcsname{I}%
	\or \expandafter\def\csname #1\endcsname{J}%
	\or \expandafter\def\csname #1\endcsname{K}%
	\or \expandafter\def\csname #1\endcsname{L}%
	\or \expandafter\def\csname #1\endcsname{M}%
	\or \expandafter\def\csname #1\endcsname{N}%
	\or \expandafter\def\csname #1\endcsname{O}%
	\or \expandafter\def\csname #1\endcsname{P}%
	\or \expandafter\def\csname #1\endcsname{Q}%
	\or \expandafter\def\csname #1\endcsname{R}%
	\or \expandafter\def\csname #1\endcsname{S}%
	\or \expandafter\def\csname #1\endcsname{T}%
	\or \expandafter\def\csname #1\endcsname{U}%
	\or \expandafter\def\csname #1\endcsname{V}%
	\or \expandafter\def\csname #1\endcsname{W}%
	\or \expandafter\def\csname #1\endcsname{X}%
	\or \expandafter\def\csname #1\endcsname{Y}%
	\or \expandafter\def\csname #1\endcsname{Z}%
	\fi%
}

% Defining a command that prints the classification of the angle #1, given in degrees.
\newcommand\ClassifyAngle[1]{%
	\FPeval{n}{clip(trunc(#1/90,0)+1)}%
	\ifcase\n
	\or Acute%
	\or Obtuse%
	\or Reflex%
	\or Reflex%
	\fi%
}

%==============================================
% AT END PREAMBLE HOOK
%==============================================

\AtEndPreamble{%
	% Checking if the necessary metadata is defined.
	\ifdefined\Test\else%
		\ClassError{orulatest}{\protect\test{<testname>} must be defined in the preamble}%
	\fi%
	\ifdefined\Course\else%
		\ClassError{orulartest}{\protect\course{<coursename>} must be defined in the preamble}%
	\fi%
	\ifdefined\TestAuthor\else%
		\ClassError{orulatest}{\protect\testauthor{<authorname>} must be defined in the preamble}%
	\fi%
	\ifdefined\School\else%
		\ClassWarningNoLine{orulatest}{\protect\school{<schoolname>} should be defined in the preamble. Setting to none}%
		\school{NONE}
	\fi%
	\ifdefined\Institution\else%
		\ClassWarningNoLine{orulartest}{\protect\institution{<institutionname>} should be defined in the preamble. Setting to none}%
		\institution{NONE}
	\fi%
	\ifdefined\TestMonth\else%
		\ClassWarningNoLine{orulatest}{\protect\testmonth{<month>} should be defined in the preamble. Setting to current month}%
		\testmonth{\MONTH}
	\fi%
	\ifdefined\TestYear\else%
		\ClassWarningNoLine{orulatest}{\protect\testyear{<year>} should be defined in the preamble. Setting to current year}%
		\testyear{\the\year}
	\fi%
	\ifdefined\RandSeed\else%
		\ClassWarningNoLine{orulatest}{\protect\randseed{<naturalnumber>} should be defined in the preamble. Setting to integer test month and year in the form MMYYYY}%
		\FPeval\s{clip(\TestMonth\TestYear)}
		\randseed{\s}%
	\fi%
	\ifdefined\EquationSheet\else%
		\ClassInfo{orulatest}{No formula sheet provided through \protect\formulasheet{<filename.tex>}. No formula sheet is attached to this document}%
	\fi%
	\ifdefined\CoverPage\else%
		\ClassInfo{orulatest}{No cover page provided through \protect\coverpage{<filename.tex>}. Setting cover page to default}%
	\fi%
	
	\expandafter\ifstrequal\expandafter{\School}{NONE}{\newcommand{\School}{\phantom{NONE}}}
	
	% Loading a user defined custom coverpage, should one exist.
	\ifdefined\CoverPage
		\input{\CoverPage}
		\InputIfFileExists{\CoverPage}{}{%
			\ClassWarningNoLine{orulatest}{Provided cover page file not found. Setting to default cover page}%
		}%
	\else%
		\InputIfFileExists{orulatest_cover.tex}{}{}
	\fi%
	
	% Loading a user defined macro file, should one exist.
	\InputIfFileExists{orulatest_commands.tex}{}{}
}

%==============================================
% AT BEGIN DOCUMENT HOOK
%==============================================

\AtBeginDocument{%
	% Set the document metadata. Requires \Test, \testVersion, \Couse, \TestYear, \TestMonth
	%    \TestAuthor, \RandomSeed to be defined.
	\title[\Test\testVersion]{\Test\testVersion}
	\subject[\Course]{\Course}
	\date{\MonthName{TestMonth} \TestYear}
	\author{\TestAuthor}
	\keywords{\Course, \Test\testVersion, \MonthName{TestMonth}\ \TestYear, timelimit=\TimeLimit, seed=\RandSeed, compiled \DTMnow}
	\university{\Institution}
	\hfuzz = .7pt
	
	% Properly sets the random seed for each version.
	\setRandomSeed{\RandSeed}%
	
	% Beginning the exam environment.
	\begin{exam}{exam1}
}

%==============================================
% AT END DOCUMENT HOOK
%==============================================

\AtEndDocument{%
	% Adding a workpage if the workpage option is present.
	\ifworksheet
		\clearpage%	
		\begin{center}
		\Large \underline{\textsc{Worksheet}}\\
		\end{center}
		\vfill	\TextField[charsize={12pt},multiline=true,height={0.95\textheight},width={\textwidth},name={worksheet},bordercolor={0.2 0.2 0.7},default={}]{}
	\fi
	
	% Adding the fomula sheet to the end of the document should one exist.
	\ifdefined\FormulaSheet%
		\clearpage%
		\include{\FormulaSheet}%
	\fi%
	
	% Adding a summary page if the answerkey option is set.
%	\ifanswerkey
%		\clearpage%
%		\begin{center}
%			\Large \underline{\textsc{Summary by Topic}}\\
%			\vspace{12pt}
%			\normalsize
%			\addtopic{\textsc{Total},\thetotalsteps}
%			\TopicSummaryTable%
%		\end{center}
%	
%		\clearpage%
%		\begin{center}
%			\Large \underline{\textsc{Summary by Question}}\\
%			\vspace{12pt}
%			\normalsize
%			\addquestion{\textsc{Total},\thetotalsteps}
%			\QuestionSummaryTable%
%		\end{center}
%	\fi
	
	% Ending the exam environment.
	\end{exam}
}

%==============================================
% END OF CLASS
%==============================================