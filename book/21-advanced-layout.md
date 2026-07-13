# Advanced layout

Most of the time you want Typst to make the layout decisions. You pour in
headings and paragraphs and figures, and the engine breaks the lines, fills
the columns, and floats the pictures somewhere sensible. That's the whole
pleasure of the thing: you say *what*, and it works out *where*.

But now and then you know exactly where. You want a "DRAFT" stamp glued to
the top-right corner, a label rotated up the spine of a page, a little logo
you drew yourself, a dotted leader marching from a chapter title to its page
number. For those moments Typst keeps a drawer of manual controls — tools
that let you place content by hand, wrap it in a coloured box, transform it,
draw with it, or reach into the finished document and ask what's inside.

This chapter is that drawer. None of it is exotic; it's just the layer below
the automatic one, the escape hatches you reach for when the defaults won't
do. We've been dropping promissory notes about it since Chapter 5 ("scoping a
watermark is a Chapter 21 topic"), Chapter 6 ("`#place` gets covered later"),
and Chapter 17 ("for mid-page sections you'll want `query`"). Time to pay
them off.

## Placing things exactly

You met `#place` by name in [Chapter 6](06-figures-and-images.md), as the
lower-level cousin of a floating figure. Here's what it actually does: it lifts
a piece of content clean out of
the text flow and pins it to a position on the page.

```typ
#place(top + right, box(fill: yellow, inset: 6pt)[*DRAFT*])
```

The first argument is an alignment — `top + right`, `bottom + center`,
`horizon + left`, any horizontal-plus-vertical pair. That's the anchor. The
content goes wherever that alignment points, measured against the page's text
area.

Two offsets fine-tune it. `dx` shifts horizontally, `dy` vertically, both
taking a length that can be negative:

```typ
#place(top + right, dx: -0.2cm, dy: 0.2cm, [...])
```

Positive `dx` moves right, positive `dy` moves down — the usual screen
convention, with the origin at the top-left. So to tuck a corner tag *inward*
from the top-right you pull it left (negative `dx`) and push it down (positive
`dy`), which is exactly what the yellow tag in `examples/108-place-and-float/`
does.

The crucial part — the thing that surprises people once and then becomes the
whole point — is that placed content **reserves no space**. The flow behaves
as though it isn't there. In example 108 the body paragraph starts at the very
top of the page, right underneath the tag, because as far as the text is
concerned the tag doesn't exist. That's a feature: it's how a watermark can
sit *behind* your words without shoving them around.

> [!WARNING]
> Because placed content reserves no space, it will happily overlap your body
> text if you aim it into an occupied spot. That's not a bug for a faint
> background stamp, but it will bite you if you `#place` something opaque in
> the middle of a paragraph. Placement is for the margins, corners, and
> backgrounds — the parts of the page the flow isn't using.

### Floating, the manual way

Add `float: true` and `#place` stops pinning to a fixed corner and starts
*floating*: it sends the block to the top or bottom of the page and lets the
body text close up the gap it left behind.

```typ
#place(bottom, float: true, clearance: 10pt, block(...))
```

This is the same machinery a figure uses when you write `placement: bottom`
(Chapter 6) — in fact a figure's float *is* this, one layer down. The
difference is that `#place(float: true)` floats *any* content, not just a
figure, and doesn't add a caption or a number. Use it for a callout box you
want at the foot of the page, or a full-width banner at the top, without
dressing it up as a figure. `clearance` sets the gap between the float and the
body text it displaces.

> [!TIP]
> Remember Chapter 5's watermark, the one built with `#set page(background:
> ...)`? That mark repeats on *every* page, because it's part of the page
> setup. To stamp a mark on **one** page only, don't touch the page settings —
> just `#place` the mark directly on the page you want. Placement happens once,
> where you write it, so a single placed stamp stays on a single page. That's
> the scoping trick Chapter 5 promised.

## Boxes and blocks

