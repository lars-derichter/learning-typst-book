# Set rules

You have been using set rules for five chapters. Every time you wrote `#set
text(font: "New Computer Modern")` to pick a typeface, or `#set par(justify:
true)` to square off the right margin, or `#set page(margin: 2cm)` to give a
document room to breathe, you reached for the same tool without anyone naming it
properly. That was deliberate. Set rules are so useful that waiting until you
had the whole model before writing a single one would have left you mute for a
hundred pages.

Now you have earned the model. This chapter is the whole picture: what a set
rule actually *is*, exactly how far its reach extends, and the handful of them
you will use every day. It is the first of the two big ideas that turn Typst
from a markup language into a styling engine. The second — show rules — is the
next chapter, and the two are companions. Set rules configure; show rules
transform. Get set rules solid here and the next chapter has half its work done
already.

## What a set rule actually is

Start with the two ways to style a piece of text, side by side. You met both in
Chapter 4:

```typ
The word #text(fill: red)[danger] stands out.

#set text(fill: red)
Now every word is red.
```

These look similar and do entirely different things. The first is a **direct
call**: `#text(...)` is a function, you hand it some content in brackets, and it
gives that content — and *only* that content — a red fill. The word "danger"
turns red; the rest of the sentence does not. When the brackets close, the
effect is over.

The second is a **set rule**. It has no content in brackets, and that absence is
the whole point. A set rule does not style anything directly. Instead it changes
a *default*. Read `#set text(fill: red)` as a sentence: "from here on, the
default fill for text is red." Every stretch of text that comes after it
inherits that new default, until something says otherwise. You are not colouring
one word; you are reaching into the machine and turning the "text colour" dial,
and every character printed after the turn comes out in the new colour.

That distinction — one-shot versus reconfigure-the-default — is the thing to
hold onto. A direct call is a verb: *do this, now, to this content*. A set rule
is a setting: *change what "normal" means from this point forward*.
`examples/045-a-first-set-rule/` puts two set rules at the top of a short
document and lets the whole thing repaint itself, without a single word styled
by hand.

> [!IMPORTANT]
> A set rule affects everything *after* it, never anything before it, and never
> the set rule's own line. If a paragraph looks wrong, the rule that governs it
> is somewhere *above* it in the file. Read upward.

### The anatomy

Every set rule has the same shape:

```typ
#set element(parameter: value)
```

- `#set` is the keyword that says "I am configuring a default, not calling a
  function."
- `element` is the *function* whose defaults you are changing — `text`, `par`,
  `page`, `heading`, `list`, and so on. These are the same functions you can
  call directly; a set rule just changes their defaults instead of invoking
  them.
- Inside the parentheses go the named parameters you want to change, and only
  those. Parameters you leave out keep whatever value they already had.

That last point matters more than it looks. Set rules are *additive per
parameter*. Two set rules on the same element don't wipe each other out; each
one only touches the parameters it names:

```typ
#set text(size: 12pt)
#set text(fill: navy)
```

After both lines, text is twelve-point *and* navy. The second rule changed the
fill and left the size alone. You can also fold them into one call — `#set
text(size: 12pt, fill: navy)` — which is tidier when you're setting several
things at once. Both styles are common; pick whichever reads better in the
moment.

## Where a set rule reaches

A set rule applies from where you write it to the end of the *enclosing block*.
What counts as "the enclosing block" is the entire trick, and it's simpler than
it sounds.

At the **top level** of your file — not inside any brackets or braces — a set
rule reaches to the end of the document. This is the common case. A `#set
text(...)` on line 1 governs the whole file, which is exactly why the advice is
to configure defaults near the top.

Inside a **content block** `[...]` or a **code block** `{...}`, a set rule is
*local*: it reaches only to the closing bracket. The moment the block ends, the
default snaps back to whatever it was outside. This is what lets you change a
default for just one section and no further:

```typ
This line uses the document defaults.

#[
  #set text(fill: blue, style: "italic")
  This block is blue and italic.
]

And this line is back to the defaults.
```

