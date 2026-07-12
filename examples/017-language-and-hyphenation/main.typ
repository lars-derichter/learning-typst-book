// Language-aware quotes and hyphenation in a narrow, justified column.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 7cm, height: auto, margin: 1.2cm)
#set par(justify: true)
#set text(font: "Libertinus Serif", size: 10pt, lang: "en", region: "US")

*Hyphenation on.* Typst breaks long words at the margin, so a narrow
justified column keeps even word spacing:

#set text(hyphenate: true)
#lorem(38)

#line(length: 100%, stroke: 0.5pt)

*Hyphenation off.* The same text, forbidden to break words, so the
spacing has to stretch:

#set text(hyphenate: false)
#lorem(38)

#line(length: 100%, stroke: 0.5pt)

*Language picks the quotes.* Straight quotes curl to fit the
document language:
#text(lang: "en")["English"],
#text(lang: "de")["Deutsch"],
#text(lang: "fr")["français"].
