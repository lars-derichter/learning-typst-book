# Your own functions

You wrote a `callout` in Chapter 14. It was good. You used it, liked it, and
moved on. Two weeks later you start a new document — a different report, a
different folder — and you want that same callout. So you open the old file,
scroll past three hundred lines of prose to find it, copy the twelve lines of
the definition, paste them into the top of the new file, and carry on.

Do that four times and you have four copies of `callout` in four documents. Then
you improve one of them — a nicer colour, a bit more padding — and now you have
three documents that are subtly wrong and one that's right, and no way to tell
which is which without reading all four.

This is the moment a function wants to leave home. Chapter 14 taught you to
*write* functions; this chapter is about where to *keep* them. The answer is a
file of their own, and a couple of small keywords — `import` and `include` — for
wiring that file into any document that needs it. By the end you'll have a
little personal library that every future document can borrow from, and a single
place to fix the callout when you finally get the padding right.

## Machinery in one file, content in another

Start with the smallest possible split. Here is a function in a file all by
itself, `helpers.typ`:

```typ
// helpers.typ
#let callout(body, title: "Note", color: blue) = block(
  fill: color.lighten(85%),
  stroke: (left: 3pt + color),
  inset: 10pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(fill: color, weight: "bold")[#title] \
  #body
]
```

That's the whole file. Compile it on its own and you get a blank page, which is
exactly right: `helpers.typ` doesn't *say* anything, it only *defines*
something. It's machinery, not content.

Next to it sits `main.typ`, the actual document, which borrows the function:

```typ
// main.typ
#import "helpers.typ": callout

= Release notes

#callout[
  The `callout` function isn't defined anywhere in this file — it was
  imported from `helpers.typ`, which sits right beside it.
]
```

The `#import` line reads the other file, finds the name `callout` in it, and
makes that name available here as if you'd defined it locally. Everything below
uses `callout` without knowing or caring that it lives next door. That's Example
095 (`examples/095-splitting-into-files/`), and it is the entire idea of this
chapter in eight lines. The rest is refinement.

The path in quotes is relative to the file doing the importing. Because
`main.typ` and `helpers.typ` are in the same folder, `"helpers.typ"` is all you
need. A helper a folder up would be `"../helpers.typ"`; one in a subfolder,
`"lib/helpers.typ"`. The same rules as any file path.

> [!NOTE]
> A `.typ` file that you import is called a *module*. That's the proper Typst
> word for it, and you'll see it in error messages. A module is just a file
> whose top-level `#let` definitions can be pulled into other files.

## The three ways to import

`#import` has three forms, and the difference between them is entirely about
*which names land in your document*. Take a small library with two public
names — an accent colour and a keycap function:

```typ
// lib.typ
#let accent = rgb("#2b6cb0")
#let kbd(key) = box(
  fill: luma(245), stroke: 0.5pt + luma(160),
  inset: (x: 4pt, y: 1pt), radius: 3pt, baseline: 2pt,
)[#text(font: "DejaVu Sans Mono", size: 8pt)[#key]]
```

Example 096 (`examples/096-import-forms/`) imports this same file all three
ways so you can see them side by side.

### Named: take exactly what you ask for

List the names you want after a colon:

```typ
#import "lib.typ": accent, kbd
```

Now `accent` and `kbd` exist in your document, and nothing else does. This is
the everyday form. It's explicit — a reader can see at a glance precisely what
came from where — and it keeps your namespace uncluttered. When you know which
handful of things you need, name them.

### Star: take everything

A `*` means "import every public name in the module":

```typ
#import "lib.typ": *
```

After this, `accent` and `kbd` are both available, along with anything else
`lib.typ` happens to define now or in the future. It's convenient when you're
using most of a library and don't want to maintain a list. The cost is that you
no longer control what enters your namespace. If `lib.typ` defines a `total` and
your document already has a `total`, one silently shadows the other, and you get
to spend an afternoon finding out why. Reach for `*` with libraries you know
well; be wary of it with large or unfamiliar ones.

