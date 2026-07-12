// main.typ — the two ways to pull in another file, side by side.
//   #import brings in a file's DEFINITIONS (names you can then use).
//   #include splices in a file's CONTENT (words that appear on the page).
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

// import: makes `signoff` available. Nothing prints from this line.
#import "defs.typ": signoff

= The Weekly

An opening paragraph, typed right here in `main.typ`.

// include: the heading and paragraph from section.typ appear at this spot.
#include "section.typ"

// Now use the imported definition.
#signoff("Ada Lovelace")
