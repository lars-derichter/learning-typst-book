// Size, weight, and style, the three axes you reach for most.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 12pt)

Size in points and ems:
#text(size: 8pt)[8pt] ·
#text(size: 12pt)[12pt] ·
#text(size: 18pt)[18pt] ·
#text(size: 1.5em)[1.5em of the current size].

Weight by name:
#text(weight: "regular")[regular] ·
#text(weight: "medium")[medium] ·
#text(weight: "bold")[bold].

Weight by number, 100 to 900:
#text(weight: 300)[300] ·
#text(weight: 400)[400] ·
#text(weight: 700)[700] ·
#text(weight: 900)[900].

Style:
#text(style: "normal")[normal] ·
#text(style: "italic")[italic] ·
#text(style: "oblique")[oblique].

In markup the shortcuts are *strong* for bold and _emph_ for italic.
