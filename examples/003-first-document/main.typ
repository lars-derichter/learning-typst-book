// Your very first Typst document.
// Compile with:  typst compile main.typ out.pdf
// (The #set page line just keeps the rendered preview small — you can
//  delete it and get a normal A4 page.)
#set page(width: 12cm, height: auto, margin: 1.5cm)

= My first Typst document

Hello. This paragraph is here so the page has something to typeset. Notice
that you did not choose a font, a size, or a margin — Typst picked sensible
defaults so you could get straight to writing.

#lorem(40)

#lorem(30)
