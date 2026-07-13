# Appendix B · From LaTeX to Typst

If you already speak LaTeX, most of Typst is a matter of translation, and the
dictionary is short. Three shifts cover the bulk of it. First, there is no
preamble: a blank file is a valid document, so `\documentclass`, `\usepackage`,
and `\begin{document}` all map to *nothing*. Second, LaTeX's backslash commands
become one of two things — inline markup (`*bold*`, `= Heading`) for the common
cases, or a function call `#name(...)` for everything else. Third, math drops
the backslashes entirely: symbols are spelled by name (`alpha`, not `\alpha`)
and a slash is a fraction (`a/b`, not `\frac{a}{b}`).

The tables below are a phrasebook. Each section points at the chapter that
covers the idea in full; come here to translate, go there to understand. Typst
markup is the default; a `#` opens a code expression, and `$ … $` opens math.

## Document setup

The whole LaTeX skeleton — class, preamble, `document` environment — collapses.
A minimal article, side by side:

```latex
\documentclass[12pt,a4paper]{article}
\usepackage{amsmath}
\title{My paper}
\author{A. Writer}
\begin{document}
\maketitle
Hello.
\end{document}
```

```typ
#set text(size: 12pt)
#set page(paper: "a4")
Hello.
```

The title block, the class, and the packages are gone — replaced by a couple of
`#set` rules for the things you actually want to change, and by a *template*
([Chapter 19](19-templates.md)) when you want a reusable look with a real title
block.

| LaTeX | Typst | Notes |
|---|---|---|
| `\documentclass{article}` | *(nothing)*, or a template | A blank file already compiles. |
| `\documentclass[12pt]{...}` | `#set text(size: 12pt)` | Base font size is a set rule. |
| `\documentclass[a4paper]{...}` | `#set page(paper: "a4")` | Paper by name; `margin:` too (Ch 5). |
| `\usepackage{geometry}` | `#set page(margin: 2cm)` | Built in; no package. |
| `\usepackage{...}` (most) | *(nothing)* | Math, color, graphics, links are core. |
| `\usepackage{...}` (extras) | `#import "@preview/name:version"` | Registry packages (Ch 20). |
| `\begin{document}` … `\end{document}` | *(nothing)* | The file body *is* the document. |
| `\maketitle`, `\title{}`, `\author{}` | template arguments | `#show: article.with(title: …)` (Ch 19). |
| custom `\documentclass` (`.cls`) | a template function | An ordinary `#let`-defined function. |

## Text formatting

| LaTeX | Typst (markup) | Typst (code) |
|---|---|---|
| `\textbf{x}` | `*x*` | `#strong[x]` |
| `\textit{x}`, `\emph{x}` | `_x_` | `#emph[x]` |
| `\texttt{x}`, `\verb\|x\|` | `` `x` `` | `#raw("x")` |
| `\underline{x}` | — | `#underline[x]` |
| `\sout{x}` (soul) | — | `#strike[x]` |
| `\textsc{x}` | — | `#smallcaps[x]` |
| `\textcolor{red}{x}` | — | `#text(fill: red)[x]` |
| `{\large x}`, `\Large` | — | `#text(size: 1.4em)[x]` |
| `\footnote{x}` | — | `#footnote[x]` |
| `\href{url}{x}` | — | `#link("url")[x]` |
| `\url{u}` | — | `#link("u")` |

A handful of LaTeX's typographic shorthands survive almost unchanged, because
Typst does the same smart substitutions in markup:

| LaTeX | Typst | Result |
|---|---|---|
| `\\` | `\` (end of line) | Hard line break |
| `~` | `~` | Non-breaking space |
| `---` | `---` | Em dash — |
| `--` | `--` | En dash – |
| `\ldots` | `...` | Ellipsis … |
| `\newpage`, `\clearpage` | `#pagebreak()` | `weak: true` collapses at page top |
| `\centering`, `center` env | `#align(center)[…]` | |
| `\hfill` | `#h(1fr)` | Flexible horizontal fill |
| `\hspace{1em}`, `\vspace{1em}` | `#h(1em)`, `#v(1em)` | |
| `\rule`, `\hrule` | `#line(length: 100%)` | |
| `\noindent` / indent | `#set par(first-line-indent: …)` | Controlled globally by set rule |

