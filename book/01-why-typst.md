# Why Typst?

Here is a small file. Six lines, no ceremony:

```typ
= Hello, Typst
Typesetting used to mean wrestling with your software. Not here. You write
plain text with a little markup, and Typst turns it into a properly typeset
page — real ligatures, automatic hyphenation, and micro-typography you never
had to ask for.
```

Feed it to Typst and, in the time it takes to blink, you get a PDF: a crisp
heading, a neat paragraph, proper typography, the works. No document class
to choose. No preamble to copy from a forum post you half understand. No
"package `float` not found." You wrote content; you got a document.

That gap — between how much you wrote and how much you got — is the reason this
book exists. Let's talk about why it's so wide.

## What Typst actually is

Typst is a **typesetting system**. That word is worth unpacking, because it's
the whole game.

A word processor like Microsoft Word or Google Docs is a *what-you-see-is-what-
you-get* editor. You manipulate the document's appearance directly, by clicking
and dragging, and the file stores a tangle of content and formatting fused
together. It's wonderful for a two-page letter and increasingly hostile as your
document grows.

A typesetting system takes a different deal. You write your content as plain
text, marked up to describe its *structure* — "this is a heading," "this word is
emphasized," "here is a list" — and you describe the *appearance* separately, as
rules. Then a program reads both and does the fussy work of arranging ink on the
page: line breaking, hyphenation, spacing, page breaks, keeping figures near
their captions. You say *what*; the system figures out *where*.

This is the model LaTeX has used to typeset scientific literature for four
decades. Typst uses it too. The difference is roughly forty years of hindsight.

> [!NOTE]
> "Typesetting" is an old printing word. It once meant physically arranging
> metal type in a frame. The craft survived the metal; the software that does
> it now inherited both the name and the exacting standards.

## A little history

Typst is young. It grew out of the work of two graduate students, Laurenz Mädje
and Martin Haug, at the Technical University of Berlin, who had done enough
LaTeX to know exactly what hurt. Their theses turned into a real system, written
from scratch in the Rust programming language, and in 2023 it went public and
open source.

Two design decisions from that origin shape everything you'll experience:

- **It's fast.** Typst was built around *incremental compilation* — when you
  change one line, it recomputes only what that line affects. In practice the
  preview updates as fast as you can type. Compare this to LaTeX, where a big
  document can take a coffee break to build, and the difference in how you
  *work* is profound. Fast feedback changes learning from "guess, wait,
  despair" to "try, see, adjust."
- **It's designed, not accreted.** LaTeX is a set of macros piled on top of TeX,
  Donald Knuth's original 1978 engine, with layer upon layer added by thousands
  of hands over decades. It's magnificent and it's a sediment. Typst was
  designed as one coherent thing, with a single consistent language for content,
  styling, and scripting. There's a lot less to hold in your head.

