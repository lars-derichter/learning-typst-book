// `repeat` tiles content to fill the space it is given. Put it in a
// 1fr-wide box between a title and a page number and you get the dotted
// leader line of a table of contents.
// See Chapter 21, "Advanced layout".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#let leader(title, page) = [
  #title #box(width: 1fr, repeat[.]) #page
]

#stack(
  dir: ttb,
  spacing: 7pt,
  leader[Introduction][1],
  leader[Placing things by hand][12],
  leader[The box model][17],
  leader[A gratuitously long section title that still lines up][23],
)
