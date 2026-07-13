# From markup to code

You have been writing Typst for twelve chapters, and the whole time a
second language has been hiding behind a single character. Every `#set
text(...)`, every `#lorem(30)`, every `#let draft = true` from the last
chapter reached across a border into it. You used the crossings without
being told they were crossings. Time to look at the map.

That border separates Typst's two halves. On one side is **markup** —
the mode you have written all book, where `=` makes a heading and
`*word*` makes it bold and everything you type lands on the page as
content. On the other side is **code** — a small, real programming
language with variables, values, arithmetic, and types. The `#` is the
door between them, and it swings both ways.

This is the first chapter of Part IV, and its whole job is to make that
language stop feeling like magic. If you have never programmed, good:
we start from nothing, and by the end you will read `#(seats * price)`
the way you now read `*bold*`. If you have programmed, this will go
quickly, but skim it anyway — Typst has a couple of ideas that no other
language does, and the round-trip between markup and code is one of them.

## The two worlds

Here is the border in a single file (`examples/066-into-code-and-back/`):

```typ
This sentence is markup. Type a hash and Typst reads what follows
as one code expression: two plus two is #(2 + 2), and
#upper("shouting") comes back in capitals.
```

The plain text is markup, set as-is. Then `#(2 + 2)` happens: the hash
tells Typst "the next thing is code, not words," Typst computes `4`, and
drops the `4` back onto the page. `#upper("shouting")` is the same move —
`upper` is a function that uppercases a string, and its result, the text
`SHOUTING`, lands in the sentence. From the reader's side it is one
smooth line. Underneath, you crossed into code twice and came back.

That is the first direction: **`#` in markup drops you into a single code
expression.** Just one. The hash reaches forward exactly as far as one
complete expression and no further — `#upper("shouting")` is one call, so
the whole call comes along, but the space after it is markup again.

The second direction is the mirror image. Inside code, square brackets
open a **content block** — a patch of markup you can write right in the
middle of the language:

```typ
#{
  let mood = "sunny"
  [The forecast is *#mood* today.]
}
```

The `#{ ... }` is a block of code. The `let` line is code. But
`[The forecast is *#mood* today.]` is markup again — headings, `*bold*`,
the lot — with one more `#` splicing the code value `mood` back in. So
the trip reads: markup → code → markup → code → markup, all in four
lines. This round-trip is the mental model for the entire part. Hold onto
it:

> [!IMPORTANT]
> `#` takes you from markup into code. `[...]` takes you from code back
> into markup. Content blocks nest inside code, code nests inside content
> blocks, as deep as you like. Nothing about Typst's scripting makes sense
> until this click into place — so if it hasn't yet, reread the two
> snippets above before moving on.

## Naming a value with `#let`

The most useful thing you can do in code is give a value a name. Typst's
word for that is `let` (you met it in passing last chapter). Write a name,
an equals sign, and a value:

```typ
#let pi = 3.14159
```

That is a **binding**: the name `pi` is now bound to the value `3.14159`.
From this line onward you can write `#pi` in your markup and get the
number back:

```typ
A circle's circumference is #pi times its diameter.
```

Notice there are no parentheses around `#pi`. The rule is simple: `#`
followed by a single token — a name, a number, a function call — needs
nothing extra. It is only when the expression is built from several pieces
that you wrap it in parentheses so Typst knows where it ends. `#pi` is
fine; `#pi * 2` would confuse the markup parser (is that `*` the start of
bold text?), so you write `#(pi * 2)`. More on that in a moment.

Names earn their keep the instant a value appears twice. Example
`examples/067-let-bindings/` runs a tiny course flyer on three of them:

```typ
#let course = "Typst for teachers"
#let seats = 24
#let price = 15

= #course

Enrolment is capped at #seats seats, at #price euro each. If every
seat sells, that is #(seats * price) euro.
```

