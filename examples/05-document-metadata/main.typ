// A small document that sets PDF metadata with #set document(...).
// Compile from the repo root so --root resolves absolute paths:
//   typst compile --root . examples/05-document-metadata/main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set document(
  title: "A Short Field Guide to Puddles",
  author: "R. Waterhouse",
)

= A short field guide to puddles

The title and author above never appear on the page. They are written into
the PDF's metadata instead — the fields a PDF reader shows in its "Document
Properties" panel, and the text a browser puts in the tab.

#lorem(30)
