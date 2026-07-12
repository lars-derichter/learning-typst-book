#import "../template/admonitions.typ": *
#import "../template/index.typ": idx

= Installing the tools

Before you can typeset a single page you need the #idx("compiler") on your
machine. Typst ships as one self-contained binary: there are no
#idx("dependencies") to chase down and no runtime to install first. Download it,
put it on your path, and you are ready.

== From a package manager

The quickest route is whatever package manager you already use. On macOS with
Homebrew:

```sh
brew install typst
```

On Windows the equivalent is `winget install --id Typst.Typst`, and most Linux
distributions carry it too. Check the version once it lands:

```sh
typst --version
```

#note[
  You do not have to install anything at all to try Typst. The web app at
  `typst.app` runs the same compiler in your browser, with a live preview
  beside your source. Everything in this book works identically there.
]

== Compiling a document <sec:compiling>

A Typst project is just a folder of plain-text files. Point the
#idx("compiler") at the entry file and it writes a PDF next to it:

```sh
typst compile main.typ out.pdf
```

Add `--watch` instead of `compile` and it rebuilds every time you save, which
is the way you will actually work once a document gets long.

#tip[
  Keep the PDF open in a viewer that reloads on change. With `typst watch`
  running on one side and the PDF on the other, you get the same
  edit-and-see loop the web app gives you, without leaving your editor.
]
