# Control flow

Back in Chapter 1 there was a five-line loop that wrote its own list — the
powers of two, from `2` up to `1024`, without a single row typed by hand. It was
a party trick at the time. You weren't meant to understand it; you were meant to
notice that a Typst document can compute part of itself and file that away as
interesting.

The bill for that trick comes due now, and we can afford it. You have values and
types and `let` from Chapter 13. You have functions from Chapter 14. The two
ideas in this chapter — *choosing* and *repeating* — are the last pieces that
turn "a document with a bit of code in it" into "a document that builds itself
from data." By the end you'll be able to write that powers-of-two loop yourself,
and rather more besides.

There are only three things to learn: `if` for choosing, `for` and `while` for
repeating, and a couple of small words (`break`, `continue`) for steering a loop
mid-flight. That's the whole toolkit. It's less than most languages give you,
and it's enough.

## Choosing with `if`

Suppose an inventory count sits in a variable and you want the page to say one
thing when the item is in stock and another when it isn't. You don't want to
edit the document every time the number changes; you want it to decide.
That's an `if`.

```typ
#let stock = 3

#if stock > 0 [
  In stock — #stock left. Ships today.
] else [
  Out of stock. We will email you when it returns.
]
```

Read it in plain English: *if* `stock` is greater than zero, print the first
block; *else*, print the second. Exactly one of the two content blocks reaches
the page. Change `stock` to `0` and the sentence flips, with nothing else
touched. That's `examples/078-if-else/`.

The `[ … ]` brackets are the content blocks you already know. The `else` and its
block are optional — an `if` with no `else` simply prints nothing when the
condition is false, which is often precisely what you want (a "draft" watermark
that appears only in draft mode, say).

### `if` is also an expression

Here's the part that surprises people coming from other tools. In Typst, `if`
doesn't just *do* something — it *is* something. It evaluates to a value, the
same way `2 + 2` evaluates to `4`. So you can hand its result straight to a
`let`:

```typ
#let badge = if stock == 0 {
  "SOLD OUT"
} else if stock < 5 {
  "LOW STOCK"
} else {
  "AVAILABLE"
}
```

Whichever branch runs, its last expression becomes the value of the whole `if`,
and that value lands in `badge`. No branch was "printed"; a string was *chosen*.
The `else if` in the middle chains as many as you like — Typst tries
each condition top to bottom and takes the first that holds, falling through to
the final `else` if none do.

Notice the two flavours side by side. In markup you reach for the `[ … ]` form
and get *content*. In code — inside `{ … }`, feeding a `let` — you get a
*value*. Same keyword, same logic; the difference is whether you're building
the document or computing a value to use later. Example 078 shows both in one
short file.

> [!NOTE]
> The braces `{ … }` around each branch are code blocks, and a code block's
> value is its last expression. That's why `else { "AVAILABLE" }` yields the
> string — it's the last (and only) thing in the block. If you find yourself
> writing `{ "AVAILABLE" }` and wondering where the `return` went, there isn't
> one; the block just *is* its final value.

### The conditions themselves

The thing between `if` and its block is any expression that comes out `true` or
`false` — a **boolean**, from Chapter 13. You build those with the comparison
operators, which do what they look like:

| Operator | True when                    |
| -------- | ---------------------------- |
| `==`     | the two sides are equal      |
| `!=`     | they are *not* equal         |
| `<` `>`  | less than / greater than     |
| `<=` `>=`| less-or-equal / greater-or-equal |

And you glue conditions together with three plain words — `and`, `or`, `not` —
rather than the cryptic symbols some languages use:

```typ
#if stock > 0 and stock < 5 [ Running low. ]
#if not draft [ Final copy. ]
```

`a and b` is true only when both are; `a or b` when at least one is; `not a`
flips a boolean. That's the entire logic vocabulary, and it reads aloud like the
sentence it stands for.

> [!WARNING]
> `=` and `==` are different animals. A single `=` assigns (`stock = 0` *puts*
> zero into `stock`); a double `==` compares (`stock == 0` *asks* whether it's
> zero). Reach for the wrong one inside an `if` and Typst will object — but the
> two-second confusion catches everyone at least once.

## Repeating with `for`

A conditional runs a block at most once. A loop runs it once *per item* in a
collection. This is where documents start writing themselves.

The shape is `for` *variable* `in` *collection*, then a block. Each pass binds
the variable to the next element and runs the block. Here it turns an array of
titles into a bullet list:

```typ
#let books = (
  "The Left Hand of Darkness",
  "Piranesi",
  "A Canticle for Leibowitz",
)

#for title in books [
  - #emph[#title]
]
```

Three elements, three passes, three bullets. Add a fourth book and a
fourth bullet appears — you never touch the list markup again. The `[ … ]` block
is emitted once per pass, and Typst stacks them into your document. That's
the first half of `examples/079-for-over-data/`.

### Looping over a dictionary

Arrays aren't the only thing you can walk. A dictionary hands you its entries as
`(key, value)` pairs, and you can unpack each pair right in the loop header:

```typ
#let hours = (
  Monday: "9–11",
  Wednesday: "14–16",
  Friday: "10–12",
)

#for (day, slot) in hours [
  / #day: #slot
]
```

The `(day, slot)` destructures each pair — `day` gets the key, `slot` gets the
value — so the body reads naturally. This produces a term list (that's what `/`
starts) mapping each day to its hours. Same example, second half.

### Markup form and code form

Like `if`, a `for` comes in two flavours. The markup form uses `[ … ]` and emits
content, as above. The code form uses `{ … }` and is where you go when a pass
needs to *do* something more than print — update a running total, decide whether
to skip an item, build up an array:

```typ
#for n in (1, 2, 3) {
  [Item #n is here. ]
}
```

Inside the `{ … }` you're in code, but `[ … ]` still drops you back into content
whenever you want to emit some. Both forms loop identically; pick the one that
fits what the body needs to do. Most of the time in a document you'll want the
markup form. The moment a loop has to compute as well as print, switch to code.

## Counting with `range`

Often you don't have a collection to loop over — you just want to do something a
certain number of times, or count. That's what `range` is for: it manufactures a
sequence of integers on demand.

It comes in three settings:

- `range(5)` — the numbers `0, 1, 2, 3, 4`. One argument means "start at zero,
  stop before five."
- `range(2, 6)` — `2, 3, 4, 5`. Two arguments give an explicit start and stop.
- `range(0, 10, step: 2)` — `0, 2, 4, 6, 8`. A `step:` counts in strides. It can
  be negative (`range(10, 0, step: -1)` counts down).

```typ
#for n in range(5, 55, step: 5) [#n #h(0.8em)]
```

That prints `5 10 15 … 50` — multiples of five to fifty. Which brings us to the
one thing about `range` you must not forget.

> [!IMPORTANT]
> Ranges are **half-open**: they include the start and *exclude* the end.
> `range(5, 55, step: 5)` stops at 50, never reaching 55. This is why the
> Chapter 1 loop wrote `range(1, 11)` for the powers of two through *ten* — it
> stops just before 11. It trips up newcomers constantly. When a loop runs one
> pass shy of what you expected, this is nearly always why: bump the end by one.

Note that `step:` is a *named* argument. `range(0, 10, 2)` is an error — Typst
won't read the bare `2` as a step. It's always `step: 2`.

## Repeating with `while`

A `for` loop runs a known number of times: once per item, once per number in a
range. Sometimes you don't know the count in advance — you want to keep going
*until some condition changes*. That's a `while`.

```typ
#let x = 1
#while x <= 1000 {
  [#x #h(0.8em)]
  x = x * 2
}
```

Before each pass, Typst checks the condition. While `x` is at most 1000, it
prints `x` and doubles it: `1 2 4 8 … 512`. Once `x` reaches 1024, the condition
is false and the loop stops. There are your powers of two again — this time
*computed* by a loop with a running variable, not counted out by hand.
`examples/080-range-and-while/` has both the range and the `while`.

> [!WARNING]
> A `while` loop repeats until its condition is false, so *something inside the
> loop must make that eventually happen*. Forget the `x = x * 2` line and `x`
> stays `1` forever, the condition holds, and Typst spins until it gives up
> with an error. If a compile hangs on a `while`, look first at whether the loop
> can ever end.

## Steering a loop: `break` and `continue`

Two small keywords let a loop change its mind partway through.

`continue` abandons the *current* pass and jumps to the next item. It's how you
filter — skip the elements you don't want and keep going:

```typ
#let scores = (88, 42, 95, 67, 30, 71, 100, 55)

#for s in scores {
  if s < 60 { continue }
  [#s #h(0.8em)]
}
```

