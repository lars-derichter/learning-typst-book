# Tables and grids

The table is where word processors go to die. You have four columns of tidy
numbers, you paste in a fifth, and the whole thing lurches sideways off the
page. You drag a border to make room; a different border moves. You get it
looking right, add one row, and it isn't right any more. Somewhere in that
struggle you stop thinking about your data and start thinking about the
software, which is exactly backwards.

Typst takes the opposite deal. You describe the table — these are the columns,
here are the cells, this row is the header — and the engine does the arranging.
When you add a row, you type a row; nothing lurches. When you want the numbers
right-aligned, you say so once, in one place, for the whole column. The table
stops being a thing you fight and goes back to being a thing you write.

And there's a bonus hiding in here. The machine that lays out tables is the same
one that can place two blocks of text side by side, or set up a poster, or split
a page into panels. It's called `grid`, and a `table` is really just a `grid`
that also knows it's holding data. Learn one and you've most of the way learned
the other. We'll start with tables, because they're the part you'll reach for
first, and meet the bare `grid` at the end.

## The shape of a table

Here is a whole table, start to finish (`examples/30-basic-table/`):

```typ
#table(
  columns: 3,
  [*Course*], [*Credits*], [*Exam*],
  [Typesetting], [6], [Project],
  [Statistics], [4], [Written],
  [Pedagogy], [5], [Oral],
)
```

That renders a neat three-column grid with light borders: a header-ish top row
of bold labels, then three courses under it.

Two things are doing all the work. `columns: 3` says the table is three columns
wide. Everything after it is a flat list of *cells*, and Typst pours them into
the grid the way you'd read them — left to right, then down to the next row.
After every third cell it wraps to a new line. There are no row brackets, no
`\\` at the end of each line, no `&` between columns. You just list the cells in
reading order and tell Typst how wide the grid is; it works out where each one
lands.

Each cell here is a piece of *content* in square brackets — `[*Course*]`,
`[6]` — the same `[…]` content blocks you've been writing since Chapter 3. A
cell can hold anything content can hold: a word, a number, a whole paragraph,
an image, another table if you're feeling reckless. The bold labels are just
`*strong*` markup inside the cell, nothing table-specific.

> [!NOTE]
> The cells are one long list, so the commas matter and the line breaks don't.
> Laying each row on its own source line, as above, is purely for your eyes —
> Typst counts cells, not lines. But do lay them out that way. A table whose
> source rows match its printed rows is a table you can still edit next month.

> **Coming from a spreadsheet.** A Typst table isn't a live grid you click into;
> it's a description you write out. That sounds like more work, and for three
> cells it is. The payoff arrives at scale: the description is plain text, so
> you can diff it, search it, paste a column from somewhere else, or generate
> the whole thing from a loop (Part IV). No cell references, no hidden
> formulas — what you see is what's there.

## Sizing the columns

`columns: 3` is shorthand. What Typst actually wants is a list of *column
tracks*, and `3` is a friendly way of saying "three tracks, each `auto`." Spell
the list out and you control every column's width. There are three kinds of
track, and you'll mix them constantly (`examples/31-column-sizes/`):

```typ
#table(
  columns: (auto, 1fr, 2.5cm),
  [*Feature*], [*What it does*], [*Since*],
  [Preview], [Recompiles as you type, usually faster than you can notice.], [v0.1],
  [Packages], [A central registry you pull templates and tools from.], [v0.6],
  [HTML export], [An experimental second output format beside PDF.], [v0.11],
)
```

- **`auto`** sizes the column to fit its widest cell and no more. The first
  column is exactly as wide as "HTML export" needs and stops there.
- **A length** like `2.5cm` (or `2cm`, `40pt`, `1in`) pins the column to a fixed
  width, come what may. The "Since" column is 2.5 cm whether it holds "v0.1" or
  nothing.
- **A fraction** like `1fr` claims a share of whatever width is *left over*
  after the `auto` and fixed columns have taken theirs. Here one column has
  `1fr`, so it swallows all the remaining space — which is why the long
  descriptions wrap neatly inside it instead of shoving the table off the page.

The `fr` unit is the quietly brilliant one. It's short for *fraction*, and
fractions split the leftover space in proportion. Two columns at `(1fr, 2fr)`
divide the remaining width one-third to two-thirds. `(1fr, 1fr, 1fr)` gives
three equal columns no matter what's in them. `fr` is how you say "share this
space fairly" without doing the arithmetic yourself, and it's the reason a Typst
table adapts when the page width changes instead of overflowing.

