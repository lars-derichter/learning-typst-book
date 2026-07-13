# Appendix D · Quick reference

Everything the book covers, condensed for fast recall. Every snippet is Typst
0.15.0; the chapter in each heading points back to the full treatment. Recall
the two doorways: `$` opens math, `#` drops from markup into code.

## Markup (Ch 3)

| Syntax | Does |
| ------ | ---- |
| `= H1` … `====== H6` | Headings, levels 1–6 (space after `=` required) |
| `*strong*` | Bold — long form `#strong[…]` |
| `_emph_` | Italic — long form `#emph[…]` |
| `` `raw` `` | Inline verbatim / monospace |
| ` ```lang … ``` ` | Fenced block, optional language for highlighting |
| `- item` | Bullet list |
| `+ item` | Numbered list (Typst counts) |
| `/ Term: desc` | Term list |
| `https://typst.app` | Bare URL becomes a link |
| `#link("url")[text]` | Labelled link (address first) |
| `<label>` | Pin a label to the preceding element |
| `@label` | Reference or citation to a label |
| `\` at line end | Hard line break inside the paragraph |
| `~` | Non-breaking space |
| `--` / `---` | En dash / em dash |
| `...` | Ellipsis |
| `"…"` / `'…'` | Smart quotes, language-aware |
| `\*` `\#` `\_` | Escape a markup character |
| `\u{2713}` | Any character by Unicode codepoint |
| `// …` | Comment to end of line |
| `/* … */` | Comment spanning lines |

## Text and fonts (Ch 4)

`#text(…)[span]` styles one stretch; `#set text(…)` styles everything after.

| Argument | Value |
| -------- | ----- |
| `font:` | `"Libertinus Serif"`, or a fallback list `("A", "B")` |
| `size:` | `11pt`, `1.2em` |
| `weight:` | `"regular"`, `"bold"`, or `100`–`900` |
| `style:` | `"normal"`, `"italic"`, `"oblique"` |
| `fill:` | a color (see below) |
| `lang:` / `region:` | `"en"` / `"US"` — drives quotes and hyphenation |
| `tracking:` | letter spacing, e.g. `0.15em` |
| `number-type:` | `"lining"` (default) or `"old-style"` |
| `number-width:` | `"proportional"` or `"tabular"` |
| `hyphenate:` | `auto`, `true`, `false` |
| `ligatures:` | `true` / `false` |

Bundled fonts (no warnings, render everywhere): `"Libertinus Serif"`,
`"New Computer Modern"`, `"New Computer Modern Math"`, `"DejaVu Sans Mono"`.

Colors: `rgb("#1a7f37")`, named (`red`, `blue`, `navy`, …), `luma(40%)`,
`cmyk(75%, 0%, 70%, 5%)`. Colors adjust: `red.lighten(70%)`, `navy.darken(20%)`.

Decorations, each taking content in brackets:

```typ
#underline[x] #overline[x] #strike[x] #highlight[x] #smallcaps[Name]
E = mc#super[2]   H#sub[2]O
```

## Pages and paragraphs (Ch 5)

`#set page(…)` — one function for the whole sheet:

| Argument | Value |
| -------- | ----- |
| `paper:` | `"a4"` (default), `"us-letter"`, `"a5"`, … |
| `width:` / `height:` | explicit size when no named paper fits |
| `flipped:` | `true` for landscape |
| `margin:` | one length, `(x: …, y: …)`, or per-side `(top:, bottom:, left:, right:)` |
| `columns:` | `2` for a full-page multi-column flow |
| `header:` / `footer:` | content reprinted each page |
| `numbering:` | pattern: `"1"`, `"i"`, `"a"`, `"1 / 1"` |
| `number-align:` | `center`, `right + bottom`, … |
| `fill:` | flood the whole sheet with a color |
| `background:` / `foreground:` | content drawn behind / over the page |

`#set par(…)`: `justify: true`, `leading: 0.8em` (within a paragraph),
`spacing: 1.2em` (between paragraphs), `first-line-indent: 1.2em` (or
`(amount: 1.2em, all: true)`), `linebreaks: auto`.

Spacing and breaks by hand:

```typ
#v(2cm)          // vertical space (weak: true collapses at page top)
#h(1cm)          // fixed horizontal space
a #h(1fr) b      // stretchy space: shoves a and b to the edges
#pagebreak()     // hard; pagebreak(weak: true) skips if page is empty
#colbreak()      // jump to the next column
#columns(2, gutter: 1cm)[ #lorem(40) ]   // a local multi-column block
```

