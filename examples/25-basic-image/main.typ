// Placing a raster/vector image on the page with #image.
// The asset, logo.svg, is a small hand-authored SVG in this folder.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

An image lands wherever you put it, at its natural size unless you say
otherwise:

#image("logo.svg", alt: "A blue rounded square with a white disc and orange triangle")

Give it a width and it scales to fit, keeping its proportions:

#image("logo.svg", width: 3cm, alt: "The same logo, three centimetres wide")
