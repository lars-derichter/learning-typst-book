// let bindings: name a value once, then reuse it by writing its name
// with a hash. Rebinding replaces the value from that point on.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 12pt)

#let course = "Typst for teachers"
#let seats = 24
#let price = 15

= #course

Enrolment is capped at #seats seats, at #price euro each. If every
seat sells, that is #(seats * price) euro --- a figure Typst computes
from the two numbers above, so it can never drift out of sync.

#let price = 12
After the early-bird discount the price is #price euro, and a full
room now brings #(seats * price) euro. The name #raw("price") points
at the new value from here on; nothing above this line changed.