### Namespaced: take the module, keep the dot

Leave off the colon entirely and you import the module *itself*, bound to a name
taken from the filename:

```typ
#import "lib.typ"

#lib.kbd("Esc")
#text(fill: lib.accent)[accented]
```

Nothing from inside the module lands in your namespace — only the name `lib`
does. You reach through it with a dot: `lib.kbd`, `lib.accent`. This is the
safest form, because it can't collide with anything: your `total` and the
library's `total` are your `total` and `lib.total`, unmistakably different. The
small tax is a `lib.` in front of every use, which for a library you lean on
heavily can get wordy. For a document that pulls from several libraries at once,
that little prefix is often worth it — you can always tell which house a
function came from.

> [!TIP]
> No single form is correct. Named for the few things you use often; namespaced
> when clarity or clash-avoidance matters; star when you're deep inside one
> library and the convenience wins. Most real documents mix named and
> namespaced and almost never need star.

> [!NOTE]
> You can rename on the way in with `as`: `#import "lib.typ": kbd as key`
> brings `kbd` in under the name `key`. Handy when two libraries both export a
> `callout` and you need them both in one file.

## Building a small style library

One function in a file is a helper. A handful of functions plus the constants
they share is a *library*, and that's where this pays off. The pattern is always
the same: constants at the top, components below, all in one file you import
from.

Here's `lib.typ` from Example 097 (`examples/097-a-style-library/`), the
centerpiece of the chapter. First the theme — the values every component draws
from:

```typ
// lib.typ  — theme constants
#let brand = rgb("#2b6cb0")   // headings, rules, accents
#let muted = luma(110)        // captions, secondary text
#let gap   = 0.9em            // standard vertical breathing room
```

These are the knobs. Put them at the top, name them well, and the entire look of
every document you build on this library is decided in three lines. Want a
green house style instead of blue? Change `brand` once; everything downstream
follows.

Then the components, each one leaning on those constants rather than hard-coding
a colour:

```typ
// lib.typ  — components
#let callout(body, title: "Note", color: brand) = block(
  fill: color.lighten(85%),
  stroke: (left: 3pt + color),
  inset: 10pt, radius: (right: 4pt), width: 100%,
)[#text(fill: color, weight: "bold")[#title] \ #body]

#let kbd(key) = box(
  fill: luma(245), stroke: 0.5pt + luma(160),
  inset: (x: 4pt, y: 1pt), radius: 3pt, baseline: 2pt,
)[#text(font: "DejaVu Sans Mono", size: 8pt)[#key]]

#let framed(body, caption: none) = figure(
  block(stroke: 0.5pt + muted, inset: 10pt, radius: 4pt, width: 100%)[#body],
  caption: caption,
)
```

Three components — a titled note box, a keycap, and a labeled figure — and each
defaults to a theme constant. `callout`'s colour defaults to `brand`; `framed`'s
frame uses `muted`. A caller who overrides nothing gets the house style for
free; a caller who wants a one-off green callout still can, with
`callout(color: green)[...]`.

Now `main.typ` is nothing but content and one import:

```typ
// main.typ
#import "lib.typ": brand, callout, kbd, framed

#show heading: set text(fill: brand)   // a set rule using a library constant

= Keyboard shortcuts

#callout[
  Everything on this page — the heading colour, this box, the keycaps
  below — comes from `lib.typ`. Nothing is styled twice.
]

To copy, press #kbd("Ctrl") + #kbd("C").

#framed(caption: [A framed panel from the same library.])[
  #callout(title: "Tip", color: green)[Components nest happily.]
]
```

Notice the imported `brand` doing double duty: it colours a callout by default
*and* feeds a `set` rule for headings, right there in the document. A library
constant is an ordinary value — you can use it anywhere a value goes, not only
inside the library's own functions.

That's the whole arc of the chapter in one example. The machinery lives in
`lib.typ`; the document imports the few names it needs; the look is decided
once, centrally, and every document built on the library inherits it. Improve
the callout tomorrow and all of them improve together — the copy-paste drift
from the opening of this chapter simply cannot happen, because there's only ever
one copy.

