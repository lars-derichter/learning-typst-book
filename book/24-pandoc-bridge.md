# The Pandoc bridge

Here is a confession about the book you are reading. Its chapters are not
written in Typst. Every one of them — this one included — is a plain Markdown
file, the same `.md` you'd write for a README or a GitHub wiki. You've been
reading Typst's output all along, but the *source* is Markdown.

That should sound like a contradiction. This is a book about Typst; why isn't it
written in Typst? Because Markdown is a wonderful format to *write* in — light,
familiar, readable in a plain editor, painless to review on GitHub — and Typst
is a wonderful engine to *typeset* with. This chapter is about having both: you
write in Markdown, and a pipeline converts it to Typst and compiles it to a
finished PDF. By the end, you'll understand exactly how this book turns itself
into the thing in your hands, and you'll be able to do the same to any pile of
Markdown you have.

The bridge between the two worlds is a program called **Pandoc**.

## Pandoc, the universal converter

Pandoc is the Swiss Army knife of document conversion. It reads a few dozen
formats and writes a few dozen more — Markdown, HTML, LaTeX, Word, EPUB — and,
since version 3.0, **Typst**. It works by parsing your input into an internal
document model and then rendering that model in the target format. Markdown in,
Typst out.

The smallest possible taste, on the command line:

```sh
echo '# Hello' | pandoc --from gfm --to typst
```

```text
= Hello
<hello>
```

Pandoc read a Markdown heading and wrote the Typst equivalent: `= Hello`, plus a
`<hello>` label so the heading can be cross-referenced. `--from gfm` says the
input is GitHub-Flavored Markdown (the dialect this book uses, with its tables
and alerts); `--to typst` picks the output. That's the whole engine. Everything
in this chapter is teaching that one command to produce not just correct Typst
but *nicely typeset* Typst.

Point Pandoc at a real chapter and it handles the everyday things without help:

- `#`, `##`, `###` headings become `=`, `==`, `===`.
- `*emphasis*` and `**strong**` become `#emph[…]` and `#strong[…]`.
- Bullet and numbered lists become Typst lists.
- Fenced code blocks become Typst raw blocks, language tag and all.
- Markdown tables become `#table(…)` calls.
- Links become `#link(…)[…]`.

If that were all we needed, the pipeline would be one command. But a book wants
more than a faithful transcription — it wants a title page, a table of contents,
styled admonition boxes, a running design. Getting from "correct Typst" to "a
book" is the interesting part, and it takes three steps.

## The three-step pipeline

The whole build lives in `examples/117-pandoc-book-build/` and in the
repository's `scripts/build-book.sh`. It does exactly three things:

1. **Convert** every chapter's Markdown into one big Typst *body* with Pandoc.
2. **Assemble** the book by putting a Typst *preamble* — the design — in front
   of that body.
3. **Compile** the combined file to a PDF with Typst.

In shell, stripped to its bones:

```sh
pandoc book/*.md --from gfm --to typst \
  --lua-filter github-alerts.lua \
  --output body.typ

cat book-preamble.typ body.typ > learning-typst.typ

typst compile learning-typst.typ learning-typst.pdf
```

The `book/*.md` glob expands in order, because the chapters are named `00-`,
`01-`, `02-`, and so on — the numbering scheme earning its keep one last time.
Pandoc concatenates them into a single body. We prepend the preamble with a
plain `cat`, and Typst compiles the result.

> [!NOTE]
> You might expect to use Pandoc's own `--template` feature to wrap the body,
> and you can — but there's a trap. A Pandoc template treats every `$…$` as a
> variable to substitute, and Typst uses `$…$` for math. The two notations
> collide badly. Concatenating a plain Typst preamble with `cat` sidesteps the
> whole problem: the preamble is pure Typst, Pandoc never sees it, and nothing
> gets confused. Sometimes the blunt tool is the right one.

