// The show-set form applies a set rule only to matched elements. Here it gives
// level-1 headings a large navy style, and recolors every inline `raw` snippet
// — without touching anything else. This is the safest, most common show rule.
// See Chapter 10, "Show rules".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)
#set heading(numbering: "1.")

#show heading.where(level: 1): set text(size: 18pt, fill: navy)
#show raw: set text(fill: rgb("#7b2d8b"))

= The bigger picture
A level-1 heading is now large and navy, but its numbering, spacing, and
weight all keep Typst's defaults. Inline code like `#show` and `it.body`
comes out purple.

== A quieter subheading
The rule matched only level 1, so this heading is untouched.