`#(seats * price)` computes `360` from the two numbers above it. The
payoff is not saving a multiplication — it is that the `360` cannot lie.
Change `seats` to `30` and the total becomes `450` on the next compile,
with no second edit and no chance of the heading and the arithmetic
disagreeing. A value written once and referred to by name is a value that
stays consistent with itself.

### Rebinding, and where a name reaches

A binding is not carved in stone. Write `let` again with the same name and
you **rebind** it — the name points at the new value from that line
forward:

```typ
#let price = 15
Early price: #price euro.

#let price = 12
Discounted price: #price euro.
```

The first sentence prints `15`, the second prints `12`. This is the second
half of example 067. Nothing above the second `let` changes; the new value
takes over only from where you wrote it.

That "from where you wrote it" is the whole rule for a binding's reach. A
name is visible from its definition down to the end of the block it lives
in — for a top-level `let`, that means the rest of the document. Ask for a
name *before* you have bound it and Typst stops with an error, because at
that point in the file the name genuinely does not exist yet. If you have
read Chapter 9 on set rules, this will feel familiar: like a set rule, a
binding reaches forward, never backward.

> [!TIP]
> Put the bindings a document depends on — a colour, a client's name, a
> tax rate — in a little cluster near the top of the file. Then the values
> that steer everything are in one place, and tuning the document is a
> matter of editing that block, not hunting through the prose.

## Values have types

Every value in Typst has a **type** — a category that says what kind of
thing it is and what you can do with it. `3.14159` is a number; `"sunny"`
is a piece of text; `true` is a yes-or-no. Types are not bureaucracy; they
are how Typst knows that `2 + 2` is arithmetic but `"foo" + "bar"` is
gluing text together. You will rarely name a type out loud, but knowing the
cast of characters makes every error message and every reference-manual
page readable.

You can ask any value its type with the `type` function, and see how a
value is written with `repr` (short for *representation*, a debug view).
Example `examples/068-values-and-types/` lays out one literal of each
everyday type beside the type Typst reports:

```typ
- #repr(42) --- #type(42)
- #repr(3.14) --- #type(3.14)
- #repr("hello") --- #type("hello")
- #repr(true) --- #type(true)
- #repr(12pt) --- #type(12pt)
- #repr(50%) --- #type(50%)
- #repr([bold]) --- #type([bold])
- #repr((1, 2, 3)) --- #type((1, 2, 3))
- #repr((name: "Ada")) --- #type((name: "Ada"))
```

which prints:

```text
42 — int
3.14 — float
"hello" — str
true — bool
12pt — length
50% — ratio
[bold] — content
(1, 2, 3) — array
(name: "Ada") — dictionary
```

Read down that list — it is the working vocabulary of the whole language:

- **Integer** (`int`) — a whole number: `42`, `-7`, `0`.
- **Float** (`float`) — a number with a fractional part: `3.14`, `0.5`.
  ("Float" is short for *floating-point*, the standard way computers store
  such numbers.)
- **String** (`str`) — text in double quotes: `"hello"`. Note the quotes:
  in code, text must be quoted, because unquoted words are names. This is
  the opposite of markup, where text is just text.
- **Boolean** (`bool`) — one of exactly two values, `true` or `false`.
  The stuff of yes/no decisions, and of every `if` condition
  ([Chapter 15](15-control-flow.md)).
- **Length** — a measurement: `12pt`, `2cm`, `1em`. These carry a unit, so
  they know that `1em` scales with the font while `12pt` does not.
- **Ratio** — a percentage: `50%`, `100%`. A fraction of something,
  resolved once Typst knows what that something is.
- **Content** — a piece of typeset material: the result of `[bold]`, a
  heading, an image, a whole chapter. Every content block `[...]` is a
  value of this type, which is exactly why you can bind one to a name.
- **Array** — an ordered list of values: `(1, 2, 3)`.
  [Chapter 16](16-arrays-dictionaries-strings.md).
- **Dictionary** — values stored under named keys: `(name: "Ada")`. Also
  Chapter 16.

