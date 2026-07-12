# Math and equations

Here is the thing every other writing tool gets wrong. You are typing along
happily, describing a result, and then you need to say that the area of a circle
is πr². In a word processor you stop, hunt through an equation editor, click a
fraction template, fight the cursor out of the little box, emerge two minutes
later with something that doesn't quite match the surrounding font. The sentence
you were writing has gone cold.

Typst was built by people who did their share of mathematics, and it shows. You
open math the way you open a parenthesis — with a symbol, mid-sentence, without
breaking stride — and Typst sets it beautifully. The circle above? You typed
`$pi r^2$`. That's the whole ceremony.

This chapter is where Typst stops being a nice Markdown and starts being a
genuine rival to LaTeX. By the end you'll typeset anything from an inline
fraction to a multi-line derivation with aligned equals signs and a numbered,
referenceable equation. Read it near a keyboard, because math is the one topic
that rewards fiddling more than reading.

## Entering math mode

A dollar sign opens math; the next dollar sign closes it. What you write between
them lives in a little world with its own rules, where letters lean into italics
and `^` means "superscript."

There are two flavors, and the gap between them is almost comically small.
Write the math snug against the dollar signs and it sets *inline*, right in the
run of your text, sized to match the words around it:

```typ
The area of a circle is $pi r^2$, and $a^2 + b^2 = c^2$ is Pythagoras.
```

Put a space just inside each dollar sign and the same content lifts out of the
paragraph and centers itself on its own line as a *block* (or *display*)
equation:

```typ
$ a^2 + b^2 = c^2 $
```

That single space is the whole switch. `$x$` is inline; `$ x $` is a display
block. It looks like a typo the first time you see it, but it reads naturally
once your fingers learn it: a little breathing room inside the dollars means a
little breathing room on the page. Example `examples/38-inline-vs-block/` sets
the very same equation both ways so you can see the two side by side.

> [!NOTE]
> The space only has to be *there*, not measured. One space or five, a space or
> a newline — Typst just checks whether whitespace touches the inside of each
> dollar sign. That's why you can spread a long block equation across several
> lines of source (as we will, soon) and it stays a block.

## Symbols have names, not backslashes

Type `$alpha$` and you get α. Type `$pi$` and you get π. This is the first big
idea of Typst math and the one that trips up everyone arriving from LaTeX:
symbols are spelled out by *name*, as plain words, with no backslash in front.

```typ
$alpha$, $beta$, $gamma$, $theta$, $pi$, and the capital $Omega$.
```

Capitalize the name and you get the capital letter — `$Omega$` is Ω, `$Gamma$`
is Γ. The same naming scheme covers relations, operators, and arrows, and here
Typst is kind enough to let you type the ones you already know as symbols:

```typ
$x <= y$, $x >= y$, $x != y$, $a times b$, $a dot b$,
$x in A$, $A subset B$, $x -> y$, $n -> oo$.
```

