#import "../template/admonitions.typ": *
#import "../template/index.typ": idx
#import "../template/theme.typ": accent, code-bg

= Your first document

A blank file is already a valid Typst document. You add content with a little
#idx("markup"): an `=` starts a heading, asterisks make `*bold*`, underscores
make `_emphasis_`, and a blank line starts a new paragraph. If you have written
Markdown, none of this will surprise you.

== The edit loop

The rhythm of working in Typst is a tight loop, shown in @fig:loop. You change
a line, the compiler runs in milliseconds, and the preview updates before you
have looked away. That speed is not a luxury; it changes how you learn the
tool, because trying something costs nothing.

#figure(
  block(fill: code-bg, stroke: 0.5pt + accent, inset: 10pt, radius: 4pt)[
    #stack(
      dir: ltr,
      spacing: 8pt,
      box(inset: 5pt, stroke: 0.5pt + accent, radius: 3pt)[edit],
      [#sym.arrow.r],
      box(inset: 5pt, stroke: 0.5pt + accent, radius: 3pt)[compile],
      [#sym.arrow.r],
      box(inset: 5pt, stroke: 0.5pt + accent, radius: 3pt)[preview],
    )
  ],
  caption: [The loop you live in: edit, compile, preview.],
) <fig:loop>

== Styling without formatting

The move that takes ten minutes to get used to and pays off forever: you stop
*formatting* text and start *labelling* it. Instead of selecting a line and
clicking a bigger font, you mark it as a heading —

```typ
= A section title
The paragraph that follows it.
```

— and decide, once and in one place, what every heading looks like. That "one
place" is a #idx("template"), and building a good one is what the rest of this
book is about.

#important[
  Structure first, appearance second. A document whose headings are real
  headings, not just big bold text, is one Typst can build a table of contents
  from, cross-reference, and restyle wholesale. Fake it and you lose all three.
]
