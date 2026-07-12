// Conditionals: content-producing `if` in markup, and `if` as an
// expression whose value you store in a variable.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let stock = 3

= Order status

// An `if` in markup chooses which block of content to print.
#if stock > 0 [
  In stock --- #stock left. Ships today.
] else [
  Out of stock. We will email you when it returns.
]

// An `if` is also an expression: it evaluates to a value you can store.
#let badge = if stock == 0 {
  "SOLD OUT"
} else if stock < 5 {
  "LOW STOCK"
} else {
  "AVAILABLE"
}

Inventory badge: *#badge*
