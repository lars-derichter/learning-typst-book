# Pages and layout

So far you've been pouring words onto whatever page Typst handed you. It's a
good page — A4, sensible margins, a clean single column — but it was chosen for
you, and sooner or later you'll want a different one. A letter wants US paper.
A conference handout wants two columns. A thesis wants a running header with the
chapter title and a page number down in the corner. A draft wants the word
DRAFT ghosted across it so nobody circulates it by accident.

All of that is the *page*, and in Typst the page is a thing you configure with a
single function. No package to load, no geometry to import, no preamble. You set
it once and every page obeys, or you set it again halfway through and the rest
of the document changes its mind. This chapter is about that function — and
about the smaller layout controls that shape the paragraphs sitting inside it.

## The page is one function

Everything about the sheet itself lives in `#set page(...)`. Put it near the top
of your file and it governs the whole document:

```typ
#set page(paper: "us-letter", margin: 2.5cm)
```

The `paper` argument takes a name — `"a4"` (the default), `"a3"`, `"a5"`,
`"us-letter"`, `"us-legal"`, and a long list of others, right down to business
cards and ISO envelopes. You'll almost never need the exotic ones, but they're
there.

When no named size fits, give the dimensions directly:

```typ
#set page(width: 16cm, height: 24cm)
```

That's a small book block, the kind of trim size a novel might use. You can mix
the two — name a paper and override just the height — but usually it's one or
the other.

> [!NOTE]
> A set rule takes effect from where you write it onward. Put `#set page` at the
> top and it shapes the entire document, including page one. Put a second one in
> the middle and every page after it switches — handy for a landscape spread in
> the middle of a portrait report.

### Margins

Margins are where Typst quietly saves you an afternoon. In many systems the
margin is four separate settings you have to keep in sync. Here it's one
argument that accepts however much detail you care to give it.

A single length sets all four sides at once:

```typ
#set page(margin: 2cm)
```

A dictionary sets them in pairs — `x` for left and right, `y` for top and
bottom:

```typ
#set page(margin: (x: 2cm, y: 3cm))
```

Or name each side on its own when you need real asymmetry — a wide inner margin
for binding, say:

```typ
#set page(margin: (top: 2cm, bottom: 3cm, left: 3cm, right: 2cm))
```

You can even set some sides in the dictionary and let the rest default. See
`examples/18-paper-and-margins/` for the paired form on a small page, where the
generous top and bottom are obvious at a glance.

### Landscape

To turn the page on its side, don't swap width and height by hand and hope you
got it right. Set `flipped`:

```typ
#set page(paper: "a4", flipped: true)
```

Typst exchanges the two dimensions for you, so an A4 page becomes 297mm wide by
210mm tall. It works with named papers and with explicit `width`/`height` alike.

> **Coming from LaTeX.** There is no `geometry` package, because there's
> nothing to import. Where you'd write
> `\usepackage[a4paper,margin=2.5cm]{geometry}` and hope the options don't fight
> your document class, Typst gives you one `#set page(paper: "a4",
> margin: 2.5cm)` and no document class to fight. Margins are an argument, not a
> package.

## Headers and footers

A header and a footer are just content that Typst reprints at the top and bottom
of every page. You hand them over as arguments:

```typ
#set page(
  header: [_Field notes_],
  footer: [Draft — do not circulate],
)
```

Whatever you put in the brackets is ordinary markup: emphasis, a date, a small
image, anything. The interesting part is placing pieces of it left, center, and
right, and for that Typst gives you a lovely little tool: `#h(1fr)`, a
*stretchy* horizontal space that swells to eat all the room available.

One `1fr` between two things shoves them to opposite edges:

```typ
header: [_Field notes_ #h(1fr) Chapter 5]
```

The title sits left, the chapter sits right, and the stretch fills the gap.
Wrap a piece in two of them and it lands dead center:

```typ
footer: [#h(1fr) middle #h(1fr)]
```

You'll use `1fr` constantly once you meet it. It's the same idea as a spring:
give it room and it expands to fill. `examples/19-header-and-footer/` runs a
title-and-chapter header over a centered footer across two pages.

## Page numbers

You could type a page number into the footer by hand, but you'd be wrong on
every page but one. Typst counts for you. Set `numbering` on the page:

```typ
#set page(numbering: "1")
```

