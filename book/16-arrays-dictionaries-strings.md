# Arrays, dictionaries, and strings

Suppose you have a list of twelve students and you want a certificate for each.
Or six products with prices, and you'd like the total printed at the bottom. Or
a reading list that should always come out alphabetized, whatever order you
typed it in. Until now you'd have done all of that by hand: typed each row,
added the numbers on a calculator, sorted the list in your head.

This is the chapter where that stops. Chapter 15 gave you loops — a way to
*repeat* work. This chapter gives you the things worth looping over. There are
three of them, and they are the data half of Typst's language:

- **Arrays** — ordered lists of values: `(2, 3, 5, 7)`.
- **Dictionaries** — values you look up by name: `(name: "Ada", born: 1815)`.
- **Strings** — text, which you've used since page one and which turns out to
  be quietly programmable.

Once a document can hold data and reshape it, it can build itself from a single
source of truth instead of from your patience. We'll end by turning a list of
records into a formatted table, which is the move behind nearly every
data-driven document you'll ever make.

## Arrays: values in a row

An array is a sequence of values in a fixed order, written with parentheses and
separated by commas. The values can be anything — numbers, strings, content,
even other arrays:

```typ
#let primes = (2, 3, 5, 7, 11)
#let week = ("Mon", "Tue", "Wed", "Thu", "Fri")
```

You reach a value by its **position**, counting from zero, with `.at()`:

```typ
#week.at(0)   // "Mon" — the first one
#week.at(2)   // "Wed"
```

Counting from zero trips everyone up once. The first element is at position `0`,
so the *fifth* is at position `4`. When you want the end of the array, though,
you don't have to know how long it is: negative indices count backwards from the
tail.

```typ
#week.at(-1)  // "Fri" — the last one
#week.at(-2)  // "Thu" — one before the last
```

`.at(-1)` is worth committing to muscle memory; "the last element" comes up
constantly and you rarely know or care how many there are. For the two ends
there are also named shortcuts, `.first()` and `.last()`, and `.len()` tells you
how many elements the array holds:

```typ
#week.first()  // "Mon"
#week.last()   // "Fri"
#week.len()    // 5
```

A **slice** pulls out a run of consecutive elements. `.slice(start, end)` takes
everything from `start` up to *but not including* `end` — the same half-open
convention `range` uses (Chapter 15), so the two compose without surprises:

```typ
#week.slice(1, 4)  // ("Tue", "Wed", "Thu") — positions 1, 2, 3
```

Two arrays join with `+`, exactly like strings:

```typ
#(1, 2) + (3, 4)   // (1, 2, 3, 4)
```

To ask whether a value is present, use `.contains()` or the `in` operator —
they mean the same thing, and `in` reads more like English:

```typ
#week.contains("Wed")  // true
#("Wed" in week)       // true
```

Two more you'll want daily: `.rev()` returns the array reversed, and `.sorted()`
returns it in order. Both hand back a *new* array and leave the original alone.

```typ
#(3, 1, 4, 1, 5).sorted()  // (1, 1, 3, 4, 5)
```

`.sorted()` orders numbers numerically and strings alphabetically. When you want
to sort by something *derived* from each element — length, a particular field,
the absolute value — pass a `key` function that maps each element to the thing
to compare on:

```typ
#("kiwi", "fig", "cherry").sorted(key: w => w.len())
// ("fig", "kiwi", "cherry") — shortest word first
```

That `w => w.len()` is an arrow function (Chapter 14): given a word, it returns
its length, and `sorted` compares those lengths instead of the words themselves.
Keep the shape in mind — half the methods in this chapter take a little function
like it.

Example `examples/083-arrays/` runs all of this on a week's worth of days.

> [!WARNING]
> A one-element array **must** have a trailing comma: `("solo",)`. Without it,
> `("solo")` is just the string `"solo"` in ordinary parentheses — Typst can't
> tell the two apart otherwise. It's the one piece of array syntax that bites
> people, usually when an array happens to shrink to a single item.

### Growing and shrinking an array

Arrays are values, and values in Typst don't change underneath you. But a
*variable* that holds an array can be reassigned, and two methods do that
conveniently: `.push()` adds an element to the end, `.pop()` removes the last
one and hands it back.

```typ
#{
  let stack = ("wash", "rinse")
  stack.push("dry")     // stack is now ("wash", "rinse", "dry")
  let done = stack.pop()  // done = "dry"; stack is back to two
}
```

These only work on something you can assign to — a `let` binding, a loop
variable — because they rewrite the variable. Reach for them when you're
*building* an array a piece at a time inside a loop, which is a common and
readable pattern:

