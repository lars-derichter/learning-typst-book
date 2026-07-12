// One source file, one line to change the whole citation style. This renders
// APA (author-date). Swap the style string on the last line to "ieee" and the
// same document becomes numbered [1], [2] with an IEEE reference list -- no
// other edits. Try: style: "ieee", or "chicago-author-date", or "mla".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 15cm, height: auto, margin: 2cm)
#set text(size: 11pt)

= Switching styles

Feedback @hattie2007 and cognitive load @sweller1988 are two of the most cited
ideas in the learning sciences. The citations above and the list below are the
same source data; only the `style:` argument decides how they look.

#bibliography("refs.yml", style: "apa")
