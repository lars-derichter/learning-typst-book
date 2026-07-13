# Figures and images

Here is the thing word processors get wrong more reliably than anything else.
You drop an image into a page, and for the rest of that document's life it
behaves like a cat you are trying to photograph: never quite where you left it,
sliding two paragraphs down the instant you add a sentence above, now and then
leaping onto a blank page of its own out of sheer spite. Placing a picture ought
to be the easy part. Somehow it becomes the part that eats the afternoon.

Typst places an image with one line. Better than that, it turns a bare image
into a proper *figure* — a numbered, captioned thing the rest of your document
can point at by name — with barely more effort. This chapter is about both:
getting a picture onto the page, and then dressing it up so a sentence three
pages later can say "see Figure 4" and always be telling the truth, even after
you have shuffled everything around.

Most of our pictures will be drawn with Typst's own shapes, so the examples need
no files you don't already have. But we start with a real image, because that is
what you came for.

## Placing an image

The function is `image`, and in its shortest form you hand it a filename:

```typ
#image("logo.svg")
```

That is the whole thing. Typst reads the file, works out the format from its
contents, and sets it on the page at its natural size. It understands the
formats you'd expect: PNG and JPG for photographs and screenshots, GIF, and SVG
for vector art that stays crisp at any size.

The file in `examples/025-basic-image/` is an SVG, and it's worth a look because
SVG is just text — a few lines of tags describing a rounded blue square, a white
disc, and an orange triangle. You can open it in any editor, read it, and see it
in a diff. That is a small superpower: an image asset you can actually inspect,
rather than an opaque blob of pixels.

The filename is resolved **relative to the file doing the loading**. If your
`main.typ` sits next to `logo.svg`, then `"logo.svg"` finds it; a picture in a
subfolder is `"images/logo.svg"`. A path that starts with a slash is treated as
absolute *from the project root* instead — the root being the folder you point
Typst at with `--root` (Chapter 2). So `"/assets/logo.svg"` means "the `assets`
folder at the top of the project," wherever the current file lives.

### Sizing it

Natural size is rarely the size you want. Give the image a `width`, a `height`,
or both:

```typ
#image("logo.svg", width: 3cm)
```

Hand it just one dimension and Typst scales the other to match, so the image
keeps its proportions and nothing looks squashed. You can use any length Typst
understands, including a percentage — `width: 60%` means 60% of the space the
image sits in, which is the usual way to say "about two-thirds of the text
width" without doing arithmetic. We'll come back to what happens when you pin
*both* dimensions, because that is where `fit` earns its keep.

### A word for screen readers

One argument you should get into the habit of adding is `alt`, a short text
description of the picture:

```typ
#image("logo.svg", width: 3cm, alt: "The company logo: a blue square with a white disc")
```

Nobody sees `alt` on the page. It's written into the PDF for screen readers and
other assistive tools, and it's the difference between a blind reader hearing
"the company logo" and hearing nothing at all. It costs you a few seconds. Spend
them.

> [!NOTE]
> Typst infers the format from the file's *contents*, not its extension, so a
> PNG that someone mischievously named `photo.jpg` still loads correctly. The
> extension is for humans; the bytes are for Typst.

## Wrapping it in a figure

A loose image is fine for a logo in a header. But most pictures in a serious
document want three things a bare `#image` doesn't give you: a number, a
caption, and the ability to be referenced from the text. That bundle is a
*figure*, and you make one by wrapping your content in `#figure`:

```typ
#figure(
  image("logo.svg", width: 4cm),
  caption: [The project logo, in its natural habitat.],
)
```

Notice that `image` inside `figure` has no `#` in front of it. The `#` is what
drops you from markup into code; once you're already inside the parentheses of
`#figure(...)`, you are in code, so the inner call is plain `image(...)`. (If
that sounds like a rule you'll forget, you will, and Typst's error message will
remind you, kindly. Chapter 13 makes the whole markup-versus-code idea click.)

Compile that and you get your image, centered, with a line beneath it reading
something like **Figure 1: The project logo, in its natural habitat.** You typed
no number. Typst counts figures for you, in order, and if you insert a new one
at the top tomorrow, everything below renumbers itself without you lifting a
finger. The word "Figure" is the *supplement* — the label Typst puts before the
number — and it, too, is automatic.

The body of a figure doesn't have to be an image at all. It can be any content:
a shape, a block of text, a table. `examples/026-figure-with-caption/` wraps a
plain drawn rectangle and a circle, purely to show that the caption and
numbering machinery cares nothing for what's inside — it frames whatever you
give it and counts.