```typ
#{
  let evens = ()
  for n in range(1, 20) {
    if calc.rem(n, 2) == 0 { evens.push(n) }
  }
  // evens is now (2, 4, 6, 8, 10, 12, 14, 16, 18)
}
```

That works, and you'll see it in the wild. But building an array by hand with a
loop and a `push` is often the long way round — which brings us to the heart of
the chapter.

## The transformer trio

Three methods do most of the real work with arrays, and they're the reason
data-driven Typst is pleasant rather than tedious. Each one takes a function and
applies it across the whole array for you. Learn these three and you'll reach
for hand-written loops far less often.

**`.map(f)`** runs a function over every element and collects the results into a
new array. "Transform each one":

```typ
#(1, 2, 3, 4).map(n => n * n)   // (1, 4, 9, 16)
```

**`.filter(pred)`** keeps only the elements for which a test returns `true`, and
drops the rest. "Keep the ones that pass":

```typ
#(1, 2, 3, 4, 5, 6).filter(n => calc.rem(n, 2) == 0)  // (2, 4, 6)
```

**`.fold(init, f)`** collapses the whole array down to a single value. You give
it a starting value and a function of two arguments — the running result so far,
and the next element — and it walks the array accumulating as it goes. "Boil it
down to one thing":

```typ
#(1, 2, 3, 4).fold(0, (running, n) => running + n)   // 10
```

Read that fold as: start the running total at `0`; for each `n`, the new total
is the old total plus `n`. Summing is so common that there's a dedicated
`.sum()` for exactly this case, and a `.product()` for multiplying — but `fold`
is the general tool, and it does things `sum` can't, like building a string or
finding a maximum.

The three compose. Because each returns an array (well, `fold` returns whatever
you accumulate), you can chain them left to right and read the pipeline like a
sentence:

```typ
#scores.map(s => s + 5).filter(s => s >= 60).sum()
// curve every score, keep the passing ones, add them up
```

Example `examples/084-map-filter-fold/` runs the trio on a set of exam scores —
a five-point curve with `map`, the passing marks with `filter`, the total with
`fold` and then `sum`, and the whole pipeline chained into one line.

### A few more that pull their weight

Four supporting methods round out the toolkit:

- **`.join(separator)`** glues an array of strings or content into one, with a
  separator between: `("a", "b", "c").join(", ")` gives `"a, b, c"`. It even
  takes a different `last:` separator for the Oxford-comma crowd:
  `.join(", ", last: " and ")` gives `"a, b and c"`.
- **`.enumerate()`** pairs each element with its index, handing back an array of
  `(index, value)` pairs — perfect when a loop needs a row number.
- **`.zip(other)`** stitches two arrays together element by element:
  `(1, 2, 3).zip(("a", "b", "c"))` gives `((1, "a"), (2, "b"), (3, "c"))`. If
  the arrays differ in length, it stops at the shorter one.
- **`.sum()`** and **`.product()`**, already met, are the common folds named.

> [!WARNING]
> `.join()` is for strings and content, not raw numbers — `(1, 2, 3).join(", ")`
> is an error, because you can't glue an integer to a comma. Convert first:
> `(1, 2, 3).map(str).join(", ")`. The `str` function turns any value into its
> text, and you'll pair it with `join` constantly.

> **Coming from a spreadsheet or LaTeX.** In a spreadsheet, `map` is dragging a
> formula down a column, `filter` is a filter view, and `fold` is `SUM` (or
> `PRODUCT`, or a pivot). The difference is that here the operation lives
> in your document as one readable line, versioned in plain text, instead
> of hidden in a grid of cells you have to click to inspect. And in LaTeX,
> where looping over a list means `\foreach` from PGF and a good deal of
> expansion-order folklore, `map`/`filter`/`fold` are ordinary method calls
> that return ordinary values. No package, no `\edef`, no surprises.

## Dictionaries: values with names

An array indexes by position: element `0`, element `1`. That's perfect when
order is the point and awkward when it isn't. If you're describing a *person*,
"field number 1" tells you nothing; you want to say "their birth year." A
**dictionary** stores values under names instead of positions.

```typ
#let ada = (name: "Ada Lovelace", born: 1815, field: "computing")
```

Same parentheses as an array, but each entry is a `key: value` pair. Read a
value back with a dot and the key's name:

```typ
#ada.name   // "Ada Lovelace"
#ada.born   // 1815
```

The keys are **strings** — `name`, `born`, and `field` are stored as `"name"`,
`"born"`, `"field"`. The dot form `ada.name` is the tidy shorthand, and it works
whenever the key is a plain word. When the key isn't a simple identifier, or
when you don't know it until the document runs — it's sitting in a variable —
use `.at()` with the key as a string:

```typ
#ada.at("field")     // "computing" — same as ada.field
#let k = "born"
#ada.at(k)           // 1815 — the key came from a variable
```

To see everything a dictionary holds, three methods take it apart:

```typ
#ada.keys()     // ("name", "born", "field")
#ada.values()   // ("Ada Lovelace", 1815, "computing")
#ada.pairs()    // (("name", "Ada Lovelace"), ("born", 1815), ("field", "computing"))
```

`.pairs()` is the one that pairs beautifully with a loop — each item is a
`(key, value)` array you can destructure:

```typ
#for (key, value) in ada.pairs() [
  / #key: #value
]
```

You grow and shrink a dictionary the same way you did an array, on a variable
you can assign to. `.insert(key, value)` adds or overwrites an entry;
`.remove(key)` deletes one and returns the value it held:

```typ
#{
  let record = ada
  record.insert("died", 1852)
  let year = record.remove("field")   // year = "computing"
}
```

And to check whether a key exists before you reach for it, `in` works on
dictionaries too — it tests keys:

```typ
#("died" in ada)   // false
#("born" in ada)   // true
```

Example `examples/085-dictionaries/` builds a record, reads it both ways,
lists its keys and values, and inserts and removes fields. It also shows a small
thing worth internalizing: assigning `let record = ada` and mutating `record`
leaves `ada` untouched, because values are copied, not shared. No spooky action
at a distance.

> [!TIP]
> Reaching for a key that doesn't exist is an error that stops compilation. When
> a field might be missing, give `.at()` a fallback: `ada.at("died", default:
> "—")` returns the dash instead of blowing up. That one habit prevents most
> dictionary-related crashes when your data is uneven.

## Strings: sequences of characters

You've written strings in every chapter — every `"a4"`, every font name, every
label. They're more capable than they've let on. A string is a *sequence of
characters*, and it comes with a toolkit that overlaps deliberately with the
array one.

`.len()` gives the length, `.upper()`/`.lower()` (as the functions `upper()` and
`lower()`) flip the case, and `.contains()` tests for a substring:

```typ
#upper("quiet")           // "QUIET"
#"typesetting".contains("set")   // true
```

`.split(separator)` is the workhorse: it breaks a string into an *array* of
pieces, which is how raw text becomes data you can loop over.

```typ
#"Ada,Grace,Alan".split(",")   // ("Ada", "Grace", "Alan")
```

`.trim()` shaves whitespace off both ends — indispensable when your data arrives
with stray spaces — and `.replace(old, new)` swaps every occurrence of one
substring for another:

```typ
#"  hello  ".trim()             // "hello"
#"a-b-c".replace("-", " / ")     // "a / b / c"
```

`.slice(start, end)` cuts out a run of characters, just like the array version,
and `.find(pattern)` returns the matched text if it's there and `none` if it
isn't:

```typ
#"Typst".slice(0, 3)     // "Typ"
#"hello world".find("world")   // "world"
```

Because a string is a sequence, you can loop straight over it, one character at
a time:

```typ
#for c in "hi" [ #upper(c) ]   // H, then I
```

Example `examples/086-strings/` puts these to work: it takes a scruffy slug
`"  the-wind-up-bird  "`, trims it, splits it on hyphens into words, and
rebuilds those words into a title-cased heading using `slice` and `upper`.

### Strings and regex

`.replace()` and `.find()` (and its cousin `.match()`) accept more than plain
text. Hand them a `regex(...)` and they match by *pattern* — the regular
expressions you met in the show rules of Chapter 10. To collapse any run of
spaces down to one:

```typ
#"too    many     spaces".replace(regex(" +"), " ")
// "too many spaces"
```

`.match(regex(...))` returns a dictionary describing the first match — its
`text`, its `start` and `end` positions, and any captured groups — or `none`
if the pattern doesn't match. It's the tool when you need to *pull* structure
out of text rather than replace it: a year out of a citation, a code out of a
filename.

> [!NOTE]
> `.len()` and `.slice()` count *bytes*, not characters, and for plain English
> text those are the same number. They diverge on accented or non-Latin
> characters: `"café".len()` is `5`, because `é` takes two bytes. When you truly
> need to count or walk *characters*, `"café".clusters()` gives you the array
> `("c", "a", "f", "é")` — four elements — to work with instead.

## Putting it together: an array of dictionaries

Here's the shape that runs the data world, and it's just the two collections
nested. An **array of dictionaries** is a list of records, each record a
dictionary with the same keys — a table, essentially, one row per element:

```typ
#let pioneers = (
  (name: "Ada Lovelace", born: 1815, field: "computing"),
  (name: "Grace Hopper", born: 1906, field: "computing"),
  (name: "Alan Turing",  born: 1912, field: "logic"),
)
```

Every tool in this chapter now points at it. Loop over the array to get one
record at a time, and reach into each with the dictionary syntax:

```typ
#for p in pioneers [
  - *#p.name* (b. #p.born) — #p.field
]
```

Or work on the whole dataset at once. `map` a single field out of every record;
`filter` to the records that match a condition; `sorted` by any field with a
key function. They chain exactly as before:

```typ
#pioneers.map(p => p.name)                       // every name
#pioneers.filter(p => p.field == "computing")    // just the computer scientists
#pioneers.sorted(key: p => p.born)               // eldest first
```

Example `examples/087-array-of-dictionaries/` does all three on a slightly
larger roster.

### The payoff: data to table

Now the move the whole chapter was pointing at. The `table` function (Chapter 7)
wants a flat run of cells. `map` can turn each record into a row of cells, and
the **spread operator** `..` (Chapter 14) unpacks that list of rows straight
into the table's arguments:

```typ
#table(
  columns: 3,
  table.header([Name], [Born], [Field]),
  ..pioneers.map(p => (p.name, [#p.born], p.field)).flatten()
)
```

Three things happen in that last line. `map` turns each record into a
three-element array — its cells. `.flatten()` dissolves the array-of-arrays
into one long array of cells, because `table` wants cells, not rows-of-cells.
And `..` spreads that array into the argument list, as if you'd typed every
cell by hand.
Add a column, and it's one more expression in the `map`; add a row, and it's one
more dictionary in the data. The table never changes.

Example `examples/088-data-to-table/` is this, fleshed out: the records sorted
by birth year, a computed "century" column derived with a touch of arithmetic,
grey strokes, and a `show` rule that bolds the header. It is, in miniature,
every report you'll ever generate from data — a spreadsheet export, a class
roster, a price list — and it's maybe a dozen lines.

That's the arc: **read data into arrays and dictionaries, reshape it with
`map`/`filter`/`fold`, and render the result.** Change the data, recompile, and
the document redraws itself. This is the same instinct as the self-building
documents in Chapter 15, now aimed at real records instead of number ranges.

One limit worth naming before you go. Everything here is computed from the data
*in front of it* — the values you wrote, transformed. Some values depend instead
on *where the element lands in the finished document*: the page a heading falls
on, the current section number, a running total that accumulates down the pages.
Those can't be known while Typst is still deciding the layout, and they need a
different mechanism — `context`, the subject of Chapter 17.

## What you've got

You've picked up the data half of Typst's language:

- **Arrays** — ordered lists: indexing with `.at()` (including `.at(-1)` from
  the end), `.first()`/`.last()`/`.len()`, `.slice()`, `+`, `.contains()`/`in`,
  `.rev()`, `.sorted(key: ...)`, and `.push()`/`.pop()` for building on a
  variable. Plus the trailing-comma rule for single-element arrays.
- **The transformer trio** — `.map()` to reshape every element, `.filter()` to
  keep the ones that pass, `.fold()` to collapse to one value, all driven by
  arrow functions and chainable end to end. With `.sum()`, `.join()`,
  `.enumerate()`, and `.zip()` alongside.
- **Dictionaries** — records keyed by string: `.name` and `.at("name")` access,
  `.keys()`/`.values()`/`.pairs()`, `.insert()`/`.remove()`, `"key" in dict`,
  and a `default:` for keys that might be missing.
- **Strings** — as programmable sequences: `.len()`, `.split()`, `.replace()`,
  `.trim()`, `.contains()`, `.slice()`, `.find()`, `upper()`/`lower()`, looping
  over characters, and `regex(...)` for pattern work.
- **The array of dictionaries** — the workhorse dataset, turned into a formatted
  table with `map` + `flatten` + the `..` spread.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

16.1. Start with `#let nums = (8, 3, 11, 6, 3, 9)`. Print its length, its first
and last elements, the last element again using a negative index, and the middle
two elements with a slice. Then print the array sorted, and confirm `nums`
itself is unchanged afterwards.

16.2. Given `#let prices = (4.50, 12.00, 3.25, 8.75)`, use `map` to add 21% VAT
to each price, `filter` the original list down to the items over 5.00, and
`.sum()` to print the grand total of all four. Do it in three separate
expressions, then write one chained expression that prints the total
VAT-inclusive cost of just the items over 5.00.

