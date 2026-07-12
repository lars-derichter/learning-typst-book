// Strings are sequences of characters. Here: length, trim, split into an
// array, case conversion, slicing, searching, iteration, and a regex-powered
// replace (regex ties back to Chapter 10).
// See Chapter 16, "Arrays, dictionaries, and strings".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let raw-title = "  the-wind-up-bird  "

The string is #raw-title.len() characters long, padding and all.
Trimmed, it is "#raw-title.trim()".

// split turns a string into an array of pieces
#let words = raw-title.trim().split("-")
Split on "-": #words.join(" / ") --- that is #words.len() words.

// rebuild it in title case with slice() and upper()
#let title = words.map(w => upper(w.slice(0, 1)) + w.slice(1)).join(" ")
Title case: #title.

Case flips freely: #upper("quiet") and #lower("LOUD").
Contains "bird"? #raw-title.contains("bird").
`.find()` returns the matched text, not a position:
#repr(raw-title.find("wind")).

// regex replace collapses each run of spaces to a single space
#let spaced = "too    many     spaces"
Collapsed: #spaced.replace(regex(" +"), " ").

// a string is a sequence, so you can loop over its characters
#let shout = ()
#for c in "typst" { shout.push(upper(c)) }
Letter by letter: #shout.join("-").
