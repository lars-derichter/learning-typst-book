// main.typ — apply a bundled look to the whole document with a single line.
// `#show: report` feeds everything below into the report function, so all its
// set and show rules take effect document-wide.
// Compile with:  typst compile main.typ out.pdf
#import "look.typ": report

#show: report

= Field notes

An entire look — page size, fonts, justified paragraphs, numbered and coloured
headings — arrives from one line, `#show: report`. Swap in a different look
function and the document reskins without touching a word of content.

== Method

#lorem(30)

== Result

#lorem(25)
