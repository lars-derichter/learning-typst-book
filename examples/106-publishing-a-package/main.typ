// main.typ — a document that USES the package through a RELATIVE import,
// exactly the way `@preview/...` will once it is published. This is how you
// smoke-test a package on your own machine before submitting it: no network,
// no cache, just the two files side by side.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 11cm, height: auto, margin: 1cm)
#set text(font: "Libertinus Serif", size: 11pt)

#import "lib.typ": callout

= A package, tested locally

#callout(title: "Before you publish")[
  This box is defined in `lib.typ`, the entrypoint declared in `typst.toml`.
  Publish the two files to Typst Universe and this import line becomes
  `#import "@preview/callout-box:0.1.0": callout` — nothing else changes.
]
