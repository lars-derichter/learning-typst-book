// Controlling size with widths (absolute and relative) and the three fit modes.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

A relative width scales against the surrounding space. This image is 60% of
the text width:

#image("logo.svg", width: 60%, alt: "The logo at 60% of the text width")

When you pin *both* width and height, `fit` decides what happens to the
leftover space. Each box below is 4cm by 2cm; only the fit differs.

#let frame = box.with(width: 4cm, height: 2cm, stroke: 0.5pt + gray)

contain (whole image, letterboxed):
#frame[#image("logo.svg", width: 100%, height: 100%, fit: "contain")]

cover (fills the box, crops the overflow):
#frame[#image("logo.svg", width: 100%, height: 100%, fit: "cover")]

stretch (fills the box, distorts to do it):
#frame[#image("logo.svg", width: 100%, height: 100%, fit: "stretch")]