Text and fonts are [Chapter 4](04-text-and-fonts.md); page-level layout is
[Chapter 5](05-pages-and-layout.md).

## Sectioning and cross-references

Headings are equals signs — one per level. Unlike LaTeX, they are **not
numbered by default**; turn numbering on with a set rule.

| LaTeX | Typst | Notes |
|---|---|---|
| `\section{Intro}` | `= Intro` | Top level you use; depth = count of `=`. |
| `\subsection{...}` | `== ...` | |
| `\subsubsection{...}` | `=== ...` | |
| `\chapter{...}` | `= ...` | In a book template `=` renders as a chapter. |
| numbered sections | `#set heading(numbering: "1.1")` | Off unless you ask. |
| `\section*{...}` | `#heading(numbering: none)[...]` | One unnumbered heading. |
| `\label{k}` | `<k>` (after the thing) | On a heading, equation, figure… |
| `\ref{k}`, `\autoref{k}` | `@k` | Clickable, auto-supplemented ("Section 2"). |
| `\pageref{k}` | `#context counter(page).at(<k>).first()` | Uses context (Ch 17). |
| `\tableofcontents` | `#outline()` | |
| `\listoffigures` | `#outline(target: figure.where(kind: image))` | |

References and cross-references are
[Chapter 11](11-references-and-cross-references.md); headings and numbering
patterns are Chapters [3](03-markup-content-layer.md) and
[9](09-set-rules.md).

## Lists

No environments — just a marker at the start of each line. Nesting is by
indentation.

| LaTeX | Typst | Notes |
|---|---|---|
| `\begin{itemize}` / `\item` | `- item` | One `-` per line. |
| `\begin{enumerate}` / `\item` | `+ item` | Auto-numbered. |
| `\begin{description}` / `\item[Term]` | `/ Term: description` | Term list. |
| nested lists | indent two spaces | Depth follows indentation. |
| `\begin{enumerate}[(a)]` | `#set enum(numbering: "a)")` | Numbering pattern (Ch 9). |
| custom bullet | `#set list(marker: [--])` | |

Lists live in Chapter 3.

## Math

The one topic that changes the most and hurts the least. Math still sits between
dollar signs, `^` is still superscript, `_` still subscript — but every
backslash command becomes a plain name, and `\frac` becomes a slash. The
`amsmath` / `amssymb` packages have no equivalent because everything they add is
already built in.

Inline versus display is a matter of *spacing inside the dollars*:

```typ
Inline $a^2 + b^2 = c^2$ sits in the line.

$ a^2 + b^2 = c^2 $   // a space inside each dollar → centered block
```

| LaTeX | Typst | Notes |
|---|---|---|
| `\(x\)`, `$x$` | `$x$` | Snug against the dollars = inline. |
| `\[x\]`, `$$x$$`, `equation` | `$ x $` | A space inside each dollar = display. |
| `\frac{a}{b}` | `a/b` or `frac(a, b)` | The slash is a fraction. |
| `\sqrt{x}` | `sqrt(x)` | Auto-sized radical. |
| `\sqrt[3]{x}` | `root(3, x)` | |
| `x^{n+1}`, `x_{ij}` | `x^(n+1)`, `x_(i j)` | Parens group; a space separates letters. |
| `\sum_{i=1}^{n}` | `sum_(i=1)^n` | Bounds stack in display, tuck in inline. |
| `\int_a^b`, `\prod`, `\lim` | `integral_a^b`, `product`, `lim` | |
| `\alpha`, `\beta`, `\Omega` | `alpha`, `beta`, `Omega` | Names, no backslash; capital name = capital. |
| `\times`, `\cdot` | `times`, `dot` | |
| `\le \ge \ne \in \to \infty` | `<= >= != in -> oo` | Typed symbols work too. |
| `\mathbb{R}` | `RR` or `bb(R)` | Plus `NN`, `ZZ`, `QQ`, `CC`. |
| `\mathrm{}`, `\mathbf{}`, `\mathcal{}` | `upright()`, `bold()`, `cal()` | |
| `\text{if}` | `"if"` | Quotes set upright text. |
| `\hat{x}`, `\bar{x}`, `\vec{v}`, `\tilde{x}` | `hat(x)`, `bar(x)`, `arrow(v)`, `tilde(x)` | Accents are functions. |
| `\quad`, `\qquad`, `\,`, `\;` | `quad`, `wide`, `thin`, `med` | Explicit spaces by name. |