Any score below 60 hits `continue`, so nothing prints for it; the passing scores
sail through to the `[#s]`. `break` is the bigger hammer: it abandons the loop
*entirely*, no more passes. Swap the condition for `if s == 100 { break }`
and the loop halts the instant it meets a perfect score. Both live in
`examples/081-break-and-continue/`. The pattern — an `if` inside the loop that
decides whether to `continue` past this item or `break` out of the whole thing —
is how you turn a raw list into just the part you care about.

## A note on scope

A `let` binding inside a block — a loop body, an `if` branch, any `{ … }` or
`[ … ]` — lives and dies inside that block. It's invisible outside, and it's
fresh on every pass of a loop:

```typ
#let label = "outer"
#{
  let label = "inner"   // a different, local label
  [Inside the block, label is #label.]
}
Outside, label is still #label.
```

The inner `label` shadows the outer one only within the braces; the moment the
block closes, the outer `label` is back, untouched. This is the same scoping you
met with set rules in Chapter 9 (`#set` inside `[ … ]` is local to it) and with
function parameters in Chapter 14 — one consistent rule across the whole
language. It's what lets a loop use a scratch variable per pass without those
passes stepping on each other.

## The payoff: data in, document out

Everything so far has been building toward one idea, and it's worth stating
plainly: **you keep your data in one place, and let a loop typeset it.** The
document stops being a thing you write and becomes a thing you *generate* from a
small structure you can read, check, and edit at a glance.

Here's the shape of it — a workshop schedule built from a single array
(`examples/082-a-self-building-document/`):

```typ
#let sessions = (
  ("09:00", "Welcome & setup", 30),
  ("09:30", "Markup basics", 60),
  ("10:30", "Coffee break", 15),
  ("10:45", "Styling with rules", 75),
  ("12:00", "Lunch", 60),
)

#let minutes = 0
#for (time, session, length) in sessions {
  minutes = minutes + length
}

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, right),
  table.header([*Time*], [*Session*], [*Min*]),
  ..for (time, session, length) in sessions {
    (time, session, [#length])
  }
)

Total scheduled: *#minutes minutes* across #sessions.len() sessions.
```

Two loops do all the work. The first walks the array once and adds up the
minutes into a running total — accumulation, the same move as the doubling
`while`. The second is the interesting one. That `..for` in front of the loop is
the *spread* operator: the loop produces an array of cells — three per session —
and the `..` unpacks them straight into the `table` call as if you'd typed every
cell yourself. One row of the table per row of your data.

Now sit with what you can do. Add a session to the array and a table row appears
*and* the total updates. Reorder them and the table reorders. Delete the coffee
break and it's gone from both. The table markup never changes, because it isn't
really markup — it's a rule for turning `sessions` into a table, applied
to whatever `sessions` holds. Point it at ten sessions or a hundred and
it just works. That is the whole promise from Chapter 1, delivered: describe the
document once, let the machine elaborate it.

> [!NOTE]
> The `#sessions.len()` at the end asks the array how many elements it has — a
> taste of the collection methods that are
> [Chapter 16](16-arrays-dictionaries-strings.md)'s whole subject. Arrays,
> dictionaries, and strings have a deep bag of tricks (mapping, filtering,
> sorting) that make "data in, document out" even tidier than a hand-written
> loop. This chapter gave the loops; the next gives you richer things to loop
> over and cleaner ways to reshape them.

> **Coming from LaTeX.** You have almost certainly fought `\ifthenelse` from the
> `ifthen` package, hand-rolled `\newif\if@draft` incantations, or reached for
> `\foreach` from `pgffor` and discovered it doesn't quite behave like a loop in
> a language. Control flow in LaTeX is a patchwork bolted onto a macro expander,
> and it shows: expansion timing bites, and a stray brace derails everything.
> Typst has none of that baggage. `if` and `for` and `while` are ordinary parts
> of one language, they *return content* like everything else, and they nest and
> compose without ceremony. The powers-of-two loop is four lines because it's a
> loop, not a macro pretending to be one.

## What you've got

You can now make a document decide and repeat:

- **`if` / `else if` / `else`** — choose which block runs. In markup it emits
  content (`#if cond [ … ] else [ … ]`); in code it's an *expression* whose
  value you can store in a `let`.
- **Conditions** — boolean expressions built from `==`, `!=`, `<`, `<=`, `>`,
  `>=` and joined with the plain words `and`, `or`, `not`.
