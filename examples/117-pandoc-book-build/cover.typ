// cover.typ — the book's front cover.
//
// An affectionate homage to the classic animal-book covers, deliberately its
// own thing: a framed layout with the title on top and the creature below, in
// the book's teal palette, with no borrowed wordmark or trade dress. The animal
// is an ouroboros — a snake biting its own tail — because that is exactly what
// this book does: it typesets itself ("the snake, contentedly, eats its tail",
// Chapter 24). The illustration is a naturalistic engraving in the old
// natural-history-plate style (assets/cover-animal.png); swap that one file to
// change the creature. Its warm off-white ground is matched by the page fill
// below, so the plate melts into the cover.
//
// `cover` is a content value the build passes to the template's `cover:` slot,
// which lays it down as the very first page. Paths are absolute from the repo
// root because the build compiles with `--root` at the repository.

#import "/examples/115-oreilly-book-template/template/theme.typ": *

// The cream ground of the engraving plate, sampled from the image itself, so
// the plate blends seamlessly into the page with no visible bounding box.
#let cream = rgb(249, 249, 244)

#let cover = page(
  width: 21cm,
  height: 29.7cm,
  margin: 0cm,
  header: none,
  footer: none,
  fill: cream,
)[
  #set text(font: font-head, fill: ink)

  // A double-ruled frame — a cover flourish the plain animal books don't have,
  // so this reads as homage rather than copy.
  #place(top + left, dx: 1.15cm, dy: 1.15cm,
    rect(width: 21cm - 2.30cm, height: 29.7cm - 2.30cm, stroke: 0.9pt + accent))
  #place(top + left, dx: 1.34cm, dy: 1.34cm,
    rect(width: 21cm - 2.68cm, height: 29.7cm - 2.68cm, stroke: 0.4pt + accent))

  // A teal series band near the top.
  #place(top + center, dy: 2.15cm,
    block(width: 21cm - 3.4cm, fill: accent, inset: (y: 9pt))[
      #set align(center)
      #text(fill: white, size: 11.5pt, tracking: 3.5pt, weight: "bold")[
        #upper[The self-typesetting library]
      ]
    ])

  // Title block, below the band.
  #set align(center)
  #v(4.7cm)
  #text(size: 41pt, weight: "bold", fill: ink)[Learning\ Typst]
  #v(0.35cm)
  #text(size: 15pt, style: "italic", fill: accent)[
    A hands-on guide to the Typst typesetting system
  ]
  #v(0.45cm)
  #line(length: 26%, stroke: 1pt + accent)

  // The creature.
  #v(0.7cm)
  #image("/examples/117-pandoc-book-build/assets/cover-animal.png", width: 10cm)
  #v(0.15cm)
  #text(size: 9.5pt, fill: muted, style: "italic")[
    The ouroboros — a book that typesets itself.
  ]

  // Push the byline to the foot.
  #v(1fr)
  #text(size: 15pt, fill: ink)[Lars De Richter]
  #v(3pt)
  #text(size: 11pt, fill: muted)[with Claude (Opus 4.8)]
  #v(0.25cm)
  #text(size: 8pt, fill: muted, style: "italic")[
    In the spirit of the classic animal books — an homage, not one of them.
  ]
  #v(1.7cm)
]
