// main.typ — a short document built entirely from lib.typ. The theme colour and
// all three components come from the library; this file just arranges content.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 13cm, height: auto, margin: 1.6cm)
#set text(font: "Libertinus Serif", size: 11pt)

// Pull in the constants and components we use, by name.
#import "lib.typ": brand, callout, kbd, framed

// A set/show rule can lean on a library constant too.
#show heading: set text(fill: brand)
#set figure(supplement: "Panel")

= Keyboard shortcuts

#callout[
  Everything on this page — the heading colour, this box, the keycaps below,
  the framed panel — comes from `lib.typ`. Nothing is styled twice.
]

To copy, press #kbd("Ctrl") + #kbd("C"). To paste, #kbd("Ctrl") + #kbd("V").

#framed(caption: [A framed panel from the same library.])[
  #callout(title: "Tip", color: green)[
    Components nest: this callout sits inside a `framed` figure, both from the
    library, and they still agree on spacing and style.
  ]
]
