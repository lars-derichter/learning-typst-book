// A set rule reaches from where it is written to the end of its enclosing
// scope -- no further. Inside a content block [ ... ] it is local: the
// text before and after the block keeps the document defaults.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

This opening line uses the ordinary document defaults.

#[
  #set text(fill: blue, style: "italic")
  This whole block is blue and italic, because the set rule lives
  inside the square brackets and applies only until they close.
]

And this closing line is back to the defaults -- black and upright.
The set rule never escaped its block.
