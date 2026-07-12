// main.typ — the document. It pulls one function out of helpers.typ and uses
// it. The machinery lives next door; this file stays about content.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

// Bring in just the name we need, by name.
#import "helpers.typ": callout

= Release notes

#callout[
  The `callout` function isn't defined anywhere in this file — it was imported
  from `helpers.typ`, which sits right beside `main.typ`.
]

#callout(title: "Heads up", color: orange)[
  Change the box in one place and every document that imports it updates at
  once. That is the whole point of splitting code into its own file.
]
