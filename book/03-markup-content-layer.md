# Markup: the content layer

Open a blank file and type a sentence. Compile it. You get that sentence set in
a real typeface, with proper kerning and ligatures and its lines broken to fit —
a paragraph, and a handsome one, from a line you typed without a thought. You
never asked for any of that. Typst assumed it, because prose is the default. A
file with nothing special in it is already a document.

Everything else in this chapter is a small, deliberate deviation from that
default: a stroke of punctuation that tells Typst "this part is a heading,"
"this word is emphasized," "these three lines are a list." That punctuation is
*markup*, and it is the layer you'll spend most of your writing life in. It is
deliberately quiet — a hyphen here, an asterisk there — so that your source
still reads like the thing it describes, not like a wall of tags.

If you've written [Markdown](29-appendix-e-markdown.md), a lot of this will feel
like coming home, with the furniture moved slightly. Read the "Coming from
Markdown" box near the end before you assume anything transfers unchanged; a
few of the pieces are in
different places, and one or two will trip you if you don't look.

By the end of the chapter you'll be able to hand-write a structured,
multi-section document — headings, emphasis, lists, links, the lot — without
touching a single styling rule. Styling comes later. First you learn to say
*what things are*.

## Paragraphs and whitespace

A paragraph is just text with a blank line above and below it. That's the whole
rule. To start a new paragraph, leave a blank line; to keep writing the same
one, don't.

Inside a paragraph, Typst treats whitespace generously — which is to say, it
mostly ignores how much of it you typed. Runs of spaces collapse to one. A line
break in your source is just another space. So this:

```typ
This sentence is broken across
several   lines   with   odd
spacing in the source.
```

comes out as one tidy line of prose, respaced and rewrapped to fit the page.
Your source can be as ragged as you like; the output won't care. This is a
feature, not a quirk: you get to wrap your source at a comfortable width (this
book wraps at 80 columns) without those wraps leaking into the page.

Now and then you *do* want a line to break exactly where you say — an address, a
line of a poem, the closing of a letter. For that, end the line with a
backslash:

```typ
Rue de la Paix 12\
1000 Brussels\
Belgium
```

The trailing `\` forces a hard line break *within* the same paragraph. It's the
one case where your source's line ending survives into the output. See
`examples/006-headings-and-paragraphs/` for headings and both kinds of break in
one small file.

> [!NOTE]
> A blank line and a backslash are not the same thing. A blank line starts a new
> paragraph, which carries paragraph spacing above it. A backslash breaks the
> line but stays inside the paragraph, tight against the line before. Use the
> one that matches what you mean.

## Headings

A heading is an equals sign, a space, and the heading text:

```typ
= Chapter title
== A section
=== A subsection
```

One `=` is a top-level heading; each extra `=` drops you a level, down to six
(`======`) if you ever need that far, which you almost never will. The space
after the equals signs matters — `=heading` with no space is just literal text.

That's the whole syntax. Notice what's missing: no numbers. Typst does not print
"1.2.3" in front of your headings unless you ask it to, and asking is a one-line
*set rule* — `#set heading(numbering: "1.")` — which we hold until
[Chapter 9](09-set-rules.md), where set rules get the introduction they
deserve. For now, write your headings as plain structure and let the
numbering wait.

> **Coming from Markdown.** Yes, it's `=`, not `#`. In Typst the `#` is reserved
> for something bigger (dropping into code — hold that thought), so headings
> took the next most obvious symbol. More equals signs means a *deeper*
> heading, the same way more `#` means deeper in Markdown.

## Emphasis: italic and bold

Wrap a word or phrase in underscores to *emphasize* it, and in asterisks to make
it *strong*:

```typ
Wrap a word in underscores for _emphasis_, which renders italic,
and in asterisks for *strong*, which renders bold.
```

They nest, so you can have bold with a slice of italic inside it:

```typ
*Read this now, it is _actually_ important.*
```

