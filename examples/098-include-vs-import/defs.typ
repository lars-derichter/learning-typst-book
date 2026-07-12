// defs.typ — DEFINITIONS. This file makes a name available but prints nothing
// on its own. main.typ reaches it with #import. See Chapter 18.

#let signoff(name) = text(style: "italic", fill: luma(90))[— #name, editor]
