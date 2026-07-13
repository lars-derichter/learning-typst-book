# Packages

You need a diagram. Not a photograph of one — a real, sharp, editable diagram:
a couple of boxes, an arrow, a label or two. You could build it out of Typst's
`line` and `rect` primitives and a lot of patience, nudging coordinates until it
looks right. Or you could type one line at the top of your file and borrow a
drawing library that someone spent two years perfecting.

That someone is a stranger on the internet, and their work is one import away.

In [Chapter 18](18-your-own-functions.md) you learned to pull a function out of
your own file with `#import "helpers.typ": callout`. In
[Chapter 19](19-templates.md) you wrapped a whole look into a template. This
chapter is the same `#import`, reaching further: past your own
folder, past your own machine, all the way to a community registry of ready-made
Typst code. You'll learn to use packages, and — because your templates from the
last chapter deserve an audience — to publish your own.

## Typst Universe

The registry is called **Typst Universe**, and it lives at
[typst.app/universe](https://typst.app/universe). It's a searchable catalogue of
community packages: drawing kits, table helpers, unit typesetters, slide
systems, whole document templates. Everything there is open source, and pulling
one in takes a single line.

That line names three things — a *namespace*, a *name*, and a *version*:

```typ
#import "@preview/cetz:0.3.4": *
```

The `@preview` namespace is the public registry: every package on Universe lives
there. (There's a second namespace, `@local`, for packages you keep privately on
your own machine — handy for testing, and we'll get to it.) After the namespace
comes the package's name, `cetz`, and after the colon its version, `0.3.4`.

That version is not optional. Leave it off and Typst refuses to compile: it will
not guess which release you meant. This feels pedantic for about a day and then
you're grateful for it — more on why in a moment.

The first time you compile a file with that import, Typst reaches out to the
network, downloads the package, and tucks it into a cache in your user
directory. Every compile after that reads from the cache. So you pay the network
cost once, per package, per version; from then on the package is *yours*,
offline, as fast as any local file. Get on a plane right after the first build
and everything still works.

> [!NOTE]
> The cache lives in a system-dependent spot — on macOS it's
> `~/Library/Caches/typst/packages/`, on Linux `~/.cache/typst/packages/`. You
> rarely need to look, but if you ever want to force a fresh download, that's
> the folder to clear.

### A package in action

CeTZ (a pun on the German pronunciation of "TikZ", LaTeX's famous drawing
package) is a library for drawing with coordinates instead of a mouse. Here's
the whole of `examples/104-using-a-package/`:

```typ
#import "@preview/cetz:0.3.4"
#set page(width: 7cm, height: auto, margin: 0.8cm)

= A figure, drawn in code

#align(center, cetz.canvas({
  import cetz.draw: *
  line((0, 0), (3, 0), (3, 2), close: true)
  rect((2.6, 0), (3, 0.4), stroke: 0.5pt)
  content((1.5, -0.35), $a$)
  content((3.4, 1), $b$)
  content((1.2, 1.25), $c$)
}))
```

The import brings in the `cetz` module; `cetz.canvas` opens a drawing surface,
and inside it `line`, `rect`, and `content` place a labelled right triangle by
coordinate. The result is a crisp little figure that stays sharp at any zoom,
because every stroke is an instruction rather than a pixel. You didn't write the
drawing engine. You just described the triangle.

> [!IMPORTANT]
> Because this example downloads a package, it needs the network the first time
> you compile it. In this book's repository it carries a `.skip-build` marker so
> the offline build script leaves it alone — but on your own machine, connected,
> `typst compile main.typ out.pdf` works exactly as advertised.

## Why the version is pinned

Now, that pedantic required version. Here's the reason, in the form of a package
that will not compile.

`codly` is a popular package for prettifying code listings. Ask for an old
release under today's Typst and watch:

```typ
#import "@preview/codly:1.2.0": *
```

```text
error: unknown variable: pattern
   ┌─ @preview/codly:1.2.0/src/args.typ:10:29
```

Nothing is wrong with your document. The package itself uses a feature —
`pattern` — that a later Typst version renamed. The code that was correct when
`codly 1.2.0` shipped is now, against a newer compiler, broken. This is not
codly's fault or Typst's; it's simply what happens when a living language and a
living package drift out of step.

Package versions follow **semantic versioning** — that `major.minor.patch`
triple, like `0.3.4`. The convention is a promise about compatibility: a bump in
the last number (`0.3.4` → `0.3.5`) is a fix that shouldn't change how things
behave; the middle number adds features; the first number is reserved for
changes that *break* existing code. (Packages still at major version zero, like
`cetz 0.3.4`, are declaring themselves pre-1.0, where even minor bumps may
break. Most of Universe still lives here — the ecosystem is young.)

Pinning the version is how you opt out of surprise. Your document says "build me
with exactly `cetz 0.3.4`", and it means it, forever. A newer, subtly different
release can appear on Universe next week and your file won't notice or care.
Come back in two years and it still compiles the same way — the pinned version
is cached, frozen, exactly the code you tested against.

> [!WARNING]
> The flip side: a package pinned to an old version can fall behind the Typst
> compiler itself, exactly as `codly 1.2.0` did. If an import suddenly errors
> after you upgrade Typst, check Universe for a newer release of the package and
> bump your pin to match. A well-behaved package can also declare the minimum
> Typst version it needs (a `compiler` field in its manifest), so you get a
> clear message instead of a cryptic one.

## A short tour of Universe

Universe is large and uneven — some packages are polished and maintained, others
are a weekend experiment someone never came back to. Rather than a catalogue,
here is an honest map of the neighbourhoods worth knowing, by what you'd reach
for them to do. Names, not endorsements; check the version compatibility and the
last-updated date before you commit.

- **Drawing and diagrams.** *cetz* for general vector drawing by coordinate;
  *fletcher* (built on cetz) for node-and-arrow diagrams — flowcharts,
  commutative diagrams, state machines.
- **Tables.** Typst's native tables (Chapter 7) already go far, but *tablem*
  lets you write tables in a Markdown-like shorthand, and *tablex* predates some
  native features if you meet it in older documents.
- **Code listings.** *codly* and *zebraw* both turn fenced code blocks into
  properly styled listings with line numbers and highlighting.
- **Units and science.** *unify* typesets numbers and physical units correctly
  (`#qty("299792458", "m/s")`); *physica* gives you compact operators for
  calculus and vectors, which we'll use in a moment.
- **Glossaries.** *glossarium* manages a glossary and acronym list, expanding
  each term on first use — the sort of bookkeeping you never want to do by hand.
- **Running headers.** *hydra* puts the current section's title in the page
  header automatically, tracking where you are in the document.
- **Slides.** *polylux* and *touying* turn Typst into a presentation tool, with
  slides, overlays, and speaker notes. Yes, you can replace PowerPoint with a
  text file.

For one worked example, take *physica*. It exists because physicists and
engineers write the same operators constantly and would rather not spell each
one out. Here's `examples/105-a-useful-package/`:

```typ
#import "@preview/physica:0.9.4": *

The gradient of a scalar field $phi$:
$ grad phi = pdv(phi, x) vu(x) + pdv(phi, y) vu(y) + pdv(phi, z) vu(z) $

$ dv(f, t) quad div vb(E) = rho / epsilon_0 $
```

`grad` is the gradient, `pdv(phi, x)` a partial derivative, `dv` a total
derivative, `div` a divergence, `vu(x)` a unit vector, `vb(E)` a bold vector.
Six short names for notation that would otherwise be a fiddly pile of subscripts
and `upright`s. The package did the fiddling once so you don't repeat it.

> [!TIP]
> Both packages in this chapter — `cetz:0.3.4` and `physica:0.9.4` — are
> verified to compile cleanly with Typst 0.15.0. When you go shopping on
> Universe yourself, the surest test is the one you already know: pin a version,
> import it, and compile a two-line document. If it builds clean, it's good.

## Starting from a template package

Chapter 19 taught you to build a template — a function that wraps a document in
a consistent look. Templates travel on Universe too, and they get a special
convenience: you can start a brand-new project *from* one.

```sh
typst init @preview/charged-ieee
```

That command downloads the `charged-ieee` template package and scaffolds a fresh
project from it — a starter `main.typ` already wired to the template, ready for
you to fill in your title and start typing. It's the fastest possible way from
"I want an IEEE-style paper" to a blank page that already looks like one. (As
with `#import`, you can pin a version by appending `:0.1.0`; unlike `#import`,
`typst init` will happily default to the latest release if you don't.)

The web app has the same thing behind its "Start from template" button. Either
way, the template author did the layout; you do the writing.

## Publishing your own package

So how does a package get onto Universe in the first place? The surprise is how
little there is to it. A package is an ordinary `.typ` file with one extra thing
beside it: a manifest.

The manifest is a file named `typst.toml`, and here's a complete, minimal one
(from `examples/106-publishing-a-package/`):

```toml
[package]
name = "callout-box"
version = "0.1.0"
entrypoint = "lib.typ"
authors = ["Your Name <you@example.com>"]
license = "MIT"
description = "A tiny titled callout box."
```

Six fields. The `name` and `version` are how the world will refer to your
package; `entrypoint` names the `.typ` file Typst loads when someone imports it.
The other three — `authors`, `license`, `description` — are required for
publishing, not for the package to work locally. The `license` must be a valid
SPDX identifier (`MIT`, `Apache-2.0`, `MIT-0`, and so on): Universe only accepts
licenses that let people actually use what you shared.

The entrypoint is just code you've already written. Ours, `lib.typ`, exports one
function:

```typ
#let callout(title: none, body) = block(
  fill: luma(240),
  stroke: (left: 2pt + rgb("#3b6ea5")),
  inset: 10pt, radius: 2pt, width: 100%,
  {
    if title != none [ #strong(title) \ ]
    body
  },
)
```

### Test it before you ship it

Before submitting anything, you want to *use* your package and confirm it works.
You don't need to publish for that — you can import the entrypoint by a plain
relative path, exactly the trick from Chapter 18:

```typ
#import "lib.typ": callout

#callout(title: "Before you publish")[
  Publish these two files and this import line becomes
  `#import "@preview/callout-box:0.1.0": callout`.
]
```

That's the entire local smoke test in `examples/106-publishing-a-package/`: a
manifest, an entrypoint, and a `main.typ` that imports it by path. When you're
ready to test it the way a *user* would — via the `@preview`-style machinery —
copy the package into the `@local` namespace's folder on your machine and import
it as `@local/callout-box:0.1.0`. Same mechanism as `@preview`, no network, no
publishing.

### Getting onto Universe

The registry is a single public GitHub repository:
[github.com/typst/packages](https://github.com/typst/packages). Publishing is a
**pull request** to it. You add your package's files under a path that encodes
its name and version —

```text
packages/preview/callout-box/0.1.0/
```

— containing your `typst.toml`, your entrypoint, and any supporting files. Open
the PR, a maintainer reviews it (there's an automated check plus a human
skim for sanity), and once merged, `@preview/callout-box:0.1.0` is live for
everyone. Publishing a version is permanent: you never overwrite `0.1.0`, you
release `0.1.1` next to it. That permanence is the whole reason your pinned
imports keep working.

### Template packages

A template package is the same idea with one extra section in the manifest. Our
`examples/107-template-package/` ships a `report` function of the Chapter 19
shape, plus a `[template]` block:

```toml
[package]
name = "tidy-report"
version = "0.1.0"
entrypoint = "lib.typ"
authors = ["Your Name <you@example.com>"]
license = "MIT-0"
description = "A minimal, no-fuss report template."

[template]
path = "template"        # folder copied into the new project
entrypoint = "main.typ"  # file the user starts editing
thumbnail = "thumbnail.png"
```

The `[template]` section is exactly what makes `typst init @preview/tidy-report`
work. `path` is a folder of starter files that get copied into the user's new
project; `entrypoint` is the file they open first; `thumbnail` is the preview
image shown on Universe. The starter's own `main.typ` imports the published
package by name (`#import "@preview/tidy-report:0.1.0": report`) — because once
it's copied into someone else's project, your `lib.typ` isn't next door anymore;
it's in the registry. That one-line difference between the local test and the
shipped starter is the whole trick, and both files sit side by side in the
example folder so you can compare them.

> **Coming from LaTeX.** Universe is Typst's CTAN, and `#import "@preview/…"` is
> its `\usepackage` — but with two differences you'll feel immediately. First,
> the version is pinned *per project*, right there in your source, instead of
> whatever TeX Live installed system-wide; two documents on your disk can use
> two different versions of the same package without a fight. Second, there's no
> `tlmgr`, no multi-gigabyte distribution to update, no "package not found"
> after a fresh install. The first compile fetches exactly what this document
> needs and caches it. Nothing else, nowhere else.

## What you've got

You can now:

- **Pull in community packages** from Typst Universe with
  `#import "@preview/name:version"`, remembering the version is required and
  that the first compile downloads, then caches for offline use.
- **Read a version number** as a compatibility promise, and understand why
  pinning protects your document from both the package's future and the
  compiler's.
- **Diagnose a broken import** — an old package on a new Typst — and know to
  check Universe for a newer release.
- **Scaffold a project from a template package** with `typst init @preview/…`.
- **Assemble your own package**: a `typst.toml` manifest, an entrypoint, a local
  relative-import test, and the shape of a pull request to `typst/packages`.
- **Turn a Chapter 19 template into a package** by adding a `[template]` section
  to the manifest.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

20.1. Add `#import "@preview/cetz:0.3.4": *` to a fresh document and, inside a
`cetz.canvas`, draw a single circle with `circle((0, 0), radius: 1)`. Compile it
(you'll need the network the first time). Then compile it again with the network
off — confirm the second build is fast and offline.

20.2. Take the import from 20.1 and delete the `:0.3.4`, leaving
`#import "@preview/cetz": *`. Compile. Read the error. In one sentence, say why
Typst refuses rather than fetching the newest cetz for you.

20.3. Browse [typst.app/universe](https://typst.app/universe) for three minutes.
Find one package that would help with a document *you* actually write, note its
name and current version, and write the exact one-line import you'd use.

20.4. Write a `typst.toml` for a package called `my-notes` at version `0.2.0`,
with entrypoint `lib.typ`, yourself as author, an SPDX license of your choice,
and a one-line description. Put a trivial exported function in `lib.typ` and a
`main.typ` that imports it by relative path and uses it. Confirm the whole thing
compiles with no network.

20.5. *(Stretch.)* Take the template you built for the Chapter 19 exercises and
turn it into a template package: give it a `typst.toml` with a `[template]`
section, a `template/` folder containing a starter `main.typ` that imports your
template by its (hypothetical) `@preview` name, and a local `main.typ` that
imports the entrypoint by relative path to prove the wrapper works. You don't
have to publish it — just build the folder that *could* be published, and make
the local test compile.

<!--
SOLUTIONS (notes for the appendix author):

20.1 - Document:
         #import "@preview/cetz:0.3.4": *
         #cetz.canvas({ import cetz.draw: *; circle((0, 0), radius: 1) })
       Wait — with `: *` the canvas/draw names are already in scope, so it's
       #canvas({ import draw: *; circle((0,0), radius: 1) }) OR keep the module
       form `#import "@preview/cetz:0.3.4"` and call `cetz.canvas`. Either is
       fine; the point is that the FIRST compile hits the network and the second
       (e.g. run with no connection) reads from the cache and is fast. Teaches
       download-once-then-offline.

20.2 - Error is roughly: `error: version required for package import` / Typst
       reports it needs a version. Reason: a bare name is ambiguous and would
       make builds non-reproducible — the "newest" package could change under
       you and silently break the document. Pinning guarantees the same build
       forever. (Contrast with `typst init`, which DOES default to latest,
       because scaffolding a new project once is a different situation from
       reproducibly compiling an existing one.)

20.3 - No single right answer; credit for naming a real package, its current
       version, and a well-formed import line `#import "@preview/NAME:VER"`.
       Good moment to reinforce reading the version off the Universe page.

20.4 - typst.toml:
         [package]
         name = "my-notes"
         version = "0.2.0"
         entrypoint = "lib.typ"
         authors = ["..."]
         license = "MIT"     # or any valid SPDX id
         description = "..."
       lib.typ: e.g. #let hi(name) = [Hello, #name!]
       main.typ: #import "lib.typ": hi   then   #hi("world")
       Must compile offline because the relative import never touches the
       registry. This is exactly the 106 pattern.

20.5 - Mirrors example 107. Expected shape:
         typst.toml with [package] + [template] (path = "template",
           entrypoint = "main.typ", thumbnail = "thumbnail.png"),
         lib.typ exporting the Chapter 19 wrapper (show-rule function),
         template/main.typ  -> imports @preview/<name>:<ver> (illustration;
           won't compile without publishing),
         main.typ (root)    -> imports "lib.typ" by relative path, applies the
           wrapper; THIS is the one that must compile offline.
       Grade on: correct [template] fields, the relative-vs-@preview distinction
       between root main.typ and template/main.typ, and a clean local compile.
-->