Two of those steps are trivial (`cat` and `typst compile`). The craft is in the
other two: the Lua filter that shapes Pandoc's conversion, and the preamble that
supplies the design. Take them in turn.

## Teaching Pandoc new tricks with a Lua filter

Pandoc's default conversion is faithful but literal, and a book needs a few
things it won't do on its own. Rather than post-process the output with fragile
text substitution, Pandoc lets you insert a **filter**: a small program that
runs on the parsed document *between* reading and writing, so you transform the
document model itself. Filters can be written in Lua, a tiny language Pandoc
embeds, and ours — `github-alerts.lua` — is about sixty lines doing four jobs.

### Turning alerts into admonitions

Throughout this book, an admonition looks like this in Markdown:

```text
> [!NOTE]
> Something worth pausing on.
```

That's a GitHub alert, and Pandoc's `gfm` reader understands it: it parses the
block into a *Div* (a generic container) tagged with the class `note` — or
`tip`, `important`, `warning`, `caution`. But Pandoc's Typst writer, left alone,
flattens that Div into a plain `#block` and throws the flavour away. A note and
a warning come out looking identical, which defeats the purpose.

The filter catches the Div before the writer sees it and rewrites it into a call
to a Typst function we control:

```lua
local kinds = { note=true, tip=true, important=true,
                warning=true, caution=true }

function Div(el)
  for _, class in ipairs(el.classes) do
    if kinds[class] then
      local out = { pandoc.RawBlock("typst",
                      '#admonition("' .. class .. '")[') }
      for _, blk in ipairs(el.content) do
        if not (blk.t == "Div" and blk.classes:includes("title")) then
          table.insert(out, blk)
        end
      end
      table.insert(out, pandoc.RawBlock("typst", "]"))
      return out
    end
  end
end
```

Read it as a recipe. When Pandoc hands the filter a `Div`, we check whether it's
one of our alert kinds. If so, we build a replacement: a raw chunk of Typst,
`#admonition("note")[`, then the alert's own content (minus the little inner
`title` Div that just held the word "Note"), then a closing `]`. The content
blocks in the middle are still ordinary Pandoc blocks, so the Typst writer
converts *them* normally — we've only wrapped them in a function call. The
result in the body is `#admonition("note")[ …converted content… ]`, and the
preamble defines `admonition` to draw the coloured box. The alert's flavour
survives, because we transformed the document at the structural level instead of
patching its text.

### Passing math through untouched

The second job is subtler. This book writes its math in *Typst's* syntax —
`$sum_(i=1)^n$`, `$pi r^2$`, `$a <= b$` — right in the Markdown prose. But
Pandoc, told to read dollar-math, assumes it's *LaTeX* and would try to convert
it, which mangles Typst-native spellings like `pi` (Typst's π) or `oo` (Typst's
∞). We don't want conversion here; we want the exact text preserved. So the
filter intercepts every piece of math and hands it straight back as raw Typst:

```lua
function Math(el)
  if el.mathtype == "InlineMath" then
    return pandoc.RawInline("typst", "$" .. el.text .. "$")
  else
    return pandoc.RawInline("typst", "$ " .. el.text .. " $")
  end
end
```

Because the source was already valid Typst math, wrapping the raw text back in
`$…$` reproduces it perfectly. This is the quiet advantage of writing a book
about Typst *in* files destined for Typst: the math needs no translation, only
protection from a well-meaning converter.

### Numbering the book like a book

A book's Preface shouldn't be "Chapter 1," and its appendices want letters, not
numbers — but to Pandoc every `#` heading is just a top-level heading. Left
alone, the numbered chapters would start at 2 (the Preface having eaten number
1). The filter fixes this by emitting the Preface and each Appendix as
*unnumbered* headings, which Typst does not count:

```lua
function Header(el)
  if el.level == 1 then
    local text = pandoc.utils.stringify(el)
    if text == "Preface" or text:match("^Appendix") then
      return pandoc.RawBlock("typst",
        "#heading(level: 1, numbering: none)[" .. text .. "]")
    end
  end
end
```

