// main.typ — imports a package from Typst Universe and uses it. The version
// is pinned and required: the first compile downloads cetz into a local
// cache, and every compile after that works offline.
// Compile with:  typst compile main.typ out.pdf   (needs network the first time)
#import "@preview/cetz:0.3.4"
#set page(width: 7cm, height: auto, margin: 0.8cm)
#set text(font: "Libertinus Serif", size: 11pt)

= A figure, drawn in code

#align(center, cetz.canvas({
  import cetz.draw: *
  line((0, 0), (3, 0), (3, 2), close: true)
  rect((2.6, 0), (3, 0.4), stroke: 0.5pt)
  content((1.5, -0.35), $a$)
  content((3.4, 1), $b$)
  content((1.2, 1.25), $c$)
}))

Every line above is an instruction, not a pixel, so the triangle stays
crisp at any zoom.
