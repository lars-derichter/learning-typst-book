// Fill colors and the built-in text decorations.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 12pt)

Fill colors:
#text(fill: rgb("#1a7f37"))[hex green],
#text(fill: red)[a named red],
#text(fill: luma(45%))[a luma gray], and
#text(fill: cmyk(75%, 0%, 70%, 5%))[a cmyk green].

Decorations wrap content:
#underline[underlined],
#overline[overlined],
#strike[struck through],
#highlight[highlighted], and
#smallcaps[small capitals].

You can restyle a decoration too:
#highlight(fill: rgb("#fff3b0"))[a soft yellow highlight] and
#underline(stroke: 1.5pt + red, offset: 3pt)[a thick red underline].