With the front and back matter set aside, the chapters in between number 1
through N exactly as they should. It's a three-line rule that turns a flat
sequence of headings into the structure of a real book.

### Dropping the author's notes

The last job is a one-liner. Each chapter ends with an HTML comment holding
solution notes for the appendix author — content that must never reach a reader.
Pandoc reads it as raw HTML, and the filter simply discards all raw HTML:

```lua
function RawBlock(el)
  if el.format == "html" then return {} end
end
```

Four small functions, and Pandoc's literal conversion becomes a book-aware one.

## The preamble: a template, one more time

The body that Pandoc produces is just content — headings, paragraphs, the
`#admonition` calls the filter emitted. It has no page size, no fonts, no title
page, and no definition of `admonition`. All of that lives in
`book-preamble.typ`, and it is nothing you haven't seen. It is a template, in
the exact sense of Chapter 19 and the book template of Chapter 22: a stack of
`set` rules for the page and text, `show` rules that give chapters their opening
pages and style the code blocks, the `admonition` function built with the
content-argument pattern from Chapter 14, a title page, and a generated
`#outline` for the table of contents.

The one structural trick is that the preamble ends not with a `body` parameter
but with nothing at all — because the body is *concatenated on* after it by the
`cat` in step two. Everything the preamble sets up is therefore in force for the
content that follows it, the same "rules first, content after" logic that makes
every template work.

That reuse is the point worth savouring. The Markdown-to-PDF pipeline didn't
need a new styling system; it plugs the converted content into the very
machinery this book spent Part V teaching. The book's design is a Typst
template, whether the content arrives hand-written in Typst (Chapter 23) or
converted from Markdown here. Same engine, two front doors.

## Running it

With Pandoc and Typst installed, the whole book builds with one command from the
repository root:

```sh
scripts/build-book.sh
```

It converts every chapter, assembles them under the preamble, compiles the
result, and writes `build/learning-typst.pdf` — a few hundred pages, with a
title page, a linked table of contents, numbered chapters, styled admonitions,
themed code, and typeset math, all from a folder of Markdown files. The preview
beside this example (`examples/117-pandoc-book-build/out.png`) is its title
page.

That is the sentence this whole book has been walking toward: **the book
typesets itself.** The document you're holding is the output of running that
script on the Markdown that describes it — and, because this chapter is one of
those Markdown files, the description includes the description of how it's
built. The snake, contentedly, eats its tail.

> **Coming from LaTeX.** If you've used Pandoc to make PDFs before, it was
> almost certainly through LaTeX: `pandoc thesis.md -o thesis.pdf` quietly
> shelled out to a LaTeX engine. The Typst writer is the same idea with a
> faster, friendlier backend — no multi-gigabyte TeX install, compilation in a
> blink, and legible intermediate output you can actually read and debug. If you
> have a stack of Markdown and you want a PDF, `--to typst` is now the shortest
> path to a good-looking one.

## What's simplified, honestly

A pipeline this short makes trade-offs, and it's only fair to name them. Links
between chapters (`[Appendix A](25-…md)`) render as text rather than live
internal jumps, because resolving them into one document would take another
filter. Markdown tables come through wrapped in figures, so they pick up "Table
N" numbers you may not want. Fine typography that you'd hand-tune in a real
Typst document — exact page breaks, widow control around a specific figure —
isn't something a batch conversion can decide for you. None of these are hard to
improve; each is another small filter or a preamble tweak, and adding one is a
good exercise. The pipeline is a foundation, not a ceiling.

What it proves is the important thing: Markdown and Typst are not rivals.
Markdown is a superb way to *write*, Typst a superb way to *typeset*, and Pandoc
is the bridge that lets you keep both. Write in the format that's pleasant to
write in; compile with the engine that makes it beautiful.

## What you've got