Two more values round out the set, and they are special enough to name on
their own: **`none`** and **`auto`**. `none` is deliberately nothing — the
absence of a value, what a set rule uses to mean "no stroke," "no fill,"
"no header." `auto` means "decide for me" — the default many parameters
take, letting Typst pick a sensible value from context. Each is the only
value of its own type, a singleton. You will meet both constantly; for now
just recognise them as legitimate values, not mistakes.

> [!NOTE]
> `type` and `repr` are your two flashlights. When a value surprises you —
> a function hands back something you did not expect, or an expression
> won't compile — drop a `#repr(mystery)` into the page and *look* at it.
> Half of learning a language is learning to interrogate it, and these are
> the two questions that always get an answer.

## Operators

With values and types in hand, you can compute. Typst's operators are the
ones you would guess, and they respect the arithmetic you learned in school
(`examples/069-operators/`):

```typ
- #(3 + 4 * 2)     // 11 — times binds tighter than plus
- #((3 + 4) * 2)   // 14 — parentheses override it
- #repr(6 / 2)     // 3.0 — division always gives a float
```

The four arithmetic operators are `+`, `-`, `*`, `/`, with `*` and `/`
binding tighter than `+` and `-`, and parentheses to override the order
when you need to. One quirk worth filing away: **division always produces a
float**, even when it comes out even. `6 / 2` is `3.0`, not `3`. If you
specifically need whole-number division or a remainder, `calc.div-euclid`
and `calc.rem` give them to you; most of the time the float is exactly what
you want.

Comparisons ask a question and answer with a boolean:

```typ
- #(3 < 5)      // true
- #(3 == 3.0)   // true
- #(4 != 4)     // false
```

The full set is `==` (equal), `!=` (not equal), `<`, `>`, `<=`, `>=`. Note
`==`, two equals signs, for *comparison* — a single `=` is the binding
from `#let`, an entirely different job. And `3 == 3.0` is `true` because
Typst compares the numbers, not their spelling.

Booleans combine with three plain-English operators — `and`, `or`, `not` —
rather than symbols:

```typ
- #(true and false)   // false
- #(true or false)    // true
- #(not true)         // false
```

Finally, the operator that does the most surprising double duty. `+` adds
numbers, yes, but it is really a **joiner**, and it will join anything
joinable — strings end to end, arrays into a longer array, and even content
into more content:

```typ
- #("Lear" + "ning")        // Learning
- #repr((1, 2) + (3, 4))    // (1, 2, 3, 4)
- #([Hello ] + [world])     // Hello world
```

That last one is quietly powerful. Because content is a value and `+`
joins it, you can build up a document by adding pieces together — a fact
that pays off the moment you start writing your own functions in
[Chapter 14](14-functions-and-closures.md).

## Two kinds of block

You have now seen both of Typst's blocks in passing; here they are
side by side, because knowing which to reach for is half of writing clean
code (`examples/070-code-vs-content-blocks/`).

A **content block** `[...]` produces content. Whatever markup you put
between the brackets becomes a content value — one you can drop on the
page immediately, or bind to a name and place later:

```typ
#let reminder = [Remember to *save* first.]

#reminder
```

`reminder` holds a bold-bearing sentence as a value. Writing `#reminder`
sets it. You could place it three times, or hand it to a function; it is
just content, sitting in a variable.

A **code block** `{...}` runs a sequence of statements and evaluates to
their joined result. Reach for it when you need to do a few things — bind
some names, compute — before you produce output:

```typ
#{
  let w = 8
  let h = 5
  [The rectangle is #w by #h, so its area is ]
  [#(w * h).]
}
```

Inside the braces, the two `let` lines do their work quietly (a binding
produces no content), and the two content lines are joined into a single
piece of content, which the block hands back to the page:
`The rectangle is 8 by 5, so its area is 40.` That is the rule for a code
block's value in one sentence: **everything the block produces, joined
together** — and since `let` statements produce nothing, what is left is
your actual result.

