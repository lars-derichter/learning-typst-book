// Fractions (the slash and frac), the binomial, and roots.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Fractions and roots

A slash builds a fraction, numerator over denominator. Parentheses
decide what belongs on each side:

$ 1 / 2, quad (a + b) / (c + d), quad (dif y) / (dif x) $

The `frac` function does the same job and is handy when a bare slash
would read ambiguously; `binom` stacks two terms without a rule:

$ frac(1, 1 + 1 / x), quad binom(n, k) = n! / (k! (n - k)!) $

`sqrt` takes one argument for a square root. Give `root` an index and a
radicand for anything higher:

$ sqrt(2), quad sqrt(x^2 + y^2), quad root(3, x), quad root(n, x) $
