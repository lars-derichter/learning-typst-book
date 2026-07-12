// "Page X of Y" in a footer. The current page comes from
// `counter(page).display()`; the total comes from `counter(page).final()`,
// which returns the counter's end value as an array — `.first()` pulls the
// number out. Both live inside `context` because both depend on layout.
// Compile with:  typst compile main.typ out.pdf
#set page(
  width: 9cm,
  height: 7cm,
  margin: 1cm,
  footer: context [
    #set align(center)
    #set text(9pt)
    Page #counter(page).display() of #counter(page).final().first()
  ],
)

= A short handout

The footer counts correctly on every page: "Page 1 of 3" here, then "2 of 3",
then "3 of 3". Typst fills in that final "3" only after laying the whole
document out — it solves the page count by iterating.

#pagebreak()
#lorem(30)

#pagebreak()
#lorem(20)
