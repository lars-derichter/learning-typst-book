# References and cross-references

Open any book you wrote in a word processor and go hunting for the phrase "see
Figure 4 above." Odds are decent that Figure 4 is now Figure 6, sitting below
the sentence that points up at it, and that nobody noticed for two drafts. Every
hand-typed number in a long document is a small promise to keep it up to date,
and every one of those promises eventually gets broken, usually at the worst
moment — the reviewer's copy, the printed proof.

Typst does not make you type the numbers. You already saw the trick twice: in
[Chapter 6](06-figures-and-images.md) you labelled a figure and pointed at it
with `@fig:name`, and in [Chapter 8](08-math-and-equations.md) you did the same
with an equation. This chapter is where that becomes a full toolkit. You'll
label *anything* worth pointing at — headings, figures,
tables, equations — reference it from anywhere, bend the wording to taste, and
then let Typst build a table of contents and a list of figures from the same
information, all of it correct by construction and all of it in one compile.

## Labels: naming a thing

A **label** is a name you pin to a piece of your document so you can refer back
to it later. You write it in angle brackets, and it attaches to whatever comes
*immediately before* it:

```typ
= Introduction <sec:intro>
```

That's a heading called `sec:intro`. The label itself prints nothing; it's an
invisible handle. Attach one to a figure and you write it after the closing
parenthesis; attach one to a display equation and it goes after the closing
dollar sign:

```typ
#figure(image("chart.svg"), caption: [Revenue.]) <fig:revenue>

$ e^(i pi) + 1 = 0 $ <eq:euler>
```

Four kinds of thing can be labelled *and* usefully referenced: headings,
figures, tables (which are figures — Chapter 6), and equations. Those are the
elements Typst knows how to number, and a reference is really just a way of
printing a number you didn't have to type.

All your labels live in one shared namespace. A heading, a figure, and an
equation cannot all be called `<results>` — the second one is a collision. That
is why you keep seeing those little prefixes: `sec:` for a section heading,
`fig:` for a figure, `tbl:` for a table, `eq:` for an equation. They are pure
convention. Typst attaches no meaning to them and would take `<banana>` just as
happily. But they keep your names unique and they tell *you*, six months later,
what a label points at. Use them.

> [!IMPORTANT]
> The prefix is decoration; the number comes from what the label is attached to.
> Pin `<fig:x>` onto an equation and a reference to it prints "Equation 3," not
> "Figure" anything. The label's spelling never overrides the thing's real
> nature.

## Referencing: `@name` and `#ref`

To point at a label, put an `@` in front of its name:

```typ
The measurements are collected in @fig:revenue.
```

That renders as "Figure 3" (or whatever number the figure lands on), typeset as
a live, clickable link straight to the figure. Two ingredients go into it: a
**supplement** — the word "Figure" — and the **number**, both supplied for you.

`@name` is shorthand. The full function is `ref`, and the two are the same
thing:

```typ
... in @fig:revenue.
... in #ref(<fig:revenue>).
```

The `@` form is what you'll use ninety-nine times out of a hundred, because it
reads cleanly in the middle of a sentence. You reach for `#ref(...)` when you're
already inside code, or — the real reason it exists — when you want to pass it
an argument, which is the next section.

> [!WARNING]
> Reference a name you never defined and Typst stops with `label <y> does not
> exist in the document`. That's a feature: a broken cross-reference is a
> compile error you fix now, not a stale "Figure ??" a reader finds later. Mind
> the spelling, including the prefix.

## Referencing headings (numbering required)

Try to reference a heading and you may hit a wall:

```typ
= Introduction <sec:intro>
See @sec:intro.
```

```text
error: cannot reference heading without numbering
  hint: you can enable heading numbering with
        `#set heading(numbering: "1.")`
