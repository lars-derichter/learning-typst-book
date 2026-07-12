// `continue` skips the rest of the current pass; `break` abandons the loop
// entirely. Together they let you filter data mid-loop.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let scores = (88, 42, 95, 67, 30, 71, 100, 55)

= Passing scores (60 and up)

// `continue` jumps to the next item, so failing scores print nothing.
#for s in scores {
  if s < 60 { continue }
  [#s #h(0.8em)]
}

= Up to the first perfect score

// `break` stops the loop the moment we hit 100.
#for s in scores {
  if s == 100 { break }
  [#s #h(0.8em)]
}
