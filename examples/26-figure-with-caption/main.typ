// Wrapping content in a numbered figure with a caption.
// The body here is a Typst-drawn shape, so no external asset is needed.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

A figure numbers itself and prints its caption underneath:

#figure(
  rect(width: 5cm, height: 3cm, fill: aqua, radius: 4pt),
  caption: [A placeholder diagram, drawn with a single rectangle.],
)

The body does not have to be an image. Anything works, including this
circle:

#figure(
  circle(radius: 1.4cm, fill: orange),
  caption: [Figures number in one sequence, whatever their body.],
)
