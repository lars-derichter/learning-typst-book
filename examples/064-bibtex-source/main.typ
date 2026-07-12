// The same idea, driven from a BibTeX .bib file instead of Hayagriva YAML.
// Point bibliography() at refs.bib and everything else is unchanged: the
// .bib files you already have from LaTeX work as-is.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 14cm, height: auto, margin: 2cm)
#set text(size: 11pt)

= Citing from a .bib file

#cite(<sweller1988>, form: "prose") argued that overloading working memory
undermines learning. The idea that media reshape thought is older
@mcluhan1964.

#bibliography("refs.bib", style: "apa")