## Positioning and layout (Ch 21)

| Call | Does |
| ---- | ---- |
| `#place(top + right, dx: -2mm, dy: 2mm, body)` | Pin to a spot; reserves no space |
| `#place(bottom, float: true, clearance: 10pt, body)` | Float any block |
| `#box(fill:, stroke:, radius:, inset:, outset:, width:, clip:)[…]` | Inline container |
| `#block(…same args…)[…]` | Block-level container |
| `#stack(dir: ttb, spacing: 8pt, a, b, c)` | Line items on one axis (`ttb`, `ltr`, …) |
| `#pad(x: 1cm, body)` | Space around content |
| `#align(center)[…]` | Position within the allotted width |
| `#rotate(-20deg, body)` | Rotate (add `reflow: true` to claim space) |
| `#scale(x: 140%, y: 70%, body)` | Stretch / squash |
| `#move(dx:, dy:, body)` | Shift without leaving the flow |
| `#skew(ax: 20deg, body)` | Slant |
| `#box(width: 1fr, repeat[.])` | Tile content to fill width (dotted leaders) |
| `#hide[Paris]` | Lay out, take space, draw nothing |

Shapes: `#rect`, `#circle(radius:, fill:)`, `#line(length:, stroke:)`,
`#polygon(fill:, (0pt,0pt), (30pt,0pt), (15pt,25pt))`. Paths use `#curve`
(the removed `#path` is gone): `curve.move`, `curve.line`, `curve.cubic`,
`curve.quad`, `curve.close`.

## Figures and images (Ch 6)

```typ
#image("logo.svg", width: 3cm, alt: "…")   // fit: "cover"|"contain"|"stretch"
#figure(
  image("chart.svg", width: 60%),
  caption: [Revenue.],
) <fig:rev>            // then reference with @fig:rev
```

`#figure(body, caption:, kind:, supplement:, placement:)`. `placement:` is
`top`, `bottom`, or `auto`. A `table` or code body auto-detects its kind;
otherwise set `kind: "diagram"` and `supplement: [Diagram]` for a separate
counter. Caption on top: `#set figure.caption(position: top)`.

## Tables and grids (Ch 7)

```typ
#table(
  columns: (auto, 1fr, 2.5cm),   // track kinds: auto | length | fr
  align: (left, center, right),  // value | per-column list | (x, y) => …
  fill: (x, y) => if calc.odd(y) { luma(240) },
  stroke: none,
  inset: (x: 10pt, y: 6pt),      // padding inside cells
  gutter: 6pt,                   // or column-gutter / row-gutter
  table.header([*A*], [*B*], [*C*]),
  [1], [2], [3],
  table.footer([*Σ*], [x], [y]),
)
```

| Piece | Does |
| ----- | ---- |
| `table.header(…)` / `table.footer(…)` | Rows that repeat across page breaks |
| `table.cell(colspan: 2, rowspan: 3, fill:, align:, inset:)[…]` | Span or override one cell |
| `table.hline(stroke: 1pt)` / `table.vline(…)` | Hand-placed rules (booktabs) |
| `#grid(…)` / `grid.cell(…)` | Same API, no borders, no table semantics — for layout |

Use `table` for data, `grid` for pure layout.

## Math (Ch 8)

`$x$` is inline; `$ x $` (spaces inside the dollars) is a display block.
Symbols are **names, not backslashes**; a run of letters is one name, so
separate variables with spaces (`a b`, not `ab`).

| Write | Get |
| ----- | --- |
| `alpha`, `pi`, `Omega` | α, π, Ω |
| `<=` `>=` `!=` | ≤ ≥ ≠ |
| `->` `oo` | → ∞ |
| `times` `dot` `in` `subset` | × · ∈ ⊂ |
| `plus.minus` `arrow.double` | ± ⇒ |

