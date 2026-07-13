# Functions and closures

By now you've called functions in nearly every chapter of this book.
`#text(fill: red)[...]`, `#image("cat.jpg")`, `#figure(...)`, `#table(...)` —
every one of those is a *function*: a named thing you hand some values to, and
that hands something back. You never had to think about it, because Typst wrote
them for you.

This chapter is where you start writing your own.

The reason you'd want to is the oldest reason in programming: you're repeating
yourself. Say you're building a worksheet, and every answer sits in the same
little green box —

```typ
#box(fill: green, inset: 6pt, radius: 3pt)[#text(fill: white)[42]]
```

— and there are forty of them. Type that out forty times and two things happen.
It's tedious, and somewhere around box twenty-three you'll fat-finger `insert`
for `inset`, and one box will quietly come out wrong. The cure is to describe
the box *once*, give it a name, and use the name forty times.

That's a function.

## Defining a function

You already know the keyword. In [Chapter 13](13-from-markup-to-code.md) you
used `#let` to give a name to a value:

```typ
#let pi = 3.14159
```

Add a parameter list in parentheses and the very same `#let` defines a function
instead:

```typ
#let greet(name) = [Hello, #name! Welcome aboard.]
```

Read it left to right: define `greet`, which takes one thing called `name`, and
whose body is the content to the right of the `=`. That `name` is a
*parameter* — a stand-in for whatever you pass in when you call the function.
And you call it exactly the way you've been calling built-ins all along, with a
value in parentheses:

```typ
#greet("Ada")
#greet("Grace")
```

Each call drops its argument into the body where `name` sits and produces the
finished content: "Hello, Ada! Welcome aboard." and the same for Grace. Write
the recipe once, serve it as often as you like
(`examples/072-defining-a-function/`).

A one-line body is fine when the whole function is a single expression. When it
needs to do a few things first, give it a *block body* — curly braces, several
statements, and the last expression as the result:

```typ
#let shout(word) = {
  let loud = upper(word)
  text(weight: "bold")[#loud!]
}
```

Here the function upper-cases the word, stashes it in a local variable, then
returns it as bold content. There's no `return` keyword in sight, and you don't
need one: a block hands back whatever its last expression evaluates to, the same
rule you met for code blocks in Chapter 13. `return` does exist, and it's handy
when you want to bail out early —

```typ
#let sign(x) = {
  if x < 0 { return "negative" }
  "zero or positive"
}
```

— but for a function that runs straight to the end, the last-expression rule is
all you need, and most of the functions you'll write never say `return` at all.

## Returning content, returning a value

Look again at those two functions. `greet` ends in a bracketed `[...]`, so it
hands back *content* — the same kind of thing a heading or a paragraph is,
something you can drop straight into your markup. `shout` does too. But a
function can just as easily return a plain value:

```typ
#let area(width, height) = width * height
```

`area(4, 3)` gives you the number `12` — not content to display, but a value to
carry on computing with. The difference isn't a special mode you switch on; it's
simply *what the last expression happens to be*. End on content and you get
content; end on a number, a string, or a colour and you get that. A function is
just a name for "evaluate this body with these inputs," and the body decides.

## Named arguments and defaults

`greet` had one positional parameter — positional because Typst matches it *by
position*, first argument to first parameter. That's perfect when a function has
one or two obvious inputs. It gets miserable when it has six, and you're left
counting commas to work out which one is the corner radius.

The answer is *named* parameters, and you've been using them since Chapter 4
without a second thought. `#text(fill: red, size: 12pt)[...]` passes `fill` and
`size` by name. You write your own the same way, by giving a parameter a default
value with a colon:

```typ
#let tag(body, color: gray, size: 9pt) = box(
  fill: color,
  inset: (x: 6pt, y: 3pt),
  radius: 4pt,
)[#text(fill: white, size: size, weight: "bold")[#body]]
```

`body` is positional; `color` and `size` are named, and each carries a default.
Now the caller picks exactly what to override and leaves the rest alone
(`examples/073-named-and-default-args/`):

```typ
#tag[draft]                      // gray, 9pt — every default in place
#tag(color: green)[approved]     // just the colour changed
#tag(size: 12pt, color: red)[urgent]   // both, in any order
```

That last line is the point of names: because Typst matches a named argument by
its name and not by its position, you can order the named ones however reads
best. The positional arguments are still matched by position — first positional
to the first parameter, and so on — so those keep their order among themselves.
By convention you write the positionals first and the named ones after, which is
what nearly all Typst code does and what keeps a call easy to scan at a glance.
(Typst will actually let you interleave the two, but there's little reason to
make a reader hunt for which argument is which.)