16.3. Build a dictionary describing a book (`title`, `author`, `year`). Print a
sentence like "*Title* by Author (year)" using field access. Then `insert` a
`pages` field, `remove` the `year` field, and print the remaining keys. Finally,
use `.at()` with a `default:` to print a `publisher` field that you never added,
without causing an error.

16.4. Take the string `"lastname, firstname"` (for a real name of your choice).
Use `.split(", ")` to break it into parts, then reassemble and print it as
"Firstname Lastname" — first name first, each part capitalized. (Hint:
`.slice(0, 1)` and `upper()` capitalize a first letter; the two parts come
out of `split` reversed from the order you want.)

16.5. *(Stretch.)* Write an array of at least four dictionaries describing
songs, each with `title`, `artist`, and `seconds` (the duration). Render them
as a table sorted by duration, with a header row, using `map` + `flatten` +
the `..` spread. For extra credit, add a computed final column that shows each
duration as `m:ss` (minutes and seconds) — you'll need integer division and
`calc.rem`, and a little care so that a nine-second song reads `0:09`, not
`0:9`.

<!--
SOLUTIONS (notes for the appendix author):

16.1 - nums = (8, 3, 11, 6, 3, 9).
       nums.len() = 6; nums.first() = 8; nums.last() = 9; nums.at(-1) = 9.
       Middle two: nums.slice(2, 4) = (11, 6).
       nums.sorted() = (3, 3, 6, 8, 9, 11). Point: sorted() returns a NEW array,
       so nums is still (8, 3, 11, 6, 3, 9) afterward — verify by printing it
       again. Mirrors examples/083-arrays.

16.2 - prices = (4.50, 12.00, 3.25, 8.75).
       VAT each:   prices.map(p => p * 1.21)
       Over 5.00:  prices.filter(p => p > 5.00)  -> (12.00, 8.75)
       Grand total (all four): prices.sum() = 28.50
       Chained (VAT-inclusive total of items over 5.00):
         prices.filter(p => p > 5.00).map(p => p * 1.21).sum()
         = (12.00 + 8.75) * 1.21 = 25.0075
       Formatting to 2 decimals with calc.round(x, digits: 2) is a nice touch
       but not required. Mirrors examples/084-map-filter-fold.

16.3 - let book = (title: "Dune", author: "Herbert", year: 1965)
       Sentence: [#emph(book.title) by #book.author (#book.year)] or markup
       *#book.title* by #book.author (#book.year).
       book.insert("pages", 412); book.remove("year");
       book.keys() -> ("title", "author", "pages").
       book.at("publisher", default: "unknown") -> "unknown" without an error.
       Key teaching points: keys are strings; remove returns the removed value;
       default: prevents the missing-key crash. Mirrors examples/085-dictionaries.
       (Must use a mutable `let` binding for insert/remove.)

16.4 - let raw = "Lovelace, Ada"
       parts = raw.split(", ")  -> ("Lovelace", "Ada")
       Want "Ada Lovelace": parts.at(1) + " " + parts.at(0), i.e. reverse order.
       Capitalize helper: w => upper(w.slice(0, 1)) + w.slice(1) — though if the
       input is already capitalized this is a no-op; accept either.
       Reversing via parts.rev().join(" ") is an elegant alternative:
         raw.split(", ").rev().join(" ") -> "Ada Lovelace".
       Mirrors examples/086-strings (split + slice + upper + join).

16.5 - let songs = (
         (title: "Blackbird",    artist: "The Beatles", seconds: 138),
         (title: "Teardrop",     artist: "Massive Attack", seconds: 329),
         (title: "Roygbiv",      artist: "Boards of Canada", seconds: 161),
         (title: "Svefn-g-englar", artist: "Sigur Ros", seconds: 594),
       )
       #table(
         columns: 4,
         table.header([Title], [Artist], [Length], [m:ss]),
         ..songs.sorted(key: s => s.seconds).map(s => (
           s.title,
           s.artist,
           [#s.seconds s],
           {
             let m = calc.div-euclid(s.seconds, 60)
             let r = calc.rem(s.seconds, 60)
             let rr = if r < 10 { "0" + str(r) } else { str(r) }
             [#m:#rr]
           },
         )).flatten()
       )
       calc.div-euclid(seconds, 60) is the whole-minutes; calc.rem the leftover
       seconds. The zero-padding (r < 10 -> "0" + str(r)) is the point of the
       "0:09 not 0:9" caveat. Accept any equivalent padding. `..` + flatten as in
       examples/088-data-to-table. A `show table.cell.where(y: 0): strong` for a
       bold header is a nice bonus.
-->
