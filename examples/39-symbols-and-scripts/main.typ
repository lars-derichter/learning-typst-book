// Symbols spelled by name (no backslashes), plus superscripts,
// subscripts, and grouping with parentheses.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Symbols and scripts

Greek letters are simply their names: $alpha$, $beta$, $gamma$,
$theta$, $pi$, $Omega$. Capitalize the name for the capital letter.

Relations and operators, likewise, by name: $x <= y$, $x >= y$,
$x != y$, $a times b$, $a dot b$, $x in A$, $A subset B$, $x -> y$,
$n -> oo$.

A caret raises a superscript and an underscore lowers a subscript:

$ x^2, quad x_i, quad x_i^2 $

Anything longer than a single token goes in parentheses, which group
without printing:

$ x^(n + 1), quad a_(i j), quad e^(-x^2 / 2) $
