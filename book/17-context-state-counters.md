# Context, state, and counters

Here is a footer that lies:

```typ
#set page(footer: [Page 3 of 12])
```

It might be right. On page three of a twelve-page document, briefly, it is
even true. Then you add a paragraph, the document spills onto a thirteenth
page, and every footer in the book is quietly wrong. The number `12` was a
promise you had no business making, because when you typed it the document
wasn't finished, and a document's page count is a fact about the *finished*
thing.

This is the knot the whole chapter unties. Some values simply cannot be known
while you're writing the line that needs them. What page am I on? How many
figures come before this one? How many pages are there in total? Each answer
depends on the layout — on where things actually land once Typst has done the
fussy work of filling pages. And the layout doesn't exist yet when Typst is
reading your source top to bottom.

Typst's escape from this is almost cheeky: it lays the whole document out with
placeholders where those values go, reads the real numbers off the finished
layout, and runs the layout *again* with the numbers filled in. If the second
pass shifts anything, it goes round once more. It keeps going until the numbers
stop changing. You met the front door of this machinery back in Chapter 5,
where a hand-built footer used `context counter(page).display()` and we
promised the full story later. This is later.

## The value you can't have yet

Try to print the current page number the obvious way and Typst stops you:

```typ
Page #counter(page).display()
```

```text
error: can only be used when context is known
  = hint: try wrapping this in a `context` expression
```

`counter(page)` is the running tally of pages, and `.display()` renders it —
but *which* page? The answer depends on where this text lands, and at the
moment Typst reads the line, that isn't settled. So it refuses to guess.

The fix is the `context` keyword:

```typ
Page #context counter(page).display()
```

`#context <expression>` means "don't evaluate this yet — wait until you know
where we are, then run it." Inside that expression you may read
layout-dependent values; outside it you may not. That's the entire rule. The
error above is just Typst telling you that you stepped outside the fence.

You can wrap a single expression, as above, or a whole block of content:

```typ
#context [
  This is page #counter(page).display(), and there's more
  ordinary markup in here too.
]
```

Everything inside is evaluated once the context is known, so anything in there
can ask position-dependent questions.

The most basic question of all is "where am I?", and `here()` answers it. It
hands back a *location* — an opaque token marking this exact spot — and you can
ask that location things:

```typ
#context [We're on page #here().page(),
  #here().position().y down the page.]
```

`here().page()` gives the page number as an integer; `here().position()` gives
a dictionary with `page`, `x`, and `y`, the last two being real lengths from
the top-left corner. `examples/089-context-basics/` runs this over two pages,
and the same source line prints "page 1" on the first and "page 2" on the
second — proof that the expression really is evaluated fresh at each spot.

> [!NOTE]
> `context` is not a loop or a delay you can feel. Typst still compiles in
> milliseconds. Think of it less as "run this later" and more as "run this
> where it belongs" — the difference between reading a thermometer and reading
> a thermometer *in a specific room*.

## Counters

A counter is a number Typst maintains for you as it walks the document. You've
been benefiting from several without knowing their names. `counter(page)`
counts pages. `counter(heading)` counts headings — it's what puts the "2.1" in
front of a numbered subsection. `counter(figure)` is why figures say "Figure
4". Each is summoned by handing `counter` the element you want counted.

Every counter answers the same small vocabulary of questions, all of which
need `context` because all of them depend on position:

- `.display()` renders the current value. Give it a numbering pattern to
  choose the style — `.display("i")` for roman numerals, `.display("A")` for
  uppercase letters, just like the `numbering` patterns from Chapter 5.
- `.get()` returns the current value as an array of numbers (an array, because
  a counter can have levels, like `1.2.3`). For a simple counter, `.get()` is
  `(3,)` and `.get().first()` is `3`.
- `.at(loc)` returns the value at some *other* location, not just "here".
- `.final()` returns the value at the very end of the document.

And two that *change* the counter rather than read it — these don't need
`context`, because setting a value doesn't depend on layout:

- `.step()` bumps the counter by one.
- `.update(n)` sets it to `n`; `.update(x => x + 2)` sets it via a function of
  the old value. (That `x => x + 2` is a closure, from Chapter 14.)

### Page X of Y