> **Coming from LaTeX.** A LaTeX custom command is `\newcommand{\tag}[1]{...}`,
> where the arguments are numbered — `#1`, `#2`, `#3` — and you address them by
> position and nothing else. Optional arguments exist, but only one, only in
> brackets, and defining more than a couple turns into `xparse` and a small
> adventure. A Typst function has as many named, defaulted parameters as you
> like, each with a readable name instead of a number, and no package to load.
> The gap only widens from here.

## Passing a whole block: the content-argument trick

Notice something about that `tag` function: you called it `#tag[draft]`, with
the text in square brackets, not `#tag("draft")`. That's not a special feature
of `tag`. It's a piece of syntax sugar that runs through the entire language,
and once you see it, a lot of Typst stops looking like magic.

Here's the rule. A content block in square brackets, written right after a
function call, is passed as that call's **last positional argument**. So:

```typ
#greet[Ada]           is exactly   #greet([Ada])
#tag(color: red)[urgent]   is exactly   #tag(color: red, [urgent])
```

That's the whole trick, and it's why `#figure[...]`, `#text(...)[...]`, and
`#box[...]` have worked all book. `figure` is a plain function whose last
parameter is the figure's body; the bracket sugar just hands it over without the
parentheses and quotes. Every one of those "special" markup forms is an ordinary
function call wearing comfortable clothes.

Which means the moment you write a function whose last parameter is a `body`,
you get a first-class Typst component — one that takes a block of marked-up
content and wraps it in whatever you want. A callout box, say
(`examples/074-content-argument/`):

```typ
#let callout(body, title: "Note", color: blue) = block(
  fill: color.lighten(85%),
  stroke: (left: 3pt + color),
  inset: 10pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(fill: color, weight: "bold")[#title] \
  #body
]
```

Now you have a reusable box that reads like something built in:

```typ
#callout[
  An ordinary note. The whole bracketed block became the `body` argument.
]

#callout(title: "Tip", color: green)[
  Give it a different title and colour with named arguments.
]
```

The content can be paragraphs, lists, images, other callouts — anything, because
it's just content, and it rode in through the last positional slot. This pattern
— a `body` parameter plus a few named options with defaults — is the backbone of
almost every component and template you'll build in Part V. Learn it once here.

> [!TIP]
> Put the `body` parameter *last* in the list and the bracket sugar works
> automatically. If you ever need the content in the middle, you can still pass
> it the long way, `#callout([text], title: "Note")`, but there's rarely a
> reason to. Last position, every time.

## However many arguments you like

Sometimes you don't know in advance how many arguments there'll be. A function
that builds a breadcrumb trail — `Home › Docs › Functions` — should take three
items today and five tomorrow without you rewriting its signature. For that,
Typst gives you a *variadic* parameter: prefix a parameter with `..` and it
becomes a sink that swallows every leftover argument.

```typ
#let breadcrumbs(..items) = items.pos().join(text(fill: gray)[ › ])
```

Whatever you pass, `items` collects it. But `items` isn't an array — it's an
`arguments` value, which keeps positional and named arguments in separate
compartments. You pull the positional ones out with `.pos()` (an array) and the
named ones with `.named()` (a dictionary). Here `.pos()` gives us the list of
crumbs, and `join` stitches them together with a grey separator between each
(`examples/075-variadic/`):

```typ
#breadcrumbs("Home", "Docs", "Functions")   // Home › Docs › Functions
```

The same idea powers a function that adds up however many numbers you throw at
it:

```typ
#let total(..nums) = nums.pos().sum()

#total(2, 4, 6, 8)    // 20
```

Variadics have a mirror image, and it's just as useful. If `..` in a *parameter*
list gathers loose arguments up, `..` at a *call site* spreads a collection back
out into separate arguments. Say the breadcrumbs already live in an array:

```typ
#let path = ("Users", "ada", "notes.typ")
#breadcrumbs(..path)     // Users › ada › notes.typ
```

Without the `..`, you'd be passing one argument — the whole array — and
`breadcrumbs` would draw a single crumb containing a list. With it, the three
elements arrive as three separate arguments, exactly as if you'd typed them out.
Spreading works for named arguments too: spread a dictionary and each key
becomes a named argument. It's the natural way to forward a bundle of options
from one function into another.

## Functions are values