## Bundling a whole look into one function

The library above hands you components you place by hand. Sometimes you want the
opposite: apply an entire look to a document in one stroke — page size, fonts,
heading style, the lot — without touching any of it individually. You already
have the tool for this. It's a function whose body is a stack of `set` and
`show` rules, wrapped around a `body` parameter.

Put it in its own file, `look.typ` (Example 099,
`examples/099-a-reusable-look/`):

```typ
// look.typ
#let brand = rgb("#7c3aed")

#let report(body) = {
  set page(width: 13cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)

  set heading(numbering: "1.1")
  show heading.where(level: 1): set text(fill: brand, size: 17pt)
  show heading.where(level: 2): set text(fill: brand)

  body   // hand the rest of the document back, now that the rules are in force
}
```

`report` takes a `body`, sets up the world it wants — page, text, headings — and
returns `body` at the end so it inherits all of it. Every set and show rule
inside the function applies to whatever `body` turns out to be.

The trick is how you apply it. You *could* write `#report[...huge block of the
whole document...]`, but there's a cleaner idiom you met in passing with show
rules:

```typ
// main.typ
#import "look.typ": report

#show: report

= Field notes
An entire look arrives from one line. Swap in a different look function and
the document reskins without touching a word of content.

== Method
...
```

`#show: report` means "take everything from here to the end of the document, and
pass it through `report`." The rest of the file becomes the `body` argument, and
all of `report`'s rules take hold across the whole document. One line at the top
and the document is styled.

This is the seam where a library of components becomes a *template*, and it's
exactly where [Chapter 19](19-templates.md) picks up. A template is this same
`#show: function` move, grown up: one function that captures an entire design
and applies it to
any content you feed it. You've now built the small version by hand.

> [!IMPORTANT]
> The set rules only take effect from where the function's body runs. With
> `#show: report` at the very top of the file, that's the whole document —
> which is what you want. Put the `#show:` line halfway down and only the second
> half gets the treatment. For a whole-document look, `#show: report` goes
> first, above your content.

## import brings definitions; include brings content

There's a second keyword that looks like `import` and does something almost
opposite, and mixing them up is a classic early stumble. So let's draw the line
sharply.

- `#import "file.typ": name` reaches into another file and pulls out its
  **definitions** — the `#let`-bound names — so you can use them here. It does
  *not* put any of that file's *content* on the page. Importing `helpers.typ`
  earlier added nothing visible to the document; it only made `callout`
  available.

- `#include "file.typ"` does the reverse. It runs the other file and splices its
  **rendered content** into the document at the point of the call — its
  headings, its paragraphs, its images, all of it appears right there. It's the
  Typst equivalent of pasting the file's output in place.

Example 098 (`examples/098-include-vs-import/`) puts them side by side. One side
file holds a definition:

```typ
// defs.typ
#let signoff(name) = text(style: "italic", fill: luma(90))[— #name, editor]
```

The other holds content — actual words meant for the page:

```typ
// section.typ
== From the archives
This whole section lives in its own file. `#include` drops its rendered
content into the document at the point of the call.
```

And `main.typ` uses each for what it's good at:

```typ
// main.typ
#import "defs.typ": signoff     // a definition — usable, prints nothing yet

= The Weekly
An opening paragraph, typed right here in main.typ.

#include "section.typ"          // content — the heading and paragraph appear here

#signoff("Ada Lovelace")        // now use the imported definition
```

Read the output top to bottom and the two roles are plain: the `#import` line
adds nothing where it sits but makes `signoff` work later; the `#include` line
is where the archived section physically shows up. Definitions come in through
`import`; words come in through `include`.

The obvious use for `include` is splitting a long document into a file per
chapter — `main.typ` becomes a table of contents of `#include` lines, one per
`chapter-01.typ`, `chapter-02.typ`, and so on, each file editable on its own.
We'll build exactly that when we assemble a whole book in Part VI.

