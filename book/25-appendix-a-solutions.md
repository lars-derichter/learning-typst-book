# Appendix A · Solutions to the exercises

Here are worked solutions to every exercise in the book, chapter by chapter.
Where a solution shows code, it's the part that matters — assume the ordinary
document around it. The stretch exercises (the last one in most chapters) are
open-ended by design, so what follows is one good answer, not the only one. If
your version compiles and does the job, count it as correct.

## Chapter 1 — Why Typst?

**1.1** A word processor fuses content and appearance into a single binary file
that you edit by direct manipulation: what you see on screen *is* the document.
A typesetting system keeps the two apart — your content lives as marked-up plain
text, the appearance lives in rules, and the layout is computed from the
structure. The gap matters more as a document grows: with centralized rules one
change propagates everywhere, the layout stays predictable, and because the
source is plain text you can search it, diff it, and track its history.

**1.2** A word processor is the better tool when the job is short, simple, or
collaborative in a hands-on-the-page way: a one-page letter or invitation; a
document a non-technical colleague has to edit live; anything that calls for
real-time co-editing with tracked comments (though Typst's web app narrows that
last gap). Any answer works as long as the *why* is coherent — short, simple, or
WYSIWYG-collaborative all point at the word processor.

**1.3** `range(1, 11)` counts 1 through 10; `range(1, 4)` counts 1, 2, 3 and
stops — `range` is half-open, so it never reaches its second number. The loop
therefore prints three rows: 2¹ = 2, 2² = 4, 2³ = 8. (Chapters 15 and 16 return
to ranges properly.)

**1.4** No single right answer; the win is simply having looked. The reference
is organized by category — text, layout, math, and so on — and noticing that
shape is the whole point of the two minutes.

## Chapter 2 — Getting Typst running

**2.1** Whatever installs Typst on your machine: `brew install typst` on macOS,
`winget install --id Typst.Typst` on Windows, your distro's package or the
GitHub binary on Linux, or `cargo install --locked typst-cli` anywhere with
Rust. `typst --version` should then print something like `typst 0.15.0`. If you
get `command not found`, the binary isn't on your `PATH`: open a fresh terminal,
and make sure the install directory is on `PATH`.

**2.2** Compile the file, then edit and recompile:

```sh
typst compile examples/003-first-document/main.typ out.pdf
```

Change the `= ` heading line, run the command again, and the PDF changes. The
output is regenerated from the source on every compile — you never edit the PDF
directly.

**2.3** `typst watch` prints `compiling …` and then `compiled successfully in N
ms` on each save. Introduce a deliberate error — delete a closing `]` — and
watch prints an error with the file and line number, then keeps watching; fix
and save, and it returns to a clean compile. That tight, forgiving loop is the
point.

**2.4** Export the same file twice, once at each resolution:

```sh
typst compile examples/004-output-formats/main.typ out.png
typst compile examples/004-output-formats/main.typ out.png --ppi 300
```

The 300-ppi file is larger and stays crisp when you zoom in; the default (144
ppi) is lighter and looks fine on screen. Send the 300-ppi version to a printer
and the 144-ppi one to a chat. (ppi is pixels per inch.)

**2.5** Any folder with a `main.typ` that sets `#set document(title: …, author:
…)` and a heading of your choosing. After compiling, the title and author appear
in the PDF viewer's document-properties panel (and the browser tab, if you open
it there). Compiling with `--open` builds and opens the result in one step. This
is your first taste of `#set`, which Chapter 9 covers in full.

## Chapter 3 — Markup: the content layer

**3.1** A title and two sections:

```typ
= My title
== First section
Some prose...
== Second section
More prose...
```

`=` is the title, `==` a section — and the space after the equals signs is
required. Compile it and eyeball the size contrast between the two heading
levels; that's the whole exercise.

**3.2** Inline markup is `_emphasized_`, `*strong*`, and inline raw code with
`` `backticks` ``. A nested list is made purely by indentation:

```typ
- one
- two
  - two-a
  - two-b
- three
```

The `two-a` and `two-b` items become a sublist because they're indented past
`two`; nothing else marks them.

**3.3** Each of these does one specific job:

```typ
See pages 30--34, then a break---a real one---5~km on, and a literal \*.
```

`--` is an en dash (for ranges), `---` an em dash (for an aside), `~` a
non-breaking space (so the `5` and the `km` never split across a line), and `\`
escapes the character after it. Check the PDF to catch, for instance, a single
hyphen where you meant an en dash.

**3.4** A term list and a link:

```typ
/ Title one: a note.
/ Title two: a note.
/ Title three: a note.

#link("https://example.com")[borrow it here]
```

A term list starts each line with `/ Term:`; the link is `#link("url")[label]`.
Any working term syntax and any correct link count.

**3.5** One small document combining headings, emphasis, both list kinds, a
link, and a fenced block nested under a numbered item. The trap flagged in the
chapter's Lists warning: the block must be indented *under* its list item, or a
flush-left block ends the list and the numbering restarts.

````typ
= Weeknight risotto

== Ingredients
- Arborio rice
- Stock
- A glass of _something_ white

== Method
+ Toast the rice.
+ Add stock a ladle at a time:

  ```
  stir, wait, repeat
  ```

+ Serve. See #link("https://example.com")[the original].
````

Because the code block is indented under step 2, the list keeps counting to 3
instead of restarting at 1.

## Chapter 4 — Text and fonts

**4.1** A document-wide set rule, then a local override:

```typ
#set text(font: "New Computer Modern", size: 12pt)

Only the #text(size: 18pt, weight: "bold")[important] word changes.
```

The set rule governs the whole document; the `#text` call overrides just the
span it wraps. Everything stays 12 pt regular except the one bold, 18 pt word.

**4.2** Name any font Typst doesn't bundle — `Helvetica`, `Arial`, `Comic Sans`
— and it still compiles, but prints `warning: unknown font family: <name>` and
renders the text in the fallback (Libertinus Serif). Switch to a bundled family
(Libertinus Serif, New Computer Modern, or DejaVu Sans Mono) and the warning
disappears. The lesson: a named-but-missing font compiles, but the result isn't
reproducible on another machine.

**4.3** Subscripts, a superscript, and small caps:

```typ
Water is H#sub[2]O and carbon dioxide is CO#sub[2].
Einstein: E = mc#super[2].
Set in #smallcaps[Belgium].
```

`#sub[…]` lowers, `#super[…]` raises (the `²` could also be typed as the literal
character), and `#smallcaps[…]` sets small capitals.

**4.4** Right-aligned tabular figures line up digit for digit in a clean column,
because every digit is the same width. Proportional figures look ragged even
when right-aligned, because a `1` is narrower than the other digits, so the
columns of digits don't stack. The switch is one text property:

```typ
#set text(number-width: "tabular")     // vs "proportional"
```

**4.5** A narrow, justified French column:

```typ
#set page(width: 7cm)
#set par(justify: true)
#set text(lang: "fr")
#lorem(60)
```

French switches to guillemets and its own hyphenation patterns, so line breaks
fall in different places than English. Turn hyphenation off with `#set
text(hyphenate: false)` and the justified lines stretch, opening wider word
gaps. Neither is objectively right — prefer whichever trades even spacing
against broken words the way you like for that column.