The set rule lives inside the square brackets, so it governs only what's inside
them. The text before is untouched (the rule hadn't happened yet); the text
after is untouched (the block has closed and the default has reverted).
`examples/048-scope-of-a-set-rule/` is exactly this, with plain lines top and
bottom to prove the middle block is the only thing that changed.

This scoping is not a limitation to work around — it's the mechanism that makes
localized styling clean. Want one appendix in a smaller font, or one quoted
passage in italics, without disturbing the rest? Wrap it in a content block, set
the default inside, and the change is sealed in.

> [!TIP]
> If you want a run of content styled locally but you're already deep in markup,
> remember that `[...]` is just a content block you can drop in anywhere. Open a
> bracket, put your `#set` on the first line, write the passage, close the
> bracket. The style is contained.

## A tour of the set rules you'll actually use

There are many settable elements, but a working writer leans on a small core.
Here is that core, with a pointer back to the chapter where each element got its
proper treatment. Nothing below is new — it's the same functions you already
know, seen now through the set-rule lens.

**`#set text(...)`** — the typeface, size, weight, colour, language, and every
other property of type (Chapter 4). The workhorse. A document almost always
opens with one.

```typ
#set text(font: "New Computer Modern", size: 11pt, lang: "en")
```

**`#set par(...)`** — paragraph shape: justification, line spacing (`leading`),
first-line indent, and the space *between* paragraphs (`spacing`) (Chapter 5).

```typ
#set par(justify: true, leading: 0.75em, first-line-indent: 1em)
```

**`#set page(...)`** — paper size, margins, columns, headers and footers, page
numbering (Chapter 5). A set-page rule takes effect from the current page
onward, so like the others it belongs near the top.

```typ
#set page(paper: "a4", margin: 2.5cm, numbering: "1")
```

**`#set heading(numbering: ...)`** — switch on automatic heading numbers
(Chapter 3 introduced headings; the numbering is here). One rule and Typst
counts your sections for you — `1`, `1.1`, `2`, `2.1` — updating every number
when you reorder or insert:

```typ
#set heading(numbering: "1.")
```

`examples/046-heading-numbering/` shows the numbers appearing on a nested set of
headings, with no counting by hand.

**`#set list(marker: ...)`** and **`#set enum(numbering: ...)`** — the bullet on
an unordered list and the counter style on an ordered one (Chapter 3). Give
`list` one marker or a tuple that alternates by nesting depth; give `enum` a
numbering pattern:

```typ
#set list(marker: ([--], [·]))
#set enum(numbering: "a)")
```

`examples/047-list-and-enum-markers/` runs both, including a nested list so you
can watch the two markers alternate.

**`#set table(...)`** — default strokes, cell padding (`inset`), fills, and
column behaviour for every table below (Chapter 7). Set the house style once and
stop repeating it on each table:

```typ
#set table(stroke: 0.5pt + gray, inset: 8pt)
```

**`#set figure(...)`** and **`#set figure.caption(...)`** — figure numbering and
caption styling (Chapter 6). Note the dotted name: `figure.caption` is an
element in its own right, reachable by a set rule, so you can style captions
separately from the figures they sit under:

```typ
#set figure(numbering: "1")
#set figure.caption(separator: [ --- ])
```

**`#set block(...)`** and **`#set par(spacing: ...)`** — vertical rhythm.
`block` governs the space around block-level things (headings, figures, lists);
`par(spacing:)` governs the space between paragraphs specifically. When a
document feels cramped or loose, these two are the dials.

You do not need to memorize this list. You need to recognize the pattern:
*whatever you can call as a function, you can also configure with `#set`.* Find
the element, find its parameters in the reference, set the ones you care about.

## Numbering patterns, in one place

Headings, enumerations, figures, equations, and page numbers all share one
notation for *how to count*, so it's worth learning once. A numbering pattern is
usually a **string**, and inside that string a few characters are magic —
they're the counting symbols — while everything else is printed literally.

The counting symbols:

| Symbol | Counts as        | Sequence          |
| ------ | ---------------- | ----------------- |
| `1`    | Arabic numerals  | 1, 2, 3, …        |
| `a`    | lowercase letters| a, b, c, …        |
| `A`    | uppercase letters| A, B, C, …        |
| `i`    | lowercase Roman  | i, ii, iii, …     |
| `I`    | uppercase Roman  | I, II, III, …     |

Any other character in the pattern — a dot, a parenthesis, a space — is just
punctuation that gets printed around the count. So:

- `"1."` gives `1.`, `2.`, `3.` — the plainest choice, and the usual one for
  headings.
- `"1.1"` gives `1`, then `1.1`, `1.2` for the level below, `2`, `2.1`, and so
  on. The pattern describes *one full level's worth* of separators, and Typst
  extends it down the nesting.
- `"i."` gives `i.`, `ii.`, `iii.` — lowercase Roman, the traditional look for
  front-matter pages or sub-points.
- `"A."` gives `A.`, `B.`, `C.` — uppercase letters, common for appendices.
- `"(1)"` gives `(1)`, `(2)`, `(3)` — the parentheses are literal; only the `1`
  counts. This is the classic look for numbered equations (Chapter 8).

For anything a string can't express, the numbering can be a **function** instead
— you receive the level numbers and return whatever content you like:

```typ
#set heading(numbering: (..nums) => {
  let n = nums.pos()
  numbering("1.1", ..n) + [ · ]
})
```

The `(..nums)` collects however many level-counters Typst hands you;
`nums.pos()` turns them into an array; and you build the label from there. Most
days a plain string is all you want, but when a house style demands something no
string can say — Roman parts with Arabic chapters, a custom separator — the
function form is the escape hatch. We return to functions properly in Chapter
14; for now, just know the door exists.

> [!NOTE]
> The same patterns feed the `numbering` function directly: `#numbering("I.",
> 4)` prints `IV.`. That's occasionally handy on its own, but mostly you'll meet
> these patterns as the `numbering:` argument to a set rule.

## Setting a default only when a condition holds

Sometimes you want a default to apply *conditionally* — draft copies
double-spaced and stamped, final copies clean; a handout in a larger face than
the same content printed as a book. Typst has a compact form for this: append
`if` and a condition to a set rule.

```typ
#let draft = true

#set text(fill: red) if draft
#set par(leading: 1.5em) if draft

= Chapter one
#lorem(20)
```

Read it as: "make red text the default, *but only if* `draft` is true." Flip the
`draft` variable to `false` at the top and both rules simply don't fire — the
document reverts to ordinary black, single-ish spacing — without you deleting or
commenting out a thing. One flag, one switch, two behaviours.

The condition is any expression that evaluates to `true` or `false`, so this
composes with everything the language offers. A common pattern is a single
configuration flag near the top of the file that several conditional set rules
watch, so that toggling one value reshapes the whole document. That is precisely
the kind of switch a template exposes to its users — which is where we're headed
in Chapter 19.

> [!WARNING]
> The condition is evaluated once, where the rule sits, using the variables in
> scope at that point. `#set text(...) if draft` needs `draft` to already be
> defined above it. If Typst complains about an unknown variable, you've put the
> flag below the rule that reads it.

## The mental model to keep

Everything in this chapter collapses into one habit:

**Configure your defaults once, near the top. Reach for a direct call only for
one-offs.**

If two-thirds of your headings should be one colour, don't colour two-thirds of
them by hand — set the default and override the odd exception with a direct
call. If your whole document is eleven-point, say so once at the top, not
paragraph by paragraph. The direct call `#text(...)[...]` is for the single word
that must break the pattern; the set rule is for the pattern itself.
`examples/049-configuring-a-document/` is that habit in miniature: a stack of
set rules at the top, then a body of plain markup that inherits the lot.

This is also the right way to *read* someone else's Typst. The set rules near
the top are the document's design brief — its typeface, its margins, its
numbering scheme, its list style — all declared before the content starts. Skim
those and you know how the document will look before you've read a line of it.

Two forward pointers. Set rules can only change values that a parameter already
accepts — a colour, a size, a boolean. When you need to change the *structure*
of an element — wrap every heading in a coloured box, print figures with a rule
above the caption, replace a term with a link throughout — you want a **show
rule**, Chapter 10. Show rules transform; set rules configure. And when you've
assembled a satisfying stack of set rules and want to hand it to someone else —
or reuse it across a dozen documents — you bundle it into a **template**,
Chapter 19. A template is, to a first approximation, a well-chosen pile of set
rules with a nice front door.

> **Coming from LaTeX.** A set rule is the everyday job you'd reach for
> `\renewcommand`, `\setlength`, or a class-option for — changing a default like
> the section font, the list label, or the paragraph spacing. But there's no
> `\makeatletter`, no digging into a `.cls` file, no fear of clobbering an
> internal macro. You don't *redefine* the element; you hand its existing
> parameters new values, in the same syntax you'd use to call it. And scope is
> lexical and obvious: a rule inside `[...]` is local, the way a LaTeX group
> `{...}` scopes `\bfseries`, but without the ambient surprise of which commands
> happen to respect grouping.

> **Coming from Word.** A set rule is Word's *styles* done right. When you
> modify the "Normal" or "Heading 1" style in Word, every paragraph tagged with
> it updates — that's the good idea Word had. A set rule is the same idea,
> except the definition lives in your document as one readable line instead of
> buried in a dialog box, it applies by *element* (every heading, every list)
> rather than by a label you have to remember to click, and it changes precisely
> at the point in the text where you wrote it.

## What you've got

You now understand the first half of Typst's styling model:

- **What a set rule is** — `#set element(param: value)` changes the *default*
  for every following instance of that element, as opposed to a direct call
  `#element(...)[...]`, which styles only its own content.
- **Additivity** — set rules stack per parameter; a later rule overrides only
  the fields it names and leaves the rest intact.
- **Scope** — a set rule reaches from where it's written to the end of its
  enclosing block: document-wide at the top level, local inside `[...]` or
  `{...}` — which is how you restyle one section without touching the others.
- **The core set rules** — `text`, `par`, `page`, `heading`, `list`, `enum`,
  `table`, `figure`/`figure.caption`, and `block`, each tied back to the chapter
  that taught the element.
- **Numbering patterns** — the shared notation (`"1."`, `"1.1"`, `"i."`, `"A."`,
  `"(1)"`) for headings, enums, figures, and equations, plus the function form
  for when a string won't do.
- **Conditional set rules** — `#set … if <condition>` to make a default fire
  only when a flag is set, the seed of a configurable template.
- **The habit** — configure defaults once, near the top; use direct calls for
  one-offs; read a document's set rules as its design brief.

Next, show rules: the companion idea that lets you *transform* an element's
appearance and structure, not just adjust its settings.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

9.1. Write a short document (a heading and two paragraphs of `#lorem`) and, with
two set rules at the top, make the whole thing twelve-point New Computer Modern
with justified paragraphs. Confirm that adding a third paragraph inherits the
same styling with no extra work.

9.2. Take the document from 9.1 and turn on heading numbers with a single set
rule so the heading reads "1." before its title. Then add a sub-heading and
check that it numbers itself "1.1" automatically.

9.3. Set a custom bullet marker for lists and a lettered numbering (`a)`, `b)`,
`c)`) for enumerations, each with one set rule. Write one of each list to prove
they took effect.

9.4. Demonstrate scope. Write three lines: a normal line, then a content block
`[...]` containing a `#set text` rule that makes its text italic and coloured,
then another normal line. Compile it and confirm that only the middle block
changed — the first and third lines are untouched.

9.5. *(Stretch.)* Put a `draft` flag at the top of a document (`#let draft =
true`). Using conditional set rules, make the text larger and coloured *only*
when `draft` is true — and, as a second effect, loosen the line spacing. Compile
once with the flag `true` and once with it `false`, and confirm the document
snaps between a marked-up draft and a clean final with a single edit. (Optional:
add a page header that reads "DRAFT" only in draft mode — you'll need a show
rule or a direct call for the header content, so treat this as a bridge to
Chapter 10.)

<!--
SOLUTIONS (notes for the appendix author):
9.1 - At top: #set text(font: "New Computer Modern", size: 12pt) and
      #set par(justify: true). Body is plain markup (= heading, then #lorem(30)
      twice). Point: a set rule governs the whole document, so a third paragraph
      pasted anywhere below inherits the styling automatically. Mirrors
      examples/045-a-first-set-rule.
