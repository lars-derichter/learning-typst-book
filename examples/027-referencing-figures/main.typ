// Labelling figures and pointing at them from prose with @.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

The signal starts calm (@fig:calm) and then spikes (@fig:spike). Because the
references are live, reordering the figures would renumber both the labels and
the text that points at them.

#figure(
  rect(width: 5cm, height: 1.6cm, fill: aqua, radius: 3pt),
  caption: [A steady, low-amplitude signal.],
) <fig:calm>

#figure(
  polygon(fill: red, (0cm, 1.6cm), (2cm, 1.6cm), (2.5cm, 0cm), (3cm, 1.6cm), (5cm, 1.6cm)),
  caption: [The same signal, spiking sharply in the middle.],
) <fig:spike>

Together, @fig:calm and @fig:spike make the contrast obvious.