## Chapter 5 — Pages and layout

**5.1** Asymmetric margins come from a per-side dictionary:

```typ
#set page(paper: "us-letter", margin: (left: 3cm, right: 2cm, y: 2.5cm))
#lorem(80)
```

The wider left margin pushes the text block rightward, so it sits away from the
left edge. The per-side dictionary is the whole tool here.

**5.2** A header and a hand-placed page number:

```typ
#set page(
  header: [Name #h(1fr) 12 July],
  footer: context [#h(1fr) #counter(page).display() #h(1fr)],
)
#lorem(40)
#pagebreak()
#lorem(40)
```

The moment you supply your own `footer:`, Typst's automatic page number
vanishes, so you place it by hand with `counter(page).display()` — wrapped in
`context` because the number depends on *where* it's drawn. The `#h(1fr)`
springs push the header date to the right and centre the footer number.

**5.3** The plain-length form does *not* indent the first paragraph after a
heading (the usual typographic convention):

```typ
#set par(justify: true, first-line-indent: 1.5em, spacing: 0em)
```

Switch to the dictionary form to indent that first paragraph too:

```typ
#set par(first-line-indent: (amount: 1.5em, all: true), spacing: 0em)
```

In one sentence: `all: true` gives the first paragraph its indent; the plain
length withholds it. Setting `spacing` small (or `0em`) collapses the gaps
between paragraphs for the classic novel look.

**5.4** Use the local `#columns` function, not `#set page(columns: 2)`, so the
heading can span the full width:

```typ
= Heading spanning the full width

#columns(2, gutter: 1.5cm)[
  #lorem(80)
]
```

The page-level setting would force the heading itself into the first column;
`#columns(…)[…]` confines the two-column flow to its own block and leaves the
heading above it, spanning the width.

**5.5** Open-ended. A complete answer combines the chapter's tools — one
version:

```typ
#set page(
  paper: "a4",
  fill: rgb("#fbfbf5"),
  background: align(center + horizon,
    rotate(-30deg, text(size: 90pt, luma(90%))[DRAFT])),
  header: [Internal memo #h(1fr) CONFIDENTIAL],
  footer: context align(center)[#counter(page).display("1 / 1", both: true)],
)
#set par(justify: true, leading: 0.5em)

#lorem(120)

#v(2cm)
#line(length: 6cm, stroke: 0.5pt)
Signature
```

Grade yourself on combining the pieces coherently, not on exact taste. The
`both: true` in `display` gives the `1 / 3` total-pages form.

## Chapter 6 — Figures and images

**6.1** A sized image with alt text:

```typ
#image("shot.png", width: 5cm, alt: "The app's main window.")
```

The path is relative to the file's folder. Giving one dimension scales the other
proportionally. `alt` is invisible on the page but written into the PDF for
screen readers. Any real PNG or JPG works.

**6.2** Wrap the image in a figure:

```typ
#figure(
  image("shot.png", width: 5cm),
  caption: [A caption.],
)
```

Note that the inner `image(…)` has no leading `#`: it's already inside code, as
an argument to `figure(…)`. The output reads `Figure 1: A caption.` below the
image, with the number supplied automatically.

**6.3** Two figures labelled `<fig:one>` and `<fig:two>`, referenced with
`@fig:one` and `@fig:two`. Move `fig:two` above `fig:one` in the source and it
becomes Figure 1 — the references renumber themselves on the next compile. The
point: a reference tracks its label, not a number you typed. See
`examples/027-referencing-figures/`.

**6.4** Bake the shared box settings once with `box.with`, then vary `fit`:

```typ
#let b = box.with(width: 4cm, height: 2cm, stroke: 0.5pt)

#b[#image("photo.jpg", width: 100%, height: 100%, fit: "contain")]
#b[#image("photo.jpg", width: 100%, height: 100%, fit: "cover")]
#b[#image("photo.jpg", width: 100%, height: 100%, fit: "stretch")]
```

`contain` fits the whole image inside the box and letterboxes the spare space;
`cover` fills the box and crops the overflow; `stretch` fills the box by
distorting the image. Mirrors `examples/028-sizing-and-fit/`.

**6.5** Three figures whose `kind` differs, so each gets its own counter:

```typ
#figure(rect(width: 2cm, height: 1cm), caption: [A drawn shape.]) <fig:shape>
#figure(table(columns: 2, [a], [b]), caption: [A little table.]) <tbl:mini>
#figure(
  rect(width: 2cm, height: 1cm, stroke: (dash: "dashed")),
  kind: "diagram", supplement: [Diagram],
  caption: [A diagram.],
) <dia:flow>

See @fig:shape, @tbl:mini, and @dia:flow — each numbered 1.
```

A drawn shape takes the default kind (Figure 1), a table figure the `table` kind
(Table 1), and the last one an explicit `kind: "diagram"` (Diagram 1). The
insight: `kind` separates the counters, so all three read `1`; `supplement` only
sets the printed word. Mirrors `examples/029-figure-of-a-table-or-diagram/`.

## Chapter 7 — Tables and grids

**7.1** A movie table with a flexible title column:

```typ
#table(
  columns: (1fr, auto, auto, auto),
  [*Title*], [*Director*], [*Year*], [*Rating*],
  [Metropolis], [Lang], [1927], [Great],
  [Rashomon], [Kurosawa], [1950], [Great],
  [Le Trou], [Becker], [1960], [Superb],
  [Stalker], [Tarkovsky], [1979], [Hypnotic],
  [Chungking Express], [Wong], [1994], [Dazzling],
)
```

Making `Title` a `1fr` column lets it absorb the slack while the shorter columns
stay `auto`. A plain `columns: 4` works too; choosing the track kind to fit the
content is the learning goal.

**7.2** Per-column alignment plus zebra stripes:

```typ
#table(
  columns: 4,
  align: (left, left, right, center),
  stroke: none,
  fill: (x, y) => if calc.odd(y) { luma(240) },
  [*Title*], [*Director*], [*Year*], [*Rating*],
  [Metropolis], [Lang], [1927], [Great],
)
```

`align` takes a per-column list; `stroke: none` drops the rules; the `fill`
function tints odd rows. Striped or ruled is an aesthetic call — either is fine
with a reason.

**7.3** A schedule with spans:

```typ
#table(
  columns: 3,
  table.cell(colspan: 3)[*Weekly schedule*],
  [Mon], [Tue], [Wed],
  table.cell(rowspan: 2)[Gym], [Email], [Design],
  [Reading], [Ship],
)
```

The trap: the row *after* a `rowspan` cell supplies only the cells the span
doesn't already cover — here the last row gives just two cells, because `Gym`
still occupies the first column. Once you account for the spans, every row's
cell count lines up; miscount and Typst shifts everything into the wrong slots.

**7.4** The booktabs look: no grid, three explicit horizontal rules.

```typ
#table(
  columns: 3,
  stroke: none,
  inset: (x: 10pt, y: 6pt),
  table.hline(stroke: 1pt),
  [*Item*], [*Qty*], [*Price*],
  table.hline(stroke: 0.6pt),
  [Pens], [12], [3.00],
  [Ink], [2], [8.50],
  table.hline(stroke: 1pt),
)
```

