# Templates

You've typed the same fifteen lines at the top of every document for a month. A
`set page` with your margins, a `set text` with your font, a `set par(justify:
true)`, a show rule to color the headings, and a little title block you paste in
and edit by hand. Every new report starts with a pilgrimage to the last one, to
copy the preamble across. Then one afternoon you change the font in a single
document, forget to change it in the others, and now none of them match — and
you can't remember which one holds the good version.

That itch has a name, and the cure is a template. A template is the entire look
of a document — every set rule, every show rule, the title block, the running
headers, the lot — packed into one function that you apply with a single line.
Write it once. Apply it to a hundred documents. Change it in one place and all
hundred follow.

You've already met the mechanism, in miniature, at the very end of
[Chapter 10](10-show-rules.md). This chapter grows it into the real thing.

## A template is a function

Back in Chapter 10 you wrote a `report` function that took the document `body`,
applied a stack of rules, and handed the body back wearing them. Then a
selector-less `#show: report` fed the whole document into that function.

That was a template. There is no deeper secret. A template is an ordinary
function that takes your content as its last argument, dresses it in set and
show rules and any scaffolding you like, and returns the dressed result —
invoked by a show rule with no selector in front of it.

Everything else in this chapter is making that function *do more*: take
configuration, build a title block, live in its own file. The shape never
changes. Here's the smallest version that still earns the name
(`examples/100-a-first-template/`):

```typ
#let report(body) = {
  set page(width: 12cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true, leading: 0.7em)
  set heading(numbering: "1.")
  body
}

#show: report

= Field notes
#lorem(30)
```

`report` is a plain function with one parameter. Inside, four set rules
establish the page, the font, justified paragraphs, and numbered headings. The
last line is just `body` — the function's result is the content it was handed,
now sitting *after* all those rules, so the rules apply to it. (Remember from
Chapter 10 that set and show rules only affect what comes after them, within
their scope. The rules run first; `body` comes last; the body is styled.)

Then `#show: report` does the feeding. It has no selector, so it catches the
entire rest of the document, hands that content to `report` as `body`, and
replaces it with what comes back. From that one line down, your document is
justified Libertinus with numbered headings, and you never touched the content
to make it so.

## Giving the template something to configure

The `report` above dresses the body but knows nothing *about* it. Real documents
have a title, an author, a date — things the template should lay out for you
rather than make you build by hand every time. That means parameters: the named,
defaulted parameters you met in Chapter 14.

Add a couple in front of `body` and build a title block out of them
(`examples/101-configurable-template/`):

```typ
#let report(title: none, author: none, body) = {
  set page(width: 12cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)
  set heading(numbering: "1.")

  align(center)[
    #text(size: 18pt, weight: "bold")[#title] \
    #text(style: "italic")[#author]
  ]
  v(1.2em)

  body
}
```

Now the function has three parameters. `title` and `author` are named, with a
default of `none`; `body` is positional and comes *last*. Inside, before the
body, we render a centered title block: the title big and bold, the author in
italics below it, a little vertical breathing room, and then the body.

Applying it looks like this:

```typ
#show: report.with(
  title: "Weeknotes",
  author: "A. Reader",
)

= Monday
#lorem(28)
```

You get a centered "Weeknotes" title over an italic byline, followed by your
numbered sections — a real front matter from two lines of configuration.

### Why `.with` is the magic word

Look hard at that `#show: report.with(...)`, because it's the hinge the whole
pattern turns on, and it's two ideas you already know clicking together.

The first is `.with`, from Chapter 14. `report.with(title: "Weeknotes", author:
"A. Reader")` doesn't *call* `report` — it pre-fills those two arguments and
returns a *new function* with them baked in. That new function has exactly one
parameter still waiting to be supplied: `body`.

The second is the selector-less show rule, from Chapter 10. `#show:
someFunction` gathers up the entire rest of the document and passes it to
`someFunction` as its argument.

Put them side by side and it clicks. `.with` fills the *configuration*
and leaves a single hole named `body`. The show rule then drops the whole
document into that hole. The two halves meet in the middle: you supply the
config, Typst supplies the content, and `report` gets a complete set of
arguments. That is the entire idiom, and you'll write it at the top of nearly
every serious document you make.

