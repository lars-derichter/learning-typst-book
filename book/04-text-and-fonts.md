# Text and fonts

Everything you have typeset so far arrived in the same clothes: Libertinus
Serif, eleven points, black on white, set ragged along the right edge. You never
chose any of it. Typst did, the moment you started typing, because a document
has to look like *something*, and those are sensible defaults.

This chapter is about changing them — every visible property of type, from the
whole typeface down to whether the digit 7 sits on the baseline or dips below
it. It's the first chapter where you stop describing *what things are* and start
deciding *how they look*.

## Styling text: the `text` function

One function controls the appearance of type, and it is called `text`. You have
been using it all along without naming it; it's the thing Typst wraps around
every character on the page. Call it explicitly to restyle a stretch of words:

```typ
The word #text(fill: red)[danger] stands out.
```

`#text(...)` takes named arguments — the properties you want to change — and a
chunk of content in square brackets. Everything in the brackets gets those
properties; everything outside keeps the defaults.

That's fine for one word. For a whole document you don't want to wrap every
paragraph by hand. Instead you set the property once, as a *set rule*:

```typ
#set text(font: "New Computer Modern", size: 12pt)
```

A set rule changes a default for everything after it. Put that line at the
top of your file and the entire document switches to twelve-point New Computer
Modern; put it halfway down and only the second half changes. Set rules are one
of the two big ideas that turn Typst from a markup language into a styling
engine, and [Chapter 9](09-set-rules.md) gives them the full treatment. For
now the shape is all you need: `#set text(...)` means "from here on,"
`#text(...)[...]` means
"just this."

Almost everything in the rest of this chapter is an argument to that one
function. Learn the arguments and you have learned text styling.

## Choosing a typeface

The `font` argument takes the name of a font family, as a string:

```typ
#set text(font: "Libertinus Serif")
```

To find out which names are legal on your machine, ask Typst:

```sh
typst fonts
```

It prints every font family it can see — the ones bundled with Typst plus every
one installed on your system. That list is where the trouble starts, so let's
talk about reproducibility before you fall for a font you'll later regret.

### Bundled fonts, and why to prefer them

Typst ships with a handful of fonts baked into the program itself. On any
machine, in any browser, with nothing installed, these are always present and
always render identically:

- **Libertinus Serif** — the default, a warm and readable book serif.
- **New Computer Modern** — the classic look of LaTeX, for when you want a
  document to *read* as academic.
- **New Computer Modern Math** — its partner for equations (Chapter 8).
- **DejaVu Sans Mono** — a monospace face for code and anything that needs
  fixed-width columns.

Notice what's missing: a general-purpose sans-serif. Typst bundles no
Helvetica-alike. If you want clean sans type, you're reaching for a system font
— and that's exactly where "it looked fine on my laptop" goes to die.

When you name a font Typst can't find, it doesn't stop. It prints a warning —

```text
warning: unknown font family: helvetica
```

— falls back to a font it *does* have, and carries on. Your document still
compiles, but it no longer looks the way you wrote it, and on a colleague's
machine it may look different again. Every example in this book sticks to the
bundled fonts for that reason: they render the same everywhere and they never
warn. If you're writing something that has to travel — a template for two
hundred students, a paper for a co-author — do the same. If you're the only
person who will ever compile the file and you have Garamond installed, name
Garamond and enjoy it.

> **Coming from LaTeX.** Remember the ritual: `\usepackage{fontspec}`, switching
> to XeLaTeX or LuaLaTeX, `\setmainfont{...}`, and a separate spell for the
> math font. In Typst, choosing a font is one line — `#set text(font: "...")` —
> with no package, no engine flag, and no preamble. The font is just another
> property.

### Fallback lists and missing glyphs

You can hand `font` a *list* of families instead of one, in parentheses:

```typ
#set text(font: ("Libertinus Serif", "DejaVu Sans Mono"))
```