Now the honest version of the footer we started with. The current page is
`counter(page).display()`; the total is `counter(page).final()`, the value at
the end of the document. `.final()` returns an array, so `.first()` pulls the
number out:

```typ
#set page(footer: context [
  #set align(center)
  Page #counter(page).display() of #counter(page).final().first()
])
```

That footer is correct on every page, forever, because there's no `12`
hard-coded anywhere — Typst lays the document out, discovers the real total,
and fills it in on the next pass. `examples/090-page-x-of-y/` runs it over
three pages, and the footers read "Page 1 of 3", "2 of 3", "3 of 3", exactly
as they should.

> [!TIP]
> There's a shorthand for this. `counter(page).display("1 of 1", both: true)`
> prints the current page *and* the final total in one call, substituting both
> into the pattern — so `"1 of 1"` becomes "3 of 3". Handy, though the
> spelled-out version above shows what's actually happening.

### Your own counter

The built-in counters count Typst's own elements. But you can invent one by
passing a *name* — any string you like — instead of an element:

```typ
#let thm = counter("theorem")
```

`counter("theorem")` is now a counter that nobody but you touches. Wrap a step
and a display in a small helper and every theorem numbers itself:

```typ
#let theorem(body) = {
  thm.step()
  block(inset: 8pt, stroke: 0.5pt + gray, radius: 3pt)[
    *Theorem #context thm.display().* #body
  ]
}

#theorem[The angles of a triangle sum to a straight angle.]
#theorem[There are infinitely many prime numbers.]
```

The first renders "Theorem 1", the second "Theorem 2", and if you slip a new
one in between them tomorrow, the rest renumber without you lifting a finger.
That's the whole point of a counter over a hand-typed number: it's a single
source of truth that stays true. `examples/091-custom-counter/` sets three of
them in bordered boxes.

> [!NOTE]
> `.step()` and `.update()` sit *outside* the `context` in that helper, and
> `.display()` sits *inside* one. That split is the pattern to remember:
> changing a counter is a plain instruction Typst can carry out immediately;
> reading a counter is a question about position and needs a context to answer.

### The end, from the beginning

`.final()` earns a second look, because it does something that ought to be
impossible. It reads a value from the end of the document and lets you use it
at the *start*:

```typ
#context [This worksheet has #ex.final().first() exercises.]
```

Put that line above your exercises, before a single one has been written in the
source, and it still prints the right total. Typst can't know the number on the
first pass — so it leaves a blank, finishes laying out, counts the exercises it
found, and comes back to fill in the blank on the next pass.
`examples/094-final-total/` prints "This worksheet has 4 exercises" up top,
above four exercises that only appear afterward. Reading the future is just
iteration wearing a disguise.

## State

A counter is a number that only ever goes up by one. Sometimes you want a value
that can be anything and can change to anything — a title, a color, a running
subtotal. That's `state`:

```typ
#let part = state("part", "Part I — Basics")
```

`state` takes a name and an initial value. From then on it behaves like a
counter's more flexible cousin: `.update(...)` changes it (to a value, or via a
function of the old value), and inside `context`, `.get()` reads it, `.at(loc)`
reads it elsewhere, and `.final()` reads it at the end.

The classic use is a running header that names the current section. Here's the
shape of it:

```typ
#set page(header: context [
  #emph(part.get()) #h(1fr) #counter(page).display()
])

= Warm-up
#lorem(30)

#part.update("Part II — Practice")
#pagebreak()
= Drills
```

The header reads `part.get()` and prints whatever the state currently holds. On
page one that's the initial "Part I — Basics"; after the update it's "Part II —
Practice". `examples/092-state-basics/` runs it, and the header changes from one
part to the next right where you'd want it to.

There's a subtlety hiding in that example, and it's worth seeing clearly
because it trips people up.

> [!WARNING]
> A header reads state as of the **top** of its page, not the bottom. If you
> put `#part.update(...)` in the *middle* of a page, that page's header won't
> see it yet — the update happens below where the header was drawn. That's why
> the example updates the state and *then* breaks the page: the change lands at
> the very end of page one, so page two's header, drawn at the top, already has
> the new value. Update-then-break is the reliable order. (For a header that
> must track sections starting mid-page, you'll want `query`, a Chapter 21
> tool.)

### When it won't settle