Under the hood, `_…_` is shorthand for a function called `emph` and `*…*` for
one called `strong`. You can call them the long way — `#emph[like this]` and
`#strong[like this]` — and you'll occasionally want to when you're generating
text from code rather than typing it by hand. That `#` is the doorway into
Typst's programming language; [Chapter 13](13-from-markup-to-code.md) walks
through it properly. For plain writing, the underscores and asterisks are all
you need. Example
`examples/007-emphasis-and-raw/` shows emphasis, nesting, and raw text together.

> **Coming from Markdown.** Both delimiters are *single* here. Markdown makes
> you double the asterisks for bold (`**bold**`) and reserves single ones for
> italic; Typst uses `*` for strong and `_` for emphasis, one character each.
> Fewer keystrokes, one fewer thing to miscount.

## Raw text: code and verbatim

Sometimes you need Typst to keep its hands off — to print exactly what you
typed, markup characters and all. That's *raw text*, and you get it with
backticks.

For a snippet mid-sentence, wrap it in single backticks: run `` `typst watch
main.typ` `` to rebuild on every save. Whatever sits between the backticks is
verbatim, so `` `*this stays literal*` `` prints its asterisks instead of
turning bold. Handy, given how much of this chapter is about characters that
normally *do* something.

For a whole block — a code listing, a config file, a terminal session — fence it
with three backticks, and optionally name the language right after the opening
fence:

````typ
```rust
fn main() {
    println!("Hello, Typst!");
}
```
````

Everything inside is preserved character for character: indentation, blank
lines, the works. The language tag (`rust` here) switches on syntax
highlighting, so keywords, strings, and the rest come out colored. Leave the tag
off and you get the same verbatim block without the colors. Typst knows a long
list of languages; if it doesn't recognize the tag, it simply skips the
highlighting rather than complaining.

## Lists

Three kinds of list cover almost everything you'll write, and all three are one
character at the start of a line.

A hyphen makes a bullet:

```typ
- Bread
- Cheese
- A quiet afternoon
```

A plus sign makes a numbered list, and Typst does the counting — you never type
the numbers, so reordering items never means renumbering by hand:

```typ
+ Boil the water.
+ Add the pasta.
+ Wait, impatiently.
```

Nest either kind by indenting, and mix them freely — bullets under numbers,
numbers under bullets, however the content wants to be shaped:

```typ
- Fruit
  + Apples
  + Pears
- Vegetables
  - Leafy
  - Root
```

Indentation is what creates the nesting, so keep it consistent within a list.
`examples/008-lists/` collects all of these, plus the third kind.

That third kind is the *term list*, for pairing a name with its definition — a
glossary, a cast of characters, a set of options:

```typ
/ Markup: the content layer you type by hand.
/ Set rule: a way to change a default, met in Chapter 9.
```

A term list item is a forward slash, the term, a colon, and the description.
Typst sets the term apart (bold, by default) and lays the description beside it.

> [!WARNING]
> A block sitting flush against a list — a fenced code block, say — ends the
> list, and a following `+` item starts counting again from one. If you want a
> code block to belong *inside* an item, indent it to line up under that item's
> text. The meeting note in `examples/011-a-structured-note/` does exactly this
> to keep a shell block tucked inside step two.

## Links

Type a bare URL and Typst turns it into a working link automatically:

```typ
The docs live at https://typst.app/docs — go read them.
```

A naked URL is honest but ugly. To hang a link on some friendlier words, use the
`link` function, which takes the address in quotes and the visible text in
square brackets:

```typ
Read #link("https://typst.app/docs")[the official docs] when you get stuck.
```

That `#link(...)[...]` is your first real look at Typst's function-call shape: a
`#`, a name, the arguments in parentheses, and content in square brackets.
You'll see that shape everywhere once you start styling, so it's worth clocking
now even though functions proper wait for Chapter 13. Links and quotes share
`examples/009-links-and-quotes/`.

Links don't only point outward. You can also link *within* your document — jump
to a heading, a figure, an equation — using labels, which is the next stop.

## Smart quotes and punctuation

