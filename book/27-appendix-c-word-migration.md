# Appendix C · From Word to Typst

You know how to make a document look right in Word. You select a line, click a
bigger font, maybe bold it, nudge the spacing until it sits well. Typst asks you
to unlearn that reflex — not the goal, just the reflex — and the payoff is a
document that stays consistent no matter how long it grows.

This appendix is a translation table. It maps the Word way of working (menus,
dialogs, toolbar buttons) onto the Typst way (markup and rules), and points you
at the chapter where each idea gets the full treatment. It assumes you're
coming from Microsoft Word or Google Docs, not from LaTeX or any programming
language. If a snippet looks alien, that's fine — the chapter it points to
starts from zero.

## The one shift that explains all the others

In Word you apply formatting *directly*. You select some text and act on the
selection: this word becomes bold, this line becomes 18-point, this paragraph
becomes centered. The formatting lives on the characters. Change your mind about
what headings should look like, and you go find every heading and re-do it by
hand — or you fight the Styles gallery, which is Word quietly admitting that
direct formatting doesn't scale.

In Typst you *label structure* and *style it once*. You mark a line as a heading
(`= Introduction`) without saying anything about how it looks. Then, separately,
you write one rule that decides what every heading looks like. Change the rule,
and all headings change together. The two jobs — saying what something *is* and
deciding how it *looks* — are pulled apart and done in different places.

Those rules come in two kinds, and together they are the heart of the whole
system:

- A **set rule** adjusts an element's built-in settings — the font of all text,
  the numbering of all headings, the margins of every page (Chapter 9).
- A **show rule** rebuilds an element's whole appearance, or applies a set rule
  to only *some* elements. This is the workshop where the fancy looks get built
  (Chapter 10).

Word's Styles gallery is the closest thing it has to this idea; a Typst
template (Chapter 19) is the same instinct taken all the way, packing every rule
for a document's look into one reusable function.

Here is the shift in miniature — structure labeled, appearance decided once:

```typ
#set text(font: "Libertinus Serif", size: 11pt)
#set heading(numbering: "1.")
#show heading: set text(fill: navy)

= Introduction
This has *strong*, _emphasized_, #underline[underlined], and
#strike[struck] text, plus #highlight[a highlight].
```

Nothing in the body says "make Introduction navy and numbered." The three rules
at the top do, and they'd do it for a hundred headings just as happily as one.

> **Coming from Word.** The first ten minutes feel like more work: you're typing
> `= Introduction` instead of clicking a style. The reward comes at minute
> eleven and every minute after, when one edit re-styles the entire document and
> nothing drifts out of sync. Word makes the easy thing easy and the consistent
> thing hard. Typst makes the opposite trade.

## How do I do X? — the quick reference

Read this as "the thing you'd click in Word" on the left, "the thing you'd type
in Typst" on the right, and where to learn it on the far side. In the Typst
column, `*...*` and `_..._` are markup you type inline; anything starting with
`#` is a function call.

