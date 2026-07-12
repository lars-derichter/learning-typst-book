// measure() and layout(). Both ask about the layout instead of the document's
// place in it. `context measure(body)` returns a content's `.width`/`.height`
// before it is placed, so you can size something to fit it. `layout(size => ..)`
// hands you the available area, so content can adapt to where it lands.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 9cm, height: auto, margin: 1cm)

// (1) measure: draw a rule exactly as wide as the text above it.
#let ruled(body) = context {
  let size = measure(body)
  stack(
    spacing: 3pt,
    body,
    line(length: size.width, stroke: 1.5pt + orange),
  )
}

#ruled[*Short*]
#v(8pt)
#ruled[*A considerably longer heading*]

#v(14pt)

// (2) layout: lay three tags in a row when there is room, stack them when there
// is not — same content, different available width.
#let tags(..items) = layout(size => {
  let sep = if size.width < 5cm { 3pt } else { 10pt }
  let dir = if size.width < 5cm { ttb } else { ltr }
  stack(dir: dir, spacing: sep, ..items.pos())
})

Wide: #tags([`draft`], [`urgent`], [`review`])

#box(width: 4cm, stroke: 0.5pt + gray, inset: 6pt)[
  Narrow box:
  #tags([`draft`], [`urgent`], [`review`])
]