So: `[...]` when you want content, `{...}` when you want to run several
steps. In markup you prefix either with a hash — `#[...]`, `#{...}` — to
drop into it. In code you are already inside the language, so the bare
`[...]` and `{...}` are enough.

## Putting values back: interpolation

Computing a value is only useful if you can get it onto the page, and you
already know how: write `#` and the expression. Splicing a computed value
back into the document like this is called **interpolation**, and it is the
punchline of the whole chapter. `#pi`, `#(2 + 2)`, `#upper("hi")`,
`#(seats * price)` — every one of these computes something and drops the
result into the flowing text.

The one rule to remember is the parentheses rule from earlier, now with a
reason attached. A bare `#name` or `#function(...)` is unambiguous, so it
needs no parentheses. But an expression with an operator in it —
`#(a + b)`, `#(price * 1.21)` — must be wrapped, because otherwise the
markup parser sees the `+` or `*` and wonders whether you meant text
formatting. The parentheses say "all of this is one code expression; read
it as arithmetic."

Example `examples/071-interpolation/` puts every idea in this chapter to
work on something you might actually print — a café receipt whose figures
compute themselves:

```typ
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
```

The prices are named once at the top. `subtotal` adds them; `vat` takes
21% and rounds to two decimals with `calc.round`; `total` adds the two.
The table's right column is nothing but interpolations — `#espresso`,
`#subtotal`, `#total` — so not a single number is typed twice. Change the
price of a sandwich and the subtotal, the VAT, and the total all move on
the next compile. That is the difference between a document you *type* and
a document you *compute*, and it is the reason the rest of Part IV exists.

## A first taste of methods

One last thing to plant, because you will trip over it soon. Many values
carry their own little functions, called **methods**, that you call with a
dot after the value:

```typ
- #("hello".len())      // 5
- #((1, 2, 3).len())    // 3
```

`"hello".len()` asks the string how long it is; `(1, 2, 3).len()` asks the
array how many items it holds. The dot means "call this value's own
function." Strings, arrays, and dictionaries come loaded with these —
ways to slice, search, sort, reverse, and reshape — and they get a whole
chapter of their own (Chapter 16). For now, just recognise the shape:
`value.method(...)` is a value answering a question about itself.

> **Coming from LaTeX.** TeX has "programming" too, but of a peculiar
> kind: it is macro *expansion*, textual substitution where `\newcommand`
> pastes tokens and you count expansion passes, wrestle `\expandafter`,
> and discover that a "variable" is really a stretch of replacement text.
> There are no first-class values, no types, no `2 + 2` that simply
> evaluates to `4`. Typst throws all of that out and gives you an ordinary
> expression language: values you can name, types you can inspect,
> operators that mean what they say, and functions that take arguments and
> return results. The mental weight lifts. You stop thinking about *when*
> things expand and start thinking about *what* they are.

## What you've got

You can now read and write Typst's scripting language at a beginner's
level, which is most of the way to fluent:

- **The round-trip** — `#` drops from markup into a single code
  expression; `[...]` drops from code back into a content block. The two
  nest inside each other without limit.
- **Bindings** — `#let name = value` names a value; `#name` uses it. A
  binding reaches from its line to the end of its block, and rebinding
  with a second `let` replaces it from that point on.
- **Types** — the everyday cast: `int`, `float`, `str`, `bool`, `length`,
  `ratio`, `content`, `array`, `dictionary`, plus the singletons `none`
  and `auto`. Inspect any value with `#type(x)` and see it plainly with
  `#repr(x)`.
- **Operators** — arithmetic (`+ - * /`, with `/` always yielding a
  float), comparison (`== != < > <= >=`), logic (`and or not`), and `+`
  as a universal joiner for strings, arrays, and content.
- **Blocks** — `[...]` produces content; `{...}` runs statements and
  evaluates to their joined result. Prefix either with `#` to enter it
  from markup.
