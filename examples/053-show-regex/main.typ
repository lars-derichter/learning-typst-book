// Regex-selector show rules transform text that matches a pattern. The first
// sets any run of two-or-more capitals (an acronym) in small caps; the second
// colors any four-digit year. `it.text` is the matched string.
// See Chapter 10, "Show rules".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#show regex("[A-Z]{2,}"): it => smallcaps(lower(it.text))
#show regex("\d{4}"): it => text(fill: rgb("#c05621"))[#it.text]

The HTML spec was first drafted in 1991, the CSS one in 1996, and a modern
JSON API returns data over HTTP long after both. All-caps acronyms drop to
small caps and years pick up a warm accent — without editing a single acronym
by hand.
