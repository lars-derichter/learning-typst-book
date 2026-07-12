// Headings, paragraphs, whitespace, and the hard line break.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= A trip report
== Getting there

The train left on time. #lorem(20)

This blank line above started a new paragraph. Runs of    spaces
and
line breaks in the source all collapse into a single space.

I can force a break inside a paragraph\
right where I want one, without starting a new paragraph.

=== A finer point
==== Even finer
Headings go all the way down to level six; you rarely need past three.
