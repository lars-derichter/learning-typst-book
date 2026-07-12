# The initial prompt

This is the first thing Lars typed, reproduced verbatim. It's a good example of
a strong brief: it fixes the *genre* (an O'Reilly *Learning* book), the *quality
bar* (readable and funny but complete and thorough), and a handful of concrete
*structural constraints* (file naming, where examples go, the license), while
leaving the AI room to propose the actual shape of the book. Crucially, its last
two sentences set up the working relationship: ask questions first, then plan,
then run unsupervised.

Note the small inaccuracy in it — *Learning Perl* is the "llama" book by Randal
Schwartz and others; the "camel" is *Programming Perl* by Larry Wall et al. It's
reproduced here uncorrected, because this is a record of what was actually said,
and the intent (that lineage of warm, thorough O'Reilly teaching books) came
through perfectly regardless.

---

> I want you to write an ebook about the typst typesetting system. It should
> follow the style and conventions of a typical O'Reilly 'learning' book. (Like
> the original learning Perl book by Larry Wall, aka the Camel book, readable,
> even fun to read with some humor, but also very complete and thorough with a
> very high standard of quality).
>
> The README.md of this repository should contain the blurb and table of
> contents. Each chapter should get its own numbered (NN) filename.
>
> All files use github flavored markdown (you can use github style alerts for
> important stuff etc).
>
> Example code goes into the examples folder. Every example should get its own
> numbered (NN) subfolder.
>
> The book should become its own example. A main project or example in the book
> should be howto typeset the book itself using typst.
>
> All folder and filenames are kebab-case.
>
> The book is written in english.
>
> It should be like a real book, so it is perfectly okay that a printed version
> would contain 100+ pages.
>
> Add a CC4-BY-NC-SA LICENSE. So do not worry too much about licensing and
> copyright. I will never use this book for commercial purposes or try to make
> any money out of it. It is mainly for my personal use, because I like learning
> in this way and this type of book does not exist yet. On the other hand what
> helps me? Might help someone else as well, so why wouldn't I share this?
>
> Start by asking me any important questions that need answering before you can
> make a plan. Then make the plan. You should be able to run fully unsupervised
> after I have approved the plan.

---

## Why this brief worked

A few things in here did a lot of quiet work:

- **It named a genre with a known quality bar.** "An O'Reilly *Learning* book"
  carries an enormous amount of shared context — tone, structure, the presence
  of exercises, the little admonition boxes — that would have taken paragraphs
  to specify from scratch.
- **It set structural invariants up front.** Kebab-case names, `NN-` numbering,
  examples in their own folders, GitHub-flavored Markdown. These are cheap to
  state and expensive to retrofit, so stating them early paid off.
- **It gave the project a soul.** "The book should become its own example" — the
  idea that the book would learn to typeset itself — turned a competent tutorial
  into something with a spine and a destination.
- **It set the collaboration protocol.** "Ask questions first, then plan, then
  run unsupervised" is exactly the shape that lets an AI do a large job well:
  resolve ambiguity cheaply at the start, agree on a plan, then execute without
  a human in the loop for every paragraph.

The next file is what the AI did with that last instruction.
