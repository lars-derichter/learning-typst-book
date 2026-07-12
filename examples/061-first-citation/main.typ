// The smallest end-to-end citation: one source file, one cite, one
// bibliography, formatted APA.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 13cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= A first citation

Working memory is a bottleneck for learning @sweller1988. The idea that
media themselves shape thought is older still @mcluhan1964.

#bibliography("refs.yml", style: "apa")
