%==============================================
% ORULATEX CRITICAL PATH CLASS
% CREATED BY: Kier von Konigslow
% EMAIL: kvonkonigslow@gmail.com
% DATE: February 26, 2018
%==============================================

%==============================================
% Identification
%==============================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{orulapath}[2018/02/26 v0.5 OrulaPath document class]

%==============================================
% Option Handling and Packages
%==============================================

\LoadClass[letterpaper, 12pt]{article}

\RequirePackage{gantt}
%\RequirePackage{}

\setlength{\headheight}{15pt} 

%==============================================
% Commands
%==============================================

% Defining the assignment metadata commands.
\newcommand{\coursecode}[1]{\newcommand{\CourseCode}{#1}}
\newcommand{\coursename}[1]{\newcommand{\CourseName}{#1}}
\newcommand{\teacher}[1]{\newcommand{\Teacher}{#1}}
\newcommand{\school}[1]{\newcommand{\School}{#1}}
\newcommand{\institution}[1]{\newcommand{\Institution}{#1}}
\newcommand{\startdate}[1]{\newcommand{\StartDate}{#1}}
\newcommand{\finishdate}[1]{\newcommand{\FinishDate}{#1}}

% Importing all OrulaTex lua functions
\directlua{package.path = './?.lua;' .. package.path}
\directlua{require('orulatex_common')}

% Defining the maketitle alternative
\newcommand{\makecptitle}{%
\thispagestyle{empty}
	\begin{center}
		\Large \textsc{Critical Path} \\
		\large \CourseCode : \CourseName \\
		\vspace{12pt}
		\normalsize Instructor: \Teacher \\
		\vspace{24pt}
		\hrulefill
	\end{center}
}

% Defining a critical path table command.
\newcommand\CriticalPathTable{%
	\begin{tabular}{ |c|c|c|c| }
		\hline
		Week & Topics, Readings, and Activities & Due Dates & Weight \\ \hline %
		\ListOfWeeks
		\hline
	\end{tabular}
}

% Empty commands to contain the rows of the summary table
\newcommand\ListOfWeeks{}

% Defining a command to add rows to the topic summary table.
\newcommand\addtoweeks[1]{%
	\g@addto@macro\ListOfWeeks{\@gobble}%
	\@for\tmp:=#1\do{%
		\expandafter\g@addto@macro\expandafter\ListOfWeeks
		\expandafter{\expandafter&\tmp}%
	}%
	\g@addto@macro\ListOfWeeks{\\}%
}

\def\luacode{%
	\bgroup
	\catcode`\{=12
	\catcode`\}=12
	\catcode`\^^M=12
	\catcode`\#=12
	\catcode`\~=12
	\catcode`\%=12
	\doluacode
}

\bgroup
\catcode`\^^M=12 %
\long\gdef\doluacode#1^^M#2\endluacode{\directlua{#2}\egroup}%
\egroup

% Initializing empty arrays.
\luacode
weeknum = {}
listoftopics = {}
assessname = {}
assessweight = {}
assessdue = {}
classday = {}
classstart = {}
classend = {}
i = 1
j = 1
k = 1
\endluacode

\newcommand{\week}[2]{%
	\directlua{
	weeknum[i] = "#1"
	listoftopics[i] = split("#2","[^,]*")
	i = i+1
	}%
}

\newcommand{\assessment}[3]{%
	\directlua{
	assessname[j] = "#1"
	assessweight[j] = "#2"
	assessdue[j] = "#3"
	}%
}

\newcommand{\class}[3]{%
	\directlua{
	classday[k] = "#1"
	classstart[k] = "#2"
	classend[k] = "#3"
	}%
}

\newcommand{\makecptable}{%
	\directlua{
	for i,line in ipairs(weeknum) do
	tex.print(line)
	tex.print("")
	end
	}%
}

\newcommand{\listtopics}{%
	Topics:
	\directlua{
	--for x in listoftopics[1] do
	tex.print(listoftopics)
	--end
	}
}

%==============================================
% AtBegin, AtEnd, Document
%==============================================

\AtBeginDocument{
	\makecptitle
}

\AtEndDocument{
%
}