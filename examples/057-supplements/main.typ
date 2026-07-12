// Supplements: the word printed before a reference number.
// Change it globally on an element, or per-reference with #ref(..., supplement).
#set page(width: 13cm, height: auto, margin: 1.6cm)
#set heading(numbering: "1.")
#set heading(supplement: [Chapter])       // headings say "Chapter", not "Section"
#set figure(supplement: [Illustration])   // figures say "Illustration", not "Figure"

= Methods <sec:methods>
= Findings <sec:findings>

#figure(
  rect(width: 3.5cm, height: 1.5cm, fill: luma(220)),
  caption: [A placeholder plot.],
) <fig:plot>

The approach in @sec:methods yields the results in @sec:findings.

The global supplement makes @fig:plot read in full, while a per-reference
override shortens that one mention to #ref(<fig:plot>, supplement: [Fig.]).
