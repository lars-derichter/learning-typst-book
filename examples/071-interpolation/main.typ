// Interpolation: compute values once with let, then splice them into
// the document with #. Change a price and every total updates.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#let espresso = 3
#let sandwich = 8
#let cookie = 2
#let subtotal = espresso + sandwich + cookie
#let vat = calc.round(subtotal * 0.21, digits: 2)
#let total = subtotal + vat

= Café Turing --- receipt

#table(
  columns: (1fr, auto),
  align: (left, right),
  stroke: none,
  [Espresso], [#espresso],
  [Sandwich], [#sandwich],
  [Cookie], [#cookie],
  table.hline(),
  [Subtotal], [#subtotal],
  [VAT (21%)], [#vat],
  [*Total*], [*#total*],
)

All amounts in euro. Not one number in this table was typed twice ---
change a price above and the subtotal, VAT, and total all follow.