The iterate-until-stable trick has an obvious failure mode, and Typst is candid
about it. If a value depends on itself in a way that never stops changing, the
passes never agree, and after five tries Typst gives up:

```typ
#let s = state("s", 1)
#context s.update(s.final() + 1)   // don't do this
```

Read that update: set `s` to one more than its own final value. But changing
`s` changes its final value, which changes the update, which changes the final
value… Each pass makes the number bigger, forever. Typst runs five rounds,
watches `1, 2, 3, 4, 5` march past without settling, and prints:

```text
warning: document did not converge within five attempts
warning: value of `state("s")` did not converge
```

The document still compiles — you get *a* number — but it's meaningless, and
the warning is telling you so. The cure is always the same: make sure a value
never depends, however indirectly, on its own final result. Counters and states
are for reading layout, not for feeding themselves.

## measure and layout

The contextual values so far all answer "where am I in the document?" Two more
tools answer a different question — "how big is this, and how much room do I
have?" — and they round out the chapter.

`measure` tells you a piece of content's size *before* it's placed:

```typ
#context {
  let size = measure[A considerably longer heading]
  size.width   // a length, e.g. 118pt
}
```

It hands back a dictionary with `.width` and `.height`. That lets you size
something to fit its own contents — for instance, draw a rule exactly as wide
as the text above it:

```typ
#let ruled(body) = context {
  let size = measure(body)
  stack(spacing: 3pt,
    body,
    line(length: size.width, stroke: 1.5pt + orange))
}
```

Short text gets a short rule, long text a long one, each underline matched to
its own words. `examples/093-measure-and-layout/` shows two of them stacked.

`layout` comes at it from the other side. Instead of measuring your content, it
tells you the size of the *region* your content is about to fill, and lets the
content adapt:

```typ
#layout(size => {
  if size.width < 5cm {
    // narrow: stack the tags vertically
  } else {
    // wide: lay them in a row
  }
})
```

`layout` takes a function; Typst calls it with the available `size` and uses
whatever content comes back. The same block of tags in the example sits in a
tidy row at full page width but stacks into a column inside a four-centimeter
box — responsive layout, decided at compile time by the room actually
available.

> [!NOTE]
> `layout` establishes its own context, so you don't write `context` in front
> of it — the `size` it hands you is already a resolved, contextual value.
> `measure`, by contrast, reads the surrounding context, so it needs a
> `context` around it like everything else in this chapter.

## Tying it together

Step back and the whole of Typst's "magic" is this one idea wearing different
hats. The running header that knows its chapter: state. "Figure 7" and "Table
3": counters, stepped by show rules you'll write in Chapter 10's spirit. The
table of contents with correct page numbers: counters read with `.at()`. "Page
4 of 20": a counter and its `.final()`. A box that hugs its caption: `measure`.
A template that reflows for a narrow column: `layout`. All of it rests on the
same bargain — Typst lays the document out, reads the truth off the result, and
goes round again until the truth stops moving.

You've been living inside that bargain since Chapter 1. Now you can write your
own clauses.

> **Coming from LaTeX.** This chapter quietly replaces a whole shelf of LaTeX
> machinery. `\thepage` and friends, `\newcounter`/`\stepcounter`/`\the...`,
> the `\label`–`\ref`–`\pageref` trio, and above all the notorious two-pass
> dance where LaTeX writes numbers into an `.aux` file on one run and reads them
> back on the next (so you compile twice, or three times, and learn to ignore
> "Rerun to get cross-references right"). Typst folds every bit of that into
> `context` plus counters and state, and does the iterating itself, invisibly,
> in a single command. No `.aux`, no rerun, no guessing how many passes you
> need. You just ask for the value inside a `context` and Typst makes sure it's
> the right one.

## What you've got

You can now reach the values that depend on the finished page:

- **`context`** — `#context <expr>` defers a read until Typst knows *where* it
  is. Layout-dependent values live inside it; outside it, they're an error.
- **`here()`** — the current location, with `.page()` and `.position()` for the
  page number and coordinates.
- **Counters** — `counter(page)`, `counter(heading)`, and custom
  `counter("name")`, with `.step()`, `.update()`, `.display()`, `.get()`,
  `.at(loc)`, and `.final()`.
- **"Page X of Y"** — `counter(page).display()` with `counter(page).final()`,
  or the `.display("1 of 1", both: true)` shorthand.