```

The reason is simple once you say it out loud: a reference prints a *number*,
and by default headings don't have one. Figures and equations come pre-numbered;
headings don't, until you ask. So you ask, once, at the top of the file:

```typ
#set heading(numbering: "1.")
```

That's the set rule from Chapter 9. The `"1."` is a numbering pattern —
top-level headings become 1, 2, 3; their subheadings 1.1, 1.2; and so on down.
With numbering switched on, `@sec:intro` springs to life and prints "Section 1,"
a link to the heading. Nest a subheading under it and `@sec:background` reads
"Section 1.1," tracking the outline structure exactly.

Why "Section" and not "Heading"? Because "Section" is the default *supplement*
for headings, the same way "Figure" is the default for figures. Which brings us
to how you change it.

`examples/056-labels-and-references/` puts all of this in one short document:
numbered headings at two levels, each labelled and referenced, plus a figure
reference for good measure, and the long `#ref(<sec:results>)` form alongside
the `@` shorthand.

## Supplements: the word before the number

The supplement is the label Typst prints ahead of the number — "Figure,"
"Table," "Equation," "Section." You bend it in two places, depending on how wide
you want the change to reach.

For **one reference**, pass `supplement` to `ref`. This is the argument that
`@` can't take, so you drop to the function form:

```typ
See #ref(<fig:revenue>, supplement: [Fig.]).
```

That single mention prints "Fig. 3"; every other reference to the same figure is
untouched. Handy inside a tight parenthetical where the full word would crowd
the line.

For **every reference to a kind of element**, and for the captions too, set the
supplement on the element itself:

```typ
#set heading(supplement: [Chapter])
#set figure(supplement: [Illustration])
```

Now all heading references read "Chapter 1," and every figure — in its caption
*and* in every reference — reads "Illustration 1." The set rule changes the
element's identity across the whole document; the per-reference `supplement`
overrides it for a single mention. A local override always beats the global
setting, so you can set "Illustration" everywhere and still shorten one stubborn
reference to "Fig."

`examples/057-supplements/` sets both globals and then overrides one figure
reference back to "Fig.," so you can watch the layers stack: caption, default
reference, and the one-off override, side by side.

> [!TIP]
> The supplement takes content, not just a string, so it can hold anything a
> caption can: `supplement: [Fig.]`, `supplement: [Abb.]` for a German document,
> even `supplement: [§]` if you want references that read "§ 1." Whatever you
> put there, it appears before the number.

## Customizing every reference

Setting the supplement changes the *word*. Sometimes you want to change the
whole *look* — colour every reference, box it, drop the supplement and keep only
the number. For that you write a show rule on `ref`, exactly the way
[Chapter 10](10-show-rules.md) showed you show rules on headings:

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

Two things earn their keep here. The parameter `it` is the reference, and
inside the rule `it.element` hands you the actual thing being referenced — the
figure, the heading — so you can look at it and decide. Here `el.func() ==
figure` asks "is this a reference to a figure?" and styles those differently
from everything else. The rest of the reference machinery still runs: because
each branch ends by rendering `it`, the supplement and number you'd normally get
are produced for you, and you're only wrapping them in a box or a colour. You
change the packaging, not the contents.

`examples/060-customizing-references/` runs this rule over a document with two
heading references and a figure reference, so the grey figure chip and the blue
heading links show up together.

> [!NOTE]
> `it.element` can be `none` — for the odd reference that resolves to something
> without an element behind it — which is why the rule guards with `el != none`
> before poking at it. Inspecting `it.element` is your window into *what* is
> being referenced; leaning on it too hard drifts into Chapter 17's territory of
> context and locations, but a simple `func()` check like this stays well inside
> what you know now.

## Outlines: the table of contents

A cross-reference points at one thing. An **outline** points at all of them at
once — it's how Typst builds a table of contents. One function call, no
arguments required:

```typ
#outline()
```

Drop that near the top of a document with numbered headings and you get a
contents list: every heading, in order, with its number, a row of dots, and the
page it's on. It reads the same heading structure your references do, so the
numbers in the table of contents and the numbers in the text always agree.

Three arguments cover almost everything you'll want to adjust:

```typ
#outline(
  title: [Contents],   // the heading over the list (default: "Contents")
  depth: 2,            // include headings down to level 2 only
  indent: 2em,         // how far each level is indented from the last
)
```

