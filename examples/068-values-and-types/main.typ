// Values and types: a literal of each everyday type, shown next to the
// type Typst reports for it with type(). repr() gives the debug view.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Values and their types

Every value has a type. You inspect it with #raw("type()"), and
#raw("repr()") shows a value the way you would write it in code:

- #repr(42) --- #type(42)
- #repr(3.14) --- #type(3.14)
- #repr("hello") --- #type("hello")
- #repr(true) --- #type(true)
- #repr(12pt) --- #type(12pt)
- #repr(50%) --- #type(50%)
- #repr([bold]) --- #type([bold])
- #repr((1, 2, 3)) --- #type((1, 2, 3))
- #repr((name: "Ada")) --- #type((name: "Ada"))

Two special values stand apart: #raw("none"), which is deliberately
nothing, and #raw("auto"), which means "let Typst decide". Each is the
sole member of its own type.
