// Big operators carrying limits: sum, integral, product, and lim.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Big operators with limits

Write the bounds as an ordinary subscript and superscript. In a block,
Typst lifts them above and below the operator:

$ sum_(i=1)^n i = (n (n + 1)) / 2 $

$ integral_a^b f(x) dif x $

$ product_(k=1)^n k = n! $

$ lim_(x -> 0) (sin x) / x = 1 $

Inline, the same operator tucks its bounds to the side to save vertical
space, so a sentence stays a sentence: the geometric series
$sum_(n=0)^oo 1 / 2^n = 2$ converges.
