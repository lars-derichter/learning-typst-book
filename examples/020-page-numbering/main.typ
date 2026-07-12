// Page numbering. Set `numbering` on the page and Typst prints the number in
// the footer automatically — no explicit footer needed. The string is a
// pattern: "1" is plain digits, "i" is lowercase roman, "1 / 1" shows the
// current page and the total.
// Compile with:  typst compile main.typ out.pdf
#set page(
  width: 9cm,
  height: 12cm,
  margin: 1.4cm,
  numbering: "1 / 1", // "current / total"
  number-align: center,
)

= A three-page document

With `numbering: "1 / 1"` the footer reads "1 / 3" on this page, "2 / 3" on
the next, and so on. Swap the pattern for "i" and you get roman numerals; swap
it for "1" and you get bare digits.

#lorem(40)

#pagebreak()
#lorem(45)

#pagebreak()
#lorem(45)
