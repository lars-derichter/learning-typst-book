// A custom counter. `counter("theorem")` invents a fresh counter under a name
// of your choosing. `.step()` bumps it by one; `#context ....display()` prints
// its current value. Wrap both in one helper and every theorem numbers itself.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 9cm, height: auto, margin: 1cm)

#let thm = counter("theorem")

#let theorem(body) = {
  thm.step()
  block(
    inset: 8pt,
    stroke: 0.5pt + gray,
    radius: 3pt,
    width: 100%,
  )[
    *Theorem #context thm.display().* #body
  ]
}

= Numbers that count themselves

#theorem[The angles of a triangle sum to a straight angle.]

#theorem[There are infinitely many prime numbers.]

#theorem[Between any two rationals lies another rational.]

Add a fourth theorem anywhere above and the rest renumber themselves — nobody
edits "Theorem 3" by hand.