Rows work the same way, through a `rows:` argument, though you'll set it far
less often — cells are usually happy to be as tall as their content. When you do
want control, the same three track kinds apply: `rows: 1cm` makes *every* row
exactly one centimetre tall; `rows: (auto, 2cm)` sets the first row to fit and
the second to a fixed height. If you give fewer track sizes than there are
columns or rows, Typst cycles through the list and reuses it, which is how a
single value like `rows: 1cm` ends up governing all of them.

## Alignment

By default everything sits top-left. To move it, reach for `align`, and `align`
takes three shapes depending on how much control you want.

The simplest is one value for the whole table — `align: center` centres every
cell. One step up is a list, one entry per column:

```typ
#table(
  columns: 3,
  align: (left, center, right),
  ...
)
```

Now the first column is left-aligned, the second centred, the third right — the
classic layout for a table of labels and numbers, where you want the figures to
line up on their right edge. Like the column tracks, a short list cycles, so
`align: (left, right)` on a four-column table alternates left, right, left,
right.

The most powerful shape is a *function*. Instead of a fixed list, you hand
`align` a little rule that receives a cell's column `x` and row `y` (both
counting from zero) and returns an alignment for it. That sounds abstract until
you see what it's for (`examples/32-alignment/`):

```typ
#table(
  columns: (1fr, auto, auto),
  align: (x, y) => if y == 0 { center } else if x == 0 { left } else { right },
  [*Item*], [*Qty*], [*Price*],
  [Notebook], [3], [€4.50],
  [Fountain pen], [1], [€28.00],
  [Ink cartridges], [12], [€6.20],
)
```

Read the function out loud: *if we're in the top row, centre it; otherwise, if
we're in the first column, left-align; otherwise, right-align.* That single line
centres the header, left-aligns the item names, and right-aligns every quantity
and price so the euro amounts line up cleanly — three alignment rules that no
per-column list could express, because the header row wants different treatment
from the body. The `=>` makes an anonymous function; if it looks strange now,
Chapter 14 gives functions the full introduction. For tables you only need the
pattern: `(x, y) => something-that-depends-on-x-and-y`.

## Fills and zebra striping

A `fill` colours the background of cells, and it takes exactly the same three
shapes as `align`: one colour for everything, a list per column, or a function
of `(x, y)`. The function is where it earns its keep, because it's how you get
*zebra striping* — that alternating shaded-row look that makes a wide table
readable across (`examples/33-striped-table/`):

```typ
#table(
  columns: (1fr, auto, auto),
  stroke: none,
  inset: 8pt,
  fill: (x, y) => if calc.odd(y) { luma(240) },
  [*Region*], [*Q1*], [*Q2*],
  [North], [120], [138],
  [South], [98], [102],
  [East], [156], [161],
  [West], [143], [149],
)
```

The fill function says: for a cell in an odd-numbered row, paint it `luma(240)`,
a very light gray; otherwise, return nothing. `luma` builds a gray from a single
number — `luma(0)` is black, `luma(255)` white, so 240 is a whisper of gray.
`calc.odd(y)` is true for rows 1, 3, 5, and so on. The trick is what happens on
the even rows: the `if` has no `else`, so the function returns `none`, and a
cell with no fill just stays transparent. Odd rows get shaded, even rows don't,
and the eye gets a rail to follow.

Turning `stroke: none` off the borders is what makes striping look modern
rather than boxed-in — the shading does the row-separating work that lines used
to. More on strokes in a moment.

You can also paint a single cell, without any function, by wrapping it in
`table.cell` and handing it a `fill` — `table.cell(fill: yellow)[Overdue]` for
one flagged cell. `table.cell` is the general "this cell is special" wrapper,
and we're about to lean on it hard.

## Header and footer rows

