# Appendix G · Where to go next

A book has to stop somewhere. Typst doesn't. While you were reading, someone
shipped a new package, someone else filed a bug that will be fixed by Friday,
and the compiler quietly gained a feature that isn't in these pages. That's not
a flaw in the book; it's the shape of a young, fast-moving tool. What follows is
a map to the living parts — where to look things up, where to ask, and where to
watch for what changed after this book went to press.

## The official documentation

Two doors, and you'll use both for different reasons.

The **Tutorial** — <https://typst.app/docs/tutorial> — is the gentle on-ramp:
four short lessons that build a document from nothing. If a friend asks you
"what's Typst?", this is the link to send. You've effectively already done it,
several times over, so treat it as a place to point other people.

The **Reference** — <https://typst.app/docs/reference> — is the one you'll keep
open forever. It's organized by category — text, layout, math, visualize, and so
on — rather than alphabetically, which sounds inconvenient until you realize it
matches how you actually think ("I want to do something with *tables*", not "I
want the function that starts with `t`"). Every function has its full parameter
list and a live, editable example. Once you know the *shapes* of Typst — that
styling is `set` and `show`, that layout is functions returning content — the
Reference is how you fill in the exact argument you half-remember. It is the
daily driver.

## The web app

<https://typst.app> is Typst in your browser: a free editor with live preview,
a gallery of templates to start from, and real-time collaboration if you're
writing with someone else. Nothing to install, nothing to configure. It's the
fastest way to try an idea, to share a document with a co-author who has never
heard of a command line, or to work from a machine that isn't yours. The same
compiler you've been running locally powers it, so a document behaves the same
in both places.

## Typst Universe

<https://typst.app/universe> is the package and template registry you met in
[Chapter 20](20-packages.md) — the searchable catalogue of community drawing
kits, table helpers,
slide systems, and ready-made document templates. When you catch yourself about
to build something fiddly from primitives, look here first; the odds are decent
that a stranger already built it and pinned a version for you.

## The community forum

<https://forum.typst.app> is the best place to ask a real question. It's an
official, searchable forum where questions get considered, worked answers rather
than a shrug — and because it's indexed, your question helps the next person who
searches the same problem. Before you post, search it: a good fraction of "how
do I…" questions have been answered thoughtfully already.

## GitHub: the source and the registry

Typst is open source, and two repositories are worth bookmarking.

The compiler lives at <https://github.com/typst/typst>. This is where you file a
bug, read the release notes, or check the changelog to see exactly what changed
between versions. If something in this book stops matching what your compiler
does, the changelog is the first place to look for why.

The registry lives at <https://github.com/typst/packages>. As Chapter 20
showed, publishing a package *is* a pull request to this repo. Even if you never
publish, it's useful to see how the registry is laid out and to browse what
others have shipped.

## Community chat

There's an official Discord for quick, conversational questions — the kind where
a forum post feels too heavy and you just want to ask someone. Rather than trust
an invite link that might have rotated by the time you read this, grab the
current one from the front page of <https://typst.app> or the README of the
compiler repo above; both link straight to it. The forum is better for anything
you'd want to find again; chat is better for "am I holding this wrong?"

## Curated lists

The community maintains an **awesome-typst** list at
<https://github.com/qjcg/awesome-typst> — a hand-curated collection of packages,
templates, tools, and articles, grouped by what they're for. It's a good way to
discover the corners of the ecosystem you wouldn't think to search for, and a
gentler survey than scrolling Universe package by package.

## Staying current

Typst is young and moves fast, and that cuts both ways: features land quickly,
but so do changes that can shift the ground under an old document. Two habits
keep you on solid ground.

Watch the releases and changelog on the compiler repo. When a new Typst comes
out, a two-minute skim of the changelog tells you whether anything you rely on
moved.

And remember the lesson from Chapter 20: **pin your package versions, and re-pin
when you upgrade the compiler.** A package frozen to an old version can fall
behind a newer Typst and start erroring; when it does, check Universe for a
fresh release and bump your pin. This book targets **Typst 0.15.0**. If you're
reading it against a later release, treat that as your homework: skim the
changelog for what's changed since, and expect a few details here to have been
smoothed over or renamed. The ideas hold; the odd argument name may not.

## How to ask a good question

Whether on the forum or in chat, the questions that get fast, useful answers all
look the same. Give three things:

- A **minimal reproducible example** — the fewest lines that compile *and* show
  the problem. Not your whole document; the smallest slice that still
  misbehaves. Half the time, building this example makes you find the answer
  yourself, which is a fine outcome too.
- Your **Typst version** (`typst --version`), since behaviour genuinely differs
  between releases.
- **What you expected versus what you got** — the actual error text, or a plain
  description of how the output was wrong.

That's it. A question with those three parts is a joy to answer; a screenshot of
a whole page with "it's broken" is not.

## Where to practice

The single fastest way to get fluent is to rebuild something you already have.
Take a document that exists — your CV, a report you wrote last month, a page of
lecture notes, the minutes of a meeting — and typeset it again in Typst. You
already know what the finished thing should look like, so all of your attention
goes to *how* Typst gets you there. You'll hit real questions instead of toy
ones, you'll reach for the Reference for real reasons, and by the end you'll
have both a document you can use and a working knowledge you didn't have that
morning. Do it two or three times and Typst stops being a thing you're learning
and starts being a thing you use.

## A last word

You started this book being promised that you didn't need to know LaTeX and you
didn't need to be a programmer, only that you could edit a plain-text file and
weren't frightened of a curly brace. That promise held. Along the way you picked
up a genuine little programming language, a styling engine built on two ideas,
and a compiler that talks back in plain sentences.

Look at what that adds up to. You can typeset a clean essay. You can write a
scientific paper with numbered figures, cross-references, and a bibliography
that formats itself. You can build a template and hand it to two hundred people.
You can, if you like, produce a book that typesets itself from its own source —
we did exactly that, and you watched it happen.

The afternoon that Typst was a quiet rebellion against, back in the preface —
the one where the table won — is yours again now. The tools have stopped
fighting you. What you make with the time is up to you, and there's no better
way to finish learning Typst than to close this book and go make something.
