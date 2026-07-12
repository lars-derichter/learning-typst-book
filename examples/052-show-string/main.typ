// A string-selector show rule replaces a literal word everywhere it appears.
// Here "TODO" turns into a bold red marker, and every mention of the product
// name is set in small capitals. See Chapter 10, "Show rules".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#show "TODO": text(fill: red, weight: "bold")[TODO]
#show "Acme": smallcaps[Acme]

The Acme report is nearly done. TODO: add the Q3 figures. The Acme board
meets Friday, so TODO: send the draft before then.