Typst reads that as an order of preference. For each glyph it tries the first
family; if that family has no glyph for the character — an obscure symbol, say,
or a script the font never covered — it moves to the next, and the next, until
something can draw it. This is how a mostly-Latin document can hold a stray
mathematical arrow or a single Chinese character without you lifting a finger:
the first font handles the ordinary letters, and a later font quietly supplies
the rest. Behind your list Typst keeps its own last-resort fonts, so a glyph is
almost never simply lost.

`examples/012-fonts-and-families/` sets one sentence in each of three bundled
faces so you can compare them side by side, and shows the list syntax at work.

## Size, weight, and style

Three arguments cover most of what you'll adjust from one day to the next.

**Size** is `size`, in points or in ems:

```typ
#text(size: 8pt)[fine print] and #text(size: 18pt)[a big word]
```

A point (`pt`) is an absolute unit — 72 to the inch, the currency of type since
the days of metal. An **em** is relative: `1em` is the current font size, so
`1.5em` is half again as large as whatever surrounds it. Ems are the better
choice inside anything reusable, because they scale with the context instead of
nailing themselves to one fixed size.

**Weight** is `weight`, given as a number from 100 to 900 in steps of 100, or as
a name:

```typ
#text(weight: "bold")[heavy] and #text(weight: 300)[light]
```

400 is "regular" and 700 is "bold"; the names ("regular", "medium", "bold", and
a few more) are just aliases for the round numbers. One catch: a font can only
give you the weights it actually ships. Libertinus Serif has a regular and a
bold and little in between, so asking for 300 gets you the nearest weight it
owns, not a true light cut. A font with nine real weights will honour all nine.

**Style** is `style`, one of `"normal"`, `"italic"`, or `"oblique"`. Italic is
the separate cursive design a type designer drew; oblique is a mechanical slant
of the upright. Most serif fonts give you a real italic, so asking for oblique
usually lands you on the italic anyway.

`examples/013-size-weight-style/` lays all three axes out in a row. And recall
from Chapter 3 that `*strong*` and `_emph_` are markup shortcuts for bold and
italic — you don't need the long form for ordinary writing.

## Color

Text color is the `fill` argument — "fill" because you're filling the letter
shapes with a color, the same word Typst uses for shapes and backgrounds. Four
ways of naming a color come up constantly:

```typ
#text(fill: rgb("#1a7f37"))[a hex green]
#text(fill: red)[a named color]
#text(fill: luma(40%))[a gray]
#text(fill: cmyk(75%, 0%, 70%, 5%))[a print green]
```

- `rgb("#rrggbb")` takes a hex string — the same one you'd paste out of a color
  picker or a website's style guide.
- Named colors (`red`, `blue`, `green`, `orange`, `purple`, `navy`, and a couple
  dozen more) are there for quick work and rough drafts.
- `luma(...)` is grayscale in a single number: `luma(0%)` is black, `luma(100%)`
  is white, and everything between is a gray. Handy for setting text a notch
  softer than dead black.
- `cmyk(...)` names a color by its cyan, magenta, yellow, and black percentages,
  the way a printer thinks. If your document is going to a professional press, a
  CMYK fill lands more predictably than RGB; for anything headed to a screen or
  an ordinary PDF, `rgb` is the friendlier choice.

## Decorations

A small cluster of functions draw lines on, through, or behind text, or reshape
it outright. Each takes its content in brackets:

```typ
#underline[underlined] #overline[overlined] #strike[struck out]
#highlight[highlighted] #smallcaps[Small Capitals]
```

- `#underline`, `#overline`, and `#strike` draw a line under, over, and through
  their content.
- `#highlight` lays a colored band behind the text, like a marker pen; it
  defaults to a soft yellow.
- `#smallcaps` sets lowercase letters as small capitals — capital letterforms at
  roughly the height of a lowercase x — the classic way to typeset an acronym
  or a name without shouting.

Each of these is a real function with its own options.
`#highlight(fill: rgb("#fff3b0"))[...]` recolors the band, and
`#underline(stroke: 1.5pt + red, offset: 3pt)[...]` thickens the rule and
drops it lower. You rarely need the options, but they're there when a house
style demands them. `examples/014-color-and-decorations/` collects the lot.