> [!WARNING]
> A file you `#include` runs in the document's context, but the names it defines
> do *not* leak back into `main.typ`. If `section.typ` defines a helper you want
> to call from `main.typ`, you must `#import` it as well — `include` alone won't
> expose it. Content flows out; definitions don't.

## Keeping the library tidy

A library is code other files depend on, which raises the stakes on a few small
habits. None of them are hard; all of them save a future headache.

**Give it default arguments.** Every component in `lib.typ` had defaults —
`title: "Note"`, `color: brand`. A caller who wants the common case types
nothing; a caller who wants a variation overrides one argument. Defaults are
what make a library pleasant instead of demanding. (Chapter 14 covers the
mechanics; a library is just where they earn their keep.)

**Document each function with a one-line comment.** A `// callout(body, title:,
color:) — a titled note box.` above the definition costs you five seconds and
tells the next reader — usually you, months later — what the thing is for and
how to call it, without reverse-engineering the body.

**Keep the public names deliberate.** Everything you `#let` at the top level of
a module becomes importable, whether you meant it to or not. If a component
needs a little internal helper that no document should call directly, that's
fine — just know it's exposed, and consider a naming convention (a leading
underscore, `_clamp`, is a common signal for "internal, don't rely on this")
so a `#import: *` reader knows what's really public.

**Group constants at the top.** The theme block — colours, sizes, spacing — is
the part you'll tweak most. Putting it together at the top of the file, above
the components, means you never hunt through function bodies to change a colour.
Machinery below, knobs on top.

> **Coming from LaTeX.** This is the job a `.sty` package file does: you write
> `\usepackage{mystyle}` in the preamble and `\input{chapter1}` to splice a
> chapter in. Typst folds both jobs into plain `.typ` files and two keywords —
> `#import` is your `\usepackage`, `#include` is your `\input` — with no
> separate package format, no `.sty` versus `.cls` distinction, and no
> `TEXINPUTS` path to configure. Your own reusable code is just a Typst file
> sitting next to the document. (Publishing a library for *other people* to
> install by name is a further step, and that's Chapter 20; for your own use, a
> file beside your document is the whole story.)

## What you've got

You can now spread work across files instead of piling it into one:

- **A file of your own** — put `#let` definitions in a `.typ` module and it
  becomes machinery any document can borrow. A module you compile alone renders
  blank, and that's correct: it defines, it doesn't say.
- **Three import forms** — named (`#import "lib.typ": a, b`) for the few things
  you use; star (`: *`) for everything, at the cost of namespace control;
  namespaced (no colon, then `lib.a`) for the safest, clash-proof access. Rename
  on the way in with `as`.
- **A style library** — theme constants at the top, components below, each
  defaulting to a constant. One file decides the look; every document that
  imports it inherits the look and every future fix.
- **A bundled look** — a `report(body)` function wrapping a stack of set and
  show rules, applied to a whole document with `#show: report`. This is a
  template in embryo (Chapter 19).
- **import vs include** — `#import` pulls in a file's *definitions*; `#include`
  splices in a file's *content*. Definitions come through one, words through the
  other, and they don't cross over.
- **Good habits** — default arguments, a one-line comment per function,
  deliberate public names, constants grouped on top.

Part V is about reuse, and this is its foundation. A template (Chapter 19) is a
library with a `#show:` function at its heart; a package (Chapter 20) is a
library you've addressed so others can install it by name. Both are the file
you just learned to write, taken one step further.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

18.1. Take the `kbd` function you wrote for Exercise 14.1 and move it into a
file called `keys.typ`. From a separate `main.typ`, import it with the named
form and use it in a sentence — `Press #kbd("Ctrl") + #kbd("C")`. Confirm that
compiling `keys.typ` on its own produces a blank page, and that `main.typ`
renders the keycaps.

