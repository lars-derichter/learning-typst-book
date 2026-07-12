// Inline math versus display blocks. The only difference in the source
// is the spaces just inside the dollar signs.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Inline versus block

The identity $a^2 + b^2 = c^2$ sits right in the run of text, at the
same size as the words around it. Nothing touches the dollar signs, so
Typst keeps the math inline.

Put a space just inside each dollar sign and the same equation lifts out
of the paragraph, centered on its own line:

$ a^2 + b^2 = c^2 $

That is the whole rule. A long expression such as
$sum_(i=1)^n i = (n (n + 1)) / 2$ stays compact and side-set when it is
inline; the very same source, set off as a block, is given room to
breathe:

$ sum_(i=1)^n i = (n (n + 1)) / 2 $