Almost everything decorative in Typst — a coloured highlight, a bordered
callout, a fixed-size frame — is one of two containers: a `#box` or a
`#block`. They take the same styling arguments and differ in exactly one way.

A `#box` is **inline**. It sits inside a line of text, like a single word,
and the line flows around it:

```typ
Here is an inline #box(fill: rgb("#fff2b0"), inset: (x: 3pt),
outset: (y: 3pt), radius: 2pt)[highlight] in a sentence.
```

The words before and after stay on the same line; the box just rides along
with them. That's the tool for a highlighted term, an inline coloured chip, a
bit of content you want boxed *without* breaking the paragraph.

A `#block` is **block-level**. It takes its own horizontal band of the page,
with the text above and below it, the way a paragraph or a heading does:

```typ
#block(fill: rgb("#eef4ff"), stroke: 1pt + rgb("#3b6fb0"),
  radius: 6pt, inset: 10pt, width: 100%)[
  A callout that takes its own slab of the page.
]
```

Both share the same styling vocabulary, and it's worth learning once:

- `fill` — a background colour.
- `stroke` — a border; `1pt + blue` means one-point blue, or pass a
  dictionary for per-side control.
- `radius` — rounded corners.
- `inset` — padding *inside* the box, between the border and the content.
- `outset` — the mirror image, growing the box *outward* past its content
  (handy on an inline box so a highlight extends a hair above and below the
  text, as in the example).
- `width` and `height` — a fixed size, instead of shrinking to fit.
- `clip: true` — cut off anything that overflows the box's bounds.

That last pair earns its own demonstration. Give a block a fixed `height` and
turn on `clip`, and content that overruns is sliced at the edge rather than
spilling out:

```typ
#block(width: 4.5cm, height: 1.8cm, clip: true, stroke: 1pt + gray)[
  #lorem(30)
]
```

`examples/109-box-and-block/` runs all three side by side: the inline
highlight, the bordered callout, and the clipped frame. The rule of thumb:
reach for a `box` when the thing belongs *in* a line, a `block` when it wants
a line of its own.

There is one thing a block does that an inline `box` never has to face: it can
run into the bottom of a page. By default a block is *breakable* — if it doesn't
fit in the space that's left, it splits, picking up again at the top of the next
page. For a long quotation or a table that runs for pages, that's exactly right;
you want the content to flow. For a callout, a figure, or a code listing you
want kept in one piece, it's a small disaster: the box tears in two, its top on
one page and its tail on the next.

Forbid the split with `breakable: false`:

```typ
#block(fill: rgb("#eef4ff"), stroke: 1pt + rgb("#3b6fb0"),
  radius: 6pt, inset: 10pt, breakable: false)[
  A callout that would rather move than be torn in half.
]
```

Now the block is indivisible: if it won't fit where it sits, the whole thing
jumps to the next page rather than break across the boundary. This is exactly
what the admonition boxes in Chapter 22 do, so a "Tip" never leaves its label
stranded at the foot of one page and its advice at the head of the next. The one
honest cost is the edge case: a block taller than a whole page has nowhere that
fits to jump to, so an unbreakable one overflows the bottom. For short callouts
that never comes up — but if a box might grow long, you may not want to commit
to "never break."

> [!TIP]
> What if a box should *prefer* to stay whole yet break when it genuinely gets
> too tall? There's no single switch for that, but `breakable` accepts any
> boolean, so you can work one out. Measure the content first — the `measure`
> and `layout` pair from Chapter 17 — and let its height decide:
>
> ```typ
> #let keep-whole(body, break-past: 8cm) = layout(size => {
>   let tall = measure(block(width: size.width, body)).height > break-past
>   block(breakable: tall, inset: 10pt, stroke: 1pt + gray)[#body]
> })
> ```
>
> A short box stays in one piece; one taller than `break-past` is allowed to
> split. The threshold is the box's *own* height, not the room left on the page
> — Typst won't tell content how much space is below it — but "small boxes stay
> whole, big ones may break" is usually the rule you actually wanted.