Structured math shares one convention: a comma separates entries across a row, a
semicolon ends the row.

| LaTeX | Typst | Notes |
|---|---|---|
| `\begin{matrix} a&b\\c&d \end{matrix}` | `mat(a, b; c, d)` | Default fence is parentheses. |
| `\begin{bmatrix}...\end{bmatrix}` | `mat(delim: "[", ...)` | Any delimiter via `delim:`. |
| `\begin{vmatrix}...\end{vmatrix}` | `mat(delim: "\|", ...)` | Determinant bars. |
| column vector | `vec(x, y, z)` | One entry per row, no `;` needed. |
| `\begin{cases}...\end{cases}` | `cases(x & "if" ..., -x & ...)` | `&` aligns the conditions. |
| `\left( ... \right)` | matched `( ... )`, or `lr(...)` | Matched delimiters auto-scale. |
| `\operatorname{argmax}` | `op("argmax")` | `limits: #true` stacks sub/superscripts. |
| `\DeclareMathOperator` | `#let f = math.op("f")` | Define once in code, reuse the name. |

Multi-line alignment is `\` for a new line and `&` for the alignment column —
the same two characters as an `align` environment, minus the `\begin`/`\end`:

```typ
$ (a + b)^2 &= (a + b)(a + b) \
           &= a^2 + 2 a b + b^2 $
```

Numbering and labels work as elsewhere: turn on
`#set math.equation(numbering: "(1)")`, pin a `<eq:name>` after the closing
dollar, and refer with `@eq:name`. All of this is Chapter 8.

## Tables

The `tabular` column-spec mini-language is gone. Columns, alignment, and rules
are ordinary arguments to `#table`, not pipes and letters wedged into a preamble
string.

| LaTeX | Typst | Notes |
|---|---|---|
| `\begin{tabular}{lcr}` | `#table(columns: 3, align: (left, center, right))` | |
| `\begin{tabular}{p{3cm}}` | `#table(columns: (3cm,))` | Fixed width. |
| flexible column | `columns: (auto, 1fr)` | `fr` shares leftover space. |
| `a & b \\` | `[a], [b],` | Cells are content, comma-separated. |
| `\hline`, `\toprule`, `\midrule` (booktabs) | `table.hline(stroke: …)` | Placed where you want it; no package. |
| vertical rule (`\|`) | `table.vline(stroke: …)` | |
| `\multicolumn{2}{c}{x}` | `table.cell(colspan: 2)[x]` | |
| `\multirow{2}{*}{x}` | `table.cell(rowspan: 2)[x]` | |
| header row | `table.header([A], [B])` | Repeats across page breaks; marks it up for screen readers. |
| cell padding | `inset: 10pt` | Space inside cells. |
| `\arraystretch`, spacing between | `gutter:`, `column-gutter:` | Space between cells. |

The booktabs look — thick top and bottom, one thin mid-rule, no verticals — is
just three `table.hline`s and `stroke: none`. A bare `#grid` is the same engine
without the borders or table semantics, for pure layout. All in Chapter 7.

## Figures and images