- **Interpolation** — computing values and splicing them back with `#`,
  parenthesising any expression that is more than a single token.
- **Methods** — the `value.method(...)` shape, a taste of the machinery
  Chapter 16 opens up.

Next chapter turns the corner from *using* values to *making machines that
produce them*: functions, the single most powerful idea in the language,
and the thing every `#set`, `#table`, and `#upper` you have written was
secretly one of all along.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

13.1. Bind three values at the top of a file: your name as a string, your
age as an integer, and a favourite colour as a string. Then write one
sentence of markup that interpolates all three, so the sentence is
assembled entirely from the bindings rather than typed out.

13.2. Predict, *without compiling*, what each of these prints, then check
yourself: `#(10 - 2 * 3)`, `#repr(9 / 4)`, `#("na" + "na" + " batman")`,
`#(5 <= 5)`, `#(not (3 > 4))`. For the second one, explain why the answer
has a decimal point.

13.3. Write a line that uses `#type` and `#repr` to inspect three values of
your own choosing, one of them a content block `[...]`. Read the reported
types back and make sure each matches the value you wrote.

13.4. Build a mini invoice like example 071, but for three items of your
choosing with your own prices. Compute a subtotal, add a 6% tax rounded to
two decimals with `calc.round`, and a total, and interpolate all three into
a small table. Then change one price and recompile to confirm every derived
figure updates on its own.

13.5. *(Stretch.)* Using a single code block `#{ ... }`, bind two numbers,
then produce a piece of content that states both numbers and their sum and
their product in one sentence — for example, "8 and 5 sum to 13 and
multiply to 40." Everything the reader sees should come out of the one
block. (Hint: the block's value is its joined content, so a `[...]` line at
the end carries your result out; interpolate the arithmetic inside it.)

<!--
SOLUTIONS (notes for the appendix author):
13.1 - e.g.
         #let name = "Ada"
         #let age = 36
         #let colour = "green"
         My name is #name, I am #age, and I like #colour.
       Point: the sentence contains no literal data, only interpolations.
       Bare #name / #age need no parens (single tokens).
13.2 - #(10 - 2 * 3)      -> 4    (multiplication first: 10 - 6)
       #repr(9 / 4)       -> 2.25 (division always yields a float)
       #("na" + "na" + " batman") -> "nana batman" (string join; prints
                                     nana batman on the page)
       #(5 <= 5)          -> true
       #(not (3 > 4))     -> true (3 > 4 is false; not false is true)
       Decimal point on 9/4 because / always produces a float, even though
       here it is not even anyway. Compare with #repr(8 / 4) -> 2.0 to make
       the "always a float" point land.
13.3 - Any three, one being [ ... ]. e.g.
         #type(42) / #repr(42)          -> int / 42
         #type("hi") / #repr("hi")      -> str / "hi"
         #type([*x*]) / #repr([*x*])    -> content / strong(body: [x])
       repr of content shows its internal element form (here strong(...));
       the exact text is unimportant, the type (content) is the check.
       For plain content, e.g. #repr([bold]) -> [bold].
13.4 - Mirror of example 071 with tax rate 6%:
         #let a = 10
         #let b = 4
         #let c = 6
         #let subtotal = a + b + c
         #let tax = calc.round(subtotal * 0.06, digits: 2)
         #let total = subtotal + tax
       subtotal 20, tax 1.2, total 21.2. Table with #subtotal, #tax, #total
       in the cells. Changing a price and recompiling updates all three;
       that is the whole point (single source of truth).
13.5 - #{
          let a = 8
          let b = 5
          [#a and #b sum to #(a + b) and multiply to #(a * b).]
        }
       -> "8 and 5 sum to 13 and multiply to 40." The block's value is the
       single trailing content line (the lets produce none), so it carries
       the sentence to the page. Accept variants that compute both results
       and interpolate them; the learning goal is: block runs statements,
       yields joined content, arithmetic parenthesised inside the brackets.
-->
