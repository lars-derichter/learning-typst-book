// `.final()` reads a counter's END value. The summary line at the very top
// prints the total number of exercises — a number that does not exist yet at
// that point in the source. Typst resolves it by laying the document out and
// reading the counter's final value, then filling the blank on a later pass.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 9cm, height: auto, margin: 1cm)

#let ex = counter("exercise")

#let exercise(body) = {
  ex.step()
  block(spacing: 8pt)[*Exercise #context ex.display().* #body]
}

// This reads the FINAL count, up top, before a single exercise is written.
#context [
  #set text(fill: gray)
  This worksheet has #ex.final().first() exercises.
]

#v(6pt)

#exercise[Factor $x^2 - 1$.]
#exercise[Differentiate $sin(x)$.]
#exercise[State the triangle inequality.]
#exercise[Give a prime larger than 100.]