> **Coming from LaTeX.** No `\begin{figure}`, no `\caption{}`, no `\label{}` —
> and, the part that surprises people, no `float` package, no `[htbp]`
> incantation, no `\usepackage{graphicx}` at the top. A figure is one built-in
> function. Captions, numbering, and cross-references come in the box, and the
> figure only floats if you ask it to (we'll get there).

### Captions above instead of below

By default the caption sits below the figure, which is conventional for images.
Tables usually want their caption on top. You move it with a set rule:

```typ
#set figure.caption(position: top)
```

Set rules are [Chapter 9](09-set-rules.md)'s whole topic, so don't worry about
the mechanics yet.
The shape to notice is that the caption's position is a setting you change once,
in one place, rather than a decision you re-make at every figure.

## Referencing figures

Automatic numbers are only half the win. The other half is never having to
*read* those numbers yourself. You attach a label to a figure and refer to it by
that label; Typst fills in the number, keeps it correct forever, and makes it a
clickable link into the bargain.

A label is a name in angle brackets, written right after the figure:

```typ
#figure(
  image("chart.svg"),
  caption: [Quarterly revenue.],
) <fig:revenue>
```

Then, anywhere in your prose, an `@` and the label name pull in a reference:

```typ
Revenue climbed all year (@fig:revenue), then dipped in December.
```

That `@fig:revenue` renders as "Figure 3" (or whatever number the figure ends up
with), linked to the figure itself. Move the figure, add ten figures before it,
reorder the lot — the reference follows. `examples/027-referencing-figures/` has
two labelled figures and points at both from the surrounding prose, so you can
watch the numbers and the text stay in lockstep.

The `fig:` at the front of the label is a **convention, not a requirement**.
Typst is perfectly happy with `<revenue>` and `@revenue`. But labels are shared
across your whole document — headings, equations, tables, and figures all draw
from the same pool — so a short prefix like `fig:`, `tbl:`, or `eq:` keeps them
sorted and keeps you from accidentally naming two different things the same. The
number Typst prints comes from *what the label is attached to*, not from the
prefix: point `@fig:revenue` at a figure and you get "Figure 3" because it's a
figure, prefix or no prefix.

> [!TIP]
> A reference can carry its own wording:
> `#ref(<fig:revenue>, supplement: [Fig.])` prints "Fig. 3" instead of
> "Figure 3" for that one mention — handy inside a parenthetical where the full
> word would be fussy. Chapter 11 gives references the full tour; this is just a
> taste.

## Figures aren't only for images

We've said it twice now, so let's prove it. When the body of a figure is a
**table**, Typst notices, and quietly does the right thing: it labels it "Table"
instead of "Figure" and counts tables on their own separate track. Figures and
tables don't share a number, because a reader flipping to "Table 2" shouldn't
land on a photograph.

```typ
#figure(
  table(
    columns: 2,
    [*Quarter*], [*Sales*],
    [Q1], [120],
    [Q2], [148],
  ),
  caption: [Quarterly sales, in thousands.],
) <tbl:sales>
```

That auto-detection covers tables and code listings. For anything else — a
diagram, a photograph you specifically want counted apart, a musical example —
you tell Typst what it is with `kind`, and give it a word to print with
`supplement`:

```typ
#figure(
  my-diagram,
  caption: [The data pipeline, end to end.],
  kind: "diagram",
  supplement: [Diagram],
) <dia:pipeline>
```

Every figure sharing a `kind` shares a counter. So a document can run "Figure 1,
Figure 2" down one track, "Table 1, Table 2" down another, and "Diagram 1,
Diagram 2" down a third, all at once, each numbered independently and each
referenced by its labels. `examples/029-figure-of-a-table-or-diagram/` puts a
table figure and two custom "Diagram" figures side by side so you can watch the
three counters march in parallel.

> [!NOTE]
> The `kind` is what separates the counters, and `supplement` is only the word
> printed on the page and in references. Give two figures the same `kind` and
> they count together even if you spell their supplements differently — so keep
> the `kind` consistent for things that belong to one sequence.

## Sizing and fit

Back to that promise about pinning both dimensions. Give an image only a width
and there's no conflict — the height follows along to preserve the shape. But
the moment you fix *both* width and height, you've described a box that may not
match the image's proportions, and Typst needs a policy for the mismatch. That
policy is `fit`, and it has three settings:

- `"contain"` (fit the whole image inside the box, adding blank space on two
  sides if the shapes don't match — the "letterbox" you see on films),
- `"cover"` (fill the box completely and crop whatever overflows), and
- `"stretch"` (fill the box by distorting the image, squashing or stretching it
  to fit exactly).

The default is `"cover"`, which is usually what you want for a background or a
uniform grid of thumbnails, where a little cropping is fine but empty gaps look
sloppy. Use `"contain"` when you must see the whole image and can tolerate the
margins. Reach for `"stretch"` almost never; distortion is rarely a good look,
though it has its uses for deliberate effect.

`examples/028-sizing-and-fit/` scales the logo with a relative `width: 60%` and
then drops the same image into three identical boxes, one per fit mode, so the
difference is impossible to miss: one letterboxed, one cropped, one squashed.

> [!TIP]
> A percentage width is the friend of a resilient layout. Say `width: 80%`
> instead of `width: 13.2cm`, and your figure keeps its proportions relative to
> the text no matter what page size or margins you switch to later. Absolute
> lengths pin an image to one specific page; relative ones let it adapt.

## Letting figures float

So far our figures have stayed exactly where we wrote them, wedged between two
paragraphs. That's the sensible default, but sometimes you'd rather a big figure
drift to the top or bottom of the page and let the text close ranks around the
gap it left — the behaviour LaTeX users know, and dread, as *floating*.

Typst floats on request, through the `placement` argument:

```typ
#figure(
  image("wide-chart.svg"),
  caption: [A chart too tall to sit mid-paragraph.],
  placement: top,
)
```

`placement: top` sends the figure to the top of a page; `bottom` sends it to the
foot. `placement: auto` lets Typst pick whichever is nearer, which is the
low-effort choice when you just want the thing out of the text's way. Leave
`placement` off entirely (its default) and the figure stays put, in the flow,
right where you typed it.

There's a lower-level cousin worth knowing by name: `#place`. Where a floating
figure politely asks to move to the top or bottom, `#place(top + right, ...)`
drops content at an exact spot — a corner, a fixed offset — and pulls it out of
the normal flow so the surrounding text ignores it entirely. It's the tool for a
watermark, a logo pinned to a corner, a caption glued beside a shape. It's also
easy to overuse; most of the time a figure with a sensible `placement` is the
better-behaved choice. Chapter 21 covers `#place` and manual positioning in
depth.

> [!WARNING]
> A floating figure needs somewhere to float *to*. On a single short page with
> nothing above or below it, `placement: top` has no room to work and the figure
> simply stays where it is — no error, just no visible effect. Floats earn their
> keep in long, flowing documents, not one-page examples.

## What you've got

You can now put pictures on the page and make them behave:

- **Load an image** with `#image("file")`, in PNG, JPG, GIF, or SVG, with paths
  relative to the current file (or from the project root with a leading `/`).
- **Size it** with `width`, `height`, or a percentage, and describe it for
  screen readers with `alt`.
- **Control the fit** when both dimensions are pinned — `"contain"`, `"cover"`,
  or `"stretch"`.
- **Wrap it in a figure** for automatic numbering, a caption above or below, and
  a "Figure N" supplement you never type by hand.
- **Reference figures** by attaching a `<fig:name>` label and writing
  `@fig:name` — a live, clickable number that stays correct as the document
  shifts.
- **Figure anything**, not just images: tables and diagrams too, with `kind` and
  `supplement` splitting them onto independent counters.
- **Float** a figure to the top or bottom of the page with `placement`, and know
  that `#place` exists for exact positioning.

That's the whole everyday toolkit for illustrations. Next, in Chapter 7, we
build the tables those figures sometimes wrap — Typst's grid system, which turns
out to be one of its quietly best features.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

6.1. Grab any small PNG or JPG you have lying around (a screenshot will do), put
it in a folder next to a `main.typ`, and place it with `#image` at a width of
`5cm`. Then add an `alt` description. Compile and confirm it appears at the size
you asked for.

6.2. Wrap that same image in a `#figure` with a caption. Compile it and check
that Typst prints "Figure 1" and your caption beneath the picture — without you
typing the number.

6.3. Add a second figure below the first, give both labels (`<fig:one>` and
`<fig:two>`), and write a sentence that refers to each with `@fig:one` and
`@fig:two`. Now cut the second figure and paste it *above* the first. Recompile
and confirm the numbers in your sentence swapped to match, all on their own.

6.4. Take one image and place it three times inside identical `4cm`-by-`2cm`
boxes, once with each `fit` value. Line them up and describe, in a sentence
under each, what happened to the image and why.

6.5. *(Stretch.)* Build a one-page "figure zoo": a drawn-shape figure, a table
figure, and a custom `kind: "diagram"` figure, each captioned and labelled.
Reference all three in a short paragraph. Confirm that the figure, table, and
diagram each carry their own independent number (Figure 1, Table 1,
Diagram 1), and that your references point at the right ones.

<!--
SOLUTIONS (notes for the appendix author):
6.1 - #image("shot.png", width: 5cm, alt: "..."). Point: path is relative to
      the file's folder; one dimension scales the other; alt is invisible but
      written into the PDF for screen readers. Any real PNG/JPG works.
6.2 - #figure(image("shot.png", width: 5cm), caption: [A caption.]). Note the
      inner image() has NO leading # because it's already inside code (the
      figure() call). Output: "Figure 1: A caption." below the image, number
      supplied automatically.
6.3 - Two figures with <fig:one>/<fig:two>, referenced via @fig:one/@fig:two.
      After moving fig:two above fig:one, it becomes Figure 1 and the references
      renumber themselves. The whole point: references track the label, not a
      hand-typed number. See examples/027-referencing-figures/.
6.4 - #let b = box.with(width: 4cm, height: 2cm, stroke: 0.5pt); then
      b[#image("x.png", width:100%, height:100%, fit:"contain")] and likewise
      "cover" and "stretch". contain = whole image, letterboxed; cover = fills
      box, crops overflow; stretch = fills box, distorts. Mirrors example 028.
6.5 - Three figures: a drawn shape (default kind -> "Figure 1"), a table figure
      (auto kind table -> "Table 1"), and kind: "diagram", supplement: [Diagram]
      (-> "Diagram 1"). Each kind has its own counter, so all three read "1".
      Reference each with its own <fig:...>/<tbl:...>/<dia:...> label. Mirrors
      example 029. Key insight: kind separates the counters; supplement is only
      the printed word.
-->