> **Coming from Word.** The highlighter button and the font-color dropdown you
> know from the toolbar are `#highlight[...]` and `#text(fill: ...)[...]` here.
> The difference is that in Typst you define the color once, in a set rule, and
> every highlight across a hundred pages matches it — no hunting for the exact
> same yellow in a swatch grid each time.

## Figures, ligatures, and other OpenType niceties

Good fonts carry more than one shape for some characters, and Typst lets you
choose between them. The most useful choices are about numbers.

### Lining vs old-style figures

By default, digits are **lining figures**: all one height, sitting on the
baseline like capitals — 0123456789. That's what you want in a table or a
heading.

Set `number-type: "old-style"` and you get **old-style figures**, which rise and
fall like lowercase letters, some of them dipping a little descender below the
baseline. They look at home in running prose, where a lining figure sticks out
like a tourist:

```typ
Founded in #text(number-type: "old-style")[1789].
```

### Tabular vs proportional figures

The other choice is width, set with `number-width`. **Proportional** figures are
individually spaced — a 1 is narrower than an 8 — which reads naturally in a
sentence. **Tabular** figures are all forced to one width, so numbers stacked in
a column line up digit for digit, ones under ones, without a ragged edge. You
want tabular in tables and anywhere numbers must align; proportional everywhere
else.

```typ
#text(number-width: "tabular")[1,111]
```

`examples/015-figures-and-numbers/` shows both figure styles and a small table
where the tabular column lines up cleanly and, for contrast, a proportional one
that doesn't.

### Ligatures and features

When two letters would collide — the f and the i, whose hook and dot fight for
the same sliver of space — a good font supplies a single combined glyph called a
**ligature**, and Typst uses them automatically. Usually that's exactly what you
want. Now and then, in a technical context, you'd rather see the raw letters;
`#text(ligatures: false)[...]` turns them off.

Beyond these named options, a font may carry any number of **OpenType features**
— alternate letterforms, swashes, whole stylistic sets — reached through the
`features` argument by their four-letter tags, as in `features: ("ss01",)`. It's
a specialist's door; most people never open it, and the fonts bundled with Typst
keep it modest. Just know that `features` exists, and read the font's own
documentation on the rare day you need it.

### Letter tracking

To add or remove space *between* letters — for a title, an acronym, or a run of
small caps that reads too tight — set `tracking`, in ems:

```typ
#text(tracking: 0.15em)[S P A C E D]
```

Positive values open the text up; negative values pull it in. A touch of
tracking on small caps or all-caps text is a classic typographic move; a lot of
it on body text is a classic mistake.

> [!NOTE]
> `tracking` is space between *letters*. Space between *words*, between *lines*,
> and between *paragraphs* is a matter of layout, not text, and lives on `par`
> and `page` — `#set par(...)` and friends — which is Chapter 5's business.

## Language and hyphenation

Two arguments tell Typst what language your text is written in:

```typ
#set text(lang: "en", region: "US")
```

`lang` is a two-letter language code; `region` is an optional two-letter country
code. Together they set more than metadata. They decide which **hyphenation
patterns** Typst uses to break long words at the margin — English words break in
different places than German ones — and which style of **quotation mark** your
straight `"..."` curls into. Set `lang: "de"` and the same typed quotes come out
as German low-and-high marks; set `lang: "fr"` and you get guillemets. You met
smart quotes back in Chapter 3; this is the knob that decides *which* smart
quotes.

Hyphenation itself is `hyphenate`. Left at its default of `auto`, Typst
hyphenates only when a paragraph is justified — which is the sensible time to,
since justification opens the ugly gaps that hyphenation exists to close.
Force it on with `hyphenate: true` or off with `hyphenate: false`:

```typ
#set text(hyphenate: false)
```

`examples/017-language-and-hyphenation/` sets a deliberately narrow, justified
column both ways so you can watch hyphenation earn its keep: with it on, word
spacing stays even; with it off, the same lines have to stretch to fill the
width, and the gaps yawn.

> [!TIP]
> Always set `lang` on a document, even an English one. It's the difference
> between correct hyphenation and none, and between real quotation marks and a
> guess. It costs one line and it's the most under-used setting in Typst.

