// Paragraph shape with `#set par`. Three knobs at once:
//   justify            - flush both margins
//   leading            - space between lines within a paragraph
//   first-line-indent  - indent the first line of each paragraph
// The `all: true` makes even the paragraph right after a heading indent;
// by default the first paragraph after a heading is left flush.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 9cm, height: 12cm, margin: 1.2cm)
#set par(
  justify: true,
  leading: 0.8em,
  first-line-indent: (amount: 1.4em, all: true),
)

= Book-style paragraphs

#lorem(35)

#lorem(40)

#lorem(30)
