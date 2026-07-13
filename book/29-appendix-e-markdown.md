# Appendix E · A Markdown primer

Here is a fact this book keeps quiet until Chapter 24: it is not written in
Typst. Every chapter is a plain Markdown file — the same `.md` you'd write for a
README — and a pipeline turns that Markdown into the PDF in your hands. The
admonition boxes you've been reading are GitHub *alerts*; the running text is
Markdown; Typst only ever sees the output. If you want to read the book's
source, file an issue against it, or write a chapter of your own, you need to
read Markdown. If you've never met it, this appendix is the whole format in a
few minutes.

Markdown is a shorthand for formatted text that stays readable before it is
rendered. You write `**bold**` and get **bold**; you write `# Title` and get a
heading. The syntax was designed to mimic the conventions people already used in
plain email — asterisks around a word for emphasis, hyphens for a bullet list —
so the raw file looks fine on its own. That is the entire pitch: the source is
legible, and the rendered output is clean.

There is no single Markdown, which trips people up. The original 2004 rules left
gaps, so implementations drifted apart. **CommonMark** is the careful standard
that nails the ambiguities down. **GitHub Flavored Markdown** (GFM) is CommonMark
plus a short list of additions — tables, task lists, strikethrough, autolinked
URLs, and the alert boxes this book leans on. GFM is what GitHub renders, what
most tools now mean by "Markdown", and the exact dialect this book is written in,
so it's what we cover here.

## The everyday syntax

**Headings** are hash marks, one per level, always with a space after the last
`#`:

```md
# Title
## Section
### Subsection
```

**Emphasis** wraps a word or phrase in symbols. One mark for italic, two for
bold, and — in GFM — two tildes for strikethrough:

```md
*italic*  or  _italic_
**bold**  or  __bold__
***bold italic***
~~struck through~~
```

**Paragraphs** are separated by a blank line. A single newline *inside* a
paragraph is ignored — the lines simply flow together when rendered, which is
why you can wrap the source at a comfortable width (this book wraps at 80) with
no effect on the output. To force a break *within* a paragraph, end the line
with a backslash or two trailing spaces:

```md
First line, hard break.\
Second line, same paragraph.
```

**Lists** come in two flavours. Bullets use `-` (or `*`, or `+`); ordered lists
use `1.`, and the numbers you type are ignored — the renderer counts for you, so
a column of `1.` still comes out 1, 2, 3. Indent to nest:

```md
- milk
- eggs
  - free-range
- flour

1. Preheat the oven.
1. Mix the batter.
1. Bake.
```

GFM adds **task lists** — bullets with a checkbox that renders ticked or empty:

```md
- [x] Write the appendix
- [ ] Rebuild the PDF
```

**Links** put the visible text in square brackets and the address in
parentheses right after. A bare URL autolinks on its own in GFM; angle brackets
make that explicit:

```md
[the Typst docs](https://typst.app/docs)
https://typst.app
<https://typst.app>
```

**Images** are links with a leading `!`. The bracketed text is the alt text,
which matters for accessibility and shows if the image fails to load:

```md
![A snake eating its own tail](cover.png)
```

**Code** is verbatim text, never reinterpreted. A `` `code span` `` sits inline;
a *fenced block* — three backticks above and below — holds several lines, with an
optional language name on the opening fence for syntax highlighting:

````md
Inline `typst compile` runs the compiler.

```sh
typst compile main.typ out.pdf
```
````

**Blockquotes** prefix each line with `>`, and nest if you stack them:

```md
> A quoted line.
> Still the same quote.
```

**Alerts** are a GFM extension built on the blockquote, and they are how this
book draws its Note, Tip, Important, Warning, and Caution boxes. A blockquote
whose first line is one of five keywords in brackets becomes a coloured callout:

```md
> [!NOTE]
> Useful context the reader can take or leave.

> [!WARNING]
> Something that will bite if ignored.
```

**Tables** are a GFM extension too. Pipes separate the cells; a divider row of
hyphens under the header turns the block into a table, and colons in that
divider set each column's alignment (`:---` left, `:--:` centre, `---:` right):

```md
| Fruit  | Colour | Price |
| :----- | :----: | ----: |
| apple  | red    |  0.30 |
| lemon  | yellow |  0.45 |
```

The source columns don't need to line up — that's just courtesy to the next
human to open the file.

**Horizontal rules** are three or more hyphens, asterisks, or underscores alone
on a line: `---`. And when you need a literal character that Markdown would
otherwise read as syntax, **escape** it with a backslash: `\*not italic\*`
renders as \*not italic\*.

## The reference

| Syntax | What it does |
| ------ | ------------ |
| `# H1` … `###### H6` | Headings, levels 1–6 (space after the `#`) |
| `*italic*` / `_italic_` | Italic |
| `**bold**` / `__bold__` | Bold |
| `~~struck~~` | Strikethrough (GFM) |
| `` `code` `` | Inline verbatim |
| ```` ```lang … ``` ```` | Fenced code block, optional language |
| `- item` / `* item` / `+ item` | Bullet list |
| `1. item` | Ordered list (numbers are recounted) |
| `- [ ] todo` / `- [x] done` | Task list (GFM) |
| `[text](url)` | Link |
| `<url>` or a bare URL | Autolink (GFM) |
| `![alt](src)` | Image |
| `> quote` | Blockquote |
| `> [!NOTE]` (TIP, IMPORTANT, WARNING, CAUTION) | Alert callout (GFM) |
| `\| a \| b \|` + `\| --- \| --- \|` | Table (GFM); `:` sets alignment |
| `---` on its own line | Horizontal rule |
| line ending in `\` | Hard line break |
| blank line | New paragraph |
| `\*` `\#` `\_` | Escape a literal Markdown character |

## Where to go deeper

Four references, in rough order of how much of a hurry you're in:

- **GitHub's "Basic writing and formatting syntax"** —
  <https://docs.github.com/get-started/writing-on-github>. The fastest tour of
  exactly the GFM this book uses, alerts and tables included.
- **The Markdown Guide** — <https://www.markdownguide.org>. A friendly
  cheat-sheet-and-tutorial site, with a basic and an extended-syntax page.
- **CommonMark** — <https://commonmark.org>. The standard, with a "learn
  Markdown in 60 seconds" card and a live in-browser editor for testing what a
  strict parser makes of your text.
- **The GFM specification** — <https://github.github.com/gfm/>. The exact,
  pedantic rules for the dialect, for when you need to settle an argument about
  an edge case.

With that, the source of this book is fully open to you. To watch that Markdown
turn into Typst and then into a PDF, read Chapter 24; for the day-to-day Pandoc
toolbox that drives the conversion, see the next appendix.