Marking your top row as a *header* does two useful things: it tells Typst (and
anyone reading the PDF's structure, including screen readers) that this row
labels the columns, and it makes that row *repeat automatically at the top of
every page* when a long table breaks across several. You get it by wrapping the
first row's cells in `table.header` (`examples/34-header-row/`):

```typ
#table(
  columns: (1fr, auto, auto),
  align: (left, right, right),
  fill: (x, y) => if y == 0 { luma(230) },
  table.header(
    [*Region*], [*Q1*], [*Q2*],
  ),
  [North], [120], [138],
  [South], [98], [102],
  [East], [156], [161],
  table.footer(
    [*Total*], [374], [401],
  ),
)
```

The header repeats by default; if for some reason you want it to appear only
once, pass `table.header(repeat: false, …)`. Here the fill function shades just
row zero, giving the header a subtle gray bar — combine that with the bold
labels and you have a header that reads as a header without a single border.

`table.footer` is the mirror image: a row pinned to the bottom, repeating on
each page, the natural home for a totals line. In a table short enough to fit
one page, as in the preview, header and footer just sit top and bottom as you'd
expect; their powers show up the moment the table grows past a page.

> [!TIP]
> A table usually wants a caption and a number ("Table 3") so you can refer to
> it from your prose. That's not the table's job — it's `figure`'s, which wraps
> any block, numbers it, and lets you cross-reference it. We met `figure` with
> images back in Chapter 6; it works exactly the same around a `table`.

## Spanning cells

Real tables aren't always perfect grids. A title stretches across the top; a
category label covers three rows beneath it. Those are *spans*, and they're two
arguments on `table.cell`: `colspan` to reach across columns, `rowspan` to reach
down rows (`examples/35-spanning-cells/`):

```typ
#table(
  columns: 3,
  align: (x, y) => if x == 0 { left } else { center },
  table.cell(colspan: 3, align: center)[*Autumn timetable*],
  [Time], [Mon], [Tue],
  table.cell(rowspan: 2)[Morning], [Maths], [Biology],
  [English], [Chemistry],
  table.cell(rowspan: 2)[Afternoon], [Art], [Music],
  [History], [Drama],
)
```

The `colspan: 3` cell eats the entire first row as a title. Then come three
ordinary cells for the "Time / Mon / Tue" row. The `rowspan: 2` on "Morning" is
the interesting one: that cell now occupies its column for *two* rows, so on the
next source line you only supply the two cells that go beside its lower half —
`[English], [Chemistry]` — and Typst slots them into the columns the span didn't
claim. You never leave gaps for spanned cells; you just stop providing cells for
the space they already fill, and the flow accounts for it. Miscount and you'll
get a row with the wrong number of cells, which Typst will place somewhere you
didn't intend — so when a spanning table looks scrambled, count your cells per
row first.

`table.cell` carries more than spans. Any single cell can override the table's
defaults for itself: `table.cell(align: right)[…]` to nudge one value,
`table.cell(fill: red.lighten(70%))[…]` to flag one entry,
`table.cell(inset: 12pt)[…]` to give one cell extra breathing room. The
table-wide settings are the defaults; `table.cell` is how one cell disagrees.

## Strokes, lines, and the booktabs look

`stroke` controls the lines. Like `fill` and `align`, it scales from blunt to
surgical.

At the blunt end, one value covers every border: `stroke: 0.5pt` for hairlines,
`stroke: 2pt + blue` for something louder (a stroke carries a thickness *and* a
colour, added together), and `stroke: none` to switch borders off entirely, as
the striped table did. A dictionary sets the four sides independently:

```typ
stroke: (left: 1pt, bottom: 0.5pt, top: none, right: none)
```

And, inevitably, a function of `(x, y)` styles each cell's borders by position —
`stroke: (x, y) => if y == 0 { (bottom: 1pt) }` draws a rule under the header
row and nowhere else.

But for the single most common look — the clean, ruled, no-vertical-lines style
that LaTeX users know as *booktabs* — there's a more direct tool. Instead of
reasoning about which cell owns which border, you place horizontal and vertical
rules yourself with `table.hline` and `table.vline`, dropped straight into the
cell list at the point where you want the line drawn
(`examples/36-custom-strokes/`):

```typ
#table(
  columns: 3,
  stroke: none,
  inset: (x: 10pt, y: 6pt),
  align: (left, right, right),
  table.hline(stroke: 1pt),
  table.header([*Element*], [*Symbol*], [*Z*]),
  table.hline(stroke: 0.6pt),
  [Hydrogen], [H], [1],
  [Helium], [He], [2],
  [Lithium], [Li], [3],
  [Beryllium], [Be], [4],
  table.hline(stroke: 1pt),
)
```

Borders are off, and three `table.hline`s do everything: a firm one on top, a
lighter one under the header, a firm one to close. That's the whole booktabs
recipe — thick top and bottom, thin mid-rule, no verticals — and it comes out
looking like it was set for print. An `hline` between two cells lands on the row
boundary at that point in the list; a `table.vline` works the same way for a
vertical rule between columns. Both accept the same `stroke:` you'd give the
table, so you can make any single line as thick, coloured, or dashed as you
like.

> **Coming from LaTeX.** This whole section is where the relief hits hardest.
> There is no column-spec mini-language — no `\begin{tabular}{|l|c|r|}` to
> decode, no counting pipes and letters. Columns are described by an ordinary
> argument (`columns: (auto, 1fr, 2.5cm)`), alignment by another (`align:`),
> lines by another (`stroke:`). You don't need the booktabs package for
> `\toprule` and `\midrule`, because `table.hline` is built in and you place it
> exactly where you want it. And `\multicolumn` / `\multirow`, that pair of
> incantations, are just `colspan` and `rowspan` — two named arguments on a
> cell. Everything that was a special syntax in `tabular` is, in Typst, a plain
> value you pass to a function.

## Spacing: inset and gutters

Two settings govern the whitespace, and they're easy to confuse because both
add room but in different places.

`inset` is the padding *inside* each cell — the gap between the cell's content
and its border. The default is a sensible few points; bump it up for an airier
table (`inset: 10pt`) or shrink it for a dense one. You can make it asymmetric
with a dictionary, exactly as example 36 does: `inset: (x: 10pt, y: 6pt)` gives
wide horizontal padding and tighter vertical, a common tweak that stops columns
feeling cramped without making rows too tall.

*Gutters* are the space *between* cells — gaps that separate the tracks instead
of padding within them. `gutter: 6pt` spaces every row and column apart;
`column-gutter` and `row-gutter` control the two axes separately. On a table you
reach for gutters rarely (borders and inset usually do the job), but on a bare
`grid` used for layout they're the main event, which is where we're headed.

## `grid`: the same engine, minus the meaning

Everything so far — the column tracks, the `fr` units, `align`, `fill`, the
spans, the gutters — belongs to a lower-level function called `grid`. A `table`
is a `grid` with two things added: default borders, and the *semantics* that
this is tabular data (headers, the accessibility structure a screen reader
announces as a table). Strip those away and you get `grid`, which lays content
out on a grid and draws nothing and claims nothing about what the content
*means*. It's Typst's tool for pure page layout
(`examples/37-grid-for-layout/`):

```typ
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1cm,
  row-gutter: 0.8cm,
  grid.cell(colspan: 2)[
    == Typst, weighed
  ],
  [
    *For* \
    Instant preview, readable
    source, one language for
    content and code.
  ],
  [
    *Against* \
    A younger ecosystem and
    fewer packages than LaTeX's
    forty-year head start.
  ],
)
```

Two equal `1fr` columns put the two blocks side by side; a `column-gutter` opens
a one-centimetre channel between them so they don't touch. The
`grid.cell(colspan: 2)` spanning the top holds a heading across both columns —
`grid.cell` is the grid's version of `table.cell`, spans and all. There isn't a
border in sight, and that's the point: this is layout, not data. The API is the
one you already know; only the defaults and the meaning have changed.

So which do you reach for? The rule is about *meaning*, not appearance:

- Use **`table`** when the content *is* a table — rows and columns of data where
  the structure carries information. It's the honest, accessible choice: the PDF
  records it as a table, headers and all, so tools and screen readers understand
  it. Even a borderless table (`stroke: none`) should stay a `table` if it's
  really data.
- Use **`grid`** when you're only positioning things on the page — two columns
  of a newsletter, a row of logos, a caption beside a figure, a dashboard of
  panels. There's no data here, so claiming there is would only mislead anything
  reading the document's structure.

Put plainly: if you'd call it a table in conversation, use `table`; if you'd
call it a layout, use `grid`. When it's a genuine toss-up, prefer `table` — the
extra semantics cost you nothing and help someone.

## What you've got

You can now build essentially any table Typst can produce:

- **The core** — `#table(columns: …, cell, cell, …)`, cells flowing left to
  right and wrapping by column count.
- **Sized columns and rows** — `auto` to fit, a length like `2.5cm` to fix, and
  `fr` units to share the leftover space; the same three kinds for `rows:`.
- **Alignment** three ways — one value, a per-column list, or an `(x, y) =>`
  function for rules that depend on position.
- **Fills**, including the `fill: (x, y) => if calc.odd(y) { luma(240) }` idiom
  for zebra striping, and per-cell `fill` for flagging one entry.
- **Headers and footers** with `table.header` / `table.footer`, which repeat
  across page breaks and carry the table's accessible structure.
- **Spanning cells** — `colspan` and `rowspan` on `table.cell`, plus per-cell
  `align`, `fill`, and `inset` overrides.
- **Strokes** from a single `stroke: 0.5pt`, through `stroke: none`, a per-side
  dictionary, and an `(x, y)` function, to hand-placed `table.hline` /
  `table.vline` for a booktabs-clean result.
- **Spacing** — `inset` inside cells, `gutter` / `column-gutter` / `row-gutter`
  between them.
- **`grid`** — the same layout engine without the table semantics, for placing
  blocks side by side, and a clear sense of when to use which.

Tables and grids round out Part II's toolkit for everyday documents. Next, in
Chapter 8, Typst shows off the feature it's arguably proudest of: mathematics.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

7.1. Build a four-column table of five films: title, director, year, and a
one-word rating. Give it a header row in bold. Get the years and ratings to sit
in sensibly sized columns while the title column takes up the slack — think
about which track kind each column wants.

7.2. Take the table from 7.1 and right-align the year column, keeping the title
left-aligned, using a single `align` list. Then add zebra striping with a `fill`
function and switch the borders off. Decide for yourself whether it reads better
striped or ruled.

7.3. Make a small weekly planner: a title spanning the full width, a header row
of weekdays, and at least one cell that spans two rows (a "lunch" block covering
two time slots, say). Count your cells per row carefully — this is the exercise
where miscounting bites.

7.4. Reproduce the booktabs look from `examples/36-custom-strokes/` on data of
your own: no vertical lines, a thick rule top and bottom, a thin rule under the
header, and comfortable `inset`. Then add one `table.vline` to separate a group
of columns from the rest and judge whether it improves or clutters the result.

7.5. *(Stretch.)* Using `grid` rather than `table`, lay out a simple "card":
a full-width title across the top, then two columns underneath — a small fixed
column for a label like "Price" or "Rating" and a `1fr` column for a paragraph
of description (`#lorem(30)` will do). Add a gutter between the columns. Then
write one sentence in a comment explaining why `grid` is the right choice here
and a `table` would be the wrong one.

<!--
SOLUTIONS (notes for the appendix author):
7.1 - A #table with columns: 4 (or better, columns: (1fr, auto, auto, auto)) and
      a bold header row. Point: title as 1fr to absorb slack, year/rating as
      auto (or a small fixed length). Any of:
        #table(
          columns: (1fr, auto, auto, auto),
          [*Title*], [*Director*], [*Year*], [*Rating*],
          [Metropolis], [Lang], [1927], [Great],
          ... five rows ...
        )
      Accept columns: 4 as well; the track-kind reasoning is the learning goal.