- **State** — `state("name", initial)` for values that vary through the
  document, with `.update()`, `.get()`, `.at()`, and `.final()`, and the
  update-then-break rule for headers.
- **Convergence** — Typst iterates until values settle, and warns when they
  never do; never let a value depend on its own final result.
- **`measure` and `layout`** — the size of a piece of content, and the size of
  the room it's landing in, for content that fits and adapts.

That's the last hard idea in Part IV, and the engine behind an enormous amount
of what Typst does for you. Part V puts it to work: your own functions
(Chapter 18), templates (Chapter 19), and packages (Chapter 20) all lean on
this chapter to build things that number, label, and lay themselves out.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

17.1. Make a two-page document with a small fixed page size. In the body of
each page, print a sentence that names the current page number using
`#context counter(page).display()`. Confirm the first page says "1" and the
second says "2" — from the same source line if you can arrange it.

17.2. Build a footer that reads "p. X / Y" — current page, a slash, total pages
— centered, using `counter(page).display()` and `counter(page).final()`. Give
the document at least three pages and check every footer.

17.3. Define a custom counter `counter("figure-note")` and a helper `note(body)`
that steps it and prints "Note 1", "Note 2", … in bold ahead of the body. Set
four notes and confirm they number 1 through 4. Then move the third note above
the first and confirm they renumber themselves.

17.4. Add a summary line at the *top* of the document from 17.3 that reads "This
page has N notes", where N is filled in with `.final()`. Explain, in one
sentence, how a number from the end of the document can appear at the top.

17.5. *(Stretch.)* Give a document a running header showing the current section
title via `state`. Use two sections, each starting on its own page, and get the
header right on both pages — including the subtlety about *when* the state
update has to happen relative to the page break. Then, for extra credit,
deliberately break it: write a `state` whose update depends on its own
`.final()`, compile, and read the convergence warning Typst gives you.

<!--
SOLUTIONS (notes for the appendix author):

17.1 - #set page(width: 9cm, height: 6cm, margin: 1cm)
       Some text. #context [This is page #counter(page).display().]
       #pagebreak()
       #context [This is page #counter(page).display().]
       Same source line on both pages prints "1" then "2". Point: context is
       evaluated per-location, so one line yields two answers. Mirrors
       examples/089-context-basics/.

17.2 - #set page(width: 9cm, height: 7cm, margin: 1cm, footer: context [
         #set align(center)
         p. #counter(page).display() / #counter(page).final().first()
       ])
       then #lorem(40) #pagebreak() #lorem(40) #pagebreak() #lorem(20).
       Footers read "p. 1 / 3", "p. 2 / 3", "p. 3 / 3". .final() returns an
       array; .first() (or .at(0)) pulls the integer. Accept the
       .display("1 / 1", both: true) shorthand as an alternative. Mirrors
       examples/090-page-x-of-y/.

17.3 - #let fn = counter("figure-note")
       #let note(body) = { fn.step(); [*Note #context fn.display().* #body] }
       Four notes -> "Note 1"..."Note 4". step() outside context, display()
       inside. Reordering the source reorders the numbers automatically because
       the counter is stepped in document order, not by hand. Mirrors
       examples/091-custom-counter/.

17.4 - Prepend: #context [This page has #fn.final().first() notes.]
       One-sentence explanation: Typst lays the document out to discover the
       counter's final value, then makes another pass to fill that value into
       the line at the top — the "future" number is available because the whole
       document is laid out (iterated) before the final PDF is emitted. Mirrors
       examples/094-final-total/.

17.5 - #let sec = state("section", "Introduction")
       #set page(..., header: context emph(sec.get()))
       = Introduction ... then sec.update("Methods"); #pagebreak(); = Methods
       KEY teaching point: the update must come BEFORE the pagebreak so the new
       value is in effect at the top of page two, where the header is drawn.
       Initialize the state with the first section's title so page one's header
       is right too. Mirrors examples/092-state-basics/.
       Break-it part: #let s = state("s", 1)
                      #context s.update(s.final() + 1)
                      #context s.get()
       Compiles with a warning "document did not converge within five attempts"
       / "value of `state(\"s\")` did not converge", listing the observed
       values 1,2,3,4,5,final 6. The moral: a value must never depend on its own
       final result.
-->
