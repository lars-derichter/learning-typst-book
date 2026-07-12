// State: a value that changes as the document flows. `state("part", ...)` holds
// it; `.update(...)` changes it; inside a `context`, `.get()` reads it. Here a
// running header prints the current part.
//
// The subtle bit: a header reads the state as of the TOP of its page. So the
// update must land BEFORE the page break — do it just above `#pagebreak()` and
// the new page's header is already correct.
// Compile with:  typst compile main.typ out.pdf
#let part = state("part", "Part I — Basics")

#set page(
  width: 9cm,
  height: 7cm,
  margin: 1cm,
  header: context [
    #set text(9pt, style: "italic")
    #part.get() #h(1fr) #counter(page).display()
  ],
)

= Warm-up
#lorem(30)

// Change the state, THEN break — so page 2's header sees the new value.
#part.update("Part II — Practice")
#pagebreak()

= Drills
#lorem(30)