and Typst prints the number in the footer automatically — you don't supply a
footer at all. The string is a *pattern*, and the digit you put in it chooses
the style:

- `"1"` — plain digits: 1, 2, 3.
- `"i"` — lowercase roman: i, ii, iii. (`"I"` gives uppercase.)
- `"a"` — letters: a, b, c.
- `"1 / 1"` — the current page and the total, e.g. "3 / 12". The surrounding
  text (` / ` here) is printed verbatim; only the counter symbols advance.

`number-align` decides where the number sits — `center` by default, or `left`,
`right`, and you can add a vertical part like `right + bottom`.
`examples/20-page-numbering/` sets `"1 / 1"` across a three-page document, so
the footer counts "1 / 3", "2 / 3", "3 / 3".

> [!WARNING]
> The automatic page number appears only while Typst is drawing the footer
> *for you*. The moment you supply your own `footer:`, that automatic number
> disappears — your footer replaces it wholesale. If you want the number inside
> a custom footer, you have to place it there yourself, which is the next thing.

### The number, by hand

Behind the automatic number is a *counter* named `page`, and you can print it
anywhere with `counter(page).display()`. That's how you fold a page number into
a footer you've designed yourself:

```typ
footer: context [#h(1fr) #counter(page).display() #h(1fr)]
```

Two things are new there. `counter(page)` is the running tally of pages;
`.display()` renders it, optionally taking a pattern string just like
`numbering` (so `.display("i")` gives roman). And the `context` keyword in front
is Typst's way of saying "this value depends on *where* we are in the document"
— the page number is different on every page, so Typst can only work it out once
it knows which page it's laying out. You met `#context` in passing before; it
gets its proper introduction, along with counters and state, in Chapter 17. For
now, treat `context [ … #counter(page).display() … ]` as the incantation that
puts the live page number into content you control, and move on.

The short version: set `numbering` when you just want a page number in the usual
place, reach for `counter(page).display()` inside `context` when you're building
a header or footer by hand and want the number to be one ingredient among
several.

## Columns

Two columns, newspaper style, is one word:

```typ
#set page(columns: 2)
```

Text now flows down the left column and continues at the top of the right,
spilling onto the next page when both are full. Everything on the page — body,
headings, the lot — obeys the column layout. `examples/21-two-columns/` fills
two columns with `#lorem` so you can see the flow and the gap down the middle.

That gap is the *gutter*, and it comes from the same `columns` machinery. For a
whole-page layout the default gutter is fine; when you want to set it, or when
you only want *part* of a page in columns, use the `columns` function instead:

```typ
#columns(2, gutter: 1cm)[
  #lorem(60)
]
```

This makes a multi-column block right where you put it, without disturbing the
single-column text above and below. It's the tool for an abstract that spans the
full width followed by a two-column body, or for one boxed aside set in narrow
measure. A `#colbreak()` inside the block forces the flow to jump to the next
column early, the way `#pagebreak()` jumps to the next page.

> [!TIP]
> Full-page `#set page(columns: 2)` and a local `#columns(2)[…]` block are two
> tools for two jobs. Reach for the page setting when the *whole* document is
> multi-column; reach for the block when only a stretch of it is, and you want
> the surrounding text left alone.

## The shape of a paragraph

The page is the container; the paragraph is what fills it, and `#set par(...)`
tunes how. A handful of knobs cover most of what you'll ever want.

`justify` stretches each line to reach both margins, giving you the clean
block-of-text edges of a printed book:

```typ
#set par(justify: true)
```

By default paragraphs are ragged-right, which reads well on screen and in narrow
measure; justification looks best once lines are long enough not to gap
awkwardly.

`leading` is the space *between lines within* a paragraph — what typesetters
call leading (it rhymes with "heading", after the strips of lead they once
slid between lines of metal type). Tighten or loosen it in em units:

```typ
#set par(leading: 0.8em)
```

`spacing` is the different, larger space *between* one paragraph and the next.
The two are easy to confuse; `leading` is inside a paragraph, `spacing` is the
gap to the following one.

`first-line-indent` indents the opening line of each paragraph, the traditional
book alternative to a blank line between them:

```typ
#set par(first-line-indent: (amount: 1.2em, all: true))
```

