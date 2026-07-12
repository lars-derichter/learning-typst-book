// `range` counts for you (half-open, optional step); `while` repeats as long
// as a condition holds.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

= Multiples of five

// range(start, end, step: n) — stops *before* end, so this reaches 50, not 55.
#for n in range(5, 55, step: 5) [#n #h(0.8em)]

= Doubling until we pass one thousand

// A while loop runs until its condition goes false. Here it doubles `x`
// each pass — the powers of two, computed rather than typed.
#let x = 1
#while x <= 1000 {
  [#x #h(0.8em)]
  x = x * 2
}
