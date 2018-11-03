\ProvidesClass{homework}[2018/10/21 homework class]
\LoadClass[11pt,letterpaper]{article}

\usepackage{geometry}
	\geometry{
	letterpaper,
	left=30mm,
	right=30mm,
	top=30mm,
 }


\usepackage{amsmath,amsfonts,amsthm,amssymb}
\usepackage{fancyhdr}           % for headers and footers
\usepackage{lastpage}           % for page numbering
\usepackage{dsfont}             % for \mathds font
\usepackage{lastpage}           % for page numbering
\usepackage{enumerate}          % for using letters in enumerate environment
\usepackage[pdftex]{graphicx}   % for included graphics
\usepackage{calc}               % calculate width of compact subproblems
\usepackage{multicol}
\usepackage{booktabs}           % for nicer tables
\usepackage{tabularx}           

\usepackage{titlesec}
\titleformat{\section}[runin]{\normalfont\normalsize\bfseries}{Problem }{0em}{}[.]
\titlespacing{\section}{0.0em}{0ex}{1.5ex}
\titleformat{\subsection}[runin]{\normalfont\normalsize\bfseries}{}{0em}{(}[)]
\titlespacing{\subsection}{0.0em}{0ex}{1.5ex}

\usepackage{tcolorbox}          % for problem boxes
\tcbuselibrary{breakable, skins}

\usepackage{tikz}               % for drawing diagrams
\usetikzlibrary{arrows}


\newcommand{\AUTH}{Nils Carlson}
\newcommand{\auth}[1]{\renewcommand{\AUTH}{#1}}
\newcommand{\CLASSNAME}{}
\newcommand{\classname}[1]{\renewcommand{\CLASSNAME}{#1}}
\newcommand{\HWNUM}{}
\newcommand{\hwnum}[1]{\renewcommand{\HWNUM}{#1}}
\newcommand{\homework}{Problem}
\newcommand{\hwtype}{Homework}

\allowdisplaybreaks             % allow page breaks in long equation arrays

% Paragraphs separated by whitespace instead of indenting
\setlength{\parindent}{0cm}
\setlength{\parskip}{6pt}

\pagestyle{fancy}
\fancyfoot{} % clear the footer
\fancyhead{} % clear the header
\fancyfoot[R]{Page {\thepage} of {\pageref{LastPage}}}
\fancyhead[L]{\AUTH}
\fancyhead[C]{{\CLASSNAME} {\hwtype} {\HWNUM}}
\fancyhead[R]{\today}
\addtolength{\headheight}{4pt}
\renewcommand{\footrulewidth}{0.4pt}
\renewcommand{\headrulewidth}{0.4pt}


\newtcolorbox{answer}
{
    colback=white, 
    colframe=black,
    breakable,
    pad at break*=2mm,
    enhanced jigsaw,
    parbox=false,
    before upper={\par}
}

\newenvironment{compactsubprob}[3]
{
    \begin{itemize}
        \item[\textbf{(#2)}\;]
    \begin{minipage}{0.99\linewidth-#1\linewidth}
        #3
    \end{minipage}
    \begin{minipage}{#1\linewidth}
    \begin{tcolorbox}[colback=white, colframe=black]
}
{
    \end{tcolorbox}
    \end{minipage}
    \end{itemize}
}

% Common math commands
\newcommand{\R}{\mathds{R}}
\newcommand{\Z}{\mathds{Z}}
\newcommand{\N}{\mathds{N}}
\newcommand{\C}{\mathds{C}}
\newcommand{\Q}{\mathds{Q}}
\newcommand{\ip}[2]{\left\langle {#1}, {#2} \right \rangle}
\newcommand{\set}[2]{\left\{\left. #1 \hspace{4pt} \right| \hspace{4pt} #2\right\}}
\newcommand{\myand}{\hspace{12pt}\text{and}\hspace{12pt}}
\newcommand{\myall}{\hspace{12pt}\text{for all}\hspace{12pt}}
\newcommand{\range}{\mathcal{R}}
\newcommand{\domain}{\mathcal{D}}
\newcommand{\myspan}{\text{span}}

\newcommand{\partder}[2]
{
    \frac{\partial{#1}}{\partial{#2}}
}
\newcommand{\covec}[1]
{
    \frac{\boldsymbol{\partial}}{\boldsymbol{\partial{#1}}}
}
\newcommand{\partdern}[3]
{
    \frac{\partial^{#3}{#1}}{\partial{#2}^{#3}}
}

% Legacy homework commands and environments
\usepackage{framed}
\newcommand{\prob}[3]
{
        \setlength{\parindent}{0cm}
        \setlength{\parskip}{6pt}
	\noindent
    \textbf{{\homework} #1.} {#2} \vspace{-4pt}
	\begin{framed}
		{#3}
	\end{framed}
}

\newcommand{\multprob}[3]
{
        \setlength{\parindent}{0cm}
        \setlength{\parskip}{6pt}
	\noindent
    \textbf{{\homework} #1.} {#2} \vspace{8pt}\\
	{#3}
        
}

\newcommand{\subprob}[3]
{
	\noindent
    \textbf{(#1)} {#2}
	\begin{framed}
        \setlength{\parindent}{0cm}
        \setlength{\parskip}{6pt}
		{#3}
	\end{framed}
}

\newenvironment{cmultprob}[2]
    {
     \setlength{\parindent}{0cm}
     \setlength{\parskip}{6pt}
     \textbf{Problem #1.} {#2} \par
     \begin{tabular}{lll}
    }
    { 
    \end{tabular} 
    }

\newcommand{\cmultboxwidth}{0.75}
\newcommand{\csubprob}[3]
{
    \textbf{(#1)} & {#2}
    &
    \fbox{
        \parbox[h]{\cmultboxwidth\linewidth}{#3}
    } \\ \\
}
