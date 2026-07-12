// A variadic parameter (`..items`) collects any number of extra arguments into
// an `arguments` value; read the positional ones back with `.pos()`. At a call
// site, `..array` spreads a sequence into separate arguments again. See
// Chapter 14, "Functions and closures".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

// Collect every argument into `items`, then join them into a breadcrumb trail.
#let breadcrumbs(..items) = items.pos().join(text(fill: gray)[ › ])

#breadcrumbs("Home", "Docs", "Functions")

#v(6pt)

// A computing variadic: sum however many numbers you pass.
#let total(..nums) = nums.pos().sum()

Sum of 2, 4, 6, 8 = #total(2, 4, 6, 8).

#v(6pt)

// Spread an existing array into the call as separate arguments.
#let path = ("Users", "ada", "notes.typ")
#breadcrumbs(..path)
