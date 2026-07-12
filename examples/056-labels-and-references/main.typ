// Labels and cross-references.
// Heading references REQUIRE heading numbering to be turned on, or Typst
// errors with "cannot reference heading without numbering".
#set page(width: 13cm, height: auto, margin: 1.6cm)
#set heading(numbering: "1.")

= Introduction <sec:intro>
This note has three parts. The groundwork is laid in @sec:intro, the numbers
arrive in @sec:results, and the verdict is @sec:conclusion.

== Prior work <sec:prior>
Nothing here is new; @sec:results is where the change shows up.

= Results <sec:results>
The measurements sit in @fig:readings, plotted from the bench log.

#figure(
  rect(width: 4cm, height: 1.6cm, fill: luma(225)),
  caption: [Three readings, standing in for a real plot.],
) <fig:readings>

= Conclusion <sec:conclusion>
As @sec:results showed (and @sec:prior predicted), the effect is small but
real. The long form of a reference is #ref(<sec:results>).