Here's where Typst quietly earns its keep. You type plain, unfussy characters
and get proper typography without thinking about it.

Type straight quotes and Typst curls them for you, and it does so
*language-aware*ly — the right quotation marks for the document's language, not
a one-size guess:

```typ
"Double quotes" and 'single quotes' and don't-panic apostrophes
all come out as the correct curly marks.
```

Dashes work by counting hyphens. One hyphen is a hyphen. Two (`--`) make an *en
dash*, the one for ranges: `pages 12--18`. Three (`---`) make an *em dash*, the
long one for a break in thought---like this. And three dots (`...`) become a
single, properly spaced ellipsis, not three cramped full stops.

One more, easy to miss and genuinely useful: a tilde (`~`) is a *non-breaking
space*. It looks like an ordinary space but Typst won't break the line there, so
you can keep a number glued to its unit — `10~kg`, `Chapter~9`, `Fig.~3` — and
never suffer a "10" alone at the end of a line with its "kg" orphaned on the
next. `examples/010-symbols-and-escapes/` demonstrates every one of these.

## Escapes and comments

If markup characters do things, you'll eventually need to print one *without* it
doing its thing — a literal asterisk, a real hash, an underscore in a filename.
Put a backslash in front of it:

```typ
\*not strong\*, a real \# hash, and a file called my\_notes.txt
```

The backslash escapes exactly the next character. It's the same backslash that
forces a line break at the end of a line; in the middle of one, it defuses
whatever follows.

The backslash also reaches any character at all by its Unicode codepoint, with
`\u{...}` and the hexadecimal number:

```typ
A check mark \u{2713}, an arrow \u{2192}, a heart \u{2764}.
```

Finally, notes to yourself that never reach the page. Two slashes start a
comment that runs to the end of the line; `/*` and `*/` bracket a comment that
can span several:

```typ
This prints. // this does not
This also prints. /* and none
of this multi-line aside does */
```

Comments are for scaffolding — a reminder, a disabled paragraph, a note to a
co-author. They vanish at compile time and leave no trace in the PDF.

## A taste of labels and references

You can pin a *label* on almost anything by writing it in angle brackets right
after the thing, and then point at it from elsewhere with an `@`:

```typ
#set heading(numbering: "1.")

= Introduction <intro>

As we saw in @intro, markup comes first.
```

Typst fills in `@intro` with a live cross-reference — a number and a link that
stay correct even as you shuffle the document around. This is one of the payoffs
of describing structure instead of formatting: the machine knows what "the
introduction" *is*, so it can always find it.

That's the whole idea in one bite. One catch worth naming now: pointing at a
*heading* only works once heading numbering is switched on, which is why that
`#set heading(numbering: "1.")` line sits at the top of the example — without
it, Typst stops and tells you it *cannot reference heading without numbering*.
Labels on other things don't need it. References can also carry their own
wording, and [Chapter 11](11-references-and-cross-references.md) gives labels
and cross-references the full treatment; file the syntax away for now.

## Two symbols you'll meet soon

While we're naming special characters, two more are worth flagging so they don't
surprise you later.

A dollar sign opens *math*: `$a^2 + b^2$` typesets an equation inline, and
Typst's math is good enough to get its own chapter
([Chapter 8](08-math-and-equations.md)). And the `#` you keep seeing drops out
of markup and into *code* — the little programming
language under the surface, where `#link` and `#emph` and `#set` all come from.
Chapter 13 opens that door deliberately. For now, just recognize the two
symbols: `$` means math, `#` means code.

> **Coming from Markdown.** The quick translation table, because the differences
> bite:
>
> - **Emphasis is single, both ways.** `*strong*` and `_emph_` — no doubling.
> - **Headings are `=`, not `#`.** More equals, deeper heading.
> - **`#` means code, not a heading.** It's the single biggest gotcha coming
>   from Markdown: a stray `#` isn't a title, it's an attempt to run something.
> - **Links are backwards.** Markdown's `[text](url)` becomes
>   `#link("url")[text]` — address first, visible text in the brackets.
> - **Raw text is the same.** Backticks and triple-backtick fences work just as
>   you'd expect, language tag and all.