18.2. Add a second name to `keys.typ` — a constant `#let key-color =
luma(245)` — and have `kbd` use it as its fill. Now import `keys.typ` all three
ways in turn (named, star, and namespaced) from `main.typ`, and for each write
the one line that uses `kbd` and `key-color`. For the namespaced form, that's
`keys.kbd(...)` and `keys.key-color`.

18.3. Build a two-component library, `lib.typ`, containing a `brand` colour
constant and two components that both default their colour to `brand`: a
`callout` and a `tag` (a small inline label — a `box` with a fill and white
text). In `main.typ`, import all three names and produce a short document that
uses each component twice, once with the default colour and once overridden.
Then change `brand` in `lib.typ` and confirm every default-coloured element
moves together.

18.4. Split a short document across files with `#include`. Write `intro.typ` and
`body.typ`, each holding a heading and a paragraph of `#lorem` text, and a
`main.typ` that sets the page and then includes them in order. Confirm the two
sections appear in the document exactly where the `#include` lines sit.

18.5. *(Stretch.)* Turn the reusable-look idea into a switchable one. Write
`looks.typ` defining two whole-document functions — `formal(body)` and
`playful(body)` — that differ in font, heading colour, and page margin. In
`main.typ`, apply one with `#show: formal`, then change that single line to
`#show: playful` and watch the entire document change character without a word
of content moving. You've just written two templates and swapped between them in
one line — which is most of what Chapter 19 is about.

<!--
SOLUTIONS (notes for the appendix author):

18.1 - keys.typ:
         #let kbd(key) = box(
           stroke: 0.5pt, inset: (x: 4pt, y: 1pt), radius: 3pt,
         )[#raw(key)]
       main.typ:
         #import "keys.typ": kbd
         Press #kbd("Ctrl") + #kbd("C") to copy.
       Point: keys.typ alone renders blank (it only defines); main.typ shows the
       caps. Relative path "keys.typ" resolves because both files are together.

18.2 - keys.typ adds:  #let key-color = luma(245)
         #let kbd(key) = box(fill: key-color, stroke: 0.5pt,
           inset: (x: 4pt, y: 1pt), radius: 3pt)[#raw(key)]
       Named:      #import "keys.typ": kbd, key-color
                   #kbd("Esc")  (uses key-color internally)
       Star:       #import "keys.typ": *
                   #kbd("Esc")
       Namespaced: #import "keys.typ"
                   #keys.kbd("Esc")  ...  #keys.key-color
       Point: all three reach the same two names; only the spelling at the call
       site differs. Namespaced needs the keys. prefix; named/star don't.

18.3 - lib.typ:
         #let brand = rgb("#2b6cb0")
         #let callout(body, title: "Note", color: brand) = block(
           fill: color.lighten(85%), stroke: (left: 3pt + color),
           inset: 10pt, width: 100%,
         )[#text(fill: color, weight: "bold")[#title] \ #body]
         #let tag(body, color: brand) = box(
           fill: color, inset: (x: 6pt, y: 3pt), radius: 4pt,
         )[#text(fill: white, weight: "bold")[#body]]
       main.typ:
         #import "lib.typ": brand, callout, tag
         #callout[default]  #callout(color: green)[override]
         #tag[default] #tag(color: red)[override]
       Point: both components default color: brand; editing brand in lib.typ
       moves every default-coloured element at once, overrides stay put.

18.4 - intro.typ:  = Introduction \ #lorem(30)
       body.typ:   = Body \ #lorem(40)
       main.typ:
         #set page(width: 12cm, height: auto, margin: 1.5cm)
         #set text(font: "Libertinus Serif")
         #include "intro.typ"
         #include "body.typ"
       Point: include splices rendered content in call order; the two sections
       appear exactly where the #include lines sit. Contrast with import, which
       would have brought nothing visible.

18.5 - looks.typ:
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
       main.typ:
         #import "looks.typ": formal, playful
         #show: formal      // <- change to `playful` to reskin
         = Title
         #lorem(40)
       Point: one #show: line swaps the entire look; content untouched. This is
       the template idea (Ch 19) — a whole design captured in a function applied
       with #show:.
-->
