# Preface

There is a particular kind of misery known to anyone who has tried to make a
document look right. You have something to say — a report, a thesis, a set of
lecture notes, a recipe for your grandmother's stew — and somewhere between the
saying and the printing, the tools turn on you. A heading drifts onto its own
lonely page. An image lands three paragraphs from where you put it. You spend a
Sunday afternoon fighting a word processor for control of a single table, and
the table wins.

Typst is a quiet rebellion against that afternoon.

It is a *typesetting system*: software whose entire job is to take your content
and lay it out beautifully on a page. In that sense it shares a mission with
LaTeX, the system that has typeset most of the world's mathematics for forty
years. But where LaTeX arrived in the 1980s and shows it, Typst arrived in 2023
and feels like it. You write in a clean, readable markup — closer to Markdown
than to anything with a backslash — and Typst compiles it into a polished PDF in
milliseconds, telling you in plain language when something is wrong instead of
vomiting three hundred lines of cryptic warnings.

This book teaches you Typst from the first `= Hello` to writing your own
reusable packages. By the end you'll be able to typeset an essay, a scientific
paper with citations, a book, or a template you hand to two hundred students —
and you'll understand not just *which* buttons to press but *why* the system
works the way it does.

## Who this book is for

You, probably. Specifically:

- **People who write things that need to look good** — students, researchers,
  teachers, technical writers, self-publishers, hobbyists with a manuscript in a
  drawer.
- **Refugees from word processors** who are tired of documents that reflow into
  chaos the moment they add a sentence.
- **Refugees from LaTeX** who love the output but not the ceremony. (You'll feel
  at home fast. There are little "Coming from LaTeX" asides throughout to
  translate.)

You do **not** need to know LaTeX. You do **not** need to be a programmer. If
you can edit a plain-text file and you're not frightened of the occasional
curly brace, you have everything required. Typst does contain a genuine little
programming language — one of its best features — and Part IV teaches it from
absolute zero, assuming nothing.

What you do need is a habit of *trying things*. Typst compiles so fast that the
right way to learn it is to keep a document open, change something, and watch
what happens. This book is built for that habit. Read it near a keyboard.

## How to read this book

Front to back, if you can. The chapters build on each other, and later ones
assume the vocabulary of earlier ones. But the book is also organized so you can
raid it:

- **Part I** gets Typst installed and teaches you to write basic marked-up
  content — the stuff you type before you think about styling.
- **Part II** covers everyday documents: text, fonts, pages, figures, tables,
  and Typst's spectacular math support.
- **Part III** introduces *set* and *show* rules — the two ideas that turn Typst
  from a markup language into a styling engine — plus references and
  bibliographies.
- **Part IV** teaches the scripting language properly: values, functions, loops,
  and the genuinely tricky concept of *context*.
- **Part V** is about reuse: your own functions, templates, and packages.
- **Part VI** is the capstone. We build an O'Reilly-style book template in
  Typst, then wire up a pipeline that typesets *this very book* from its
  Markdown source. The book, in other words, learns to print itself.

If you're impatient and already technical, you could skim Part I, skip to the
part you need, and refer back. Nothing will break. If you're new to all of this,
resist the urge to skip — the early chapters plant seeds that later ones grow.

## Conventions used in this book

Throughout the book you'll see a few recurring signposts.

`Constant width` is used for anything you'd type or that Typst would show you —
function names like `image`, snippets of code, filenames like `main.typ`, and
terminal commands.

Longer code appears in blocks, labeled by language:

```typ
= A heading
Some *emphasized* text and a bit of #text(fill: blue)[colour].
```

```sh
typst compile main.typ out.pdf
```

Set off from the main text, you'll find boxes. They're the descendants of those
little animal icons in old O'Reilly books, and they mean:

> [!NOTE]
> A clarification or a useful fact worth pausing on.

> [!TIP]
> A shortcut or a nicer way to do what you just learned.

> [!IMPORTANT]
> Something you genuinely need to get right.

> [!WARNING]
> A common trap. People fall in here. Mind the gap.

And plain sidebars translate from other worlds:

> **Coming from LaTeX.** Where you would have written `\documentclass{article}`
> and a wall of preamble, Typst asks for nothing. A blank file is already a
> valid document.

## About the examples

Every example in this book is a real, runnable project, collected in the
[`examples/`](../examples/) folder of the book's repository. Each lives in its
own numbered directory with the source (`main.typ`), a short note on what it
shows, and a committed rendering so you can see the result without lifting a
finger.

They are not decorative. Every one of them compiles — cleanly, with no errors —
against **Typst 0.15.0**, and there's a script that rebuilds and checks all of
them at once. When the book claims a snippet produces a certain result, it does,
because a compiler was made to prove it before the page went to press. If you
find one that doesn't, that's a bug, and you should feel entitled to complain.

To run any example yourself:

```sh
cd examples/001-hello-typesetting
typst compile main.typ out.pdf
```

Then open `out.pdf`. That's the whole loop. You'll be doing it in your sleep by
Chapter 3.

## A note on how this book was made

Full disclosure, because you deserve it: this book was written with heavy
assistance from an AI system, working under human direction and — crucially —
under human quality control. Every chapter was reviewed. Every example was
compiled by a real Typst binary, not imagined. The goal was a book good enough
that its origins wouldn't matter; you'll have to judge whether that worked.

It's released under a Creative Commons license (BY-NC-SA 4.0) because the person
who commissioned it learns best from books like this one, noticed that no such
book existed for Typst yet, and figured that if it helped him, it might help you
too. Share it. Teach from it. Improve it. Just don't sell it, and pass along the
same freedoms you were given.

Now. Let's go find out why Typst is worth your afternoon — the good kind, this
time.