Written as a plain length — `first-line-indent: 1.2em` — Typst indents every
paragraph *except* the first one after a heading, which is the usual
typographic convention (you don't indent a paragraph that nothing precedes).
The dictionary form with `all: true` overrides that and indents every paragraph,
which some house styles prefer. `examples/22-paragraph-settings/` combines
justification, tighter leading, and a first-line indent into the familiar
book-page look.

One more, occasionally useful: `linebreaks` chooses how Typst decides where
lines wrap. The default, `auto`, runs an optimizing algorithm when text is
justified (weighing the whole paragraph to avoid rivers and cramped lines) and a
simple greedy pass otherwise. You can force `"optimized"` or `"simple"`
yourself, but the default is usually the right call.

> **Coming from Word.** The line-spacing dropdown, the "space before/after
> paragraph" boxes, the ruler with its indent markers — all of it collapses into
> `#set par`. And you set it once, in one place, instead of selecting text and
> clicking. Change `leading` at the top of the file and every paragraph in a
> three-hundred-page document reflows to match. No "apply to all," no Format
> Painter.

## Spacing and breaks by hand

Most spacing should come from your rules, so it stays consistent. But now and
then you want to reach in and nudge one spot, and Typst has blunt instruments
for exactly that.

`#v(length)` inserts vertical space between blocks — a centimeter of air above a
signature line, a bit of breathing room before a section:

```typ
Yours sincerely,
#v(2cm)
Lars De Richter
```

`#h(length)` does the same horizontally, inline. You've already met its
stretchy cousin `#h(1fr)`; a fixed `#h(1cm)` just inserts that much space and
stops.

To force a new page, `#pagebreak()`:

```typ
#pagebreak()
= A chapter that must start fresh
```

That one always breaks. Its gentler variant, `#pagebreak(weak: true)`, breaks
*only if the current page already has content* — if a page break just happened,
a weak one does nothing rather than leaving a blank page behind. This matters
when a break lives inside a rule that might fire right after another break; the
weak version keeps you from stacking two and emptying a page. `#v` also has a
`weak: true` form, for the same reason: weak space at the very top of a page
collapses instead of pushing your text down. `examples/23-spacing-and-breaks/`
shows `#v`, `#h(1fr)`, and both kinds of break side by side.

> [!TIP]
> If you find yourself sprinkling `#v` and `#pagebreak` everywhere to fix
> spacing, stop and ask whether a set or show rule should be doing it instead.
> Manual nudges are for one-off exceptions. When *every* section needs space
> above it, that's a rule's job (Chapter 9), not a hundred hand-placed `#v`s.

## Fills and watermarks

The page has a background you can paint. `fill` floods the whole sheet with a
color:

```typ
#set page(fill: rgb("#faf6ec"))
```

That's a faint warm paper tint, the sort of thing that makes a cover feel less
clinical. Any color works; the default is white (well, no fill, which prints as
white).

For something behind the text but not the whole sheet — a watermark, a faint
logo, a "SPECIMEN" stamp — use `background`. It takes content and draws it
behind everything else, sized to the full page:

```typ
#set page(
  background: align(center + horizon,
    rotate(-30deg, text(52pt, fill: luma(80%))[*DRAFT*])),
)
```

Reading that from the inside out: some big, light-gray text, rotated thirty
degrees, centered vertically and horizontally in the page box. Because it's the
*background*, your actual document sits on top of it and stays readable.
`foreground` is the mirror image — content drawn *over* the text — for the rarer
case where you want the stamp to sit on top. `examples/24-page-background/`
combines a paper tint with a ghosted DRAFT watermark.

> [!NOTE]
> A watermark built this way repeats on every page, because it's part of the
> page setup. That's usually what you want for a draft stamp. For a mark on one
> page only, scope it — but scoping page settings to a range is a Chapter 21
> topic, once you've met the tools for it.

## What you've got

You can now shape the page itself, not just fill it:

- **Page size** with `paper:` (named) or explicit `width:`/`height:`, and
  **landscape** with `flipped: true`.
- **Margins** as one argument: a single length, an `(x:, y:)` pair, or a full
  per-side dictionary.
- **Headers and footers** as content, with `#h(1fr)` to align pieces left,
  center, and right.
- **Page numbers** via `numbering:` (the `"1"`, `"i"`, `"1 / 1"` patterns) and
  `number-align`, plus `counter(page).display()` inside `context` when you build
  a footer by hand.
- **Columns** for the whole page (`columns: 2`) or a local block
  (`#columns(2)[…]`), with a `#colbreak()` to jump early.
- **Paragraph shape** with `#set par`: `justify`, `leading`, `spacing`,
  `first-line-indent`, and `linebreaks`.
- **Manual spacing and breaks**: `#v`, `#h`, and `#pagebreak()` — hard and
  `weak: true`.
- **Backgrounds**: a `fill` color, and `background:`/`foreground:` for
  watermarks.

That's a properly furnished page. What's still missing is the good stuff you put
*on* it — figures and images come next in Chapter 6, tables in Chapter 7 — and
the deeper machinery behind counters and page-dependent content waits for you in
Chapter 17.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

5.1. Set up a US-letter page with a 3cm left margin and a 2cm right margin (top
and bottom your choice). Fill it with `#lorem(80)` and confirm in the PDF that
the text block sits left of center, hugging the wider margin.

5.2. Give a two-page document a running header that reads your name on the left
and the date on the right, using `#h(1fr)` to separate them. Add a footer that
centers the page number. (Remember: a custom footer means placing the number
yourself.)

5.3. Take three paragraphs of `#lorem` and set them justified, with a
first-line indent of `1.5em` and no blank-line spacing between paragraphs — the
classic novel look. Then switch `first-line-indent` between its plain-length and
`all: true` forms and describe, in one sentence, what changed about the first
paragraph.

5.4. Lay out a page in two columns with a 1.5cm gutter, then add a single
heading at the very top that spans the *full* width above both columns. (Hint:
one of the two column tools leaves the surrounding text alone.)

5.5. *(Stretch.)* Build a one-page "confidential memo" that uses everything:
a tinted page fill, a faint rotated watermark in the background, a header with a
title and a right-aligned classification ("CONFIDENTIAL"), a footer with a
"page 1 / 1" style number, justified body text with tightened leading, and a
`#v` of a couple of centimeters above a signature line at the bottom. Compile it
and adjust until it looks like something you'd be mildly nervous to leave on a
printer.

<!--
SOLUTIONS (notes for the appendix author):
5.1 - #set page(paper: "us-letter", margin: (left: 3cm, right: 2cm, y: 2.5cm))
      then #lorem(80). Point: per-side margin dictionary; the wider left margin
      pushes the block right, so it reads as sitting toward the right / away
      from the left edge. (Note the block hugs the narrower side visually; the
      exercise wording "left of center" — accept reasoning that the wider left
      margin shifts the block rightward. Grade on correct dictionary syntax and
      recognizing asymmetric margins.)
5.2 - #set page(header: [Name #h(1fr) 12 July],
        footer: context [#h(1fr) #counter(page).display() #h(1fr)])
      Key teaching point: because they supply footer:, the automatic page number
      is gone, so counter(page).display() must be placed by hand, wrapped in
      context. Two-page doc via #pagebreak().
5.3 - #set par(justify: true, first-line-indent: 1.5em, spacing: 0em) with the
        default (plain length) NOT indenting the first paragraph after the
        heading; switching to (amount: 1.5em, all: true) DOES indent that first
        paragraph too. One-sentence answer: the first paragraph gains its indent
        under all: true and loses it under the plain-length form. (spacing: 0em
        or a small value collapses inter-paragraph gaps for the novel look.)
5.4 - Use the LOCAL block, not #set page(columns:), so the heading can sit full
        width: = Heading, then #columns(2, gutter: 1.5cm)[#lorem(80)]. The
        page-level columns setting would force the heading into a column; the
        columns() function block confines the two-column flow and leaves the
        heading above it spanning the width.
5.5 - Open-ended. Should combine: page(fill: rgb(...)), background: align(center
        + horizon, rotate(-30deg, text(.., luma(..))[CONFIDENTIAL/DRAFT])),
        header: [Title #h(1fr) CONFIDENTIAL], footer: context [.. counter(page)
        .display("1 / 1", both: true) ..], set par(justify: true, leading:
        smaller), and a #v(2cm) before a signature line. Grade on combining the
        chapter's tools coherently, not on exact aesthetics. Note both: true in
        display gives the "1 / 3" style total-pages form.
-->