Here's the idea that quietly makes everything above possible, and a good deal
more besides: in Typst, a function is a value like any other. A number can live
in a variable, get passed to a function, or be returned from one. So can a
function. There is no separate, lesser category for them — `greet` is a value
sitting in a variable named `greet`, no different in kind from `pi` sitting in a
variable named `pi`.

Three things follow, and each is genuinely useful.

**You can store a function in a variable.** You've been doing it all along —
`#let greet(name) = ...` is really "make a function and name it `greet`." There
is an even barer syntax for writing one inline, the *arrow* form, with the
parameters on the left of `=>` and the body on the right:

```typ
#let double = x => x * 2
#let add = (a, b) => a + b
```

`double` and `add` are ordinary functions; they just skipped the parameter-list
parentheses on the way in. One parameter can go bare; two or more need
parentheses around them. These are the same functions you'd get from the `#let
double(x) = ...` form — two spellings, one idea.

**You can pass a function to another function.** If a function is a value, it
can be an argument:

```typ
#let twice(f, x) = f(f(x))

#twice(double, 5)    // 20 — double(double(5))
```

`twice` doesn't know or care what `f` does; it just calls it twice. Hand it
`double` and you get quadrupling. This is how you write a function that takes
*behaviour* as a parameter — sort by a key you supply, map an operation over a
list, filter by a test. You'll lean on it hard in the next few chapters.

**You can return a function from a function.** Which brings us to the good part.

## Closures: functions that remember

A function defined inside another function can see the outer function's
variables — and it keeps seeing them even after the outer function has finished
and returned. A function that captures its surroundings like this is called a
*closure*, and it turns an ordinary function into a factory for building
specialised ones (`examples/076-functions-as-values/`):

```typ
#let multiplier(n) = x => x * n

#let triple = multiplier(3)
#let tenfold = multiplier(10)