> [!TIP]
> You don't have to install anything to try Typst. There's a web app at
> [typst.app](https://typst.app) with a live preview, a bit like Google Docs
> crossed with a code editor. We'll set up both the web app and the command-line
> version in Chapter 2. For now, you can follow along just by reading.

## Markup meets code

Most of what you write in Typst is *markup*: lightweight symbols that mean
"heading" or "emphasis" or "list item." If you've written Markdown, it will feel
familiar. A `=` starts a heading. Asterisks around a word make it `*bold*`.
Hyphens make a bullet list. That's Example 01 in the book's repository
([`examples/01-hello-typesetting/`](../examples/01-hello-typesetting/)), and it
renders exactly what you'd hope:

> **Hello, Typst** — a bold heading over a cleanly set paragraph and a tidy
> bullet list, all from plain text.

But here's where Typst leaves ordinary markup behind. Underneath the friendly
surface sits a real programming language, and you can drop into it any time you
like by typing `#`. Watch what that buys you
([`examples/02-markup-meets-code/`](../examples/02-markup-meets-code/)):

```typ
= Powers of two
This list wasn't typed out by hand — a loop generated it:

#for n in range(1, 11) [
  / $2^#n$: #calc.pow(2, n)
]
```

That `#for` runs a loop right inside your document. Each pass produces one line
of a list, computing `2` to the power of `n` as it goes. The result is a clean
table of the powers of two from 2 up to 1024 — and if you changed the `11` to
`101`, you'd get a hundred rows without touching the list itself.

Stop and appreciate how strange and wonderful that is. Your document is also a
*program that writes the document*. Need a multiplication table, a calendar, a
chart labeled from a data file, a hundred certificates with a hundred different
names? You don't do it by hand. You describe it once and let the machine
elaborate. Part IV of this book teaches that language properly, from the ground
up. For now, just file away the headline: **in Typst, content and computation
live in the same file.**

> [!NOTE]
> Don't worry about the `$2^#n$` yet — the dollar signs mean "this is math," and
> Typst's math typesetting is so good it gets its own chapter (Chapter 8). The
> point here is only that markup, math, and code all mix freely.

## How Typst compares

You almost certainly arrived here from another tool. Here's an honest map of the
neighborhood.

### Versus word processors (Word, Google Docs, Pages)

Word processors are direct-manipulation editors, and for short, simple documents
that's exactly right — nobody should write a birthday-party invitation in Typst.
The trouble starts as documents grow. Formatting and content are welded
together, so a consistent change ("make every figure caption smaller") means
hunting through the whole file by hand. Long documents reflow unpredictably. The
files are opaque binaries, so you can't meaningfully track changes in tools like
Git, and "track changes" inside the app is a poor substitute.

Typst inverts all of that. Your source is plain text, so it's diffable,
searchable, and scriptable. Styling is centralized in rules, so one change
propagates everywhere. And because layout is computed from your structure, a
hundred-page document behaves as predictably as a one-page one.

> **Coming from Word.** The mental shift is this: you stop *formatting* and
> start *labeling*. Instead of selecting a line and clicking a bigger font,
> you mark it as a heading and decide, once, in one place, what headings look
> like. It feels like more work for the first ten minutes and less work forever
> after.

### Versus LaTeX

This is the close comparison, because Typst and LaTeX aim at the same target:
beautiful, structured, automated documents, especially ones full of mathematics.
If you know LaTeX, you already believe in the plain-text approach; the question
is only whether to switch.

What Typst gives you over LaTeX: near-instant compilation and preview; a syntax
you can read without wincing; error messages written for humans; and one unified
scripting language instead of TeX's notorious macro system, where defining a
function can feel like performing surgery with oven mitts.

What LaTeX still gives you over Typst: forty years of accumulated packages for
every niche imaginable, and its status as the *lingua franca* of academic
publishing — many journals still want LaTeX, full stop. Typst's ecosystem is
younger and smaller, though it's growing quickly and already covers the common
cases well (Chapter 20).

> **Coming from LaTeX.** The single biggest relief is the feedback loop. Save,
> and the preview is already updated — no build, no wait, no scrolling through a
> log to find the one real error among forty warnings. It changes how you work
> more than any syntax difference.

### Versus Markdown

Markdown and Typst look like cousins, and their basic markup really is similar.
But Markdown was designed to be converted *into* something else — usually HTML —
and it deliberately stops at simple structure. It has no opinion about page
size, no real story for fine typography, no standard for typesetting an
equation, no way to compute part of your document. It's a lovely notation for
content and nothing more, by design.

Typst is a Markdown-like *input* wired to a full typesetting engine and a
programming language *behind* it. You get the readability of Markdown and the
power of LaTeX in one place. And the two worlds aren't even enemies: in
Chapter 24 we build a pipeline that converts Markdown *to* Typst, which is
exactly how this book turns its own Markdown chapters into a printed PDF.

### Versus InDesign and friends

Page-layout software like Adobe InDesign is built for *visual*, manual design —
magazines, posters, packaging — where a human places every element for effect.
That's a different craft from what Typst does. Typst shines on *structured,
content-driven* documents where consistency and automation matter more than
hand-tuned art direction: books, papers, reports, theses, documentation. Use the
right tool. This book is about the second kind.

## What you'll be able to do

By the time you reach the last page, you'll be able to:

- Write essays, reports, and letters that look professionally typeset, from
  plain text, in minutes.
- Typeset serious mathematics without tears (Chapter 8).
- Manage citations and produce a correct APA bibliography (Chapter 12).
- Build tables that would make a spreadsheet jealous (Chapter 7).
- Write your own functions to automate repetitive layout (Chapters 14 and 18).
- Package your styles into a reusable template and share it (Chapters 19, 20).
- Assemble a full book — chapters, table of contents, index, the lot — and
  typeset it from Markdown (Part VI).

That last one isn't a hypothetical. It's this book. The thing you're reading was
built with the very techniques it teaches, and the final chapters walk you
through exactly how.

## What you've got

You now know:

- **What Typst is** — a typesetting system that turns marked-up plain text into
  beautifully laid-out PDFs, in the LaTeX tradition but built fresh.
- **Where it came from** — a young, Rust-based, open-source project designed for
  speed and coherence.
- **Its central idea** — markup and a real programming language in the same
  file, so documents can compute themselves.
- **How it stacks up** against word processors, LaTeX, Markdown, and layout
  software, and when each is the right call.

That's the pitch. The rest of the book is the delivery. Next up: getting Typst
running on your own machine (or in your browser) and compiling your first
document with your own hands.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

1.1. In your own words, what's the difference between how a word processor and a
typesetting system treat the *content* and the *appearance* of a document? Why
does that difference matter more as a document gets longer?

1.2. Name a document type for which a word processor is genuinely the better
tool than Typst, and say why. (Being able to see the other side is a sign you
understand the trade-off.)

1.3. Look again at the powers-of-two example. Without running anything, predict
what you'd get if you changed `range(1, 11)` to `range(1, 4)`. Then, once you've
installed Typst in the next chapter, check yourself.

1.4. *(Stretch.)* Skim the [Typst reference documentation](https://typst.app/docs/reference/)
for two minutes — just the landing page and one link that catches your eye. You
won't understand most of it yet, and that's fine. The goal is only to see the
shape of the territory before we start walking it.

<!--
SOLUTIONS (notes for the appendix author):
1.1 - Word processor fuses content and appearance in one binary file, edited by
      direct manipulation; a typesetting system keeps content (marked-up plain
      text) separate from appearance (rules), and computes layout from structure.
      Matters more as length grows because centralized rules mean one change
      propagates everywhere, layout stays predictable, and text stays diffable.
1.2 - Acceptable answers: a quick one-page letter/invitation; a document a
      non-technical collaborator must edit live; anything needing real-time
      co-editing with comments (though Typst's web app narrows this). Key is a
      coherent "why": short/simple/collaborative-WYSIWYG favors a word processor.
1.3 - range(1, 4) yields n = 1, 2, 3, so three rows: 2^1=2, 2^2=4, 2^3=8. (range
      is half-open: it stops before the second number.) Good moment to foreshadow
      Chapter 15/16 on ranges.
1.4 - No single right answer; credit for actually looking. The reference is
      organized by category (text, layout, math, etc.) — noticing that structure
      is the win.
-->