9.2 - Add #set heading(numbering: "1.") at the top. Top-level heading shows
      "1."; a == sub-heading shows "1.1" with no manual counting. Mirrors
      examples/046-heading-numbering. Watch that the rule is ABOVE the heading.
9.3 - #set list(marker: [--])  (any content works: [>], [·], sym.arrow.r)
      and #set enum(numbering: "a)"). Then a - bullet list and a + enum below.
      Mirrors examples/047-list-and-enum-markers. Marker can also be a tuple
      that alternates by nesting depth: ([--], [·]).
9.4 - Normal line; then #[ #set text(fill: blue, style: "italic")  ...text... ];
      then normal line. Only the bracketed block is styled because a set rule is
      local to its enclosing block. Mirrors examples/048-scope-of-a-set-rule.
      Common mistake: forgetting the # before [ , which makes it plain markup
      text rather than a content block (still works as a block, but clarify the
      #[...] form is the idiomatic inline content block).
9.5 - #let draft = true at the very top. Then:
        #set text(size: 14pt, fill: red) if draft
        #set par(leading: 1.5em) if draft
      Flipping draft to false makes both rules skip, reverting to defaults
      with a one-character edit. The condition must sit BELOW the #let that
      defines the flag. The optional DRAFT header genuinely needs a show rule
      or direct call for content, so it's a deliberate teaser for Chapter 10 --
      credit any
      reasonable attempt; the core exercise is the two conditional set rules and
      the single-edit toggle.
-->