| In Word | In Typst | Where |
| --- | --- | --- |
| Select text, click **B** | `*strong text*` | Ch 3 |
| Select text, click *I* | `_emphasized text_` | Ch 3 |
| Underline button | `#underline[text]` | Ch 4 |
| Strikethrough button | `#strike[text]` | Ch 4 |
| Highlighter button | `#highlight[text]` | Ch 4 |
| Font / size / color pickers | `#text(font: "New Computer Modern", size: 12pt, fill: red)[...]` — or set once with `#set text(...)` | Ch 4 |
| Styles gallery: Heading 1 / 2 / 3 | `=`, `==`, `===` | Ch 3 |
| Bulleted list | `- item` on each line | Ch 3 |
| Numbered list | `+ item` on each line | Ch 3 |
| Align left / center / right | `#align(center)[...]` | Ch 5 |
| Justify | `#set par(justify: true)` | Ch 5 |
| Navigation pane (heading tree) | `#outline()` | Ch 11 |
| Page Setup: size & margins | `#set page(paper: "a4", margin: 2.5cm)` | Ch 5 |
| Page Setup: orientation | `#set page(flipped: true)` | Ch 5 |
| Page Setup: columns | `#set page(columns: 2)` | Ch 5 |
| Insert > Header / Footer | `#set page(header: [...], footer: [...])` | Ch 5 |
| Insert > Page Number | `#set page(numbering: "1")` | Ch 5 |
| Insert > Table | `#table(columns: 3, ...)` | Ch 7 |
| Insert > Picture | `#image("photo.jpg")` | Ch 6 |
| Insert > Caption | `#figure(..., caption: [...])` | Ch 6 |
| Insert > Table of Contents | `#outline()` | Ch 11 |
| Insert > Cross-reference | a `<label>`, then `@label` | Ch 11 |
| Insert > Equation | `$ a^2 + b^2 = c^2 $` | Ch 8 |
| Find & Replace on formatting | a `#show` rule (string or `regex(...)`) | Ch 10 |
| Save As template (`.dotx`) | a template function | Ch 19 |
| Mail merge | a `#for` loop over your data | Ch 15 |
| Track Changes / version history | a plain-text file under git | below |

The rest of this appendix expands the rows that deserve more than a cell.

## Page setup

Word's Page Setup dialog — size, margins, orientation, columns — is a single
Typst function, `page`, usually applied as a set rule so it governs the whole
document (Chapter 5):

```typ
#set page(paper: "a4", margin: 2.5cm, columns: 2)
```

`flipped: true` turns any paper size to landscape. Margins can be one value for
all four sides or a dictionary like `margin: (top: 3cm, rest: 2cm)`. Because
it's a rule and not a one-time dialog, you can also *change* the page part-way
through a document — a landscape spread for one wide table, then back — which
Word makes you insert section breaks to achieve.

## Headers, footers, and page numbers

In Word these hide behind the Insert menu and a double-click into the page
margin. In Typst they're just more arguments to `page` (Chapter 5):

```typ
#set page(
  paper: "a4",
  header: align(right)[Learning Typst],
  numbering: "1",
)
```

`numbering: "1"` puts plain page numbers in the footer for you; `"1 / 1"` gives
"page of total", and `"i"` gives lowercase roman numerals. Whatever content you
put in `header:` or `footer:` repeats on every page.

## Tables and pictures

Insert > Table becomes the `table` function, which takes the number of columns
and then the cells in reading order (Chapter 7):

```typ
#table(
  columns: 3,
  table.header([Name], [Role], [Room]),
  [Ada],   [Analyst],  [B12],
  [Grace], [Compiler], [C04],
)
```

Insert > Picture is `image("photo.jpg")` (Chapter 6). On its own an image is
just an image; wrap it in a `figure` and it gains a numbered caption, floats to
a tidy spot on the page, and — with a label — becomes something you can refer
to from anywhere:

```typ
See @sales for the numbers.

#figure(
  image("chart.png", width: 8cm),
  caption: [Quarterly sales],
) <sales>
```

That `<sales>` is a label, and `@sales` is a reference to it (Chapter 11). Typst
fills in "Figure 1" and keeps the number correct even if you add three figures
before it — the cross-reference maintenance Word's Insert > Cross-reference
promises and doesn't always keep.

## Tables of contents and cross-references

Insert > Table of Contents is one line, `#outline()`, and it reads your `=`
headings automatically (Chapter 11). The same `<label>` / `@label` mechanism
from the figure above works for headings, equations, and anything else you can
tag, so "see Section 3" and "see Figure 4" stay right without a manual "Update
Field."

## Equations

Word's equation editor becomes dollar signs. Inline math sits in the flow of a
sentence; put spaces inside the dollars and it becomes a centered display
equation (Chapter 8):

```typ
Inline $E = m c^2$, and displayed on its own line:
$ a^2 + b^2 = c^2 $
```

The syntax is close to what you'd say out loud — `a^2` for a superscript,
`sqrt(x)` for a root — and it's the part of Typst that most often makes ex-Word
users wonder why they suffered so long.

