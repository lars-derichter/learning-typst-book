# Show rules

You want your section headings to have a thin colored line under them. It's a
common look — you've seen it in a hundred reports and textbooks — and you go
looking for the parameter that does it. You read the whole `heading` reference.
There's `numbering`, `outlined`, `depth`, `supplement`. There is no
`underline-with-a-colored-rule`.

Of course there isn't. No sane function would offer a parameter for every
decorative flourish anyone might ever want; the list would never end. Set rules,
from Chapter 9, can only reach the knobs the element's designer chose to expose.
A colored rule under every heading isn't a knob. It's a different *shape*.

Show rules give you that shape. Where a set rule adjusts an element's
settings, a show rule intercepts the element on its way to the page and lets
you rebuild it into anything you like. It is the more powerful of Typst's two
styling ideas, and once it clicks, the question stops being "does Typst
support this look?" and becomes "how do I want to build it?"

## Set tunes, show transforms

Hold the two ideas side by side, because the whole chapter lives in the
difference.

A **set rule** changes an element's *parameters* — the named arguments its
function accepts. `#set heading(numbering: "1.")` reaches into every heading and
flips the `numbering` argument. You are configuring the element. You can only
touch what the element chose to expose.

A **show rule** changes an element's *appearance* wholesale. It says: whenever
you're about to display one of these, stop, hand it to me, and use what I give
back instead. You are no longer configuring the heading. You are deciding, from
scratch, what a heading *is* on the page — and you can wrap it, recolor it,
add a line under it, box it, or replace it with something else entirely.

Set rules are a dial. Show rules are a workshop.

## The function form: rebuilding an element

The most powerful form of show rule hands you the element as a value and asks
for replacement content in return:

```typ
#show heading: it => {
  // build something using `it`, return it
}
```

Read that as: "Show every `heading` by running this function." The `it` is the
heading itself, caught mid-flight. Off it you can read the element's fields —
the same names you'd pass to the `heading` function — and use them to build
whatever you want. The most useful heading fields are:

- `it.body` — the heading's text (as content).
- `it.level` — `1` for `=`, `2` for `==`, and so on.
- `it.numbering` — the numbering pattern, or `none` if unset.

So the colored-rule look you couldn't find a parameter for is four lines
(`examples/050-show-heading-function/`):

```typ
#show heading: it => block(below: 0.8em)[
  #text(fill: rgb("#2b6cb0"), weight: "bold")[#it.body]
  #v(-6pt)
  #line(length: 100%, stroke: 0.6pt + rgb("#2b6cb0"))
]

= Introduction
= Method
```

Each heading now renders as a blue bold title with a thin blue rule tucked
underneath. We read the heading's own text from `it.body`, wrap it in a
colored `text`, nudge upward with a negative `v`, and draw a `line` the full
width of the column. Typst runs this for every heading in the document, so
`Introduction` and `Method` come out matching without a second thought.

The function can do anything a normal chunk of Typst can. Branch on `it.level`
to make top-level headings look different from subsections; check
`it.numbering` and add a marker only when a heading is numbered; measure, box,
indent, whatever the design wants. The element is just a value now, and you
have the whole language.

> [!IMPORTANT]
> A show rule returns the element's *entire* appearance — including whether it's
> a block. A heading is normally block-level: it sits on its own line with space
> around it. If your function returns bare inline content, you hand that layout
> back, and the "heading" runs straight into the paragraph after it. When you
> rebuild a block element, wrap your result in `block[...]` (as above) unless
> you deliberately want a run-in heading.

> **Coming from LaTeX.** This is `\renewcommand` and friends, minus the danger.
> Redefining `\section` in LaTeX means overwriting a global macro and praying
> nothing else depended on the old one; reaching inside an existing command's
> behavior often means `\usepackage{etoolbox}` and patching it with
> `\patchcmd`, a genuinely fiddly business. A Typst show rule doesn't overwrite
> anything. It's a scoped instruction — "display headings like this, from here"
> — that you can even confine to one part of the document. No package, no
> patching, no global state to break.

