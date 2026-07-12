// Multi-line math: \ starts a new line, & marks the alignment column.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= A short derivation

A backslash breaks the block onto a new line; an ampersand marks the
column everything should line up on. Here every line aligns on its
equals sign:

$ (a + b)^2 &= (a + b)(a + b) \
           &= a^2 + a b + b a + b^2 \
           &= a^2 + 2 a b + b^2 $

The same trick keeps the steps of a solved equation stacked neatly:

$ 3 x + 6 &= 21 \
      3 x &= 15 \
        x &= 5 $