`stroke: none` clears the default grid; a thick rule on top, a thin one under
the header, and a thick one at the foot give the classic three-line table, with
a roomy inset. Add `table.vline(x: k, stroke: …)` for a single vertical rule
between columns `k-1` and `k` — whether it helps is a judgement call (booktabs
orthodoxy says skip verticals), but the exercise is about placing one on
purpose.

**7.5** A card built with `grid` rather than `table`:

```typ
#grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  row-gutter: 0.6em,
  // grid, not table: this is layout, not tabular data. A table would
  // announce itself as data to a screen reader and imply a grid of
  // records where there is only a card. grid keeps the structure honest
  // and draws no borders by default.
  grid.cell(colspan: 2)[*A fine pen*],
  [Price], [#lorem(30)],
)
```

The full-width title spans both columns; a small `auto` label column sits beside
a `1fr` description. A `table` would misrepresent a layout card as data — the
comment is the sentence the exercise asks for.

## Chapter 8 — Math and equations

**8.1** An inline formula and the quadratic formula as a display block:

```typ
Einstein showed that $E = m c^2$ ties mass to energy.

$ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a) $
```

The space in `m c^2` matters: `mc` would be read as one two-letter identifier
and error. Likewise the spaces inside `4 a c` and `2 a` make them products
rather than names. That space-inside-`$…$` rule and the multi-letter-identifier
trap are the whole lesson.

**8.2** The Gaussian:

```typ
$ f(x) = 1/sqrt(2 pi) e^(-x^2 / 2) $
```

The exponent must be parenthesised — `e^(-x^2 / 2)` — otherwise only `-x^2` (or
less) rides up as the power. An explicit `dot` before `e` is fine too.

**8.3** A numbered equation and a reference to it:

```typ
#set math.equation(numbering: "(1)")

$ sum_(i=1)^n i^2 = (n (n + 1) (2 n + 1)) / 6 $ <eq:squares>

The identity in @eq:squares sums the first $n$ squares.
```

`#set math.equation(numbering: "(1)")` turns on equation numbers; the label and
`@eq:squares` do the cross-reference. Mind the spaces in `n (n + 1)` and `2 n`,
and group the whole numerator in one paren pair over `6`.

**8.4** A matrix and a piecewise definition:

```typ
$ M = mat(delim: "[", cos theta, -sin theta; sin theta, cos theta) $

$ op("sgn")(x) = cases(
   1  & "if" x > 0,
   0  & "if" x = 0,
  -1  & "if" x < 0,
) $
```

`delim: "["` gives square brackets and `;` ends each matrix row. In `cases`, the
commas separate the branches and `&` aligns the conditions; the quoted `"if"`
prints as upright text inside math.

**8.5** A derivation aligned on its equals sign, and a custom operator:

```typ
$ a^2 - b^2 &= a^2 - a b + a b - b^2 \
            &= a(a - b) + b(a - b) \
            &= (a - b)(a + b) $
```

Each line uses `\` for the newline and `&` before the `=` so the equals signs
stack. Any valid intermediate step is fine. For the operator, `math.op` mints
one that typesets upright and takes a subscript like a built-in:

```typ
#let argmax = math.op("argmax", limits: true)

$ hat(theta) = argmax_theta L(theta) $
```

`limits: true` puts the subscript directly under `argmax` in a display equation.
The whole thing must build with no warnings — check it.

## Chapter 9 — Set rules

**9.1** Two document-wide set rules:

```typ
#set text(font: "New Computer Modern", size: 12pt)
#set par(justify: true)

= A heading
#lorem(30)

#lorem(30)
```

Both rules govern the whole document, so a third paragraph pasted anywhere below
inherits the same font, size, and justification with no extra markup.

**9.2** Automatic heading numbers:

```typ
#set heading(numbering: "1.")

= First
== A sub-heading
```

The top-level heading shows `1.`, the `==` sub-heading `1.1`, with no manual
counting. The rule has to sit *above* the headings it governs.

**9.3** Custom list and enum markers:

```typ
#set list(marker: [--])
#set enum(numbering: "a)")

- one
- two

+ first
+ second
```

Any content works as a list marker (`[>]`, `[·]`, `sym.arrow.r`), and
`numbering` takes a pattern string. The marker can even be a tuple that
alternates by depth, e.g. `marker: ([--], [·])`.

**9.4** A set rule's scope stops at the end of its enclosing block:

```typ
A normal line.

#[
  #set text(fill: blue, style: "italic")
  Only this block is blue and italic.
]

Back to normal.
```

The `#[…]` content block fences off the styling. The common slip is dropping the
`#` before `[`, which makes it plain bracketed markup text.

**9.5** A `draft` flag toggling conditional set rules:

```typ
#let draft = true

#set text(size: 14pt, fill: red) if draft
#set par(leading: 1.5em) if draft

= Report
#lorem(30)
```

Flip `draft` to `false` and both conditional rules skip, snapping the document
back to its clean defaults with a one-character edit. The `if draft` conditions
must sit below the `#let` that defines the flag. The optional `DRAFT` header
genuinely needs a show rule or a direct call to place content, so treat it as a
deliberate bridge to Chapter 10.

## Chapter 10 — Show rules

**10.1** A rule above the body draws a line before each level-1 heading:

```typ
#show heading.where(level: 1): it => block[
  #line(length: 100%, stroke: 0.6pt + green.darken(30%))
  #text(fill: green.darken(30%))[#it.body]
]

= A styled heading
```

Because the line is emitted before `it.body` inside the block, every level-1
heading gets a rule above it; wrapping in `block` preserves the heading's block
layout. Use plain `heading:` if the document has only one level.

**10.2** Two show-set rules that leave body text alone:

```typ
#show quote.where(block: true): set text(style: "italic")
#show raw: set text(fill: red)
```

Ordinary paragraphs are untouched because neither selector matches them; only
block quotes and raw code pick up the new styling.

**10.3** A string replacement and a regex:

```typ
#show "Projectname": strong(smallcaps[Projectname])
#show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
```

The first restyles a fixed word; the second small-caps every run of two or more
capitals (an acronym). They overlap — the regex would also catch an all-caps
project name — so either accept that or keep the project name mixed-case.
Spotting the overlap is half the exercise.

**10.4** The buggy rule rebuilds a `strong` element inside its own show rule,
which the same rule then matches again, forever — Typst stops with `maximum show
rule depth exceeded`. The fix is to reuse `it` instead of constructing a new
`strong`:

```typ
#show strong: it => underline(it)
```

`underline(it)` wraps the strong element you were handed, adding an underline
without creating anything the rule matches again.

**10.5** A whole-document wrapper — the skeleton of a template:

```typ
#let note(body) = {
  set page(width: 12cm, height: auto, margin: 1.5cm)
  set par(justify: true)
  show heading: set text(fill: navy)
  show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
  body
}

#show: note

= A note
NASA and ESA both agree. #lorem(20)
```

A selector-less `#show: note` pipes the whole document through `note`, which
applies four effects at once. This is exactly the shape of a template; Chapter
19 grows it into a real one.

## Chapter 11 — References and cross-references

**11.1** Without numbering, `@sec:one` errors with `cannot reference heading
without numbering` (the hint even suggests `#set heading(numbering: "1.")`). Add
that set rule and the reference prints `Section 1` as a link — `Section` is the
default heading supplement. Mirrors `examples/056-`.