You can now turn a body of Markdown into a typeset Typst PDF:

- **Pandoc** converts Markdown to Typst with `pandoc --from gfm --to typst`,
  handling headings, emphasis, lists, code, tables, and links out of the box.
- **The three-step pipeline** — convert each chapter to a body, `cat` a Typst
  preamble in front, compile — keeps Typst code and Pandoc's `$…$` templating
  from colliding.
- **A Lua filter** shapes the conversion: GitHub alerts become `#admonition`
  boxes, Typst-syntax math is passed through untouched, the Preface and
  appendices are left unnumbered, and author-only HTML comments are dropped.
- **The preamble is a template** — the same Chapter 19/22 machinery — supplying
  the page design, the `admonition` function, a title page, and a table of
  contents.
- **`scripts/build-book.sh`** runs the lot and typesets this entire book from
  its Markdown source.

And with that, the book has closed its own loop: it taught you Typst, and then
it showed you the machine that printed it. What remains are the appendices — the
solutions to the exercises, migration maps from LaTeX and Word, a
quick-reference cheat sheet, and where to go next — reference material for when
the reading is done and the writing begins.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

24.1. Install Pandoc (if you haven't) and run the smallest pipeline by hand:
write a three-paragraph Markdown file with a heading, a bold word, and a bullet
list, and convert it with `pandoc --from gfm --to typst`. Read the output and
match each piece of Typst to the Markdown it came from.

24.2. Take that same file and compile it to a PDF two ways: once through Typst
(`pandoc … --to typst -o out.typ` then `typst compile out.typ`) and, if you have
a LaTeX install, once the traditional way (`pandoc file.md -o out.pdf`). Compare
the speed and the results.

24.3. Add a GitHub alert (`> [!TIP]`) to your Markdown file and convert it to
Typst *without* the filter. Confirm it comes out as a plain block with the word
"Tip" buried inside, losing its styling — the problem the filter exists to
solve.

24.4. Write a two-line Lua filter that drops every `RawBlock` of format `html`,
and run your file through it with `--lua-filter`. Put an HTML comment in the
Markdown and confirm it vanishes from the output.

24.5. *(Stretch.)* Build a miniature book of your own: two or three Markdown
files, a short Typst preamble that sets a page size and defines an `admonition`
function, and a shell script that converts the Markdown, concatenates the
preamble, and compiles the result. You'll have rebuilt this chapter's pipeline
in miniature — and you'll never be afraid of a folder of Markdown again.

<!--
SOLUTIONS (notes for the appendix author):
24.1 - Any 3-paragraph gfm file. `pandoc --from gfm --to typst` maps: # -> =,
       **bold** -> #strong[...], - list -> Typst list items. The point is to
       read the output and see the one-to-one correspondence. No compile needed.
24.2 - `pandoc x.md --to typst -o x.typ && typst compile x.typ` vs
       `pandoc x.md -o x.pdf` (LaTeX path, needs a TeX install). Typst path is
       far faster and needs no TeX. Both should produce a reasonable PDF. If no
       LaTeX, just note the Typst path works with no heavy dependency.
24.3 - Without the filter, `> [!TIP]\n> text` becomes nested #block[ #block[ Tip ]
       text ] — a plain block, no colour, "Tip" as literal text. Demonstrates why
       the Div-rewriting filter is needed. With the filter it becomes
       #admonition("tip")[text].
24.4 - function RawBlock(el) if el.format == "html" then return {} end end.
       An HTML comment <!-- x --> is a RawBlock html; the filter returns {} so it
is removed. Confirm it's gone from the -t typst output. 24.5 - Mirrors
examples/117: N markdown files, a preamble.typ defining
       #let admonition(kind, body) = ... and page/text set rules, and a build.sh
doing pandoc(*.md) -> body.typ, cat preamble body > out.typ, typst compile.
Grade on a working end-to-end build, however minimal. The insight: converter +
template + compile = a book from Markdown. -->