## The show-set form: set rules, but selective

The function form is the powerful one, and often more power than you need.
Plenty of the time you don't want to rebuild an element — you just want a set
rule to apply to *some* elements and not others. That's the **show-set** form,
and it's the one you'll reach for most:

```typ
#show heading.where(level: 1): set text(size: 18pt, fill: navy)
```

Read it right to left: "apply `set text(...)` — but only to headings where the
level is 1." A plain `#set text(size: 18pt)` would enlarge the entire
document; a plain `#set heading(...)` can't change text size at all, because
size isn't a heading parameter. The show-set form threads the needle: it aims
a set rule at exactly the elements a selector picks out.

It's the safest show rule you can write. You're not returning new content, so
there's nothing to accidentally break — no lost block layout, no recursion (more
on that later), no forgotten field. You're just saying "these specific
elements get these settings." `examples/051-show-set/` gives level-1 headings
a large navy style and, with a second show-set, paints every inline `raw`
snippet purple:

```typ
#show heading.where(level: 1): set text(size: 18pt, fill: navy)
#show raw: set text(fill: rgb("#7b2d8b"))
```

Notice the level-1 heading keeps its numbering, its spacing, its bold weight —
everything you *didn't* mention. Show-set adjusts; it doesn't replace. When a
design need is really "make these elements a bit different," reach for show-set
before you reach for a full rebuild.

## Selectors: what a rule can match

Every show rule starts with a selector — the part before the colon that
decides which elements the rule catches. You've seen two already. Here's the
full everyday set.

A **bare element function** matches every instance of that element:

```typ
#show heading: ...    // every heading
#show raw: ...        // every code snippet, inline and block
#show emph: ...       // every _emphasized_ span
#show strong: ...     // every *strong* span
#show link: ...       // every link
#show figure: ...     // every figure
#show list: ...       // every bullet list
```

Any element function can be a selector: `par`, `table`, `quote`, `ref`,
`outline`, and the rest. If you can create it, you can show it.

A **`.where(...)` selector** narrows a bare element to instances whose fields
match. This is how you distinguish a heading level, a specific figure kind, or a
particular list:

```typ
#show heading.where(level: 1): ...          // only top-level headings
#show figure.where(kind: image): ...        // only image figures
#show raw.where(block: true): ...           // only block code, not inline
```

`.where` matches on the element's fields — the same names you read off `it` —
so `heading.where(level: 2)` and reading `it.level == 2` inside a function are
two routes to the same targets.

Put those together and one document can style each heading level on its own
terms (`examples/054-show-where/`):

```typ
#show heading.where(level: 1): set text(size: 18pt, fill: navy)
#show heading.where(level: 2): it => block(above: 1em, below: 0.6em)[
  #text(fill: maroon, weight: "bold")[» #it.body]
]
```

Level-1 headings come out large and navy through a show-set; level-2 headings
get a full rebuild — maroon, bold, with a `»` marker in front. The two rules
coexist without interfering, because each selector catches only its own level.
Mixing a show-set and a function-form rule in the same document is completely
normal; use whichever fits each target.

## Matching text, not elements

Selectors don't stop at elements. You can also match raw *text* — literal
strings or regular-expression patterns — and Typst will restyle every
occurrence wherever it falls.

A **string selector** matches a literal word or phrase anywhere in the document:

```typ
#show "TODO": text(fill: red, weight: "bold")[TODO]
```

Every `TODO` you type from then on comes out bold and red, no matter where it
appears (`examples/052-show-string/`). The right-hand side can be content, as
here, or a function that receives the matched text. That second option is handy
when you want to *reuse* the matched string rather than retype it:

```typ
#show "Acme": smallcaps
```

Here `smallcaps` is handed the matched content and returns it in small capitals,
so every mention of the product name is set consistently without you writing it
out twice.

A **regex selector** matches a pattern instead of a fixed string, which is where
this gets genuinely useful. Wrap a regular expression in `regex(...)` and give a
function that transforms each match — the matched text is on `it.text`:

```typ
#show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
```

That one line sets every acronym in the document — any run of two or more
capitals — in small caps, the classic typographic treatment for `HTML`, `CSS`,
`NASA`, and friends. It lowercases the match first (`lower`) and hands the
result to `smallcaps`, which draws lowercase letters as small capitals. You
typed the acronyms in ordinary capitals; the rule does the styling —
`examples/053-show-regex/` runs it alongside a second rule that tints any
four-digit year:

```typ
#show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
#show regex("\d{4}"): it => text(fill: rgb("#c05621"))[#it.text]
```

The result reads "the html spec of 1991" with the acronym in small caps and the
year in warm orange — and it keeps working as you write, catching every new
acronym and year automatically. Anywhere you'd otherwise reach for find-and-
replace, a string or regex show rule does the job once and for good.

> [!TIP]
> Regex show rules are perfect for house-style rules you'd never remember to
> apply by hand: small-capping acronyms, formatting phone numbers or version
> tags, flagging placeholder text like `XXX`, coloring a product's name. Write
> the rule once at the top of the file and forget about it.

## The document-wide show rule

Leave the selector off entirely and something bigger happens. A show rule with
no element in front of it — just `#show: ...` — matches *the entire rest of
the document*:

```typ
#show: it => block(fill: luma(240), inset: 8pt, it)
```

Everything after that line is gathered up, handed to the function as `it`, and
replaced by whatever comes back. Here the whole document lands in a gray box.
The rule doesn't target headings or strong text or anything specific; it wraps
the lot.

That sounds like a party trick until you realize it's the mechanism behind every
template in Typst. Instead of an inline function, you point the show rule at a
named one (`examples/055-document-wide-show/`):

```typ
#let report(body) = {
  set page(width: 12cm, height: auto, margin: 1.5cm)
  set text(font: "New Computer Modern", size: 11pt)
  set par(justify: true)
  show heading: set text(fill: navy)
  body
}

#show: report

= A tiny template
#lorem(28)
```

`report` is an ordinary function that takes the document body, applies a stack
of set and show rules, and returns the body dressed in them. The line
`#show: report` feeds the entire document below it into `report` as `body`.
From that point the document is New Computer Modern, justified, with navy
headings — a complete change of clothes from one line.

That's a template in miniature. Real ones do far more — title pages, headers,
multi-argument configuration — but the engine is exactly this: a function that
wraps the document, invoked by a selector-less show rule. Chapter 19 builds
one properly. For now, note the shape, because you'll write `#show: something`
at the top of nearly every serious document you make.

## Two things that bite

Show rules are powerful, and power comes with a couple of sharp edges. Both are
easy to avoid once you've seen them.

### Recursion

A show rule watches for a kind of element. What if the rule's own output
contains that same kind of element? It matches again. And again.

```typ
#show strong: it => strong[!#it.body!]   // don't
```

The rule catches strong text and returns... new strong text, which the rule
catches, which returns more strong text. Typst doesn't hang — it notices the
runaway and stops with a clear error:

```text
error: maximum show rule depth exceeded
  = hint: maybe a show rule matches its own output
```

The fix is to not re-create the element you're matching. If you want strong text
to also be red, don't build a fresh `strong`; wrap the element you were *given*:

```typ
#show strong: it => text(fill: red, it)   // fine
```

That works because `it` is the original element, and Typst marks it as already
shown — passing it back through doesn't re-trigger the rule. Building a
brand-new `strong[...]` does. The rule of thumb: reuse `it` freely, but think
twice before your function constructs the very element its selector is watching
for.

### Order and scope

A show rule affects only the content that comes *after* it, within the same
scope. Put it at the top of the file and it governs the whole document; put it
halfway down and the first half is untouched; put it inside a `{ }` block or a
function body and it evaporates at the closing brace. This is the same "from
here on, within here" behavior set rules have, and it's what makes the template
pattern work — the rules inside `report` apply to the `body` in that function
and nowhere else.