## Stacking

`#stack` is the simplest way to line several things up along one axis. You
give it a direction and a single spacing value, then the items:

```typ
#stack(dir: ttb, spacing: 8pt,
  rect(width: 100%)[first],
  rect(width: 100%)[second],
  rect(width: 100%)[third],
)
```

`dir: ttb` stacks top-to-bottom — a column. `dir: ltr` stacks left-to-right —
a row. (There's `btt` and `rtl` too, if you ever want to build upward or
lay out a right-to-left script.) The `spacing` goes evenly between every pair
of items. `examples/110-stack/` shows a column of rectangles over a row of
circles.

This overlaps with `grid` (Chapter 7), and the difference is worth keeping
straight. A `grid` gives you a two-dimensional lattice: aligned rows *and*
columns, with cells that line up across both. A `stack` is one-dimensional —
a single run of items along one direction, each taking exactly the space it
needs. When you're placing things in a row or a column and you don't need
anything to line up in the other axis, `stack` is the lighter tool. The
moment you need a real table of alignment, go back to `grid`.

## Nudging within the flow

`#place` and the transforms take content out of the flow. Two smaller tools
work *inside* it, for when you just want to shift something a little without
uprooting it.

`#pad` adds space around content, like an inset that lives outside the box
rather than inside it:

```typ
#pad(x: 1cm, [This paragraph is indented on both sides.])
```

It takes the same side arguments as a margin — `x`, `y`, `left`, `top`, and
so on — and it's the clean way to inset a block quote or push one paragraph in
from both edges.

`#align` positions content within the width it's given:

```typ
#align(center)[Centred.]
#align(right)[Flushed right.]
```

You've been using `align` since the early chapters without much ceremony;
it's worth naming here as the in-flow counterpart to `#place`. `align` moves
content within the space the flow *has* allotted it; `place` ignores the flow
and pins to the page. Same verb, different altitude.

## Transforming content

Four functions distort content geometrically without changing what it *is* —
the letters stay selectable text, the shapes stay shapes.

```typ
#rotate(-20deg, [rotated])
#scale(x: 140%, y: 70%, [scaled])
#move(dx: 0pt, dy: -8pt, [nudged up])
#skew(ax: 20deg, [slanted])
```

`#rotate` turns content by an angle. `#scale` stretches it — pass `x` and `y`
separately to squash or elongate, or a single factor for both. `#move` shifts
it by an offset, the way `#place`'s `dx`/`dy` do but *without* leaving the
flow. And yes, `#skew` exists in Typst 0.15: it slants content, `ax` shearing
horizontally and `ay` vertically, the effect you'd use for a hand-faked
italic or a parallelogram.

There's a catch with all four, and it's the same catch. By default a
transform is purely visual: the surrounding layout reserves the content's
*original* footprint and ignores whatever the transform did to its shape. Rotate
a tag inside a line of text and it'll poke out above and below, because the
line still thinks the tag is its old upright self. Pass `reflow: true` and the
layout re-measures the transformed result and makes room for it:

```typ
before #rotate(30deg, reflow: true)[X] after
```

`examples/111-transforms/` shows the whole quartet in a row, then the same
rotation with and without `reflow` so you can watch the line grow.

> **Coming from LaTeX.** All those little positioning macros you kept looking
> up — `\raisebox{2pt}{...}` to nudge something up, `\hspace{1cm}` to shove it
> sideways, `\rotatebox`, `\scalebox`, and the whole `\node[...] at (...)`
> apparatus from TikZ for pinning things to absolute coordinates — collapse
> into a handful of ordinary functions here. `\raisebox` is `#move`.
> `\hspace` is `#h`. `\rotatebox` is `#rotate`. TikZ's absolute node placement
> is `#place`. No package to load, no `\usepackage{graphicx}`, no picture
> environment. They're built in, they nest, and they take content like
> anything else.

## Filling space with `#repeat`

