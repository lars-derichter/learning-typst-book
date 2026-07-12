// The transformer trio. `map` reshapes every element, `filter` keeps the ones
// that pass a test, and `fold` boils the whole array down to a single value.
// Each takes an arrow function -- a small inline function from Chapter 14.
// See Chapter 16, "Arrays, dictionaries, and strings".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let scores = (58, 72, 91, 44, 88, 67)

Six raw scores: #scores.map(str).join(", ").

// map: transform every element
#let curved = scores.map(s => s + 5)
After a five-point curve: #curved.map(str).join(", ").

// filter: keep only the elements that pass a test
#let passing = curved.filter(s => s >= 60)
Passing (>= 60): #passing.map(str).join(", ") ---
#passing.len() of #scores.len().

// fold: collapse the array to one value, carrying a running total
#let total = scores.fold(0, (running, s) => running + s)
Total by fold: #total. The same by shortcut: #scores.sum().
Average: #calc.round(scores.sum() / scores.len(), digits: 1).

// the three chain: curve, keep passers, add them up -- in one breath
Chained: #scores.map(s => s + 5).filter(s => s >= 60).sum() points passed.

// zip pairs two arrays element by element
#let names = ("Ada", "Ben", "Cy", "Dee", "Eve", "Fay")
Report card: #names.zip(scores).map(((n, s)) => [#n #s]).join(", ").

// enumerate hands you (index, value); here, a ranked list
Ranked, highest first:
#for (rank, s) in scores.sorted().rev().enumerate(start: 1) [
  \ #rank. #s
]