7.2 - align: (left, left, right, center) or similar (a per-column list). Then
      stroke: none and fill: (x, y) => if calc.odd(y) { luma(240) }. There is no
      single right aesthetic answer to striped-vs-ruled; credit the reasoning.
7.3 - columns: N with table.cell(colspan: N)[*title*] on top, a weekday header
      row, and a table.cell(rowspan: 2) somewhere. The trap: after a rowspan
      cell, the next row supplies only the cells NOT covered by the span. A
      correct planner has consistent cell counts once spans are accounted for.
7.4 - stroke: none on the table; table.hline(stroke: 1pt) top, hline(stroke:
      ~0.6pt) after the header, hline(stroke: 1pt) at the end; roomy inset (e.g.
      (x: 10pt, y: 6pt)). Adding table.vline(x: k, stroke: ...) inserts a single
      vertical rule between columns k-1 and k. Judgement call on whether it
      helps; booktabs orthodoxy says no verticals, but the exercise is about
      being able to place one deliberately.
7.5 - #grid(columns: (auto, 1fr), gutter/column-gutter, grid.cell(colspan: 2)
      [title], [Price], [#lorem(30)]). The "why grid" sentence should say: this
      is layout/positioning, not tabular data, so grid keeps the structure
      honest (no false table semantics / screen-reader table announcement) and
      draws no borders by default. A table would misrepresent a layout card as
      data.
-->