`#repeat` tiles a piece of content across the width it's given, as many times
as fit. On its own that sounds pointless. Combine it with a stretchy `1fr`
box and it becomes the dotted leader line every table of contents wants:

```typ
Chapter 3 #box(width: 1fr, repeat[.]) 12
```

The `box(width: 1fr, ...)` swells to eat all the horizontal slack between the
title and the page number (that's the same `1fr` spring from Chapter 5), and
`repeat[.]` fills it with dots. Change the title's length and the dots restretch
to match. `examples/112-repeat-leaders/` builds a little mock contents page
this way, and the lines stay aligned no matter how long the titles run.

This isn't a party trick — it's exactly how Typst's own `#outline` draws its
dotted leaders. Now you know the machinery underneath. `repeat` also takes a
`gap` to space the tiles out and a `justify` to spread them edge to edge (on
by default), if plain packed dots aren't the look you want.

## Reserving space without drawing

`#hide` is the odd one out: it lays content out completely, taking up its full
space, and then draws nothing. The content is there — it occupies its box, it
pushes its neighbours — it's just invisible.

```typ
The capital of France is #hide[Paris].
```

That renders the sentence with a Paris-shaped gap where the answer would be.
It's the tool for a worksheet with fill-in blanks, an answer key printed in
the same layout as the questions, or a form where you want the spacing to
match a filled-in version exactly. Because the hidden content still measures,
everything around it lines up as if it were visible — which a blank space of
guessed width never quite manages.

## Asking the document about itself

Everything so far has *put things on* the page. `query` does the opposite: it
reaches into the finished document and hands you back the elements that are
already in it.

Because the answer depends on the whole laid-out document, `query` only works
inside `#context` (the keyword from Chapter 17 that means "compute this once
you know where we are"). Give it a selector and it returns an array of the
matching elements:

```typ
#context {
  let headings = query(heading)
  [This document has #headings.len() headings.]
}
```

From each returned element you can read its fields (`h.body`, `h.level`) and,
via `h.location()`, look up *where* it landed — including its page number,
through `counter(page).at(h.location())`. String those together and you've
built a table of contents by hand:

```typ
#context {
  for h in query(heading) {
    let page-no = counter(page).at(h.location()).first()
    [#h.body #box(width: 1fr, repeat[.]) #page-no \ ]
  }
}
```

`examples/113-query/` runs exactly this, dotted leaders and all. You'd
normally just call `#outline` for a contents page, but the same technique
builds things `#outline` can't: a list of every figure over a certain size, a
custom index, or a running header that names the current section.

That last one closes a loop from Chapter 17. Remember the warning there: a
header built from *state* reads the state as of the top of its page, so a
section that starts halfway down the page won't show up in that page's header.
`query` sidesteps the problem, because it sees the *entire* document at once,
not just what came before the current point. A header that queries all the
headings and matches them against the current page number can find a section
that began mid-page — something state alone can't do.

> [!NOTE]
> `query` runs after layout, so it can see everything, but it also means the
> document may need an extra compilation pass to settle (Typst handles that for
> you). Keep queries simple and specific — `query(heading.where(level: 1))`
> rather than fishing through everything — and they stay fast.

## Drawing your own shapes

Sometimes the content you want isn't text at all — it's a small graphic: an
icon, a badge, a divider, a logo. Typst has a modest set of drawing tools that
compose like everything else.

The primitives are `#rect`, `#circle`, `#line`, and `#polygon`. You've seen
the first two dressed up as boxes; here they're shapes, taking a `fill` and a
`stroke`:

```typ
#circle(radius: 20pt, fill: green)
#polygon(fill: aqua, (0pt, 0pt), (30pt, 0pt), (15pt, 25pt))
```

For anything with a curve, reach for `#curve`. This is the general path tool:
you feed it a sequence of moves and segments, and it traces them out.

> [!IMPORTANT]
> If you find older Typst code or answers online using `#path` to draw curves,
> note that it's gone. In Typst 0.15 the drawing function is `#curve`; the name
> `path` now refers to an unrelated file-path type. Anywhere a tutorial says
> `#path`, write `#curve` instead — the segment syntax is a little different but
> the idea is the same.

A `#curve` is built from segment functions. `curve.move(pt)` lifts the pen to
a point; `curve.line(pt)` draws a straight segment to a point; `curve.cubic`
and `curve.quad` draw Bézier curves (the smooth kind), with control points that
pull the curve into shape; and `curve.close()` joins back to the start. Points
are `(x, y)` pairs, with `y` growing downward.

Here's a checkmark — two straight segments:

```typ
#curve(
  stroke: (paint: white, thickness: 5pt, cap: "round", join: "round"),
  curve.move((-10pt, 1pt)),
  curve.line((-2pt, 9pt)),
  curve.line((11pt, -9pt)),
)
```

Drop that on a green `#circle` and you've got a "verified" badge.
`examples/114-a-custom-shape/` assembles one: a `circle` for the disk, a
`curve` of straight segments for the tick, `#place` to stack the tick over the
disk, and a single `curve.cubic` for a smooth flourish underneath — the
straight-line and Bézier halves of `curve` in one small picture. It's not a
drawing program, and for serious diagrams you'll want the CeTZ package
(Chapter 20). But for a logo or an icon, the built-ins are enough.

## A door to native code

One last tool, mentioned rather than demonstrated, because it needs a
compiled binary this book can't ship: `plugin`.

```typ
#let mymod = plugin("mymodule.wasm")
```

`plugin` loads a WebAssembly module — a chunk of pre-compiled, fast, native
code — and lets your Typst document call into it as if its functions were
ordinary Typst functions. The point is speed and reach: some jobs (parsing a
tricky data format, running a heavy computation, syntax-highlighting code)
are far faster in compiled Rust or C than in Typst's scripting language, and a
plugin lets a package author write that part in a real systems language, compile
it to WebAssembly, and call it from Typst. Several packages you install
(Chapter 20) ship a `.wasm` plugin inside them and use it quietly on your
behalf; you benefit without ever writing `plugin` yourself.

Writing your own is a genuine programming project — you compile a module
against Typst's plugin protocol — and well past the scope of a layout chapter.
If the idea grabs you, the reference at
<https://typst.app/docs/reference/foundations/plugin/> is the place to start.
For now, file it away: when a package feels suspiciously fast at something
that ought to be slow, a plugin is often why.

## What you've got

You can now overrule the automatic layout when you need to:

- **Place content by hand** with `#place(align, dx:, dy:)`, out of the flow
  and reserving no space, and float any block with `float: true` — the manual
  version of a figure's placement, and the way to stamp a single page.
- **Wrap content in a container**: an inline `#box` or a block-level `#block`,
  both with `fill`, `stroke`, `radius`, `inset`, `outset`, `width`/`height`,
  and `clip` — plus `breakable: false` on a block to keep it from tearing across
  a page boundary.
- **Line items up on one axis** with `#stack(dir:, spacing:, ...)`, the
  one-dimensional lighter sibling of `grid`.
- **Nudge within the flow** using `#pad` for surrounding space and `#align`
  for positioning.
- **Transform content** — `#rotate`, `#scale`, `#move`, `#skew` — visually by
  default, or claiming layout space with `reflow: true`.
- **Fill space with `#repeat`** for dotted leaders and the like.
- **Reserve space without drawing** using `#hide`.
- **Interrogate the document** with `context query(...)` to find its elements
  and build custom contents lists and headers — including ones that track
  sections starting mid-page.
- **Draw your own shapes** with `#curve` (the modern replacement for the
  removed `#path`), plus `#rect`, `#circle`, `#line`, and `#polygon`.
- **Know that `plugin` exists** as the door to native WebAssembly code, even
  if you never open it.

That's the manual-controls drawer, and it's the end of Part V. You can build
reusable functions, templates, and packages, and now you can reach past the
automatic layout when a design demands it. Part VI puts all of it to work:
we design a real book template and then wire up the pipeline that typesets
this very book.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

21.1. Pin a small "CONFIDENTIAL" tag to the top-right corner of a page,
inset a couple of millimetres from the edge with `dx`/`dy`. Fill the page with
`#lorem(60)` and confirm the body text starts at the very top, ignoring the
tag. Then move the tag to `bottom + center` and watch where it lands.

21.2. Build a `#block` with a coloured fill, a coloured border, rounded
corners, and 10pt of inset — a callout box. Give it a fixed `height` shorter
than its content and add `clip: true`; describe, in one sentence, what `clip`
did. Then drop the fixed height, fill the box with enough `#lorem` to run past
the bottom of a page, and set `breakable: false`: recompile and say where the
whole box lands, and what would happen instead if it were taller than a page.

21.3. Recreate a single table-of-contents line by hand: the text "Chapter 1"
on the left, "7" on the right, and a dotted leader stretching between them.
(Hint: a `1fr`-wide box and `#repeat`.) Make the chapter title longer and
confirm the dots restretch.

21.4. Take the four transforms — `#rotate`, `#scale`, `#move`, `#skew` — and
apply each to the same short word inside a sentence. First leave them as they
are and note how the line's height ignores them; then add `reflow: true` to
the rotation and describe what changes.

21.5. *(Stretch.)* Use `context query(heading)` to build your own miniature
table of contents for a short multi-page document: list each heading with its
page number and a dotted leader, indenting sub-headings one em per level.
(Hint: `h.level`, `h.body`, and `counter(page).at(h.location())`.) Compare your
result to what a plain `#outline()` produces — and notice that you could now
tweak yours in ways `#outline` won't let you.

<!--
SOLUTIONS (notes for the appendix author):
21.1 - #place(top + right, dx: -2mm, dy: 2mm, box(fill: red, inset: 4pt,
       text(fill: white)[*CONFIDENTIAL*])) then #lorem(60). Point: placed
       content reserves no space, so the first line of lorem starts at the top
       margin and the tag overlaps it. Moving to bottom + center pins the tag to
       the foot, centred; body text still ignores it. See examples/108.