So `<=` becomes ≤, `!=` becomes ≠, `->` becomes →, and `oo` — two little
circles — becomes the infinity sign ∞ (its long name, `infinity`, works too).
`times` is ×, `dot` is a centered multiplication dot, `in` is ∈, `subset` is ⊂.
There are hundreds more, all discoverable in the
[symbol reference](https://typst.app/docs/reference/symbols/). Many reach a
variant with a dot: `arrow.double` for ⇒, `in.not` for ∉, `eq.not` for ≠.
Example `examples/39-symbols-and-scripts/` gathers a working set of them.

> **Coming from LaTeX.** The *ideas* map over almost unchanged. Math still lives
> between dollar signs, `^` is still superscript, `_` still subscript, and the
> `\\` you used to break a line becomes a single `\`. What changes is the
> spelling: there are **no backslash commands**. `\alpha` becomes `alpha`,
> `\infty` becomes `oo`, `\times` becomes `times`, and — the one that saves the
> most keystrokes — `\frac{a}{b}` becomes just `a/b`. Once the backslashes fall
> away, most equations get *shorter*.

Here's a wrinkle worth knowing early, because the error message is friendly but
surprising. In Typst math, a run of letters is a *single* name. Typing `$ab$`
doesn't mean "a times b" — it means "the symbol called `ab`," which doesn't
exist, so Typst stops and says so (and suggests putting a space between
the letters). To multiply two variables, separate them with a space: `$a b$`.
That space also explains why `sin`, `log`, and friends work the way they do —
which is the next stop.

## Superscripts and subscripts

A caret raises the thing after it; an underscore lowers it. This part *is* just
like LaTeX:

```typ
$x^2$, $x_i$, $x_i^2$
```

A single caret or underscore grabs one token — one letter, one digit, one
symbol. The moment you want more than that, wrap it in parentheses, which group
without printing anything:

```typ
$x^(n + 1)$, $a_(i j)$, $e^(-x^2 / 2)$
```

Without the parentheses, `$x^n + 1$` would raise only the `n` and leave `+ 1` on
the baseline — occasionally what you want, usually not. The parentheses are the
fix, and you'll reach for them constantly. Note `$a_(i j)$`: the space keeps `i`
and `j` as two subscript letters sitting together, rather than a nonexistent
symbol named `ij`.

## Fractions and roots

The slash is a fraction. Whatever sits to its left becomes the numerator and
whatever sits to its right becomes the denominator, and Typst is smart about how
far each side reaches:

```typ
$1/2$, $(a + b)/(c + d)$, $(dif y)/(dif x)$
```

A bare `1/2` stacks one over two. Parentheses decide where each half stops, so
`(a + b)/(c + d)` puts the whole sum on each level. There's also a spelled-out
`frac(a, b)` for when a slash would read ambiguously, and `binom(n, k)` for a
binomial coefficient — two things stacked in parentheses with no rule between
them:

```typ
$frac(1, 1 + 1/x)$, $binom(n, k) = n! / (k! (n - k)!)$
```

Roots come in two shapes. `sqrt(x)` is a square root over whatever's inside the
parentheses; `root(3, x)` is a cube root, and in general `root(n, x)` sets the
index `n` in the crook of the radical:

```typ
$sqrt(2)$, $sqrt(x^2 + y^2)$, $root(3, x)$, $root(n, x)$
```

The radical stretches to cover its whole argument automatically — one of those
small kindnesses you stop noticing until you go back to a tool that doesn't do
it. Example `examples/40-fractions-and-roots/` collects fractions, the binomial,
and both roots.

## Functions and operators

Type `$sin x$` and Typst sets "sin" upright and "x" italic, with a hair of space
between them — exactly the convention you learned in school. It manages this
because `sin` is a known operator. So are `cos`, `tan`, `log`, `ln`, `exp`,
`lim`, `max`, `min`, `det`, and a long list of others: they render upright, the
way function names should, while single-letter variables stay italic.

Why does `sin` come out upright when `x` comes out italic? Because `sin` is one
identifier and a *known* one — Typst defines it, set upright the way an
operator should be. Single letters have no such definition, so they stay
italic variables. (An unknown multi-letter run, recall, is an error, not silent
italics.) When you want an arbitrary word upright — a subscript label, say — put
it in quotes:

```typ
$V_"max"$ and $k_"cat"$ set "max" and "cat" as upright labels.
```

When you need an operator Typst doesn't already know, build one with `op` and a
quoted name. Give it `limits: true` if its sub- and superscripts should stack
above and below in display mode, the way `lim` and `sum` do:

```typ
$ op("argmax", limits: true)_(x in X) f(x) $
```

If you use the same operator often, define it once in code and reuse the name:

```typ
#let argmin = math.op("argmin", limits: true)
$ argmin_theta L(theta) $
```

## Sums, integrals, and other big operators

Big operators are where display mode earns its keep. Write the bounds as an
ordinary subscript and superscript, and Typst places them wherever the context
wants. In a block, the bounds climb above and below the operator:

```typ
$ sum_(i=1)^n i = (n (n + 1)) / 2 $
$ integral_a^b f(x) dif x $
$ product_(k=1)^n k = n! $
$ lim_(x -> 0) (sin x) / x = 1 $
```

Those four — `sum`, `integral`, `product`, `lim` — set as a fat summation sign
with `i=1` tucked underneath and `n` on top, an integral with its limits on the
right, and so on. Two small things to notice. `dif` is the upright "d" of a
differential (`dif x` for d*x*); writing a plain italic `d` would technically
work but reads worse. And `lim_(x -> 0)` puts the whole arrow expression under
the word "lim," because `lim` is one of those `limits: true` operators.

The clever part is that the *same source* behaves differently inline. Drop a sum
into a sentence and Typst moves the bounds to the side to keep the line from
growing tall: the series $sum_(n=0)^oo 1/2^n = 2$ sits politely on one line, its
`n=0` and `∞` shrunk to script size beside the sign. Example
`examples/41-sums-and-integrals/` shows both placements.

> [!TIP]
> Want a block-style stacked sum *inline* anyway, or side-set bounds in a block?
> Wrap the operator in `limits(...)` to stack or `scripts(...)` to force
> the side. You'll rarely need to, but it's there when a line looks cramped.

## Matrices, vectors, and cases

Three functions cover most of the structured math you'll write, and they share a
tidy convention: a comma separates entries across a row, a semicolon ends the
row.

`mat` builds a matrix:

```typ
$ A = mat(1, 2; 3, 4) $
```

`vec` stacks its arguments into a column vector — no semicolons needed, since a
column is one-per-row by definition:

```typ
$ v = vec(x, y, z) $
```

Both come wrapped in parentheses by default. Change the fence with `delim`:
square brackets for a plain matrix, vertical bars for a determinant, or any
delimiter you like:

```typ
$ mat(delim: "[", 1, 0; 0, 1) $
$ mat(delim: "|", a, b; c, d) $
```

`cases` sets a brace-delimited list of alternatives — the shape you want for a
piecewise definition. Inside it, an `&` marks where the conditions should line
up, so the "if" clauses form a neat column:

```typ
$ abs(x) = cases(
  x   & "if" x >= 0,
  -x  & "if" x < 0,
) $
```

The `"if"` in quotes is literal text, set upright — more on that shortly. All
three functions, plus the custom delimiters, live in
`examples/42-matrices-and-vectors/`.

## Lining equations up

A real derivation is several lines that want to agree on a vertical line — every
equals sign stacked, so the eye runs straight down the middle. Typst gives you
two characters for this, both usable only inside a display block. A backslash
`\` starts a new line. An ampersand `&` marks the alignment column: everything
before the `&` on each line is pushed right up to it, everything after flows
left from it.

Put the `&` just before each equals sign and the whole derivation snaps into
column:

```typ
$ (a + b)^2 &= (a + b)(a + b) \
           &= a^2 + a b + b a + b^2 \
           &= a^2 + 2 a b + b^2 $
```

Only the first line carries the `(a + b)^2`; the later lines start with `&`, so
their left side is empty and they hang from the equals sign. It sets exactly the
way a careful teacher writes it on a board. The same move keeps the steps of a
solved equation aligned:

```typ
$ 3 x + 6 &= 21 \
      3 x &= 15 \
        x &= 5 $
```

Example `examples/43-aligned-equations/` has both. You can use more than one `&`
per line to make several alignment columns (for a system of equations, say), but
one is enough to cover the common case, and it's the one to learn first.

> [!WARNING]
> The `\` line break and the `&` alignment marker are math-mode citizens. They
> only mean this inside a `$ … $` block. Out in ordinary markup a `\` is still a
> hard line break, but there is no `&` alignment there — that's what tables and
> grids are for (Chapter 7).

## Text, styles, and dropping into code

Sooner or later you need a real word inside an equation — an "if," a "where," a
short label. Bare letters won't do it, because Typst reads them as multiplied
variables. Wrap the words in double quotes and they set as upright text at the
right size:

```typ
$ f(x) = x^2 quad "for all" x in RR $
```

For emphasis and weight there are functions that mirror the markup ones:
`upright(x)` forces upright, `bold(x)` sets bold (heavier than the default math
italic), and `italic(x)` forces italic. Accents ride on top of a letter as
functions too — `hat(x)` for x̂, `arrow(v)` for a vector arrow, `bar(x)`,
`dot(x)`, `tilde(a)`.

When the value you want isn't a symbol but a *computed number*, escape out of
math and into Typst's code with `#`, exactly as you do in markup:

```typ
$ pi approx #calc.round(calc.pi, digits: 4) $
```

That drops in `3.1416`, computed at compile time. The `#` is the same doorway
into code you met in Chapter 3; it works inside math just as it does outside.

One more practical matter: spacing. Inside math, Typst decides the spacing for
you based on what things *are* — a bit of space around a `+`, a hair between
juxtaposed variables — and it ignores how many spaces you typed in the source.
`$x=y$` and `$x = y$` come out identical. When you genuinely want to *insert*
space, ask for it by name: `quad` is a wide gap (for separating two formulas
on one line), `space` is a normal word space, and `thin` is a thin sliver. For
anything bespoke, `#h(1em)` reaches for the horizontal-space function markup
uses.

## Numbering and cross-references

By default, equations aren't numbered — a display block just sits there,
anonymous. Turn numbering on with a single set rule, and from that point every
block equation gets a number on the right margin:

```typ
#set math.equation(numbering: "(1)")
```

The `"(1)"` is a numbering *pattern*: the digit `1` is the counter and the
parentheses are literal, so you get (1), (2), (3). (The same pattern language
runs headings and lists; Chapter 9 gives it the full treatment.) Inline math is
left alone — only display blocks are numbered — so your prose doesn't sprout
numbers mid-sentence.

A number is only useful if you can point at it. Pin a label on an equation by
writing it in angle brackets right after the closing dollar sign, then refer to
it from anywhere with `@`:

```typ
$ e^(i pi) + 1 = 0 $ <eq:euler>

Euler's identity, @eq:euler, is often called the most beautiful equation
in mathematics.
```

Typst fills in `@eq:euler` as "Equation 1," rendered as a live link to
the equation, and — this is the payoff — the number stays correct no matter how
you shuffle the document. Add three equations above this one and it quietly
becomes Equation 4, reference and all. The `eq:` part of the name is just a
convention to keep equation labels distinct from labels on figures or headings;
Typst doesn't require it, but your future self will thank you.
Example `examples/44-numbered-equations/` turns numbering on, labels two
equations, and references both.

> [!NOTE]
> A reference reads "Equation 1" because that's the default supplement for an
> equation. You can change the wording, or drop it, when you tune references
> in Chapter 11. For now, plain `@eq:euler` gives a correct, clickable number
> — which is most of what you wanted.

## What you've got

You can now typeset mathematics, not just decorate a page with it:

- **Two ways in** — inline `$x$` for math in the run of text, and `$ x $` (mind
  the spaces) for a centered display block.
- **Symbols by name** — `alpha`, `pi`, `sum`, `oo`, `->`, `<=`, `in` — no
  backslashes, and multi-letter runs are single names, so variables need spaces
  between them.
- **Scripts** with `^` and `_`, grouped past one token with parentheses:
  `x^(n+1)`, `a_(i j)`.
- **Fractions and roots** — `a/b`, `frac`, `binom`, `sqrt`, `root(3, x)`.
- **Functions and operators** — `sin`, `log`, `lim` set upright automatically,
  plus `op(...)` and `math.op(...)` for your own.
- **Big operators** — `sum`, `integral`, `product`, `lim` with bounds that stack
  in display and tuck to the side inline.
- **Structures** — `mat`, `vec`, and `cases`, with `delim` to choose the fence.
- **Alignment** — `\` for a new line and `&` for the column — derivations that
  line up on the equals sign.
- **Text and code inside math** — `"quoted words"`, `upright`/`bold`/`italic`,
  accents, and `#` to drop in a computed value.
- **Numbering and references** — `#set math.equation(numbering: "(1)")`, a
  `<eq:name>` label, and an `@eq:name` cross-reference that stays correct.

That is enough to set the mathematics in a homework sheet, a physics lab report,
or a research paper. The reference documentation lists every symbol and function
by name; now that you know the shape of the system, that list reads like a menu
instead of a wall.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

8.1. Write one sentence of ordinary prose that contains the inline equation
"E = mc²" (use the caret for the square). Then, on the next line, set the
quadratic formula *x* = (−*b* ± √(*b*² − 4*ac*)) / 2*a* as a centered display
block. Compile it and confirm the first stays in the line and the second stands
alone. (The ± is `plus.minus`.)

8.2. Typeset the definition of the standard normal density,
*f*(*x*) = (1/√(2π)) · e^(−x²/2), as a display block. You'll need a fraction, a
square root, `pi`, and a grouped exponent — mind where the parentheses go.

8.3. Set the sum of the first *n* squares as a numbered display equation:
∑ from *i*=1 to *n* of *i*² = *n*(*n*+1)(2*n*+1)/6. Turn on equation numbering,
give it the label `<eq:squares>`, and then, in a following sentence, refer to it
with `@eq:squares`.

8.4. Typeset a 2×2 matrix *M* = [[cos θ, −sin θ], [sin θ, cos θ]] (the rotation
matrix) using square-bracket delimiters, then a piecewise definition of the sign
function sgn(*x*) using `cases` with three branches (−1, 0, 1) whose conditions
line up on an `&`.

8.5. *(Stretch.)* Write a three-line derivation aligned on its equals sign, that
starts from *a*² − *b*² and ends at (*a* − *b*)(*a* + *b*), showing at least one
intermediate step. Then define a custom operator with `math.op` (for example,
`argmax` or `Var`) and use it in a display equation with a subscript. Verify
the whole thing compiles with no warnings.

<!--
SOLUTIONS (notes for the appendix author):
8.1 - Inline: `Einstein showed that $E = m c^2$ ties mass to energy.` Note the
      SPACE in `m c^2` (mc is one identifier and errors). Display block:
      `$ x = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a) $` — spaces inside
      `4 a c` and `2 a` are required so they read as products, not names. Point:
      the space-inside-dollars rule plus the multi-letter-identifier trap.
8.2 - `$ f(x) = 1/sqrt(2 pi) e^(-x^2 / 2) $` or with an explicit dot
      `1/sqrt(2 pi) dot e^(-x^2 / 2)`. The exponent MUST be parenthesised:
      `e^(-x^2 / 2)`, otherwise only `-x^2` (or less) is raised. Accept
      `(1/sqrt(2 pi))` with outer parens too.
8.3 - `#set math.equation(numbering: "(1)")` near the top, then
      `$ sum_(i=1)^n i^2 = (n (n + 1) (2 n + 1)) / 6 $ <eq:squares>` and a
      sentence containing `@eq:squares`. Watch the spaces in `n (n + 1) ...` and
      `2 n`. Whole numerator grouped in one paren pair over 6.
8.4 - `$ M = mat(delim: "[", cos theta, -sin theta; sin theta, cos theta) $`.
      Sign function:
      `$ op("sgn")(x) = cases(
         1  & "if" x > 0,
         0  & "if" x = 0,
         -1 & "if" x < 0,
      ) $`  (or a plain `"sgn"(x)`). Key points: delim: "[" for brackets, ; ends
      matrix rows, & aligns the cases conditions, quoted "if" text is upright.
8.5 - Derivation aligned on `=`:
      `$ a^2 - b^2 &= a^2 - a b + a b - b^2 \
                   &= a(a - b) + b(a - b) \
                   &= (a - b)(a + b) $`
      (any valid intermediate step is fine; must use \ for newlines and & before
      each =). Custom operator, e.g.:
      `#let Var = math.op("Var")` then `$ Var(X) = op(EE)[X^2] - op(EE)[X]^2 $`
      or simpler `$ argmax_x f(x) $` with
      `#let argmax = math.op("argmax", limits: true)`. Accept any op that
      compiles cleanly with a subscript. Must build with no warnings.
-->
