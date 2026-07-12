// Defining your own functions with #let. A one-line function whose body is the
// bracketed content after `=`, used several times, plus the block-body form
// where the last expression is the result. See Chapter 14, "Functions and
// closures".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

// A one-line function: everything after the = is its body.
#let greet(name) = [Hello, #name! Welcome aboard.]

#greet("Ada")

#greet("Grace")

// A block body runs several statements; the last expression is the result.
#let shout(word) = {
  let loud = upper(word)
  text(weight: "bold")[#loud!]
}

You did #shout("great") work today.