- **`for … in`** — run a block once per element, over an array, over a
  dictionary's `(key, value)` pairs, or over a `range`. Markup form emits
  content; code form computes.
- **`range`** — `range(end)`, `range(start, end)`, `range(start, end, step: n)`;
  **half-open**, so it stops *before* the end.
- **`while`** — repeat as long as a condition holds; make sure something in the
  loop eventually ends it.
- **`break` and `continue`** — bail out of the whole loop, or skip to the next
  item; the basis of filtering.
- **Scope** — a `let` inside a block is local to that block and fresh each pass.
- **The big idea** — keep data in one structure and generate the document from
  it with a loop; a spread `..for` feeds rows straight into a `table` or any
  other function that takes many arguments.

Next, in Chapter 16, we go deep on the things you've been looping over — arrays,
dictionaries, and strings — and the methods that let you transform them without
writing the loop by hand at all.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

15.1. Put `#let temperature = 28` at the top of a document. With a single `#if …
else` in markup, print "Warm — leave the coat at home." when the temperature is
20 or above, and "Bring a jacket." otherwise. Change the number and confirm the
sentence flips.

15.2. Rewrite the powers-of-two loop from Chapter 1 yourself: use `#for n in
range(1, 11)` and, for each `n`, print a line reading `2^n = ` followed by
`calc.pow(2, n)`. Then predict, without running it, what `range(1, 4)` would
produce instead — and check yourself.

15.3. Given `#let cart = (("Pen", 2), ("Notebook", 5), ("Stapler", 8))`, use a
`for` loop over the pairs to print each item and its price as a bullet list.
Then, with a second loop and a running variable, compute and print the total
price. (This is Example 082 in miniature.)

15.4. Loop over `range(1, 21)` and, using `continue`, print only the numbers
that are *not* divisible by 3. (Hint: `calc.rem(n, 3)` gives the remainder;
a number is divisible by 3 when that remainder is `0`.)

15.5. *(Stretch.)* Build a small multiplication table as a grid. Loop the rows 1
to 5 and, inside each, loop the columns 1 to 5, printing `row * col` in each
cell. Feed the cells into a `#table(columns: 5, …)` with a spread `..for`. When
it works, change one `5` to a `10` and watch the table grow in both directions
with no other edit.

<!--
SOLUTIONS (notes for the appendix author):

15.1 - #let temperature = 28
       #if temperature >= 20 [Warm — leave the coat at home.] else [Bring a jacket.]
       Point: one condition, two content blocks, exactly one prints. Flipping the
       number to e.g. 12 switches the output. Mirrors examples/078-if-else.

15.2 - #for n in range(1, 11) [
         $2^#n$ = #calc.pow(2, n) \
       ]
       (Or plain "2^#n = ..." without math if they prefer.) range(1, 4) yields
       n = 1, 2, 3, so three lines: 2^1=2, 2^2=4, 2^3=8 — because range is
       half-open and stops before 4. Directly pays off Chapter 1 exercise 1.3.

15.3 - #let cart = (("Pen", 2), ("Notebook", 5), ("Stapler", 8))
       #for (item, price) in cart [ - #item: #price ]
       #let total = 0
       #for (item, price) in cart { total = total + price }
       Total: #total   // 15
       Destructuring the pair in the loop header; accumulation in a running var.
       Mirrors examples/079 (dict/array loop) + 082 (sum). Note step: not needed.

15.4 - #for n in range(1, 21) {
         if calc.rem(n, 3) == 0 { continue }
         [#n ]
       }
       Prints 1 2 4 5 7 8 10 11 13 14 16 17 19 20. continue skips multiples of 3.
       Mirrors examples/081-break-and-continue. Code-form for (needs the if +
       continue), with [#n ] to emit. range(1, 21) reaches 20 (half-open).

15.5 - #table(
         columns: 5,
         ..for r in range(1, 6) {
           for c in range(1, 6) {
             ([#{ r * c }],)
           }
         }
       )
       Nested loops; the inner one yields one 1-tuple per cell, the outer spreads
       them all. Note the trailing comma in ([...],) to make it a single-element
       array that concatenates cleanly. Changing 6 -> 11 on both ranges gives a
       10x10 table (columns: 5 must also become 10). Ties spread + nesting + range
       together; the "grows in both directions" moment is the payoff. Accept any
       working nested-loop table; the elegant version uses the spread, but a
       row-at-a-time build with string concatenation is fine too.
-->