#triple(4)     // 12
#tenfold(4)    // 40
```

Follow the `n`. When you call `multiplier(3)`, the arrow function `x => x * n`
is created with `n` set to `3`, and it *remembers* that `3` from then on. The
outer call is long over, but the little function it produced carries its own
private copy of `n` around with it. `triple` and `tenfold` are two independent
functions baked from the same mould, each holding a different captured value.

That's a closure: a function plus the slice of the world it was born into. It
sounds abstract until you notice you've already brushed against the pattern. In
Chapter 10 a `report` function wrapped an entire document and applied a stack of
styling choices to it; a real template is that same idea grown up — a function
that captures a whole design and hands it to any body you give it. In Part V
you'll build them on purpose.

## Pre-filling arguments with `.with()`

Closures give you factories when you need real logic. For the common case —
"the same function, but with a couple of arguments already filled in" — there's
a shortcut that's less typing and reads better. Every function has a `.with`
method that pre-fills some of its arguments and returns a *new* function with
those baked in. It's called partial application, and it's tidier than it sounds.

Start from one general component and stamp out configured variants
(`examples/077-with-partial-application/`):

```typ
#let badge(body, color: gray) = box(
  fill: color, inset: (x: 6pt, y: 3pt), radius: 4pt,
)[#text(fill: white, weight: "bold")[#body]]

#let ok = badge.with(color: green)
#let danger = badge.with(color: red)

#ok[passed] #danger[failed] #badge[neutral]
```

`ok` is `badge` with `color: green` locked in; call it and you still supply the
`body`, but the colour's already decided. You could write `ok` as a closure —
`#let ok = body => badge(body, color: green)` — and get the identical result.
`.with` is just the short, clear way to say the same thing.

It works on built-ins too, which is where it really earns its keep. Tired of
retyping the same `text` settings for every title?

```typ
#let title = text.with(size: 16pt, weight: "bold", fill: navy)
#title[A pre-styled title]
```

One named function, defined once, and every title in the document stays
consistent because they all come from the same pre-filled call. You'll find
`.with` all over real Typst code for exactly this reason.

## What you've got

You can now write functions, which means you can stop repeating yourself and
start building your own vocabulary on top of Typst's:

- **Defining them** — `#let f(x) = [...]` for a one-line body, and
  `#let f(x) = { ... }` for a block whose last expression is the result.
  `return` bails out early; most functions don't need it.
- **What comes back** — whatever the last expression is. End on content and you
  get content to display; end on a number or string and you get a value to
  compute with.
- **Parameters** — positional (matched by order) and named-with-defaults
  (matched by name, optional at the call). By convention, write positionals
  first and named ones after; among the named ones, any order goes.
- **The content-block trick** — `#f[body]` is `#f([body])`, and content in
  brackets is passed as the last positional argument. This is why `#figure[...]`
  works, and how you build components that take a block of content.
- **Variadics** — `..args` sinks any number of arguments into an `arguments`
  value (`.pos()`, `.named()`); `..collection` at a call site spreads one back
  into separate arguments.
- **Functions as values** — store them, pass them, return them. Arrow syntax
  (`x => x * 2`) writes one inline.
- **Closures** — a function that captures variables from where it was defined; a
  factory for producing configured functions.
- **`.with`** — pre-fill some of a function's arguments and get back a new,
  specialised function.

Set and show rules gave you Typst's styling. Functions give you Typst's
*language*. Everything in Part V — your own reusable components, templates, and
packages — is functions, all the way down.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

14.1. Write a function `kbd(key)` that renders a keyboard key: its argument set
in bold monospace inside a small bordered box (a `box` with a `stroke`, a little
`inset`, and a `radius`). Use it three times in a sentence — `#kbd("Ctrl")`,
`#kbd("C")`, and so on — and confirm all three come out identical.

14.2. Give `kbd` a named parameter `fill` that defaults to `luma(240)` (a light
grey) so most keys are grey, but you can override one to highlight it. Call it
once with the default and once with `fill: yellow`.

14.3. Write a `callout(body, title: "Note", color: blue)` like the one in the
chapter, then use the trailing content-block sugar to call it with a multi-line
body containing a bullet list. Confirm the whole list arrives as `body`. Now
call it a second time as `#callout([short one], title: "Aside")` — the long-hand
form — and check you get the same kind of result.

14.4. Write `avg(..nums)` that returns the average of however many numbers it's
given (sum divided by count — `.pos()` gives you the array; an array has both
`.sum()` and `.len()`). Test it with `#avg(4, 8, 12)`, then build an array
`#let scores = (10, 7, 9, 8)` and call `#avg(..scores)` by spreading it.

14.5. *(Stretch.)* Write a closure factory `heading-style(color)` that returns a
function `it => ...` suitable for a `#show heading: ...` rule — one that colours
the heading and draws a rule under it in the same colour. Make two of them,
`heading-style(navy)` and `heading-style(maroon)`, and swap between them by
changing a single line. You've just written a configurable style as a value —
which is most of what a template is.

<!--
SOLUTIONS (notes for the appendix author):

14.1 - #let kbd(key) = box(
         stroke: 0.5pt, inset: (x: 4pt, y: 1pt), radius: 3pt,
       )[#raw(key)]   // or #text(font: "DejaVu Sans Mono", weight: "bold")[#key]
       Then: Press #kbd("Ctrl") + #kbd("C") to copy.
       Point: one definition, three identical uses; no copy-paste drift.

14.2 - #let kbd(key, fill: luma(240)) = box(
         fill: fill, stroke: 0.5pt, inset: (x: 4pt, y: 1pt), radius: 3pt,
       )[#raw(key)]
       #kbd("Esc")  and  #kbd("Enter", fill: yellow)
       Point: a named parameter with a default; override only when needed.

14.3 - #let callout(body, title: "Note", color: blue) = block(
         fill: color.lighten(85%), stroke: (left: 3pt + color),
         inset: 10pt, width: 100%,
       )[#text(fill: color, weight: "bold")[#title] \ #body]
       Bracket form:  #callout[ Intro line. \ - a \ - b \ - c ]
       Long-hand form: #callout([short one], title: "Aside")
       Point: #callout[...] == #callout([...]); the list is all one content
       value handed to `body`. Both call forms yield the same component.

14.4 - #let avg(..nums) = {
         let xs = nums.pos()
         xs.sum() / xs.len()
       }
       #avg(4, 8, 12)          // 8
       #let scores = (10, 7, 9, 8)
       #avg(..scores)          // 8.5
       Point: .pos() -> array; spreading ..scores turns the array back into
       separate arguments so the same function serves both call styles.

14.5 - #let heading-style(color) = it => block(below: 0.8em)[
         #text(fill: color, weight: "bold")[#it.body]
         #v(-6pt)
         #line(length: 100%, stroke: 0.6pt + color)
       ]
       #show heading: heading-style(navy)     // change navy -> maroon to reskin
       = A heading
       Point: the returned closure captures `color`; picking a palette is now a
       one-line swap. This is the template idea in embryo (foreshadows Ch 19).
-->
