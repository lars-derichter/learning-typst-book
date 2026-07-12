// A small but real styled document: a stack of set rules at the top
// configures the page, the type, paragraphs, heading numbers, and list
// markers once. The body below is plain markup that inherits all of it.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "New Computer Modern", size: 11pt, lang: "en")
#set par(justify: true, leading: 0.75em, first-line-indent: 1em)
#set heading(numbering: "1.")
#set list(marker: [--])

= A field guide to defaults

#lorem(30)

== Why configure at the top

Set the rules once, near the top, and the rest of the file stays clean
markup. The three habits worth keeping:

- decide the type and page before you write the body,
- turn on heading numbers so structure reads at a glance,
- reach for a direct call only when one spot needs to differ.

== What the body inherits

#lorem(35)