## What you've got

You can now reach every visible property of type:

- **The `text` function** — `#text(...)[span]` for a stretch, `#set text(...)`
  for everything after — as the single home of text styling.
- **Typefaces** with `font`, fallback lists with `font: ("A", "B")`, and the
  discipline of sticking to Typst's **bundled fonts** (Libertinus Serif, New
  Computer Modern, DejaVu Sans Mono) so documents render the same everywhere and
  never warn.
- **Size** in `pt` and `em`, **weight** from 100–900 or by name, and **style**
  — normal, italic, oblique.
- **Color** through `fill`: `rgb`, named colors, `luma` grays, and `cmyk` for
  print.
- **Decorations**: underline, overline, strike, highlight, small caps, and their
  options.
- **Figures**: lining vs old-style, tabular vs proportional, plus ligatures, a
  glance at OpenType `features`, and letter `tracking`.
- **Language** with `lang`/`region` driving quotes and hyphenation, and
  `hyphenate` for the final say.

Between this chapter and the markup of Chapter 3, you can write a document and
dress it exactly as you like. What you can't do yet is style the *page* it sits
on — its size, its margins, its columns, and the spacing between lines and
paragraphs. That's Chapter 5.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

4.1. Set a whole document to twelve-point New Computer Modern with a single set
rule, then make a single word eighteen-point and bold using `#text`. Compile
it and confirm that only that one word changed.

4.2. Run `typst fonts` and read the list. Pick a family that is *not* one of
Typst's bundled fonts, set your document to it, and compile. Note the warning
Typst prints and what the text falls back to. Then switch to a bundled font and
confirm the warning disappears. (The point is to feel the reproducibility trap
once, on purpose, so you recognize it later.)

4.3. Typeset a line of chemistry and a line of physics: water and carbon dioxide
with subscripts, and E = mc² with a superscript. Then set a country's name in
small capitals.

4.4. Make two stacked lines (or a two-column table) of the numbers 1,024, 512,
and 64. Give one version tabular figures and the other proportional, right-align
both, and write one sentence on what's different about how the digits line up.

4.5. *(Stretch.)* Drop `#lorem(60)` into a narrow justified column, about seven
centimetres wide. Set its language to French and compile, noting where French
hyphenation and quotation marks differ from English. Then turn hyphenation off
and compare the word spacing. Which do you prefer for that column, and why?

<!--
SOLUTIONS (notes for the appendix author):
4.1 - #set text(font: "New Computer Modern", size: 12pt) at the top, then e.g.
      "the #text(size: 18pt, weight: "bold")[important] word". Point: a set rule
      changes the whole document; a #text() call overrides just its span. Only
      the wrapped word should differ; everything else stays 12pt regular.
4.2 - Any non-bundled family works (Helvetica, Times New Roman, Arial, Comic
      Sans...). Expected: `warning: unknown font family: <name>` and the text
      rendered in the fallback (Libertinus Serif). Switching to a bundled family
      (Libertinus Serif / New Computer Modern / DejaVu Sans Mono) removes the
      warning. Lesson: named-but-missing fonts compile but aren't reproducible.
4.3 - Water: H#sub[2]O. Carbon dioxide: CO#sub[2]. Physics: E = mc#super[2]
      (the ² can be typed as #super[2] or as the literal character). Small caps:
      #smallcaps[Belgium] (any country name). Mirrors example 016.
4.4 - Right-aligned tabular figures line up digit-for-digit in a neat column
      (equal digit widths); proportional figures give a ragged look because a 1
      is narrower than other digits, so the columns of digits don't align even
      when the numbers are right-aligned. Use number-width: "tabular" vs
      "proportional". Mirrors example 015.
4.5 - #set page(width: 7cm); #set par(justify: true); #set text(lang: "fr").
      French uses guillemets and its own hyphenation patterns, so line
      breaks fall in different places than English. With hyphenate: false the
      justified lines stretch, opening larger word gaps. No single right
      preference; credit a coherent "why" tied to even spacing vs. broken words.
      Mirrors example 017.
-->
