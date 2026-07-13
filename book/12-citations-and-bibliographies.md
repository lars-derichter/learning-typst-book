# Citations and bibliographies

You have a paper due, and it leans on other people's work — a book here, three
journal articles there, a web page you'd rather not admit you're citing. Two
jobs come with that territory. In the running text you have to name your sources
the way your field expects: `(Sweller, 1988)` if you write APA, a terse `[1]` if
you write IEEE. And at the end you owe the reader a reference list, alphabetized
or numbered, every title and volume and page in exactly the right place, italics
and commas included.

Done by hand, this is a special kind of tedium. Change one source and every
number after it shifts. Switch from APA to IEEE for a different journal and you
reformat the lot. Anyone who has done a literature review in a word processor
has felt the particular dread of the manually maintained bibliography.

Typst does the whole thing for you. You keep your sources in one small data
file, you cite them by a short key, and a single line renders the list — in
whatever style you name, correct down to the last comma, kept in sync
automatically. This chapter gets you citing, gets your reference list looking
right, and spends most of its time on APA, because that's the style this book's
readers ask about most and the one it's easiest to get subtly wrong.

## The shortest possible bibliography

Two ingredients: a file of sources and a call to render them. Here is the whole
thing, start to finish (it's `examples/061-first-citation/`).

First, a sources file. Typst's native format is called Hayagriva, and it's
plain YAML — a name, then indented fields. Save this as `refs.yml`:

```yaml
sweller1988:
  type: article
  title: "Cognitive load during problem solving: Effects on learning"
  author: Sweller, John
  date: 1988
  parent:
    type: periodical
    title: Cognitive Science
    volume: 12
    issue: 2
  page-range: 257-285
  serial-number:
    doi: "10.1207/s15516709cog1202_4"

mcluhan1964:
  type: book
  title: "Understanding media: The extensions of man"
  author: McLuhan, Marshall
  date: 1964
  publisher: McGraw-Hill
  location: New York
```

The word at the top of each entry — `sweller1988`, `mcluhan1964` — is the
*key*. It's yours to choose; a lowercase surname plus year is a common habit.
That key is how you'll refer to the source from your document.

Now the document. You cite with an `@` followed by a key, exactly the way you
referenced a figure or an equation in
[Chapter 11](11-references-and-cross-references.md) — the same little symbol,
doing double duty. Then one `#bibliography` call renders the list:

```typ
= A first citation

Working memory is a bottleneck for learning @sweller1988. The idea that
media themselves shape thought is older still @mcluhan1964.

#bibliography("refs.yml", style: "apa")
```

Compile that and you get a tidy page. In the prose, each `@key` becomes an
author–date citation in parentheses: "…a bottleneck for learning (Sweller,
1988)." At the bottom, under a heading, sits the reference list:

```text
Bibliography

McLuhan, M. (1964). Understanding media: The extensions of man.
    McGraw-Hill.

Sweller, J. (1988). Cognitive load during problem solving: Effects on
    learning. Cognitive Science, 12(2), 257–285.
    https://doi.org/10.1207/s15516709cog1202_4
```

That's a complete, correctly formatted, alphabetized APA reference list from six
lines of markup. Notice what you did *not* do: you didn't format the citation,
didn't alphabetize the list, didn't italicize the journal name, didn't run a
second program. You named your sources and named a style. Typst did the rest.

> [!NOTE]
> The `#bibliography` call renders the list wherever you put it. That's almost
> always the end of the document — but it's an ordinary piece of content, so if
> you want a reference list halfway through, put it halfway through. One
> document gets one bibliography.

## Where the sources live: YAML or BibTeX

Typst reads two source formats, and it doesn't care which you pick.

The first is the Hayagriva `.yml` you just saw — Typst's own format, designed
for it, and generally the cleaner of the two to write by hand. Each entry is a
`type`, a `title`, an `author` (or a list of them, `["Deci, Edward L.", "Ryan,
Richard M."]`), a `date`, and whatever else the work needs. A journal article
nests its journal under `parent`; a book names a `publisher`. The full field
list lives in Hayagriva's documentation, but you can get a long way by copying
an entry that resembles what you have and changing the words.

The second is BibTeX's `.bib` — the format LaTeX has used for decades. If you've
ever written a paper in LaTeX, you have `.bib` files already, probably exported
straight from Zotero or Mendeley. The same two sources look like this
(`examples/064-bibtex-source/`):

