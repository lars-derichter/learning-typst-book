// appendix/a-cloud-table.typ — back matter.
//
// Drawn by hand (like the index) rather than as a `=` heading, so it gets an
// "Appendix A" masthead instead of being swept up into the chapter numbering.

#import "../../115-oreilly-book-template/template/theme.typ": font-head, ink, accent, muted

#pagebreak(weak: true)

#block(above: 0pt, below: 1.2em)[
  #text(font: font-head, size: 10pt, weight: "bold", fill: muted, tracking: 2pt)[
    #upper[Appendix A]
  ]
  #v(0.35em)
  #text(font: font-head, size: 22pt, weight: "bold", fill: ink)[A cloud table]
  #v(2pt)
  #line(length: 100%, stroke: 0.6pt + accent)
]

#table(
  columns: (auto, 1fr),
  stroke: none,
  row-gutter: 0.4em,
  [*Cirrus*], [high and wispy; fair weather ahead],
  [*Cumulus*], [puffy and flat-bottomed; a fine day],
  [*Nimbostratus*], [low and grey; steady rain],
  [*Cumulonimbus*], [towering; thunder and squalls],
)