21.2 - #block(fill: rgb("#eef4ff"), stroke: 1pt + blue, radius: 6pt,
       inset: 10pt)[#lorem(30)], then add height: 1.5cm, clip: true. clip cuts off
       what overflows the fixed height at the block's edge instead of letting it
       spill past. See examples/109. Then, breakable part: drop height/clip, use
       [#lorem(120)] so it crosses a page, add breakable: false — the whole box
       moves to the next page intact instead of splitting. Risk if it's taller
       than a page: nowhere to jump that fits, so it overflows the bottom edge
       (breakable: false can't shrink it). That's the trade behind the rule.
21.3 - Chapter 1 #box(width: 1fr, repeat[.]) 7  — the 1fr box absorbs the slack
       and repeat fills it with dots; lengthening "Chapter 1" to a long title
       shortens the dot run automatically. See examples/112.
21.4 - #rotate(20deg)[word], #scale(x:140%)[word], #move(dy:-4pt)[word],
       #skew(ax:20deg)[word], each inline. Without reflow the line height is the
       untransformed word's, so rotated/moved versions poke out of the line.
       Adding reflow: true to the rotation makes the line grow to contain the
       rotated box. See examples/111.
21.5 - #context { for h in query(heading) { let p = counter(page)
       .at(h.location()).first(); [#pad(left: (h.level - 1)*1em)[#h.body
       #box(width: 1fr, repeat[.]) #p] ] } }  over a doc with a few headings and
       #pagebreak()s. Same output shape as #outline() but fully customisable
       (e.g. filter by level, add the section number, change the leader).
       Ties to Chapter 17: query sees the whole document, unlike state.
       See examples/113.
-->