`title` sets the words at the top — pass `title: none` to drop it entirely.
`depth` limits how deep the outline goes: `depth: 2` lists parts and chapters
but leaves the level-3 subsections out, which keeps a contents page from
sprawling. `indent` controls the staircase; give it a length like `2em` for a
fixed step, and each level of heading sits that much further right than its
parent.

> [!IMPORTANT]
> The outline reflects heading numbering. Switch numbering off and the entries
> lose their `1.`, `1.1.` prefixes — the list still builds, but flat and
> unnumbered. If your contents page looks bare, check whether
> `#set heading(numbering: "1.")` is present.

`examples/058-table-of-contents/` sets a small page and pours in `#lorem` filler
so the body runs across four pages, with `depth: 2` trimming a lone level-3
heading out of the contents. It's the whole loop in miniature: numbered
headings, an outline that finds them, and page numbers that point where they
should.

## Lists of figures and tables

Here's the part that surprises people. `#outline()` isn't wired specifically to
headings — headings are just its *default target*. Point it at a different kind
of element and it collects those instead. Aim it at figures and you get a list
of figures:

```typ
#outline(title: [List of figures], target: figure)
```

That walks the document, gathers every figure, and lists each one by its
supplement, number, and caption — exactly the "List of Figures" page you'd flip
to in a printed book. `examples/059-list-of-figures/` builds one from three
captioned shapes.

Tables are figures too, so a list of *tables* is the same call with a narrower
target. `figure.where(kind: table)` means "figures whose kind is table," which
is precisely the tables and none of the images:

```typ
#outline(title: [List of tables], target: figure.where(kind: table))
```

Swap `table` for `image` and you'd get only the picture figures; swap in a
custom `kind` you defined back in Chapter 6 and you'd get a list of just those.
One function, retargeted, produces every "list of ..." a document could want.

## Coming from LaTeX

> **Coming from LaTeX.** The vocabulary maps almost one to one, minus the
> paperwork. `\label{x}` becomes `<x>`, and it attaches to the preceding element
> instead of needing to sit inside the float. `\ref{x}` becomes `@x`, and it
> already carries its supplement, so you rarely write the "Figure" by hand the
> way you did with `Figure~\ref{x}`. `\tableofcontents` becomes `#outline()`,
> `\listoffigures` becomes `#outline(target: figure)`.
>
> The part that feels like magic is what's *gone*. No `.aux` file. No "Rerun to
> get cross-references right" warning. No compiling twice — or three times, when
> the page numbers shift the layout, which shifts the page numbers. Typst
> resolves every reference and every outline in a single pass, so the numbers
> are right the first time, every time. `\pageref`, if you're wondering, lives
> inside `it.element`'s location and belongs to Chapter 17; for now, the number
> and the link cover what `\ref` and `\pageref` did between them.

## The whole point: they never lie

Step back and notice what you no longer do. You don't type figure numbers. You
don't type section numbers. You don't type page numbers into a contents list.
You attach names, you point at names, and Typst counts.

So when you move Section 3 above Section 1, every reference to it renumbers,
the table of contents reorders, the page numbers update, and the list of
figures re-sorts — because all of them were computed from the document's real
structure, not copied out of it by a tired human at 2 a.m. A cross-reference in
Typst is not a note about where something *was*. It's a live question, asked
fresh at every compile: *where is this now?* The answer is always current,
because there's no cached copy to fall out of date.

That is the entire pitch of automated cross-referencing, and you now have all
of it.

## What you've got

You can now point at anything and trust the numbers:

- **Label** any heading, figure, table, or equation with `<name>`, attached to
  the element just before it, and keep names unique with `sec:` / `fig:` /
  `tbl:` / `eq:` prefixes drawn from one shared namespace.
- **Reference** it with `@name` in prose, or `#ref(<name>)` in code — a live,
  clickable supplement-plus-number that errors loudly if the label is missing.
- **Number headings** with `#set heading(numbering: "1.")`, which references to
  headings require, and which drives their "Section N" numbers.
- **Change the supplement** per reference with
  `#ref(<name>, supplement: [Fig.])` or globally with
  `#set figure(supplement: [...])` — local beats global.
