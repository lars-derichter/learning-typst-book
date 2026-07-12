// Customizing every reference with a show rule on `ref`. The rule inspects
// it.element to tell what kind of thing is being referenced, then restyles the
// default rendering (`it`) instead of rebuilding the number by hand.
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set heading(numbering: "1.")

#show ref: it => {
  let el = it.element
  if el != none and el.func() == figure {
    // Figure references get a soft grey chip.
    box(fill: luma(235), inset: (x: 4pt), outset: (y: 3pt), radius: 2pt, it)
  } else {
    // Headings and the rest turn blue and bold.
    text(fill: rgb("#1a56db"), weight: "bold", it)
  }
}

= Overview <sec:overview>
= Results <sec:results>

#figure(
  rect(width: 3cm, height: 1.2cm, fill: luma(220)),
  caption: [A grey rectangle standing in for a chart.],
) <fig:chart>

The plan is set in @sec:overview and delivered in @sec:results. The data
appears in @fig:chart.
