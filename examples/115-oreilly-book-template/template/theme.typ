// theme.typ — the knobs.
//
// Every colour, font, size, and spacing value the book uses lives here, and
// nowhere else. Change the look of the whole book by editing this one file.
// (Chapter 18's "constants at the top" habit, scaled up to a book.)

// --- Fonts -----------------------------------------------------------------
// All three ship with Typst, so this book compiles the same on any machine.
#let font-body = "Libertinus Serif"     // body text
#let font-head = "New Computer Modern"  // titles, headings, labels
#let font-mono = "DejaVu Sans Mono"     // code

// --- Palette ---------------------------------------------------------------
#let ink = luma(25)             // body text
#let accent = rgb("#0b7285")    // headings, rules, the house colour (a deep teal)
#let muted = luma(120)          // page numbers, captions, secondary text
#let hairline = luma(205)       // thin rules

// --- Admonition colours ----------------------------------------------------
// One colour per kind of box; the label and side-rule take the full colour,
// the background a very light tint of it.
#let note-color = rgb("#1c7ed6")
#let tip-color = rgb("#2f9e44")
#let important-color = rgb("#9c36b5")
#let warning-color = rgb("#e8590c")
#let caution-color = rgb("#e03131")

// --- Code ------------------------------------------------------------------
#let code-bg = luma(245)

// --- Sizes -----------------------------------------------------------------
#let size-body = 10pt
#let size-code = 8.5pt
#let size-small = 8.5pt