**11.2** Label a sub-heading `== Sub <sec:sub>` and `@sec:sub` prints `Section
1.1`. Reorder the two top-level headings and everything renumbers in one
compile: the moved heading and every reference to it update together. References
track the label and the structure, never a number you typed.

**11.3** A per-reference supplement overrides the default:

```typ
#figure(rect(width: 3cm), caption: [A rectangle.]) <fig:demo>

@fig:demo prints "Figure 1".
#ref(<fig:demo>, supplement: [Fig.]) prints "Fig. 1".
```

Adding `#set figure(supplement: [Diagram])` makes the plain reference *and* the
caption read `Diagram 1`, but the per-reference `supplement: [Fig.]` still wins
for that one mention — local beats global. Mirrors `examples/057-`.

**11.4** `#outline()` lists every heading; `#outline(depth: 1)` lists only
level-1 headings, dropping the sub-headings; `#outline(target: figure)` lists
the figures by caption instead. All three read the same document structure, and
numbered entries need `#set heading(numbering: "1.")`. Mirrors `examples/058-`
and `examples/059-`.

**11.5** A show rule that styles heading and figure references differently by
branching on the referenced element's kind:

```typ
#show ref: it => {
  let el = it.element
  if el != none and el.func() == figure {
    box(fill: luma(235), inset: (x: 4pt), radius: 2pt, it)
  } else {
    text(fill: blue, weight: "bold", it)
  }
}
```

`it.element` is the referenced element and `.func()` identifies its kind, so the
rule can box figure references and colour the rest. Ending each branch with `it`
keeps Typst's automatic supplement-and-number intact — only the look changes.
Guard with `el != none`, since some references have no element. Mirrors
`examples/060-`.

## Chapter 12 — Citations and bibliographies

These solutions depend on a bibliography file, so the snippets don't compile on
their own — pair each with the `refs.yml` (or `.bib`) it cites.

**12.1** Any `refs.yml` with a book (`type: book`, a `publisher`) and an article
(`type: article`, a parent periodical, a page range) works:

```yaml
pigeon2019:
  type: book
  title: "Pigeons: an urban history"
  author: "Featherstone, Ada"
  year: 2019
  publisher: Corvid Press
```

```typ
As shown by @pigeon2019, the birds adapt fast.

#bibliography("refs.yml", style: "apa")
```

Check that `@key` produces `(Author, Year)` under APA and that the list sorts by
first author's surname with a hanging indent. The usual mistake is an unquoted
title containing a colon, which breaks the YAML parse. Mirrors
`examples/061-first-citation/`.

**12.2** `title: [References]` renames the heading (the default is
`Bibliography`). Switching `style: "apa"` to `"ieee"` changes in-text citations
from `(Author, Year)` to numbered `[1]`, and the list becomes numbered in order
of first citation, authors initials-first, titles in quotes. Only the one string
changed. See `examples/065-switching-styles/`.

**12.3** Add a source with three authors, e.g. `author: ["Hattie, John",
"Timperley, Helen", "Clarke, Shirley"]`. In-text APA collapses it to `(Hattie et
al., 2007)`, while the list entry spells out `Hattie, J., Timperley, H., &
Clarke, S. (2007).` — APA's three-or-more-author rule, applied for you. See
`examples/062-apa-reference-list/`.

**12.4** The prose form and a page locator:

```typ
#cite(<pigeon2019>, form: "prose")   // "Featherstone (2019)"
@pigeon2019[p.~10]                    // "(Featherstone, 2019, p. 10)"
```

`form: "prose"` gives the running `Author (Year)` form; the bracket locator
`@key[p.~10]` adds a page, printing `(Author, Year, p. 10)`. The `~` is a
non-breaking space (a plain space is accepted too); `supplement: [p.~10]` on the
function form is equivalent. See `examples/063-citation-forms/`.

**12.5** Open-ended. The core is a valid `.bib` with a book, an article, and a
web page (`@book` / `@article` / `@misc` or `@online`), compiled with `style:
"apa"`. `full: true` makes uncited entries appear. Point `style:` at any real
`.csl` file by path and Typst renders through it — it speaks CSL natively.
Credit yourself for naming one concrete thing the journal's CSL does that
built-in APA doesn't (abbreviated journal names, a different author separator,
no DOI). If you hit the `council-of-science-editors` deprecation warning, use
the replacement name the warning prints.

## Chapter 13 — From markup to code

**13.1** A sentence with no literal data, only interpolations:

```typ
#let name = "Ada"
#let age = 36
#let colour = "green"

My name is #name, I am #age, and I like #colour.
```

Bare `#name` and `#age` need no parentheses because each is a single token.

**13.2** Reading the expressions off:

```typ
#(10 - 2 * 3)              // 4    — multiplication first, then 10 - 6
#repr(9 / 4)               // 2.25 — division always yields a float
#("na" + "na" + " batman") // "nana batman" — strings join
#(5 <= 5)                  // true
#(not (3 > 4))             // true — 3 > 4 is false, and not false is true
```

The decimal on `9 / 4` is the tell that `/` always produces a float; `#repr(8 /
4)` prints `2.0` for the same reason, even though it divides evenly.

**13.3** Any three values, at least one being content:

```typ
#type(42)      / #repr(42)      // int / 42
#type("hi")    / #repr("hi")    // str / "hi"
#type([*x*])   / #repr([*x*])   // content / strong(body: [x])
```

`repr` of content shows its internal element form — `strong(body: [x])` here.
The exact text doesn't matter; the point is that `[…]` is a value of type
`content`.

**13.4** A single source of truth for a small invoice:

```typ
#let a = 10
#let b = 4
#let c = 6
#let subtotal = a + b + c                          // 20
#let tax = calc.round(subtotal * 0.06, digits: 2)  // 1.2
#let total = subtotal + tax                        // 21.2

#table(columns: 2,
  [Subtotal], [#subtotal],
  [Tax], [#tax],
  [Total], [#total],
)
```

Change one price, recompile, and the subtotal, tax, and total all follow — the
numbers live in one place and everything downstream is computed.

**13.5** Everything the reader sees comes out of one code block:

```typ
#{
  let a = 8
  let b = 5
  [#a and #b sum to #(a + b) and multiply to #(a * b).]
}
```

Prints `8 and 5 sum to 13 and multiply to 40.` The `let` lines produce nothing,
so the block's value is just the trailing content line, which carries the
sentence to the page. The arithmetic is parenthesised inside the brackets so
it's computed, not printed literally.

## Chapter 14 — Functions and closures

**14.1** One definition, reused with no copy-paste drift:

```typ
#let kbd(key) = box(
  stroke: 0.5pt, inset: (x: 4pt, y: 1pt), radius: 3pt,
)[#raw(key)]

Press #kbd("Ctrl") + #kbd("C") to copy.
```

**14.2** A named parameter with a default:

```typ
#let kbd(key, fill: luma(240)) = box(
  fill: fill, stroke: 0.5pt, inset: (x: 4pt, y: 1pt), radius: 3pt,
)[#raw(key)]

#kbd("Esc") and #kbd("Enter", fill: yellow)
```

