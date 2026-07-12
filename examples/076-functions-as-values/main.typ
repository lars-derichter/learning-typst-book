// Functions are values: store them in variables, pass them to other functions,
// and return them. Arrow syntax writes a function inline (`x => x * 2`), and a
// function that returns a function is a closure — it captures variables from
// where it was defined. See Chapter 14, "Functions and closures".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

// An arrow function stored in a variable.
#let double = x => x * 2

// A function that takes another function as an argument.
#let twice(f, x) = f(f(x))

Double 5 = #double(5). \
Double applied twice to 5 = #twice(double, 5).

#v(6pt)

// A closure factory: multiplier(n) returns a new function that remembers n.
#let multiplier(n) = x => x * n

#let triple = multiplier(3)
#let tenfold = multiplier(10)

Triple 4 = #triple(4). \
Tenfold 4 = #tenfold(4).