> [!IMPORTANT]
> The `body` parameter must come **last** in the function's parameter list. The
> selector-less show rule always feeds the document in as the final positional
> argument (the same content-block sugar from Chapter 14: `#show: f` behaves
> like handing `f` one trailing block of content). If `body` sat in the middle,
> that content would land in the wrong slot and the whole thing would misbehave.
> Configuration first, `body` last, every time.

## Configuration versus content

It's worth being clear about the two kinds of thing a template takes, because
they feel different and behave differently.

The **configuration** is data *about* the document: a title string, an author, a
date, whether to show an abstract. Small values, set once, at the top. You pass
them by name through `.with`, and inside the template you place, style, or
branch on them.

The **body** is the document itself — every heading and paragraph below the show
line. You never pass it explicitly; the selector-less show rule feeds it in for
you.

A good habit: give every configuration parameter a default, usually `none`. Two
reasons. The template still compiles if you forget one, instead of erroring on a
missing argument. And a default of `none` lets the template *notice* an omission
— "if no date was given, don't draw the date line" — which is exactly how you'll
make the abstract optional in a moment.

## Moving the template into its own file

Once a template is more than a handful of lines, you don't want it squatting on
top of every document that uses it. Give it its own file and import it, exactly
as you would any multi-file library from Chapter 18.

Put the function in `template.typ` (`examples/102-template-in-a-file/`):

```typ
// template.typ
#let article(title: none, author: none, body) = {
  set page(width: 12cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)
  set heading(numbering: "1.")

  align(center)[
    #text(size: 18pt, weight: "bold")[#title] \
    #text(style: "italic")[#author]
  ]
  v(1em)

  body
}
```

And the document that uses it shrinks to nothing but configuration and content:

```typ
// main.typ
#import "template.typ": article

#show: article.with(
  title: "On importing templates",
  author: "A. Reader",
)

= Why split the file?
#lorem(30)
```

`#import "template.typ": article` pulls the `article` function into `main.typ`,
and from there it's used identically to before. The payoff is separation: the
styling lives in one file, the writing in another. Ten documents in a folder can
all `#import` the same `template.typ`, and fixing the font once fixes it for all
ten. That is the difference between a template and a preamble you keep pasting.

## A real article template

Time to build the thing you'd reach for. The template below adds a date,
an *optional* abstract, and a more considered title block, and it styles
the headings with a show rule on top of the set rules. It is the centerpiece of
the chapter (`examples/103-an-article-template/`).

Start with the signature and the set rules:

```typ
#let article(
  title: none,
  author: none,
  date: none,
  abstract: none,
  body,
) = {
  set page(
    width: 14cm, height: auto,
    margin: (x: 2cm, top: 2cm, bottom: 1.6cm),
  )
  set text(font: "Libertinus Serif", size: 10.5pt)
  set par(justify: true, leading: 0.65em, first-line-indent: 1.2em)
  set heading(numbering: "1.1")
  show heading.where(level: 1): set text(size: 13pt)
```

Four configuration parameters, then `body` last, just as the rule demands. The
set rules do the everyday styling; the lone show rule bumps up the size of
top-level headings without disturbing anything else about them — the show-set
form from Chapter 10, doing quiet work.

Next, the title block, assembled from the configuration:

```typ
  align(center)[
    #block(text(size: 20pt, weight: "bold")[#title])
    #v(0.2em)
    #if author != none {
      text(size: 11pt)[#author]
    }
    #if date != none {
      linebreak()
      text(size: 9.5pt, fill: luma(40%))[#date]
    }
  ]

  v(1em)
```

The title is always drawn; the author and date are drawn only if they were
supplied. That's the `none`-default habit paying off — `if author != none`
guards the byline, so an untitled draft or a dateless memo still lays out
cleanly instead of printing an empty line.

Then the optional abstract, and finally the body:

```typ
  if abstract != none {
    block(width: 100%, inset: (x: 1.4em))[
      #align(center)[#text(weight: "bold", size: 9.5pt)[Abstract]]
      #set text(size: 9.5pt)
      #set par(first-line-indent: 0pt)
      #emph(abstract)
    ]
    v(1em)
  }

  body
}
```

The whole abstract is wrapped in `if abstract != none`, so a document that skips
it pays no price. Inside the block, two set rules — a smaller text size and no
first-line indent — apply *only* within those brackets, because set rules are
scoped (Chapter 9). The abstract comes out indented on both sides, smaller,
italic, under a centered "Abstract" label; the body below it is unaffected.

The document that drives all this is, once again, just a show line and content:

```typ
#show: article.with(
  title: "A Field Guide to Templates",
  author: "A. Reader",
  date: "July 2026",
  abstract: [
    Templates package a document's entire look into one function, so a
    single line dresses the whole thing.
  ],
)

= Introduction
#lorem(40)

== Background and motivation
#lorem(30)
```

Notice the abstract is passed as *content* — square brackets, not a string —
because it's a paragraph you might want to emphasize or format, not a label.
Configuration doesn't have to be plain text; a parameter can take a whole block
of content when that's what the slot deserves.

The result is a tidy article: a bold centered title, author and gray date
beneath, a set-off italic abstract, and numbered sections in Libertinus. Every
document that applies `article` comes out matching, because the design lives in
one function instead of in your muscle memory. In practice this template belongs
in its own file, imported exactly like `examples/102-template-in-a-file/` — it's
shown here in one piece only so you can read the whole thing at a sitting.

> **Coming from LaTeX.** This is your `\documentclass`, and then some. In LaTeX
> the class deciding what an "article" looks like is a `.cls` file — often an
> opaque wall of `\def`s and `\RequirePackage`s you inherit and rarely dare to
> open. A Typst template is just a function, written in the same language as the
> rest of your document, sitting in a file you can read top to bottom in a
> minute. Want to know what it does? Read it. Want to change a margin? Edit the
> `set page`. There's no separate class-writing dialect and no ceremony for
> switching: `#show: article.with(...)` swaps the entire look, and swapping to a
> different template is a one-line edit.

## Templates you can install

