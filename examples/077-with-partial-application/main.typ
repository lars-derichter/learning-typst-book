// `.with(...)` pre-fills some of a function's arguments and hands back a new
// function with those baked in — partial application. It works on your own
// functions and on built-ins alike. See Chapter 14, "Functions and closures".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

// Start from one general component...
#let badge(body, color: gray) = box(
  fill: color,
  inset: (x: 6pt, y: 3pt),
  radius: 4pt,
)[#text(fill: white, weight: "bold")[#body]]

// ...and pre-configure named variants with .with:
#let ok = badge.with(color: green)
#let danger = badge.with(color: red)

#ok[passed] #danger[failed] #badge[neutral]

#v(8pt)

// .with works on built-in functions too.
#let title = text.with(size: 16pt, weight: "bold", fill: navy)

#title[A pre-styled title]
