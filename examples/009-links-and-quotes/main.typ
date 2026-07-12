// Links (bare and labeled) and automatic smart quotes.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Links and quotes

A bare URL becomes a link on its own: https://typst.app

For friendlier wording, give the link a label:
#link("https://typst.app/docs")[the official docs].

Straight quotes turn curly automatically, and Typst is
language-aware about it: "double quotes", 'single quotes',
and don't-panic apostrophes all come out right.