## What you've got

You can now write the entire content layer of a document by hand:

- **Paragraphs** from blank lines, with a trailing `\` for a hard line break,
  and the freedom to wrap your source however you like.
- **Headings** with `=` through `======`, structure without numbering (that's a
  set rule, Chapter 9).
- **Emphasis** (`_…_`) and **strong** (`*…*`), nesting freely, with `#emph`/
  `#strong` waiting in code mode.
- **Raw text** — inline backticks and fenced blocks with syntax highlighting —
  for anything that must stay verbatim.
- **Lists**: bulleted (`-`), numbered (`+`), nested, mixed, and term lists
  (`/ Term: …`).
- **Links**, bare or labeled with `#link`, and a first taste of `<label>` /
  `@reference` cross-references (Chapter 11).
- **Typographic niceties** for free: smart quotes, en/em dashes, the ellipsis,
  and the `~` non-breaking space.
- **Escapes** (`\*`, `\#`, `\u{...}`) and **comments** (`//`, `/* … */`).

That is enough to write a clean, well-structured multi-section document —
something you'd actually be happy to hand in or send out. It won't be styled to
your taste yet; that starts in Chapter 4 with text and fonts, and turns into
real power in Chapter 9 with set and show rules. But the words, and the shape of
the words, are entirely in your hands now.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

3.1. Write a short document with a title, two sections (each a `==` heading),
and a paragraph or two of your own text under each. Compile it and confirm the
headings stand out from the body.

3.2. Take a paragraph and, without adding or removing any words, make one phrase
*emphasized*, one *strong*, and one a bit of `inline raw code`. Then add a
second paragraph containing a bulleted list of three items and turn one of those
bullets into a two-item nested list.

3.3. Typeset this line so it comes out exactly right: a range written as an en
dash ("pages 30–34"), a break in thought as an em dash, a quantity whose number
and unit never split across a line ("5 km"), and a real, literal asterisk in the
sentence. Check the compiled PDF to be sure each one landed.

3.4. Build a small "reading list" as a term list: three books, each term the
title and each description a one-line note. Then add, below it, a labeled link
to where someone could buy or borrow one of them.

3.5. *(Stretch.)* Rebuild `examples/011-a-structured-note/` from scratch without
looking at it — a meeting note or a recipe with a title, a couple of sections,
at least one numbered list and one bulleted list, an emphasized word, a link,
and a fenced code (or ingredient) block nested inside a list item. Compile it
and fix anything that doesn't render the way you meant, paying special attention
to whether your nested block breaks the numbering.

<!--
SOLUTIONS (notes for the appendix author):
3.1 - Any file of the shape:
        = My title
        == First section
        Some prose...
        == Second section
        More prose...
      Point: `=` is the title, `==` are sections; a space after the equals signs
      is required. Compiling and eyeballing the heading contrast is the whole
      exercise.
3.2 - e.g. "_emphasized_", "*strong*", "`inline raw code`". Nested list:
        - one
        - two
          - two-a
          - two-b
        - three
      Nesting is created purely by indentation under the parent bullet.
3.3 - "pages 30--34" (en dash), "...---..." for the em dash, "5~km" (tilde =
      non-breaking space), and "\*" for a literal asterisk. The point is that
      `--`, `---`, `~`, and `\` each do a specific job; verifying in the PDF
      catches, e.g., writing a single hyphen where an en dash was wanted.
3.4 - Term list:
        / Title one: a note.
        / Title two: a note.
        / Title three: a note.
      Then #link("https://...")[borrow it here]. Accept any working /Term:
      syntax and any correct #link("url")[label].
3.5 - A complete small document combining headings, emphasis, both list kinds, a
      #link, and a fenced block INDENTED under a numbered item so the list keeps
      counting (1, 2, 3) rather than restarting. Mirrors example 011. Key point
      is the gotcha flagged in the Lists WARNING: a flush block ends the list.
-->