Everything so far has been a template *you* wrote, living in your own folder.
Typst also has a way to share templates with the world: the package registry at
[Typst Universe](https://typst.app/universe). Many of the packages there are
templates — for a thesis, a CV, or a conference paper — and you pull one
in the same way you'd start a new project from it:

```sh
typst init @preview/name:version
```

You copy the exact name and version from the package's page on Universe. That
command scaffolds a new document wired to the chosen template, ready for you to
fill in the configuration and write. Under the hood it's the same `#show:
template.with(...)` idiom you've been using all chapter — the package just ships
the function and a starter `main.typ` so you don't write either by hand. We take
packages properly in Chapter 20, including how to publish one of your own; for
now, know that the template you build for yourself and the template you install
from Universe are the very same kind of thing.

## What you've got

You can now bottle an entire document design and pour it over any content:

- **What a template is** — an ordinary function that takes the document `body`
  last, applies set and show rules plus any scaffolding, and returns the dressed
  document. Nothing more exotic than a function that wraps your content.
- **How it's applied** — a selector-less `#show: template` feeds the whole
  document in as `body`. With configuration, `#show: template.with(title: ...)`
  pre-fills the settings (`.with`, from Chapter 14) and leaves the show rule to
  supply the body.
- **The one hard rule** — `body` is the *last* parameter, because the show rule
  always hands the document in as the final positional argument.
- **Configuration versus content** — named, defaulted parameters (`title`,
  `author`, `date`, `abstract`) carry data about the document; the body is the
  document. Default configuration to `none` so you can make parts optional with
  `if x != none`.
- **A real title block** — build it from configuration, guard optional pieces
  with `if`, and scope any local set rules inside their own block.
- **Templates in their own file** — `#import "template.typ": article` (Chapter
  18) keeps styling and writing apart, so one template backs many documents.
- **Installable templates** — Typst Universe ships templates as packages;
  `typst init @preview/...` scaffolds a document from one. Full story in
  Chapter 20.

A template is where set rules, show rules, functions, and imports all come
together and start earning their keep. It's also the direct ancestor of the book
template we build in Part VI — the same idea, scaled up until it can typeset an
entire book, this one included.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

19.1. Take the `report` from `examples/100-a-first-template/` and give it
a second personality: add a `show heading: set text(fill: navy)` inside the
function so every heading turns navy. Apply it with `#show: report` and confirm
all headings change from the one edit.

19.2. Add a `date` parameter (defaulting to `none`) to the configurable `report`
in `examples/101-configurable-template/`, and render it under the author in a
smaller, gray text. Apply it once *with* a date and once *without*, and
confirm the dateless version doesn't leave a blank line (hint: guard it with `if
date != none`).

19.3. Move a template into its own file. Take your answer to 19.2, put the
function in `template.typ`, and `#import` it into a `main.typ` that
contains only the show line and some content. Confirm the output is identical to
the single-file version.

19.4. Extend the article template in `examples/103-an-article-template/` with a
`keywords` parameter that takes an array of strings (e.g. `("typst",
"templates")`) and prints them, comma-separated, in italics under the abstract.
Make it optional: nothing prints if `keywords` is left at its default. (Hint:
`("a", "b").join(", ")`.)

19.5. *(Stretch.)* Write a second template, `memo(to: none, from: none, body)`,
with a completely different front matter — a left-aligned "To / From / Date"
block instead of a centered title. Keep it in the same `template.typ` as your
`article` (export both). Now write one `main.typ` that imports both and, by
changing a single line, switches the same body between two looks. You've just
proven the payoff: the design and the writing are genuinely separate.

<!--
SOLUTIONS (notes for the appendix author):

19.1 - Inside report's block body, add:  show heading: set text(fill: navy)
       (anywhere among the set rules, before `body`). Then #show: report over a
       doc with two headings. Point: the show rule is scoped to the body the
       function wraps; one line reskins every heading. Same shape as the Ch10
       report.

19.2 - #let report(title: none, author: none, date: none, body) = { ...
         align(center)[
           #text(size: 18pt, weight: "bold")[#title] \
           #text(style: "italic")[#author]
           #if date != none [ \ #text(size: 9pt, fill: luma(40%))[#date] ]
         ]
         ...
       }
       Apply once with date: "July 2026" and once without. Point: none-default +
       if-guard means the optional line simply doesn't render when omitted; no
       blank line. (The linebreak lives inside the if, so it is conditional.)

19.3 - template.typ holds the #let report(...) from 19.2. main.typ:
         #import "template.typ": report
         #show: report.with(title: "...", author: "...", date: "...")
         = A heading
         #lorem(20)
       Output identical to the one-file version. Point: import doesn't change
       behavior, only where the code lives. Any working split passes.

19.4 - Add `keywords: ()` to the signature (default empty array, or none). After
       the abstract block:
         if keywords != () {
           block(inset: (x: 1.4em))[
             #set text(size: 9pt, style: "italic")
             #keywords.join(", ")
           ]
         }
       Point: default to () (or none) and guard, so nothing prints when omitted;
       .join(", ") turns the array into "typst, templates". Accept none-default
       with `if keywords != none` too.

19.5 - In template.typ, add alongside `article`:
         #let memo(to: none, from: none, date: none, body) = {
           set page(width: 12cm, height: auto, margin: 1.6cm)
           set text(font: "Libertinus Serif", size: 11pt)
           grid(columns: (auto, 1fr), row-gutter: 0.4em,
             [*To:*], [#to], [*From:*], [#from], [*Date:*], [#date])
           line(length: 100%, stroke: 0.5pt)
           v(0.6em)
           body
         }
       main.typ:  #import "template.typ": article, memo
         #show: article.with(title: "...", author: "...")   // <- swap this one
         // #show: memo.with(to: "...", from: "...")          line to reskin
         = Heading
         #lorem(30)
       Point: the body is untouched; only the show line changes. Two templates,
       one document, a one-line switch. Proves design/content separation. Any
       working two-template file with a single-line swap passes.
-->
