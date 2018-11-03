\ProvidesClass{notes}[2016/12/22 Notes class]
\LoadClass[11pt,letterpaper]{article}

%------------------------------------------------------------------------------
%----------------------------------Packages------------------------------------
%------------------------------------------------------------------------------
\usepackage{amsmath,amsfonts,amsthm,amssymb,mathtools}
\usepackage{dsfont} 
\usepackage{enumerate}

% for definition glossaries
\usepackage[pdftex, breaklinks]{hyperref}
\hypersetup{hidelinks}
\usepackage[toc, xindy, nopostdot]{glossaries}
\setglossarystyle{altlist}

% for theorem and definition boxes
\usepackage{tcolorbox}
\tcbuselibrary{breakable, skins}

% document formatting
\usepackage{multicol}   % for multicolumns
\usepackage{lastpage}   % for page numbering
\usepackage{fancyhdr}   % for headers and footers
\usepackage{geometry}
	\geometry{
	letterpaper,
	left=25mm,
	right=25mm,
	top=30mm,
}

%------------------------------------------------------------------------------
%-----------------------------Formatting commands------------------------------
%------------------------------------------------------------------------------

\newcounter{DefCounter}[section]
\newcounter{ThmCounter}[section]

\newcommand{\thetitle}{}
\renewcommand{\title}[1]
{
    \renewcommand{\thetitle}{#1}
}

\newcommand{\theauthor}{}
\renewcommand{\author}[1]
{
    \renewcommand{\theauthor}{#1}
}

\newcommand{\thedate}{}
\renewcommand{\date}[1]
{
    \renewcommand{\thedate}{#1}
}

\newcommand{\note}[2]
{
    \date{#1}
    \subsection{\thedate: {#2}}
}

\newcommand{\thmcolor}{red!40!black}
\newcommand{\defcolor}{black!75!white}
\tcbset{breakable,
        pad at break*=2mm,
        enhanced jigsaw,
            parbox=false,
}
\newcommand{\definition}[2]
{
    \newglossaryentry{#1}{name={#1},description={#2}}
    \refstepcounter{DefCounter}
    \par
    \begin{tcolorbox}
        [
            colback=black!5!white, 
            colframe=\defcolor,
            title=\textbf{Definition \arabic{DefCounter}: \Gls{#1}},
            before upper={\hspace{-4pt}}
        ]
        {#2}
    \end{tcolorbox}
}

% Parameters:
% 1. Theorem type (lemma, theorem, etc)
% 2. Theorem name (optional)
% 3. Theorem statement
% 4. Proof (optional)
\newcommand{\thmgeneric}[4]
{
    \refstepcounter{ThmCounter}
    \par
    \begin{tcolorbox}
        [
            colback=black!5!white, 
            colframe=\thmcolor,
            lower separated=true,
            segmentation style={\thmcolor,solid,opacity=1,line width=1.5pt},
            title=\textbf{{#1} \arabic{ThmCounter}: {#2}},
            before upper={\hspace{-9pt}}
        ]
        \setlength{\parindent}{0cm}
        {#3}
        \def\temp{#4}
        \ifx\temp\empty
            % Proof not given
            %\vspace{-12pt}
        \else
            \tcblower
            % Proof given
            \thmproof{#4}
        \fi
    \end{tcolorbox}
}

\newcommand{\thmproof}[1]
{
    %\begin{tcolorbox}
    %    [
    %        blanker,
    %        left=5mm,
    %        borderline west={0.8mm}{0pt}{\thmcolor},
    %        parbox=false
    %    ]
        \begin{proof}
        {#1}
        \end{proof}
    %\end{tcolorbox}
}

\newcommand{\thm}[3]
{
    \thmgeneric{Theorem}{#1}{#2}{#3}
}
\newcommand{\lemma}[3]
{
    \thmgeneric{Lemma}{#1}{#2}{#3}
}

%------------------------------------------------------------------------------
%-----------------------------Formatting options-------------------------------
%------------------------------------------------------------------------------

\setlength{\parindent}{0cm}
\setlength{\parskip}{6pt}

\setcounter{secnumdepth}{0}

\allowdisplaybreaks             % allow page breaks in long equation arrays
\makeglossaries

\pagestyle{fancy}
\fancyfoot{} % clear the footer
\fancyhead{} % clear the header
\fancyfoot[R]{Page {\thepage} of {\pageref{LastPage}}}
\fancyhead[L]{\theauthor}
\fancyhead[C]{\thetitle}
\fancyhead[R]{\thedate}
\addtolength{\headheight}{4pt}
\renewcommand{\footrulewidth}{0.4pt}
\renewcommand{\headrulewidth}{0.4pt}

%------------------------------------------------------------------------------
%----------------------------Common math commands------------------------------
%------------------------------------------------------------------------------
\newcommand{\R}{\mathds{R}}
\newcommand{\Z}{\mathds{Z}}
\newcommand{\N}{\mathds{N}}
\newcommand{\C}{\mathds{C}}
\newcommand{\Q}{\mathds{Q}}
\newcommand{\set}[2]{\left\{\left. #1 \hspace{4pt} \right| \hspace{4pt} #2\right\}}
\newcommand{\myspan}{\text{span}}