```typ
$x^2$  $x_i$  $x^(n+1)$  $a_(i j)$      // ^ up, _ down; group with ()
$a/b$  $frac(a, b)$  $binom(n, k)$      // fraction; a/b is a fraction
$sqrt(x)$  $root(3, x)$                 // roots
$sin x$  $lim_(x->0)$  $sum_(i=1)^n i$  // known ops upright; bounds stack in block
$op("argmax", limits: #true)_x f(x)$    // ad-hoc operator (# for the bool)
#let Var = math.op("Var")               // reusable operator
$mat(1, 2; 3, 4)$  $vec(x, y, z)$       // , across a row; ; ends a row
$mat(delim: "[", 1, 0; 0, 1)$           // choose the fence
$cases(x & "if" x >= 0, -x & "else")$   // & aligns the branches
$ a &= b \ &= c $                        // \ new line, & alignment column
$V_"max"$                                // quoted words set upright
$pi approx #calc.round(calc.pi, digits: 4)$   // # drops into code
```

Numbering: `#set math.equation(numbering: "(1)")`; label with `<eq:x>`,
reference with `@eq:x`.

## Scripting: values and functions (Ch 13–14)

`#let name = value` binds; `#name` uses it. Parenthesise any multi-token
expression: `#pi` but `#(pi * 2)`. Inspect with `#type(x)` and `#repr(x)`.

| Type | Literal |
| ---- | ------- |
| `int` | `42` |
| `float` | `3.14` (division always yields a float: `6 / 2` is `3.0`) |
| `str` | `"hi"` |
| `bool` | `true`, `false` |
| `length` | `12pt`, `2cm`, `1em` |
| `ratio` | `50%` |
| `content` | `[bold]` |
| `array` | `(1, 2, 3)` |
| `dictionary` | `(name: "Ada")` |
| `none` / `auto` | the two singletons |

Operators: arithmetic `+ - * /`; compare `== != < > <= >=`; logic
`and or not`; `+` also joins strings, arrays, and content.

```typ
#let f(x, y: 10) = x + y      // positional x, named-with-default y
#f(3)  #f(3, y: 5)
#let g = x => x * 2           // arrow form (one param bare, 2+ in parens)
#let h = (a, b) => a + b
#let twice(fn, x) = fn(fn(x)) // functions are values
#let triple = g.with()        // .with(...) pre-fills arguments
#let sum(..nums) = nums.pos().sum()   // ..sink; .pos()/.named()
#sum(..(1, 2, 3))            // .. at a call site spreads
```

Blocks: `[…]` produces content; `{…}` runs statements and yields their joined
result. `#f[body]` equals `#f([body])` — bracket content is the last argument.

## Control flow (Ch 15)

```typ
#if cond [ … ] else if other [ … ] else [ … ]   // markup: emits content
#let x = if cond { a } else { b }                // code: an expression
#for item in collection [ … ]                    // arrays, or a range
#for (key, value) in dict.pairs() [ … ]          // destructure pairs
#while cond { … ; x = x + 1 }                    // make it terminate
```

`range(5)` → 0…4; `range(2, 6)` → 2…5; `range(0, 10, step: 2)` → 0,2,4,6,8.
Ranges are **half-open** (exclude the end); `step:` is a *named* argument.
`break` leaves the loop, `continue` skips to the next item. Feed generated
cells straight into a function with a spread: `..for x in xs { (x,) }`.

## Arrays, dictionaries, strings (Ch 16)

Arrays index from zero; negative counts from the end.

| Method | Does |
| ------ | ---- |
| `.at(i)`, `.at(-1)`, `.first()`, `.last()`, `.len()` | Access and length |
| `.slice(a, b)` | Half-open sub-array |
| `.contains(x)` / `x in arr` | Membership |
| `.rev()`, `.sorted(key: f)` | New reversed / sorted array |
| `.push(x)`, `.pop()` | Grow / shrink a variable |
| `.map(f)`, `.filter(p)`, `.fold(init, f)` | Transform, keep, collapse |
| `.sum()`, `.product()`, `.join(sep, last:)` | Common reductions |
| `.enumerate()`, `.zip(other)`, `.flatten()` | Pair with index, stitch, flatten |

Single-element array needs a trailing comma: `("solo",)`.

Dictionaries: `d.key` or `d.at("key", default: "—")`; `.keys()`, `.values()`,
`.pairs()`, `.insert(k, v)`, `.remove(k)`, `"k" in d`.

Strings: `.len()`, `.split(sep)`, `.replace(old, new)`, `.trim()`,
`.contains(s)`, `.slice(a, b)`, `.find(p)`, `.match(regex(…))`, `.clusters()`;
plus `upper(s)` / `lower(s)`. `.replace` and `.find` also accept `regex("…")`.