Most calls stay short; you override `fill` only when you want a different
colour.

**14.3** A component with a positional body and named options:

```typ
#let callout(body, title: "Note", color: blue) = block(
  fill: color.lighten(85%), stroke: (left: 3pt + color),
  inset: 10pt, width: 100%,
)[#text(fill: color, weight: "bold")[#title] \ #body]

#callout[
  Intro line. \
  - a
  - b
]

#callout([A short aside.], title: "Aside")
```

`#callout[…]` and `#callout([…])` are the same call — the trailing content block
becomes the `body` argument. Everything inside the brackets, list and all,
arrives as one content value.

**14.4** A variadic average:

```typ
#let avg(..nums) = {
  let xs = nums.pos()
  xs.sum() / xs.len()
}

#avg(4, 8, 12)          // 8
#let scores = (10, 7, 9, 8)
#avg(..scores)          // 8.5
```

`..nums` collects any number of positional arguments; `.pos()` turns them into
an array to sum and count. Spreading `..scores` unpacks the array back into
separate arguments, so one function serves both call styles.

**14.5** A closure factory that returns a ready-made show-rule function:

```typ
#let heading-style(color) = it => block(below: 0.8em)[
  #text(fill: color, weight: "bold")[#it.body]
  #v(-6pt)
  #line(length: 100%, stroke: 0.6pt + color)
]

#show heading: heading-style(navy)   // swap navy -> maroon to reskin

= A heading
```

The returned closure captures `color`, so picking a palette is now a one-line
change — the embryo of a template (Chapter 19).

## Chapter 15 — Control flow

**15.1** One condition, two content blocks, exactly one printed:

```typ
#let temperature = 28
#if temperature >= 20 [Warm — leave the coat at home.] else [Bring a jacket.]
```

Drop the number to 12 and the output flips.

**15.2** A table of powers of two:

```typ
#for n in range(1, 11) [
  $2^#n$ = #calc.pow(2, n) \
]
```