- **Restyle every reference** with `#show ref: it => {...}`, inspecting
  `it.element` to treat different kinds differently while keeping the automatic
  number.
- **Build a table of contents** with `#outline()`, tuned by `title`, `depth`,
  and `indent`, reflecting your heading numbering.
- **Build a list of figures or tables** by retargeting the same function:
  `#outline(target: figure)` and `target: figure.where(kind: table)`.
- **Reorganize fearlessly**, knowing every number, link, and list recomputes in
  one compile, with no `.aux` files and no second pass.

Next, in Chapter 12, we point references outward: citations and bibliographies,
where the same "name it, cite it, let the tool format it" idea handles the
literature instead of your own figures.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

11.1. Write a document with three top-level headings. Try to reference the first
one with `@sec:one` *before* turning on numbering, and read the error Typst
gives you. Then add `#set heading(numbering: "1.")`, recompile, and confirm the
reference now prints "Section 1."

11.2. Give one of those headings a subheading and label it `<sec:sub>`.
Reference it and confirm you get "Section 1.1." Then reorder the two top-level
headings (cut one, paste it above the other) and recompile — verify the numbers
in your references followed the move on their own.

11.3. Add a figure (a drawn shape is fine) labelled `<fig:demo>` and reference
it twice: once as a plain `@fig:demo`, and once as `#ref(<fig:demo>, supplement:
[Fig.])`. Confirm the first reads "Figure 1" and the second "Fig. 1," and that
changing `#set figure(supplement: [Diagram])` at the top changes the first but
leaves your "Fig." override alone.

11.4. Take a document with at least four headings across two levels and add
`#outline()`. Then constrain it with `depth: 1` and confirm the subheadings drop
out of the contents. Add a couple of captioned figures and a second outline,
`#outline(title: [Figures], target: figure)`, and confirm both lists build from
the same source.

11.5. *(Stretch.)* Write a `#show ref: it => {...}` rule that renders heading
references and figure references differently — for instance, headings in one
colour and figures wrapped in a small box — by branching on
`it.element.func()`. Keep the automatic number working by ending each branch
with `it`. Confirm the rule leaves the numbers correct while changing only how
they look.

<!--
SOLUTIONS (notes for the appendix author):
11.1 - Without numbering, `@sec:one` errors with "cannot reference heading
       without numbering" (hint suggests `#set heading(numbering: "1.")`). After
       adding that set rule, the reference prints "Section 1" as a link.
       "Section" is the default heading supplement. Mirrors example 056.
11.2 - `== Sub <sec:sub>` under the first heading; `@sec:sub` -> "Section 1.1".
       Reordering the two top-level headings renumbers everything: the moved
       heading and all references to it update in one compile. Point: references
       track the label/structure, not a typed number.
11.3 - `#figure(rect(width: 3cm), caption: [...]) <fig:demo>`. `@fig:demo` ->
       "Figure 1"; `#ref(<fig:demo>, supplement: [Fig.])` -> "Fig. 1". Adding
       `#set figure(supplement: [Diagram])` makes the plain reference AND the
       caption read "Diagram 1", but the per-reference `supplement: [Fig.]`
       override still wins for that one mention (local beats global). Mirrors
       example 057.
11.4 - `#outline()` lists all headings; `#outline(depth: 1)` lists only level-1
       headings (subheadings drop out). `#outline(target: figure)` lists the
       figures by caption. Both read the same document structure. Needs
       `#set heading(numbering: "1.")` for numbered entries. Mirrors examples
       058 and 059.
11.5 - Something like:
         #show ref: it => {
           let el = it.element
           if el != none and el.func() == figure {
             box(fill: luma(235), inset: (x: 4pt), radius: 2pt, it)
           } else {
             text(fill: blue, weight: "bold", it)
           }
         }
       Key points: `it.element` is the referenced element; `.func()` identifies
       its kind; ending each branch with `it` keeps the default
       supplement+number so only the styling changes. Guard with `el != none`.
       Mirrors example 060.
-->