The practical consequence: if a show rule doesn't seem to be firing, check
*where* it sits. A rule below the content it was meant to catch will sit there
doing nothing, wondering why nobody calls.

## What you've got

You can now change not just an element's settings but its whole appearance:

- **The distinction** — set rules tune an element's *parameters*; show rules
  replace or wrap its *appearance*. When no parameter does what you want, that's
  the show rule's cue.
- **The function form** — `#show heading: it => ...` catches the element as
  `it`, reads its fields (`it.body`, `it.level`, `it.numbering`), and returns
  rebuilt content. The powerful one.
- **The show-set form** — `#show heading.where(level: 1): set text(...)` aims a
  set rule at just the matched elements. The safest and most common one.
- **Selectors** — a bare element (`heading`, `raw`, `emph`, `link`, `figure`,
  `list`), `.where(field: value)` to narrow by field, a literal `"string"`, or a
  `regex(...)` pattern with the match on `it.text`.
- **The document-wide form** — `#show: it => ...` or `#show: template-fn` wraps
  the entire rest of the document. This is how templates work (Chapter 19).
- **The two traps** — a rule that re-creates the element it matches recurses
  (reuse `it` instead of rebuilding), and a rule only ever affects content after
  it, within its scope.

Between set rules and show rules you now hold both halves of Typst's styling
system. Everything else — references, bibliographies, your own reusable
templates — is built on this pair.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

10.1. Write a function-form show rule that makes every level-1 heading dark
green and draws a horizontal `line` above it (not below). Give the document two
or three headings and confirm they all match.

10.2. Using the show-set form, make block quotes (`quote(block: true)[...]`)
italic and inline `raw` code red — two separate rules. Check that ordinary body
text is unaffected.

10.3. Write a string show rule that replaces every occurrence of your project's
name with the name in bold small caps. Then add a regex rule that sets any
all-caps acronym of two or more letters in small caps. Type a sentence that
contains both and confirm each is styled correctly.

10.4. You write `#show strong: it => strong(it.body)` and Typst refuses to
compile. Explain in one sentence what goes wrong, then rewrite the rule so that
strong text also becomes underlined *without* triggering the error.

10.5. *(Stretch.)* Write a `#let` function `note(body)` and a selector-less
`#show: note` rule that restyles the whole document: a fixed small page, a
justified paragraph, a distinct heading color, and every acronym (regex) in
small caps. You've just written the skeleton of a template — keep it around, you
can grow it into a real one in Chapter 19.

<!--
SOLUTIONS (notes for the appendix author):
10.1 - #show heading.where(level: 1): it => block[
         #line(length: 100%, stroke: 0.6pt + green.darken(30%))
         #text(fill: green.darken(30%))[#it.body]
       ]
       (or plain `heading:` if only one level is used). Point: rule above =
       draw the line before the body inside the block. Wrapping in block keeps
       heading block layout.
10.2 - #show quote.where(block: true): set text(style: "italic")
       #show raw: set text(fill: red)
       Two show-set rules; body text untouched because neither selector matches
       plain paragraphs. (Inline raw vs block raw both match `raw`; fine here.)
10.3 - #show "Projectname": strong(smallcaps[Projectname])  (or a function RHS)
       #show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
       Note order/overlap: the acronym rule would also catch an all-caps project
       name; either accept that or make the project name mixed-case. Credit
       either a working combination or noticing the overlap.
10.4 - The function returns a NEW strong element, which the same rule matches
       again -> "maximum show rule depth exceeded". Fix by reusing `it` and not
       re-creating strong:  #show strong: it => underline(it)
       (underline wraps the given strong element; no new strong is built.)
10.5 - #let note(body) = {
         set page(width: 12cm, height: auto, margin: 1.5cm)
         set par(justify: true)
         show heading: set text(fill: navy)
         show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
         body
       }
       #show: note
       Then some headings + body with acronyms. This is exactly the ch19
       template shape; any wrapper that applies the four effects passes.
-->
