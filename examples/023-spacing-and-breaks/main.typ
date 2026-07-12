// Manual spacing and breaks.
//   #v(length)            - vertical space between blocks
//   #h(length)            - horizontal space inline (1fr = stretch to fill)
//   #pagebreak()          - always start a new page
//   #pagebreak(weak: true)- start a new page UNLESS one just started
// Compile with:  typst compile main.typ out.pdf
#set page(width: 9cm, height: 12cm, margin: 1.2cm)

= Spacing by hand

First line. #v(1cm) A full centimetre of air sat above this one, added with
`#v(1cm)`.

Left #h(1fr) pushed apart by `#h(1fr)` #h(1fr) right.

#lorem(20)

#pagebreak(weak: true) // breaks here because page one still has content
= Forced onto page two

A hard `#pagebreak()` always breaks; the weak one above only breaks because
there was still content to push down. Weak breaks collapse when they would
otherwise leave an empty page.

#lorem(25)