## Set and show rules (Ch 9–10)

```typ
#set elem(param: value)             // change a default from here on
#set text(fill: red) if draft       // only when the condition holds
#show "TODO": strong                // string selector → styled everywhere
#show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
#show heading: it => block[ … it.body … it.level … ]   // rebuild
#show heading.where(level: 1): set text(size: 18pt)     // show-set: safest
#show: template                     // wrap the whole rest of the document
```

Selectors: a bare element (`heading`, `raw`, `emph`, `link`, `figure`, …),
`elem.where(field: value)`, a `"string"`, or `regex("…")` (match on `it.text`).
Numbering patterns (shared by headings, enums, figures, equations, pages):
`"1."`, `"1.1"`, `"i."`, `"A."`, `"(1)"`. A rule that rebuilds the element it
matches recurses — reuse `it`, don't construct a fresh one.

## References and bibliography (Ch 11–12)

```typ
= Introduction <sec:intro>          // label attaches to the preceding element
#set heading(numbering: "1.")        // required before referencing a heading
See @sec:intro and #ref(<fig:rev>, supplement: [Fig.]).

#outline(title: [Contents], depth: 2, indent: 2em)
#outline(title: [Figures], target: figure)
#outline(target: figure.where(kind: table))
```

Citations resolve against one `#bibliography`:

```typ
Working memory is a bottleneck @sweller1988.
#cite(<deci2000>, form: "prose")     // "author" | "year" | "full" | "prose"
On @sweller1988[p.~262], or #cite(<deci2000>, supplement: [pp.~230--231]).
#bibliography("refs.yml", title: [References], full: true, style: "apa")
```

`style:` takes a name (`"apa"`, `"ieee"`, `"chicago-author-date"`, `"mla"`,
`"vancouver"`, …) or a path to a `.csl` file. Source files are Hayagriva
`.yml` or BibTeX `.bib`. Quote any YAML title that contains a colon.

## Context, counters, state (Ch 17, 21)

Layout-dependent values live inside `#context`; outside it they error.

```typ
#context counter(page).display()
#context [ page #here().page(), y = #here().position().y ]
```

Counters — built-in `counter(page)`, `counter(heading)`, or custom
`counter("theorem")`:

| Method | Needs context? | Does |
| ------ | -------------- | ---- |
| `.step()` | no | Bump by one |
| `.update(n)` / `.update(x => x + 2)` | no | Set to a value or via a function |
| `.display(pattern)` | yes | Render the current value |
| `.get()` | yes | Current value as an array (`.first()` for the number) |
| `.at(loc)` | yes | Value at another location |
| `.final()` | yes | Value at the document's end |

`counter(page).display("1 of 1", both: true)` prints current *and* total.
State — any value that changes: `state("part", "Part I")` with `.update()`,
`.get()`, `.at(loc)`, `.final()` (update *before* a page break so the header
sees it). Introspection: `query(sel)` (in context) returns matching elements;
`measure(body)` gives `.width`/`.height` (in context); `layout(size => …)`
adapts to the room available.

## Files and packages (Ch 18, 20)

```typ
#import "@preview/cetz:0.3.4": *     // registry package; version is required
#import "lib.typ": accent, kbd       // named
#import "lib.typ": *                 // everything (namespace clash risk)
#import "lib.typ"                    // module only → reach in with lib.kbd
#import "lib.typ": kbd as key        // rename on the way in
#include "section.typ"               // splice a file's rendered content
```

`#import` brings **definitions**; `#include` brings **content**. Scaffold a
project from a template package: `typst init @preview/charged-ieee`. The first
package compile downloads and caches; every later build is offline.

## Command line (Ch 2)

```sh
typst compile main.typ out.pdf          # format inferred from the extension
typst watch main.typ out.pdf            # recompile on every save
typst compile main.typ out.png --ppi 300   # raster resolution (default 144)
typst compile main.typ page-{p}.png     # one PNG/SVG per page via {p}
typst compile main.typ out.pdf --pages 2-4,6
typst compile --root . chapters/main.typ out.pdf   # absolute paths resolve here
typst compile main.typ out.pdf --open   # open when done
typst compile main.typ out.pdf --format png   # force a format
typst fonts                             # list available font families
typst --version
```

For further reading — the official docs, community packages, and where to go
next — see [Appendix G](31-appendix-g-resources.md).