```bib
@book{mcluhan1964,
  title     = {Understanding media: The extensions of man},
  author    = {McLuhan, Marshall},
  year      = {1964},
  publisher = {McGraw-Hill},
  address   = {New York},
}

@article{sweller1988,
  title   = {Cognitive load during problem solving: Effects on learning},
  author  = {Sweller, John},
  year    = {1988},
  journal = {Cognitive Science},
  volume  = {12},
  number  = {2},
  pages   = {257--285},
  doi     = {10.1207/s15516709cog1202_4},
}
```

To use it, you point `#bibliography` at the `.bib` instead of the `.yml`.
Nothing else changes — the `@key` and `#cite` syntax is identical:

```typ
#bibliography("refs.bib", style: "apa")
```

Which should you use? If you already have `.bib` files, use them; there's no
reason to convert. If you're starting fresh, the YAML tends to be less fiddly to
edit by hand. Either way the output is the same, because Typst normalizes both
into the same internal shape before it formats anything.

> **Coming from LaTeX.** No `bibtex` or `biber` run. No `.aux` or `.bbl` files
> to shuffle, no "compile, run bibtex, compile twice more" ritual to get the
> numbers to settle. `#bibliography(...)` resolves in the single compile pass
> that produces your PDF, every time. And the `.bib` files you already own work
> as they are — you point at them and go.

> [!WARNING]
> One YAML trap bites everyone once. A colon has special meaning in YAML, so a
> title with a colon in it — and academic titles love a colon — must be
> **quoted**: `title: "Cognitive load: Effects on learning"`. Leave the quotes
> off and Typst stops with a "failed to parse YAML" error pointing at the colon.
> When in doubt, quote the title. It never hurts.

## Getting APA right

APA is the worked example of this chapter, because it's what most social-science
and education writers need and because its rules are just intricate enough to be
worth having automated. You ask for it with `style: "apa"` — the short name
works, and so does the full `"american-psychological-association"` if you enjoy
typing. Everything below is one file, `examples/062-apa-reference-list/`.

Give it a spread of source types — a book, journal articles with one, two, and
three authors, and a web page — and cite them in a mix of prose and parentheses:

```typ
#cite(<sweller1988>, form: "prose") showed that instruction which
overloads working memory hurts learning rather than helping it. Feedback
is one of the strongest levers a teacher has, but only when it lands on a
manageable load @hattie2007. Motivation matters too: learners persist
when the work meets their needs for competence and autonomy @deci2000.

#bibliography("refs.yml", title: [References], style: "apa")
```

APA's in-text rules come out of that exactly as the manual prescribes:

- `#cite(<sweller1988>, form: "prose")` puts the name in the sentence and the
  year in parentheses: "Sweller (1988) showed…". More on `form` in a moment.
- `@hattie2007` — a source with three authors — collapses to "(Hattie et al.,
  2007)". APA abbreviates three-or-more-author works to the first author plus
  *et al.* on every in-text mention, and Typst knows the rule.
- `@deci2000` — two authors — keeps both, joined with an ampersand inside the
  parentheses: "(Deci & Ryan, 2000)".

The reference list obeys the same manual. It's alphabetized by first author,
each entry hangs with the second line indented, journal titles and volume
numbers are italic, and DOIs render as full `https://doi.org/…` links, all of
which is current APA 7th edition:

```text
References

Deci, E. L., & Ryan, R. M. (2000). The "what" and "why" of goal
    pursuits: Human needs and the self-determination of behavior.
    Psychological Inquiry, 11(4), 227–268.
    https://doi.org/10.1207/S15327965PLI1104_01

Hattie, J., Timperley, H., & Clarke, S. (2007). The power of feedback.
    Review of Educational Research, 77(1), 81–112.
    https://doi.org/10.3102/003465430298487
```

Notice the heading says `References`, not `Bibliography`. That's the one place
APA and Typst's default disagree: Typst titles the list "Bibliography" out of
the box, and APA wants "References". The fix is the `title:` argument you saw
above — `title: [References]` — and it takes any content you like, so
`title: [Works cited]` or a differently styled heading is a keystroke away.
Pass `title: none` to drop the heading entirely (handy when your template
supplies its own).

> [!TIP]
> APA expects article titles in *sentence case* — only the first word (and the
> word after a colon, and proper nouns) capitalized. Hayagriva prints your title
> as you store it, so store it in sentence case. The same goes for a `.bib`
> file: write the title in the case you want to see. Typst won't second-guess
> your capitalization, which is a feature the day you cite a work with an
> unusual name in it.

## The many shapes of a citation