| LaTeX | Typst | Notes |
|---|---|---|
| `\includegraphics{f}` | `#image("f")` | PNG, JPG, GIF, SVG. |
| `\includegraphics[width=3cm]{f}` | `#image("f", width: 3cm)` | |
| `\begin{figure}` … `\caption{}` … `\end{figure}` | `#figure(image("f"), caption: [...])` | One call; inside it you are in code, so `image(...)` needs no `#`. |
| `\label{fig:x}` inside the figure | `<fig:x>` after the `#figure(...)` | |
| `\ref{fig:x}` | `@fig:x` | Renders "Figure 3", clickable. |
| `\caption` prefix "Figure" | default supplement | Change with `#ref(<fig:x>, supplement: [Fig.])`. |
| `alt=` text | `#image("f", alt: "…")` | Accessibility built in. |
| `[htbp]`, float packages | *(nothing)* | No floats: a figure sits where you place it. |

Figures and images are Chapter 6.

## Bibliography and citations

No separate BibTeX or Biber run, and no `.aux`/`.bbl` shuffle. Your existing
`.bib` files work unchanged; Typst also reads its own Hayagriva YAML format.

| LaTeX | Typst | Notes |
|---|---|---|
| `\cite{key}` | `@key` | Or `#cite(<key>)` in code. |
| `\bibliography{refs}` | `#bibliography("refs.bib")` | Point at `.bib` or `.yml`. |
| `\bibliographystyle{apa}` | `#bibliography("refs.bib", style: "apa")` | CSL styles by name. |
| `\usepackage{natbib}`/`biblatep` | *(nothing)* | Citation forms come from the style. |
| run `bibtex`, recompile twice | *(nothing)* | Resolved in the single compile pass. |

Citations and bibliographies are Chapter 12.

## Custom commands and packages

A LaTeX macro is a Typst function; you define it with `#let` in the same
language as the rest of the document. Arguments are named and defaulted, not
numbered `#1`, `#2`.

```latex
\newcommand{\todo}[1]{\textcolor{red}{\textbf{TODO: }#1}}
\todo{write this}
```

```typ
#let todo(body) = text(fill: red)[*TODO:* #body]
#todo[write this]
```

| LaTeX | Typst | Notes |
|---|---|---|
| `\newcommand{\x}[1]{...}` | `#let x(body) = [...]` | Call `#x[...]` or `#x(...)`. |
| `\newcommand{\x}{value}` | `#let x = value` | A plain binding. |
| `\newcommand` with default arg | `#let x(body, size: 1em) = …` | Named, defaulted parameters. |
| `\renewcommand{\emph}[1]{...}` | `#show emph: it => ...` | Redefine existing behavior (Ch 10). |
| `\renewcommand` of a length/setting | `#set …(...)` | Change a default (Ch 9). |
| `\newenvironment` | a function taking a `body` | Same as a command with content. |
| `\usepackage{tool}` | `#import "@preview/tool:1.0.0": *` | From Typst Universe; version required (Ch 20). |
| `\input{f}`, `\include{f}` | `#include "f.typ"` | Splices another file's content. |
| import definitions from a file | `#import "f.typ": name` | Bring in specific bindings. |

`#let` functions are Chapters 14 and 18; `set` and `show` rules — the safe,
scoped answer to `\renewcommand` and `.sty` patching — are Chapters 9 and 10;
packages are Chapter 20.

## Things that are just gone

Not translated — simply absent, and you will not miss them:

- **No separate compile passes.** One `typst compile` produces the final PDF,
  cross-references, citations, and table of contents settled. No "run it three
  times until the numbers stop moving."
- **No `.aux`, `.toc`, `.bbl`, `.log`, `.out` litter.** Typst keeps its
  bookkeeping in memory; the only output is the PDF you asked for.
- **No preamble.** Nothing to configure before you can type your first
  sentence.
- **No float placement algorithm.** Figures and tables stay where you put them,
  so there is no `[htbp]`, no `\FloatBarrier`, no chasing a figure that
  wandered three pages downstream.
- **No package hunt for basics.** Color, graphics, hyperlinks, math, and rules
  like booktabs are in the core, not bolted on.
- **No cryptic error walls.** When something is wrong, Typst points at the line
  and says so in a sentence — and because it compiles in milliseconds, the
  preview updates as you type.

---

Coming from a word processor instead? See Appendix C. For a one-page summary of
Typst syntax with no LaTeX in sight, see the cheat sheet in Appendix D.
