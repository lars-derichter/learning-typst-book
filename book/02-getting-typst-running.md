# Getting Typst running

Installing a typesetting system has a reputation. If you have ever set up
LaTeX, you remember it: a download measured in gigabytes, an afternoon spent
feeding a package manager, and a folder somewhere on your disk you will never
fully understand.

Typst is one file. You run a single command, wait a second or two, and you have
a program that already knows how to typeset a book — fonts included. No folder
of mysteries. When a newer version lands, you replace the one file.

So this is a short chapter with a big payoff. By the end you'll have Typst on
your machine, you'll have compiled a document with your own hands, and — this is
the part that actually matters — you'll have set up the fast edit-and-preview
loop that turns learning Typst into something closer to play than study.

## Three ways to run Typst

There are three ways to put Typst to work, and they are not rivals. Most people
end up using two of them.

- **The web app** at [typst.app](https://typst.app). A free account gets you an
  in-browser editor with a live preview beside your text and real-time
  collaboration, a bit like Google Docs crossed with Overleaf. Nothing to
  install. It's the fastest way to try Typst, and a genuinely good place to
  write.
- **The command-line binary.** This is the `typst` program you run in a
  terminal, and it's the focus of this book. It compiles a source file into a
  PDF (or PNG, or SVG), it scripts and automates cleanly, and it's the same
  engine everything else is built on.
- **An editor with the Typst extension.** Your normal code editor — VS Code,
  Neovim, and others — can gain autocomplete, a preview pane, and live error
  underlines. This isn't really a fourth engine; it's the command-line world
  with a comfortable front end bolted on. We'll set it up near the end of the
  chapter.

If you just want to feel Typst move, open the web app right now and paste in the
six-line file from Chapter 1. The preview appears as you type. Come back when
you're ready to work locally — the rest of this book assumes the command line,
because that's what you'll build real projects and templates on.

## Installing the command-line binary

The commands below are the current, official ones. Pick your platform. Each one
downloads a single self-contained binary; there is no second step.

### macOS

If you have [Homebrew](https://brew.sh):

```sh
brew install typst
```

### Windows

With the built-in Windows package manager, `winget`:

```sh
winget install --id Typst.Typst
```

If you prefer [Scoop](https://scoop.sh) or [Chocolatey](https://chocolatey.org),
Typst is packaged for both (`scoop install typst`, `choco install typst`). Any
of them is fine; they all fetch the same binary.

### Linux

Typst is in a growing number of distribution repositories — search your package
manager for `typst`, or check [Repology](https://repology.org/project/typst) to
see what your distro ships. There's also a Snap
(`snap install typst`). Distro packages sometimes lag a version or two behind,
so if you need the newest release, grab the prebuilt binary straight from the
[GitHub releases page](https://github.com/typst/typst/releases): download the
archive for your architecture, unpack it, and put the `typst` file somewhere on
your `PATH` (such as `~/.local/bin`).

### The universal route: Rust's Cargo

If you have the Rust toolchain installed, one command works on every platform
and always builds the latest release:

```sh
cargo install --locked typst-cli
```

This compiles Typst from source, so it takes a few minutes and asks for nothing
but Rust. It's the reliable fallback when a package manager doesn't have what
you want.

### Confirm it worked

Whatever route you took, open a fresh terminal and ask Typst who it is:

```sh
typst --version
```

You should see something like:

```text
typst 0.15.0
```

This book is written and tested against **0.15.0**. A newer version will run
every example here just fine; if you're on something much older and a snippet
misbehaves, updating is the first thing to try.

> [!WARNING]
> If instead you get `command not found: typst` (or on Windows, `'typst' is not
> recognized…`), the install worked but your shell can't find the binary — it
> isn't on your `PATH`. Two fixes usually do it: open a brand-new terminal
> window (so it re-reads your configuration), and if you installed by hand, make
> sure the folder holding `typst` is actually listed in `PATH`. This is the
> single most common first-day snag, and it's never as broken as it looks.

> **Coming from LaTeX.** There is no TeX distribution to install here — no
> multi-gigabyte MacTeX or TeX Live, no `tlmgr`, no waiting for `latexmk` to
> settle. Typst is one binary that ships its own fonts and its own math engine.
> "Install" means "download a file," and "the fonts" means "they're already
> inside."

## Your first document

Time to make something. Create a folder, and in it a plain-text file called
`main.typ`. The name doesn't matter to Typst, but `main.typ` is the convention
this book (and most projects) uses for the entry point. Put a couple of lines in
it:

```typ
= My first Typst document

Hello. This paragraph is here so the page has something to typeset. Notice
that you did not choose a font, a size, or a margin — Typst picked sensible
defaults so you could get straight to writing.
```

That `=` at the start of the first line marks a heading, exactly as in Chapter
1. Everything else is just text. Now, from inside that folder, run:

```sh
typst compile main.typ out.pdf
```

Open `out.pdf`. There's your document: a bold heading over a justified,
properly typeset paragraph, on a clean page. You wrote structure; Typst supplied
the typography.

That single command is the whole idea, so let's name its parts. `main.typ` is
your **source** — the human-readable file you edit. `out.pdf` is the **output**
— the finished document Typst produced. **Compiling** is the act of turning one
into the other, and it's the verb you'll use a thousand times. The source is the
thing you keep and change; the output is disposable, regenerated on demand, and
usually not even worth saving in version control.

Notice that you never told Typst you wanted a PDF. It figured that out from the
`.pdf` on the output name. Typst infers the format from the extension, so
`out.png` would have given you an image and `out.svg` a vector graphic — more on
that shortly. The runnable version of this document is in
[`examples/03-first-document/`](../examples/03-first-document/).

> [!NOTE]
> The example file adds one line you didn't type: `#set page(width: 12cm,
> height: auto, margin: 1.5cm)`. That's only there to keep the rendered preview
> in this book small and tidy. Delete it and you get an ordinary A4 page.
> Anything starting with `#` is Typst code rather than content; we start
> pulling that thread properly in Chapter 3.

## The watch loop

Compiling by hand, once, is a fine way to see that Typst works. It is a
miserable way to actually write, because you'd be retyping that command after
every edit. Typst has a better mode, and building the habit of using it is
probably the most valuable thing in this chapter:

```sh
typst watch main.typ out.pdf
```

`watch` compiles once, then sits there watching the file. Every time you save
`main.typ`, it recompiles — automatically, in milliseconds. Your terminal turns
into a running log:

```text
watching main.typ
writing to out.pdf
[12:41:26] compiling ...
[12:41:26] compiled successfully in 14.28 ms
```

Save again and a new line appears. Make a mistake — a stray bracket, a
misspelled function — and instead of silence you get a clear error pointing at
the line, and the moment you fix it the next save goes green again. You leave
`watch` running in a corner while you work and forget it's there.

The trick that makes this sing is to pair `watch` with a PDF viewer that
notices when its file changes on disk and reloads on its own. Then your loop
becomes: edit, save, glance at the preview, edit again — no clicking, no
re-running anything. Good auto-reloading viewers include **Skim** on macOS,
**zathura** on Linux, and **SumatraPDF** on Windows. (The editor extension in
the next section gives you a preview pane that reloads too, which for many
people replaces the separate viewer entirely.)

> [!TIP]
> Some PDF viewers — Adobe Acrobat is the usual culprit — hold a lock on a file
> while it's open, and won't refresh it. If `watch` starts complaining that it
> can't write the output, or the PDF just never updates, that's almost always
> the viewer. Switch to one of the reloading viewers above and the problem
> evaporates.

## Editor setup: Tinymist

You can write Typst in any text editor. But the moment you install the Typst
extension for your editor, the experience changes character: you get
autocomplete for function names and their arguments, red underlines on errors
before you even save, a preview pane docked next to your text, and one-keystroke
formatting to tidy your source.

The extension to install is **Tinymist**. In VS Code, open the Extensions panel,
search for "Tinymist Typst," and click install — that's the whole setup. It's
the standard choice and the one the community has consolidated around.

Tinymist's real cleverness is that it's built on a *language server* — a
background program that understands Typst and speaks a protocol many editors
know how to talk to. So Tinymist isn't VS Code–only. Neovim, Emacs, Helix, Zed
and others can all connect to the same language server and get the same
autocomplete and error-checking. Whatever editor you already love, there's a
good chance it can speak Typst through Tinymist. If you take one recommendation
from this chapter, take this one: install it early, and let it teach you the
function names as you go.

## Output formats and handy flags

A PDF is the usual destination, but it isn't the only one. Because Typst infers
the format from the output extension, you can aim the same source at different
targets just by renaming the output — or by saying so explicitly with
`--format`. Using the small document in
[`examples/04-output-formats/`](../examples/04-output-formats/):

```sh
typst compile main.typ out.pdf
typst compile main.typ out.png
typst compile main.typ out.svg
```

PDF is your portable, printable default. PNG is a raster image — pixels — handy
for pasting a page into a slide or a web post. SVG is a vector image that stays
razor-sharp at any size, good for logos, diagrams, or anything you'll scale up.

PNG and SVG come with one wrinkle worth knowing before it surprises you: they
hold a single image, so Typst writes **one file per page**. For a one-page
document `out.png` is fine. For anything longer, you have to tell Typst where
the page number goes, using a `{p}` placeholder in the output name:

```sh
typst compile report.typ page-{p}.png
```

That produces `page-1.png`, `page-2.png`, and so on. (Leave the `{p}` out of a
multi-page export and Typst stops and tells you it's missing — a helpful error,
not a mysterious one.) A few more flags earn their keep:

- `--ppi <number>` sets the resolution of PNG export in pixels per inch. The
  default is 144, which is fine on screen; bump it to `--ppi 300` when you need
  print-quality pixels.
- `--open` opens the finished file in your default viewer the moment it's done,
  so `typst compile main.typ out.pdf --open` compiles and previews in one go.
- `--pages <range>` exports only the pages you ask for. `--pages 1` gives you
  just the first page; `--pages 2-4,6` gives pages 2 through 4 and page 6. Handy
  when a document is long and you only want to eyeball one part.

## Project structure and `--root`

A "project" in Typst sounds grander than it is. It's a folder with a `.typ` file
in it. As your document grows it gathers company — an image or two, maybe a data
file, perhaps a second `.typ` file you pull in — but it's still just a folder of
plain files, and you can zip it up and email it to a colleague and it will
compile on their machine exactly as it did on yours.

That portability depends on how paths work, which is where `--root` comes in.
When you refer to a file by an *absolute* path — one that starts with a `/`,
like `/images/logo.png` — Typst resolves it against the **project root**, not
against your whole hard drive. By default the root is the folder your main file
lives in. For safety, Typst refuses to read anything *outside* the root, so a
document can't quietly reach into the rest of your filesystem.

Sometimes you want the root to sit higher up — say your document lives in a
`chapters/` subfolder but shares an `images/` folder with its siblings. That's
what the `--root` flag is for: it points the root at a directory you choose.
This book's own examples are compiled from the repository root exactly this way:

```sh
typst compile --root . examples/05-document-metadata/main.typ out.pdf
```

The `--root .` says "treat the current directory as the project root," so
absolute paths inside the document resolve from there.

### Setting document metadata

While we're looking at real projects: a PDF carries hidden fields — a title, an
author — that don't print on the page but show up in a reader's "Document
Properties" panel and in the browser tab when someone opens the file online. You
set them with `#set document(...)`, as in
[`examples/05-document-metadata/`](../examples/05-document-metadata/):

```typ
#set document(
  title: "A Short Field Guide to Puddles",
  author: "R. Waterhouse",
)

= A short field guide to puddles
Some body text goes here.
```

The `title` and `author` never appear in the layout — they're metadata, written
into the PDF itself. It's a small, professional touch that costs one line, and
`#set` is a rule you'll meet properly in Chapter 9.

> [!TIP]
> You don't always have to start from a blank file. `typst init` scaffolds a
> whole project from a template — for instance,
> `typst init @preview/charged-ieee` pulls a template from Typst Universe, the
> package registry, and drops a ready-to-edit folder in front of you. We'll dig
> into packages and templates in Chapters 19 and 20; file the command away for
> now.

## What you've got

You went from an empty machine to a working Typst setup. Concretely, you can
now:

- **Install Typst** on macOS, Windows, or Linux, and confirm it with
  `typst --version` — and you know that "command not found" just means it isn't
  on your `PATH`.
- **Choose where to run it** — the browser for a quick try, the command line for
  real work, an editor with Tinymist for comfort.
- **Compile a document** with `typst compile main.typ out.pdf`, and explain what
  source, output, and compiling each mean.
- **Live-preview your work** with `typst watch` paired with an auto-reloading
  viewer — the loop you'll use for everything from here on.
- **Export to PDF, PNG, or SVG**, including multi-page images with a `{p}`
  template, and reach for `--ppi`, `--open`, and `--pages` when you need them.
- **Organize a project** as a folder of files, steer absolute paths with
  `--root`, and stamp a PDF with a title and author via `#set document(...)`.

The next chapter finally slows down on the thing you've been typing past —
the markup itself — and shows you how much of a document you can build with
nothing but plain text and a handful of symbols.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

2.1. Install Typst on your machine using the method for your platform, then run
`typst --version`. Write down what it prints. If you get "command not found,"
diagnose it before moving on — a fresh terminal window fixes most cases.

2.2. Compile [`examples/03-first-document/`](../examples/03-first-document/) to
a PDF and open it. Then change the heading text, save, and compile again.
Confirm the PDF updates. (You've now done by hand the loop that `watch`
automates.)

2.3. Run `typst watch main.typ out.pdf` on that same file with an auto-reloading
viewer open beside it. Edit a word, save, and watch the preview change without
you touching the terminal. Then type a deliberate error — delete the `]` from a
piece of code, say — and describe what the terminal shows you.

2.4. Take [`examples/04-output-formats/`](../examples/04-output-formats/) and
export it to PNG twice: once at the default resolution and once with
`--ppi 300`. Compare the two files' sizes and how sharp they look when you zoom
in. Which would you send to a printer, and which to a chat message?

2.5. *(Stretch.)* Start a project of your own: a folder with a `main.typ` that
uses `#set document(title: …, author: …)` and a heading of your choosing.
Compile it, open the PDF, and find your title and author in the viewer's
document-properties panel. Bonus: run the compile with `--open` so it previews
itself.

<!--
SOLUTIONS (notes for the appendix author):
2.1 - Any correct install command for the reader's OS (brew install typst;
      winget install --id Typst.Typst; distro package / GitHub binary; or
      cargo install --locked typst-cli). `typst --version` prints e.g.
      "typst 0.15.0". "command not found" = binary not on PATH: open a new
      terminal; ensure the install directory is on PATH.
2.2 - typst compile examples/03-first-document/main.typ out.pdf (or cd into the
      folder first). Editing the `= ` heading line and recompiling changes the
      PDF. Point: output is regenerated from source each compile.
2.3 - `compiling ...` then `compiled successfully in N ms` on each save. On a
      deliberate error (e.g. removing a closing `]`), watch prints an error with
      the file and line number and keeps watching; fixing it and saving returns
      to a successful compile. Reinforces the fast, forgiving feedback loop.
2.4 - typst compile examples/04-output-formats/main.typ out.png  (144 ppi
      default) vs  typst compile ... out.png --ppi 300. The 300-ppi file is
      larger and stays crisp when zoomed; 144 is lighter and fine on screen.
      Print -> 300; chat/web -> 144 (or lower). Good moment to note ppi = pixels
      per inch.
2.5 - Any folder with main.typ containing #set document(title: "...", author:
      "...") plus a heading. After compiling, the title/author appear in the PDF
      viewer's properties (and browser tab). `--open` compiles then opens the
      result. Foreshadows #set (Chapter 9).
-->
