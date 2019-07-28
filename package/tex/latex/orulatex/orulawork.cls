%==============================================
% ORULATEX ASSIGNMENT CLASS
%==============================================

% Based on the jhwhw.cls written by J. H. Wilson - https://gist.github.com/jhwilson/1278588

%==============================================
% Identification
%==============================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{orulawork}[2018/04/02 v0.5 OrulaWork document class]

%==============================================
% Option Handling and Packages
%==============================================

\LoadClass[letterpaper, 12pt]{article}

\RequirePackage{fancyhdr}
\RequirePackage[top=1in,bottom=1in,left=1in,right=1in]{geometry}
\RequirePackage{graphicx}
\RequirePackage{empheq}
\RequirePackage{ifthen}
\RequirePackage{enumitem}
\RequirePackage{exsheets}
\RequirePackage{hyperxmp}
\RequirePackage{tikz}

\setlength{\headheight}{15pt} 

%==============================================
% Commands
%==============================================

% Setting fancuhdr style for whole document
\pagestyle{fancy}

% Defining the assignment metadata commands.
\newcommand{\coursecode}[1]{\newcommand{\CourseCode}{#1}}
\newcommand{\coursename}[1]{\newcommand{\CourseName}{#1}}
\newcommand{\assignment}[1]{\newcommand{\Assignment}{#1}}
\newcommand{\teacher}[1]{\newcommand{\Teacher}{#1}}
\newcommand{\topics}[1]{\newcommand{\Topics}{#1}}
\newcommand{\duedate}[1]{\newcommand{\DueDate}{#1}}
\newcommand{\school}[1]{\newcommand{\School}{#1}}
\newcommand{\institution}[1]{\newcommand{\Institution}{#1}}

% Setting header
\lhead{\CourseCode}
\rhead{\Assignment}

% Defining the maketitle alternative
\newcommand{\makehwtitle}{%
\thispagestyle{empty}
\begin{center}
\Huge \Assignment \\
\Large \CourseCode : \CourseName \\
\vspace{12pt}
\normalsize Instructor: \Teacher \\
\vspace{4pt}
\normalsize Due Date: \DueDate \\
\vspace{24pt}
\hrulefill
\end{center}
}

% Setting up PDF document information
\ifx\pdfoutput\undefined                         %LaTeX
	  \RequirePackage[bookmarks=true]{hyperref}
	  \hypersetup{ %
		pdfauthor   = {},
	    pdftitle    = {},
	    pdfkeywords = {},
	    pdfsubject = {Mathematics},
	    pdfcreator  = {LaTeX with hyperref package},
	    pdfproducer = {dvips + ps2pdf}
	  }
\else                                            %PDFLaTeX
	  \RequirePackage[pdftex,bookmarks=true]{hyperref}
	  \hypersetup{ %
	    pdfauthor   = {},
	    pdftitle    = {},
	    pdfkeywords = {},
	    pdfsubject = {Mathematics},
	    pdfcreator  = {LaTeX with hyperref package},
	    pdfproducer = {dvips + ps2pdf}
	  }
\pdfadjustspacing=1
\fi

% Set up counters for problems and subsections
\newcounter{ProblemNum}
\newcounter{SubProblemNum}[ProblemNum]
\renewcommand{\theProblemNum}{\arabic{ProblemNum}}
\renewcommand{\theSubProblemNum}{\alph{SubProblemNum}}

% Defining the instructions paragraph
\newcommand{\instructions}[1]{%
\noindent \textbf{Instructions} : #1
\vspace{11pt}
}

% Defining the problem environment
\newcommand{\problem}[1]{\stepcounter{ProblemNum} %
\noindent Problem \theProblemNum : #1
}

% Setting up the exsheets environments
\SetupExSheets[points]{name=pt/s.}

% Defining the exercises environment
\NewTasks{exercises}[\item](3)

%==============================================
% AtBegin, AtEnd, Document
%==============================================

\AtBeginDocument{
	\makehwtitle
}

\AtEndDocument{
	\hypersetup{
		pdftitle    = {\CourseCode \space - \Assignment},
		pdfkeywords = {\Topics},
		pdfauthor   = {\Teacher}
	}
}