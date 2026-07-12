// A function-form show rule rebuilds every heading from scratch: it reads the
// heading's own body off `it.body` and returns a colored title with a rule
// drawn underneath. See Chapter 10, "Show rules".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#show heading: it => block(below: 0.8em)[
  #text(fill: rgb("#2b6cb0"), weight: "bold")[#it.body]
  #v(-6pt)
  #line(length: 100%, stroke: 0.6pt + rgb("#2b6cb0"))
]

= Introduction
#lorem(24)

= Method
#lorem(18)