A citation isn't one thing. Sometimes the author's name belongs in your
sentence ("Sweller (1988) argued…"), sometimes the whole reference belongs in
parentheses at the end. Sometimes you want only the year, because you just named
the author yourself. Typst calls these *forms*, and you select one with the
`form` argument to `#cite`. Example `examples/063-citation-forms/` lays them all
out side by side.

```typ
The load matters @sweller1988.
#cite(<sweller1988>, form: "prose") made the case directly.
The framework is due to #cite(<deci2000>, form: "author").
It was published in #cite(<deci2000>, form: "year").
```

Under APA, those produce, in order:

```text
The load matters (Sweller, 1988).
Sweller (1988) made the case directly.
The framework is due to Deci & Ryan.
It was published in 2000.
```

The plain `@sweller1988` is the *normal* form — the parenthetical citation, and
the one you'll use most. `form: "prose"` weaves the name into the sentence with
the year trailing in parentheses. `form: "author"` and `form: "year"` give you
just that one piece, for when you're building the citation into your own prose
by hand. (There's a fifth, `form: "full"`, that drops a whole bibliography-style
entry inline; you'll rarely reach for it.)

`@sweller1988` and `#cite(<sweller1988>)` are the same thing — the `@` form is
just shorthand for the function with the normal form. Reach for the full
`#cite(...)` when you need to pass an argument, like `form` or the page number
we're about to add.

### Pointing at a page

Cite a specific passage and you need a locator — "p. 262", "pp. 230–231". Typst
calls this a *supplement*, and there are two ways to attach one.

In the `@` shorthand, put the locator in square brackets right after the key:

```typ
One clear statement is on @sweller1988[p.~262].
```

That renders "…on (Sweller, 1988, p. 262)". The `~` is a non-breaking space (it
keeps "p." glued to "262" across a line break, a small courtesy from Chapter 3).
With the function form, the same thing goes in the `supplement` argument:

```typ
#cite(<deci2000>, supplement: [pp.~230--231]) narrows it further.
```

giving "(Deci & Ryan, 2000, pp. 230–231)". The `--` becomes an en dash, the
correct connector for a page range. Use whichever form is handier: brackets when
you're writing `@key` inline, `supplement:` when you're already inside a
`#cite(...)` for its `form`.

## Only what you cite

By default, the reference list contains exactly the works you cited and nothing
else. Add a source to your `.yml` but never cite it, and it stays out of the
list — which is what you want, most of the time, and matches what APA asks for.

Now and then you want the opposite: a complete list of everything in the file, a
"further reading" section or an annotated bibliography where nothing is cited in
the text at all. Pass `full: true`:

```typ
#bibliography("refs.yml", title: [Further reading], full: true, style: "apa")
```

and every entry in the file appears, cited or not.

## Choosing a style

The `style` argument is the whole personality of your citations. Feed it the
name of a built-in style and Typst reformats every citation and the entire list
to match — no other edits. The names are short strings:

- `"apa"` — American Psychological Association, author–date. Our worked example.
- `"ieee"` — numbered `[1]`, `[2]`; the engineering default (and Typst's default
  if you name no style at all).
- `"chicago-author-date"` — Chicago's author–date variant.
- `"mla"` — Modern Language Association, common in the humanities.
- `"vancouver"` — numbered, common in medicine.

That's a handful of the ninety-odd styles Typst ships. To feel the switch, take
one source file and render it two ways (`examples/065-switching-styles/`). With
`style: "apa"` a citation reads "(Sweller, 1988)" and the list is alphabetical.
Change that single string to `style: "ieee"` and the *same document* turns into
"[1]", "[2]" with a numbered list, authors initials-first, titles in quotes —
the full IEEE look, from one edited word. Nothing else in the file moves.

Need a style that isn't built in — a specific journal's house format, say?
Instead of a name, hand `style` a path to a `.csl` file, one of the thousands of
Citation Style Language definitions the academic world already maintains:

```typ
#bibliography("refs.yml", style: "chem-journal.csl")
```

Typst speaks CSL natively, so if your journal publishes a `.csl` (most do), you
drop it next to your document and point at it.

> [!NOTE]
> Style names occasionally get renamed between Typst versions. If you compile
> and see a *deprecation warning* naming a replacement — for instance,
> `"council-of-science-editors"` was superseded by a longer, version-specific
> name — the message tells you exactly what to switch to. Take its advice; the
> old name may vanish in a later release.

## What you've got

You can now handle sources the way a serious document needs:

- **A sources file** in either format — Hayagriva `.yml` (Typst's own) or
  BibTeX `.bib` (LaTeX's) — each source a keyed entry with a `type`, `title`,
  `author`, and `date`.
- **Citing by key** — `@key` in prose for the natural case, `#cite(<key>)` when
  you need arguments. Both resolve against the bibliography you render with
  `#bibliography("refs.yml", style: "apa")`.
- **APA, correctly** — author–date in-text, *et al.* for three-plus authors, an
  alphabetized hanging-indent reference list, retitled to "References" with
  `title:`.
- **Citation forms** — parenthetical (the default), `form: "prose"`, and the
  `"author"` / `"year"` pieces for hand-built citations.
- **Page locators** — `@key[p.~5]` in brackets or `supplement: [p.~5]` in the
  function.
- **Scope control** — cited works only by default, or `full: true` for the whole
  file.
- **Restyling in one word** — any built-in name (`"apa"`, `"ieee"`,
  `"chicago-author-date"`, `"mla"`, `"vancouver"`, …) or a path to a `.csl`
  file, applied to citations and list alike with no other edits.

That covers the citation needs of an essay, a thesis, or a journal submission.
The reference documentation for `bibliography` and `cite` lists every argument
and every built-in style; now that you know the shape of the system, it reads
like a menu.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

12.1. Create a `refs.yml` with two sources of your choice — a book and a journal
article. Write a short paragraph that cites each with `@key`, end it with
`#bibliography("refs.yml", style: "apa")`, and compile. Confirm the in-text
citations read "(Author, Year)" and the reference list is alphabetized.

12.2. Take the same document and change the bibliography's title to "References"
so it matches APA. Then compile it again with `style: "ieee"` instead of
`"apa"`, without touching anything else, and describe in one sentence what
changed in both the in-text citations and the list.

12.3. Add a third source with *three* authors to your `refs.yml` and cite it
with `@key` under `style: "apa"`. Confirm the in-text citation abbreviates to
"(FirstAuthor et al., Year)" while the reference list still names all three.

12.4. Cite one of your sources in prose (name in the sentence) using
`#cite(<key>, form: "prose")`, and cite another with a specific page using the
bracket locator `@key[p.~10]`. Compile and check that the first reads "Author
(Year)…" and the second ends "…(Author, Year, p. 10)".

12.5. *(Stretch.)* Export a `.bib` file from a reference manager (or write one
by hand) with at least three real sources, including one web page. Render it
with `style: "apa"` and again with `full: true` so uncited entries appear. Find
a `.csl` file for a journal you care about and render the same sources through
it. Note anything the CSL style does that the built-in APA style does not.

<!-- SOLUTIONS
12.1 - Any refs.yml with a book (type: book, publisher) and an article (type:
       article, parent periodical, page-range) works. Key check: @key produces
       "(Author, Year)" parenthetical under APA, and the list is sorted by first
       author's surname with hanging indent. Common mistake: forgetting to quote
       a title containing a colon (YAML parse error). Minimal like
       examples/061-first-citation/.
12.2 - title: [References] changes the heading (default was "Bibliography").
       Switching style: "apa" -> "ieee": in-text citations change from
       "(Author, Year)" to numbered "[1]"; the reference list becomes numbered
       (order of first citation, not alphabetical), authors initials-first,
       titles in quotes. Only the one string changed. See
       examples/065-switching-styles/.
12.3 - Add e.g. hattie2007 with author: ["Hattie, John", "Timperley, Helen",
       "Clarke, Shirley"]. In-text APA gives "(Hattie et al., 2007)"; the list
       entry spells out "Hattie, J., Timperley, H., & Clarke, S. (2007).".
       Demonstrates APA's 3+-author et al. rule, handled automatically. See
       examples/062-apa-reference-list/.
12.4 - Prose: #cite(<key>, form: "prose") -> "Author (Year)". Locator:
       @key[p.~10] -> "(Author, Year, p. 10)". The ~ is a non-breaking space;
       accept a plain space too. supplement: [p.~10] on the function form is an
       equivalent answer. See examples/063-citation-forms/.
12.5 - Open-ended. A valid .bib with book/article/web (type via @book/@article/
       @misc or @online) compiled with style: "apa" is the core. full: true
       makes uncited entries show. Any real .csl file pointed at via a path
       string should compile (Typst speaks CSL). Credit for noticing a concrete
       difference the journal's CSL makes (e.g., abbreviated journal names,
       different author separators, no DOI). Point: .bib compatibility + CSL
       extensibility + full: true, all verified by compiling. If they hit the
       "council-of-science-editors" deprecation warning, the fix is to use the
       replacement name the warning prints.
-->
