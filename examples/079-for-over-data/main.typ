// Looping over data: an array becomes a bullet list, and a dictionary's
// key/value pairs become a term list.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

= Reading list

#let books = (
  "The Left Hand of Darkness",
  "Piranesi",
  "A Canticle for Leibowitz",
)

// One pass per element; each pass emits one list item.
#for title in books [
  - #emph[#title]
]

= Office hours

#let hours = (
  Monday: "9–11",
  Wednesday: "14–16",
  Friday: "10–12",
)

// Destructure each pair into `day` and `slot`.
#for (day, slot) in hours [
  / #day: #slot
]
