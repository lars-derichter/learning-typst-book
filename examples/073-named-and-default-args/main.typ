// Parameters come in two kinds: positional (matched by order) and named with a
// default (matched by name, optional at the call site). `body` is positional;
// `color` and `size` are named and default to a value. See Chapter 14.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let tag(body, color: gray, size: 9pt) = box(
  fill: color,
  inset: (x: 6pt, y: 3pt),
  radius: 4pt,
)[#text(fill: white, size: size, weight: "bold")[#body]]

// Called with every default in place:
#tag[draft]
//
// Override one named argument:
#tag(color: green)[approved]
//
// Override both — named arguments can come in any order:
#tag(size: 12pt, color: red)[urgent]