`range(1, 11)` runs `n` from 1 to 10. `range(1, 4)` would give only 1, 2, 3 —
three lines, `2^1=2` through `2^3=8` — because `range` is half-open and stops
before its second number. (That's the payoff of Exercise 1.3.)

**15.3** A cart, listed and summed:

```typ
#let cart = (("Pen", 2), ("Notebook", 5), ("Stapler", 8))

#for (item, price) in cart [- #item: #price]

#let total = 0
#for (item, price) in cart { total = total + price }
Total: #total   // 15
```

The loop header destructures each `(item, price)` pair, and a running variable
accumulates the total across the second loop.

**15.4** Skip the multiples of three with `continue`:

```typ
#for n in range(1, 21) {
  if calc.rem(n, 3) == 0 { continue }
  [#n ]
}
```

Prints `1 2 4 5 7 8 10 11 13 14 16 17 19 20`. `continue` abandons the current
iteration whenever `n` divides by 3. `range(1, 21)` reaches 20 (half-open
again).

**15.5** A multiplication table from nested loops fed to a spread:

```typ
#table(
  columns: 5,
  ..for r in range(1, 6) {
    for c in range(1, 6) {
      ([#{ r * c }],)
    }
  }
)
```

The inner loop yields one single-element array `([…],)` per cell, and the spread
`..` flattens them all into the table's arguments. The trailing comma is what
makes `([…],)` an array rather than a parenthesised value. Change both `6`s to
`11` and `columns: 5` to `columns: 10` and the table grows in both directions
with no other edit. Any working nested-loop version passes; a row-at-a-time
build with string concatenation is fine too.

## Chapter 16 — Arrays, dictionaries, and strings

**16.1** Array basics:

```typ
#let nums = (8, 3, 11, 6, 3, 9)

#nums.len()          // 6
#nums.first()        // 8
#nums.last()         // 9
#nums.at(-1)         // 9  — negative indices count from the end
#nums.slice(2, 4)    // (11, 6) — the middle two
#nums.sorted()       // (3, 3, 6, 8, 9, 11)
```

`sorted()` returns a *new* array; print `nums` again afterward and it's still
`(8, 3, 11, 6, 3, 9)`. Nothing you called mutated the original.

**16.2** Transform, keep, and fold with `map`, `filter`, and `sum`:

```typ
#let prices = (4.50, 12.00, 3.25, 8.75)

#prices.map(p => p * 1.21)          // add VAT to each
#prices.filter(p => p > 5.00)       // (12.00, 8.75)
#prices.sum()                       // 28.50

// VAT-inclusive total of the items over 5.00, chained:
#prices.filter(p => p > 5.00).map(p => p * 1.21).sum()   // 25.0075
```

They chain left to right. Round with `calc.round(x, digits: 2)` if you want a
tidy `25.01`.

**16.3** A dictionary you build up and query safely:

```typ
#{
  let book = (title: "Dune", author: "Herbert", year: 1965)
  book.insert("pages", 412)
  let dropped = book.remove("year")     // dropped is 1965
  [
    #emph(book.title) by #book.author, #book.pages pages. \
    Keys now: #repr(book.keys()) \
    Publisher: #book.at("publisher", default: "unknown")
  ]
}
```

Keys are strings. `insert` adds a pair, `remove` deletes one and returns its
value, and `at(…, default: …)` reads a possibly-missing key without crashing —
here it yields `unknown`. The binding must be a `let` so it can be mutated.

**16.4** Split a "Surname, First" string and rebuild it in natural order:

```typ
#let name = "Lovelace, Ada"
#let parts = name.split(", ")        // ("Lovelace", "Ada")
#(parts.at(1) + " " + parts.at(0))   // "Ada Lovelace"

// or, more elegantly:
#name.split(", ").rev().join(" ")    // "Ada Lovelace"
```

`split` breaks the string on `", "`; reversing the two parts and joining with a
space gives natural order.

**16.5** An array of song dictionaries rendered as a sorted table with a
computed `m:ss` column:

```typ
#let songs = (
  (title: "Blackbird", artist: "The Beatles", seconds: 138),
  (title: "Teardrop", artist: "Massive Attack", seconds: 329),
  (title: "Roygbiv", artist: "Boards of Canada", seconds: 161),
  (title: "Svefn-g-englar", artist: "Sigur Ros", seconds: 594),
)

#table(
  columns: 4,
  table.header([Title], [Artist], [Seconds], [m:ss]),
  ..songs.sorted(key: s => s.seconds).map(s => (
    s.title,
    s.artist,
    [#s.seconds],
    {
      let m = calc.div-euclid(s.seconds, 60)
      let r = calc.rem(s.seconds, 60)
      let rr = if r < 10 { "0" + str(r) } else { str(r) }
      [#m:#rr]
    },
  )).flatten(),
)
```

`sorted(key: …)` orders by duration, `map` turns each dictionary into a
four-cell row, and `flatten` unrolls the rows into the flat argument list the
spread needs. `calc.div-euclid(seconds, 60)` gives the whole minutes and
`calc.rem` the leftover seconds; the `r < 10` pad is what makes a nine-second
song read `0:09` and not `0:9`. Add `show table.cell.where(y: 0): strong` for a
bold header if you like. Mirrors `examples/088-data-to-table/`.

## Chapter 17 — Context, state, and counters

**17.1** The same source line, evaluated per location:

```typ
#set page(width: 9cm, height: 6cm, margin: 1cm)

Some text. #context [This is page #counter(page).display().]
#pagebreak()
#context [This is page #counter(page).display().]
```

The line prints `1` on the first page and `2` on the second: `context` is
evaluated where it lands, so one line yields two answers.

**17.2** "Page x of y" in the footer:

```typ
#set page(width: 9cm, height: 7cm, margin: 1cm, footer: context [
  #set align(center)
  p. #counter(page).display() / #counter(page).final().first()
])

#lorem(40) #pagebreak() #lorem(40) #pagebreak() #lorem(20)
```

The footers read `p. 1 / 3`, `p. 2 / 3`, `p. 3 / 3`. `.final()` returns an array
with the counter's last value, and `.first()` pulls the integer out. The
shorthand `counter(page).display("1 / 1", both: true)` does the same job.

**17.3** A custom counter for numbered notes:

```typ
#let fn = counter("figure-note")
#let note(body) = { fn.step(); [*Note #context fn.display().* #body] }

#note[First.]
#note[Second.]
#note[Third.]
#note[Fourth.]
```

The four notes number themselves `Note 1` through `Note 4`. `step()` runs
outside `context` (it advances the counter in document order); `display()` runs
inside `context` (it reads the value where it's printed). Reorder the calls and
the numbers follow the new order automatically.

**17.4** A number from the end of the document, printed at the top:

```typ
#context [This page has #fn.final().first() notes.]
```

Placed at the top, it still reports the correct total. Typst lays the whole
document out to discover the counter's final value, then makes another pass to
fill that value into the line — the "future" number is knowable because the
entire document is laid out before any final PDF is emitted.

**17.5** A running header driven by `state`:

```typ
#let sec = state("section", "Introduction")

#set page(header: context emph(sec.get()))

= Introduction
#lorem(30)

#sec.update("Methods")
#pagebreak()

= Methods
#lorem(30)
```

The header reads the current section from state. The crucial subtlety: the
`sec.update("Methods")` must come *before* the `#pagebreak()`, so the new value
is already in effect at the top of page two, where the header is drawn.
Initialising the state with the first section's title keeps page one right too.

To break it on purpose, give a state an update that depends on its own
`.final()`:

```typ
#let s = state("s", 1)
#context s.update(s.final() + 1)
#context s.get()
```

This still compiles, but Typst prints a warning that the document did not
converge within five attempts, listing the values it tried (1, 2, 3, 4, 5, final
6). The moral: a value must never depend on its own final result.

## Chapter 18 — Your own functions

**18.1** A definition in one file, imported into another. `keys.typ`:

```typ
#let kbd(key) = box(
  stroke: 0.5pt, inset: (x: 4pt, y: 1pt), radius: 3pt,
)[#raw(key)]
```

`main.typ`:

```typ
#import "keys.typ": kbd

Press #kbd("Ctrl") + #kbd("C") to copy.
```

Compiling `keys.typ` on its own renders a blank page — it only defines.
`main.typ` imports the name and shows the caps. The relative path `"keys.typ"`
resolves because the two files sit together.

**18.2** Give `keys.typ` a second name, then reach both three ways. In
`keys.typ`:

```typ
#let key-color = luma(245)
#let kbd(key) = box(
  fill: key-color, stroke: 0.5pt, inset: (x: 4pt, y: 1pt), radius: 3pt,
)[#raw(key)]
```

The three imports:

```typ
#import "keys.typ": kbd, key-color   // named: specific names in scope
#import "keys.typ": *                // star: everything in scope
#import "keys.typ"                   // module: reach via keys.kbd, keys.key-color
```

Named and star let you write `kbd(…)` directly; the plain module import needs
the `keys.` prefix. Same two names underneath — only the spelling at the call
site differs.

**18.3** A shared brand colour that both components default to. `lib.typ`:

```typ
#let brand = rgb("#2b6cb0")

#let callout(body, title: "Note", color: brand) = block(
  fill: color.lighten(85%), stroke: (left: 3pt + color),
  inset: 10pt, width: 100%,
)[#text(fill: color, weight: "bold")[#title] \ #body]

#let tag(body, color: brand) = box(
  fill: color, inset: (x: 6pt, y: 3pt), radius: 4pt,
)[#text(fill: white, weight: "bold")[#body]]
```

`main.typ`:

```typ
#import "lib.typ": brand, callout, tag

#callout[Default.] #callout(color: green)[Override.]
#tag[Default] #tag(color: red)[Override]
```

Both components default `color: brand`, so editing `brand` in `lib.typ` moves
every default-coloured element at once, while explicit overrides stay put.

**18.4** `include` splices rendered content; `import` would not. With
`intro.typ` and `body.typ` each holding a heading and some prose, `main.typ`:

```typ
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif")

#include "intro.typ"
#include "body.typ"
```

`include` drops the rendered content of each file exactly where its line sits,
in call order. `import` would have brought names into scope but nothing visible
— that's the difference the exercise is after.

**18.5** Two whole-document looks, swapped with one line. `looks.typ`:

```typ
#let formal(body) = {
  set text(font: "Libertinus Serif", size: 11pt)
  set page(margin: 2.2cm)
  show heading: set text(fill: navy)
  body
}

#let playful(body) = {
  set text(font: "New Computer Modern", size: 12pt)
  set page(margin: 1.4cm)
  show heading: set text(fill: fuchsia)
  body
}
```

`main.typ`:

```typ
#import "looks.typ": formal, playful

#show: formal          // change to `playful` to reskin

= Title
#lorem(40)
```

One `#show:` line swaps the entire look; the content never moves. That's two
templates and a one-line switch between them — most of what Chapter 19
formalises.

## Chapter 19 — Templates

**19.1** Inside `report`'s block body, among the other set rules and before
`body`, add one line:

```typ
show heading: set text(fill: navy)
```

Then `#show: report` over a document with a couple of headings recolours every
one. The show rule is scoped to the body the function wraps, so a single line
reskins all the headings at once.

**19.2** An optional date on the title block:

```typ
#let report(title: none, author: none, date: none, body) = {
  align(center)[
    #text(size: 18pt, weight: "bold")[#title] \
    #text(style: "italic")[#author]
    #if date != none [ \ #text(size: 9pt, fill: luma(40%))[#date] ]
  ]
  body
}
```

Apply it once with `date: "July 2026"` and once without. The `none` default plus
the `if` guard means the date line — linebreak and all — simply doesn't render
when omitted, so you never get a stray blank line.

**19.3** Move the `#let report(…)` from 19.2 into `template.typ`, then in
`main.typ`:

```typ
#import "template.typ": report

#show: report.with(title: "Field notes", author: "A. Lovelace", date: "July 2026")

= A heading
#lorem(20)
```

The output is identical to the single-file version. Moving the code into its own
file changes where the definition lives, nothing about how it behaves.

**19.4** Add `keywords: ()` to the signature (default empty array) and guard on
it after the abstract:

```typ
#if keywords != () {
  block(inset: (x: 1.4em))[
    #set text(size: 9pt, style: "italic")
    #keywords.join(", ")
  ]
}
```

Default to `()` (or `none`) and check before printing, so nothing shows when
it's omitted; `.join(", ")` turns `("typst", "templates")` into `typst,
templates`.

**19.5** A second template with completely different front matter, kept beside
`article` in the same `template.typ`:

```typ
#let memo(to: none, from: none, date: none, body) = {
  set page(width: 12cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  grid(columns: (auto, 1fr), row-gutter: 0.4em,
    [*To:*], [#to], [*From:*], [#from], [*Date:*], [#date])
  line(length: 100%, stroke: 0.5pt)
  v(0.6em)
  body
}
```

Then `main.typ` chooses the look on one line:

```typ
#import "template.typ": article, memo

#show: article.with(title: "Q3 review", author: "A. Lovelace")
// #show: memo.with(to: "Team", from: "Ada", date: "July 2026")

= Heading
#lorem(30)
```

Swap which `#show:` line is active and the same body switches between a centred
article and a left-aligned memo. The design and the writing are genuinely
separate — that's the whole payoff.

## Chapter 20 — Packages

**20.1** Import a Universe package and let the cache do the work:

```typ
#import "@preview/cetz:0.3.4"

#cetz.canvas({
  import cetz.draw: *
  circle((0, 0), radius: 1)
})
```

The first compile reaches the network to download `cetz`; every compile after
that reads it from the local cache, so it's fast even offline. (Import with `:
*` instead and the `canvas` / `draw` names land in scope directly — either style
is fine.) The lesson is download-once-then-offline.

**20.2** A bare `#import "@preview/cetz"` errors: Typst insists on a version. A
name without one is ambiguous and would make builds non-reproducible — "newest"
could change under you and break the document silently. Pinning
`@preview/cetz:0.3.4` guarantees the same build forever. (`typst init` *does*
default to the latest version, because scaffolding a new project once is a
different situation from reproducibly recompiling an existing one.)

**20.3** No single answer; credit yourself for naming a real Typst Universe
package, its current version, and a well-formed line like `#import
"@preview/NAME:VER"`. Read the version straight off the package's Universe page.

**20.4** A local package: `typst.toml`:

```toml
[package]
name = "my-notes"
version = "0.2.0"
entrypoint = "lib.typ"
authors = ["Ada Lovelace"]
license = "MIT"
description = "Small note helpers."
```

`lib.typ` exports something like `#let hi(name) = [Hello, #name!]`; `main.typ`
reads it by relative path with `#import "lib.typ": hi` and calls `#hi("world")`.
It compiles offline because a relative import never touches the registry — the
pattern from `examples/106-publishing-a-package/`.

**20.5** Turn the Chapter 19 template into a template package. The shape
(mirrors `examples/107-`):

- `typst.toml` with a `[package]` section and a `[template]` section (`path =
  "template"`, `entrypoint = "main.typ"`, `thumbnail = "thumbnail.png"`);
- `lib.typ` exporting your Chapter 19 wrapper (the show-rule function);
- `template/main.typ` importing the package by its hypothetical
  `@preview/<name>:<ver>` name — an illustration that won't compile until
  published;
- root `main.typ` importing `lib.typ` by relative path and applying the wrapper
  — this is the one that must compile offline.

The graded points are the `[template]` fields, the relative-vs-`@preview`
distinction between the two `main.typ` files, and a clean local compile.

## Chapter 21 — Advanced layout

**21.1** Placed content reserves no space:

```typ
#place(top + right, dx: -2mm, dy: 2mm,
  box(fill: red, inset: 4pt, text(fill: white)[*CONFIDENTIAL*]))

#lorem(60)
```

The first line of `lorem` starts at the top margin and the tag overlaps it. Move
the anchor to `bottom + center` and the tag pins to the foot, centred, while the
body text still flows as if it weren't there. See `examples/108-`.

**21.2** A fixed-height block that clips its overflow:

```typ
#block(
  fill: rgb("#eef4ff"), stroke: 1pt + blue, radius: 6pt,
  inset: 10pt, height: 1.5cm, clip: true,
)[#lorem(30)]
```

Without a fixed `height` the block grows to fit its text. Fix the height and the
text overflows past the bottom edge; add `clip: true` and the overflow is cut
off cleanly at the block's border instead of spilling out. See `examples/109-`.

For the `breakable` part, drop the fixed height and fill the box with enough
text to cross a page:

```typ
#block(
  fill: rgb("#eef4ff"), stroke: 1pt + blue, radius: 6pt,
  inset: 10pt, breakable: false,
)[#lorem(120)]
```

With `breakable: false` the whole box moves to the next page rather than split
across the boundary. The catch is the edge case: if the box were taller than a
whole page, there is no page with room for it, so it overflows the bottom edge —
`breakable: false` keeps a box intact but can't make it fit.

**21.3** A dot leader that fills the slack on a line:

```typ
Chapter 1 #box(width: 1fr, repeat[.]) 7
```

The `1fr` box absorbs all the free space and `repeat[.]` fills it with dots.
Lengthen `Chapter 1` to a real title and the dot run shortens automatically to
keep the `7` at the right edge. See `examples/112-`.

**21.4** Four inline transforms:

```typ
#rotate(20deg)[word]
#scale(x: 140%)[word]
#move(dy: -4pt)[word]
#skew(ax: 20deg)[word]
```

By default these don't reflow, so the line keeps the untransformed word's height
and the rotated or moved versions poke out of it. Add `reflow: true` to the
rotation and the line grows to contain the rotated box. See `examples/111-`.

**21.5** A hand-built table of contents from `context query`:

```typ
#context {
  for h in query(heading) {
    let p = counter(page).at(h.location()).first()
    [
      #pad(left: (h.level - 1) * 1em)[
        #h.body #box(width: 1fr, repeat[.]) #p
      ]
    ]
  }
}
```

`context` gives the whole-document view; `query(heading)` returns every heading,
`counter(page).at(h.location())` finds each one's page, and the `1fr` + `repeat`
pair draws the leader. The output looks like `#outline()`, but you own every
part of it — filter by level, add section numbers, change the leader — which
`#outline` won't let you do. Like Chapter 17's `.final()`, `query` sees the
entire document at once. See `examples/113-`.

## Chapter 22 — Designing a book template

These solutions edit the multi-file book template from `examples/115-`, so the
fragments below are meant to slot into it rather than compile standalone.

**22.1** Edit `theme.typ` only — for instance `#let accent = rgb("#a12f5a")` and
`#let font-head = "Libertinus Serif"`. Everything that names `accent` moves with
it: the heading colour, the opener/part/contents rules, the chapter and part
kickers, the index letters, the code block's left rule, the title-page rule.
`font-head` re-fonts every heading, label, kicker, and title. The admonition
colours are their *own* constants, so they don't follow `accent` unless you
point them at it too. One file is the single source of truth; the rest of the
template only ever names the constants.

**22.2** One line in `admonitions.typ` mints a new kind by configuring the
existing box function:

```typ
#let example = admonition.with(kind: "Example", color: accent)
```

It's already exported through the module's `*`, so a chapter can call
`#example[…]` and get a tinted block with an `EXAMPLE` label and an accent
side-rule — no new box code, because `.with` just pre-fills the box that's
already written.

**22.3** Replace the footer body with a total:

```typ
Page #counter(page).display("1") of #counter(page).final().first()
```

(or the `display("1 of 1", both: true)` shorthand), still inside the `context`
footer. `.final()` returns an array and `.first()` pulls the integer. It's right
on every page because Typst iterates until the total settles (Chapter 17). The
total counts from wherever the page counter was last reset — here the
`counter(page).update(1)` at the start of the body — so "of N" reflects the
numbered body pages.

**22.4** Give `book` a `date` parameter before `body`, thread it into
`_title-page`, and guard it there:

```typ
#if date != none { v(0.3em); text(size: 8.5pt, fill: muted)[#date] }
```

Apply the template once with `date: "July 2026"` and once without. The `none`
default plus the `if` guard is the same optional-line habit from Chapter 19 — no
blank gap when the date is omitted.

**22.5** Have `part()` record each divider with a `metadata` marker the way
`idx` does:

```typ
#let part(title) = {
  counter("part").step()
  [#metadata(title)<part-entry>]
  page(/* … existing divider … */)[/* … */]
}
```

Then build the contents page by querying both markers and sorting by page
location:

```typ
#context {
  let parts = query(<part-entry>).map(e => (
    kind: "part", loc: e.location(), body: e.value))
  let chaps = query(heading.where(level: 1)).map(h => (
    kind: "chapter", loc: h.location(), body: h.body,
    num: counter(heading).at(h.location())))
  let items = (parts + chaps).sorted(key: it => it.loc.position().page)
  for it in items {
    let p = counter(page).at(it.loc).first()
    if it.kind == "part" {
      strong(it.body)
    } else {
      [#h(1em) #numbering("1", ..it.num) #it.body
       #box(width: 1fr, repeat[.]) #p \ ]
    }
  }
}
```

Sorting the mixed list by page location is the crux — `it.loc.position().page`
gives a sortable key. Because `query` sees the whole document, parts (which
aren't headings) and chapters (which are) merge into one ordered contents —
something `#outline`, which only knows headings, cannot build. Any
merged-and-sorted version that puts each part above its chapters passes.

## Chapter 23 — Building the book

These solutions edit the assembled book in `examples/116-`, so the snippets are
files or lines to add to that project.

**23.1** Create `chapters/04-the-clearing.typ`:

```typ
= The clearing
#lorem(60)
```

Then add one line in `main.typ` under the `#part[Rough weather]` block, after
chapter 03:

```typ
#include "chapters/04-the-clearing.typ"
```

Recompile with `typst compile --root . examples/116-assembling-a-book/main.typ
out.pdf`. It appears as Chapter 4 — the heading counter continues, it lands in
the outline on its own, and its page number is discovered by query. Adding
content is a one-line edit to the manifest.

**23.2** Create `front/dedication.typ` with no `=` heading, so it stays out of
the chapter numbering:

```typ
#v(1fr)
#set align(center)
#emph[For everyone who checks the sky before leaving the house.]
#v(1fr)
```

Include it inside the front-matter block, between the copyright and preface
includes (add `#pagebreak(weak: true)` if you want it alone on a page). Because
roman numbering is automatic, the preface renumbers from ii to iii by itself —
none of the numbers are typed.

**23.3** Prefix each chapter include with a break to the next odd page:

```typ
#pagebreak(to: "odd")
#include "chapters/01-a-clear-morning.typ"
```

Chapters now start on odd (recto) pages, with Typst inserting a blank verso
where needed. The reason *not* to bother for a screen-only PDF: read on a phone
or laptop there's no left/right spread and no binding, so the inserted blanks
are just wasted scroll — recto starts are a print-binding courtesy. You could
also fold it into the template's level-1 heading show rule (`pagebreak(weak:
true, to: "odd")`) so it's automatic and still collapses when already on an odd
page.

**23.4** In `book.typ`, `_contents-page()`, change `outline(title: none, depth:
2, indent: 1.2em)` to `depth: 1`. The contents now lists only the level-1
chapter lines, no sections. Because the depth lives in one place, it's a single
edit — if it had been repeated across many files you'd have had to find and fix
every copy and risk missing one, which is exactly the argument for Chapter 22's
theme/constants layering.

**23.5** Half-title first: the template's `book()` draws its own full title page
as the first thing in the front matter, so you can't inject a page *before* it
from `main.typ` without editing the template. The honest answer is to say so and
place the half-title as the first page *inside* the roman front-matter block
instead — it then follows the template's title page. (Conventionally a
half-title precedes the title page, so note that with this template it has to
come after unless you edit the template; both are acceptable if reasoned.)
Half-title, no heading:

```typ
#v(2fr)
#set align(center)
#smallcaps(text(size: 18pt)[The Weather Almanac])
#v(3fr)
```

Colophon after `#make-index()`, drawn by hand like the appendix (`muted` is the
template's own colour constant):

```typ
#pagebreak(weak: true)
#v(1fr)
#set align(center)
#set text(size: 9pt, fill: muted)
Set in Libertinus Serif and New Computer Modern. \
Typeset with Typst.
#v(1fr)
```

Front and back matter are just content you place around the body; the template
hands you the fonts and colours to make them match. Any version that reasons
correctly about ordering and keeps the extra pages out of the chapter numbering
(no `=` headings) passes.

## Chapter 24 — The Pandoc bridge

**24.1** Run any three-paragraph GitHub-Markdown file through `pandoc --from gfm
--to typst`. The mapping is one-to-one: `#` becomes `=`, `**bold**` becomes
`#strong[…]`, a `-` list becomes Typst list items. Reading the output and seeing
that correspondence is the exercise; no compile needed.

**24.2** Two ways to a PDF:

```sh
pandoc x.md --to typst -o x.typ && typst compile x.typ
pandoc x.md -o x.pdf     # LaTeX path — needs a TeX install
```

Both produce a reasonable PDF. The Typst path is far faster and needs no TeX; if
you don't have LaTeX installed, only the Typst path will run at all — which is
rather the point.

**24.3** Without the Div-rewriting filter, `> [!TIP]` becomes a plain nested
`#block[ #block[ Tip ] text ]` — no colour, with `Tip` as literal text. That's
exactly why the filter exists: with it, the same input becomes
`#admonition("tip")[text]`, which your preamble can style.

**24.4** A Lua filter that strips HTML:

```lua
function RawBlock(el)
  if el.format == "html" then
    return {}
  end
end
```

An HTML comment `<!-- … -->` arrives as a `RawBlock` with format `html`;
returning `{}` deletes it. Run the file with `--lua-filter` and confirm the
comment is gone from the `-t typst` output.

**24.5** A miniature version of this chapter's pipeline: a few Markdown files, a
`preamble.typ` defining `#let admonition(kind, body) = …` plus page and text set
rules, and a `build.sh` that converts, concatenates, and compiles:

```sh
pandoc chapters/*.md --from gfm --to typst -o body.typ
cat preamble.typ body.typ > out.typ
typst compile out.typ book.pdf
```

Grade yourself on a working end-to-end build, however minimal. The insight is
the whole chapter in one line: converter + template + compiler = a book from a
folder of Markdown.

---

For side-by-side translations from other systems, see Appendix B (coming from
LaTeX) and Appendix C (coming from Word); for a one-page syntax reminder, keep
Appendix D, the cheat sheet, within reach.
