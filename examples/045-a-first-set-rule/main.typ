// Two set rules restyle a whole short document at once:
// set text changes the typeface and size; set par turns on
// justification and tightens the leading. Everything after them obeys.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true, leading: 0.75em)

= On defaults

#lorem(35)

Not one word below was styled by hand. Both paragraphs are plain
markup; the two set rules at the top decided how they look.

#lorem(30)
