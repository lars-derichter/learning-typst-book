// front/preface.typ — a short preface.
//
// Like the copyright page, its title is drawn by hand rather than as a `=`
// heading, so the chapter-opener show rule leaves it alone and it stays out of
// the chapter numbering. It starts on its own page (a weak page break) and
// continues the roman front-matter numbering.

#import "../../115-oreilly-book-template/template/theme.typ": font-head, ink, accent

#pagebreak(weak: true)

#text(font: font-head, size: 20pt, weight: "bold", fill: ink)[Preface]
#v(2pt)
#line(length: 100%, stroke: 0.6pt + accent)
#v(0.7em)

#lorem(55)

#lorem(40)