## Find & Replace for formatting

Word can find and replace text. Finding and replacing *formatting* — "make every
'TODO' red and bold" — is clumsier, and it's a one-shot edit that doesn't stick
to new text you type later. A show rule does it as a standing instruction
(Chapter 10):

```typ
#show "TODO": set text(fill: red, weight: "bold")
#show regex("\d{4}"): set text(fill: blue)

TODO revisit the 2026 projection.
```

Every `TODO` in the document turns red and bold, every four-digit number turns
blue, and both keep working as you add more text. The `regex(...)` form matches
patterns, not just literal strings — the power-user corner of Word's Find that
almost nobody finds.

## Templates

A Word `.dotx` template bundles styles, page setup, and boilerplate so new
documents start from a house look. The Typst equivalent is a function that takes
your content, wraps it in every rule you'd otherwise retype, and hands it back
dressed (Chapter 19):

```typ
#let report(title: none, body) = {
  set page(paper: "a4", margin: 2.5cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)
  show heading: set text(fill: navy)
  align(center)[#text(size: 20pt, weight: "bold")[#title]]
  body
}

#show: report.with(title: "Field Notes")

= Introduction
Everything below is styled by the template.
```

The `#show: report.with(...)` line feeds the whole rest of the document through
`report`. Move that function into its own file (or publish it as a package,
Chapter 20) and every document that imports it shares one look — change the
function once, and they all update.

## Mail merge, i.e. a hundred certificates

Word's mail merge stitches a letter template to a spreadsheet of names. Typst
does the same thing with a loop, and you can see exactly what it's doing because
it's right there in your file (Chapter 15; the data-wrangling side is
Chapter 16):

```typ
#let names = ("Ada Lovelace", "Grace Hopper", "Alan Turing")

#for name in names [
  #align(center + horizon)[
    #text(size: 20pt)[Certificate of Completion] \
    awarded to #text(weight: "bold")[#name]
  ]
  #pagebreak(weak: true)
]
```

Three names, three certificates, one page each. Swap the list for a hundred
names read from a CSV file and you get a hundred certificates, no wizard, no
merge fields, no praying the preview matches the print.

## Track Changes and version history

This one isn't a feature swap; it's a change of medium, and it's the quiet
superpower of working in plain text. A Typst document is just text in a file, so
the entire toolkit that programmers use to track changes to text works on your
document too. The standard tool is **git**: it records every version you save,
shows you exactly what changed between any two (line by line, in color), lets
you label good versions, branch off to try something risky, and merge two
people's edits.

That covers what Track Changes and Word's version history do, and then some —
with one difference worth setting expectations on. Git compares *lines of your
source*, not the rendered page, so it shines when edits are text and is blunter
about a reshuffled layout. For prose and structure, which is most of what you
write, it's a genuine upgrade: nothing is ever silently lost, and "what did I
change last Tuesday?" has an exact answer. Git is a book of its own; for now,
just file away that your documents are now the kind of thing it can look after.

## What Word still does better

Switching tools honestly means naming what you give up. Word and Google Docs
still win at a few things, and Chapter 1 already conceded the big one:

- **Real-time co-editing with non-technical people.** Two colleagues editing the
  same Google Doc, cursors dancing, is a workflow Typst's collaboration story
  doesn't fully match — especially when a co-author would rather quit than see a
  curly brace.
- **Quick, throwaway, one-page documents.** A birthday-party flyer or a note for
  the fridge does not want a compiler. Open Word, type, print, forget. Reaching
  for Typst here is using a lathe to sharpen a pencil.
- **Comment threads and suggestions.** The margin conversation — "can we cut
  this?", resolved and archived — is smoother in a word processor than in text
  files, even with git in the mix.

The rule of thumb from Chapter 1 holds: short, simple, or live-collaborative
leans Word; long, structured, consistent, or automated leans Typst. Pick the
tool the document actually needs.

---

Coming from LaTeX instead? See Appendix B. For a one-page syntax crib you can
keep open while you work, see Appendix D.
