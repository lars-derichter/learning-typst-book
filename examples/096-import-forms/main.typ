// main.typ — the same lib.typ, imported three ways. Each import line stands on
// its own; you would normally pick ONE style per file. Shown together here for
// contrast. Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)
#set par(spacing: 1em)

= Three ways to import

// 1. NAMESPACED: bind the whole module to the name `lib`, reach in with a dot.
//    Safest — nothing new lands in your namespace, so nothing can clash.
#import "lib.typ"

Namespaced. Press #lib.kbd("Esc") to cancel, in
#text(fill: lib.accent)[the accent colour].

// 2. NAMED: pull out just the names you ask for. Explicit and tidy.
#import "lib.typ": accent, kbd

Named. Press #kbd("Enter") to confirm, in #text(fill: accent)[the same colour].

// 3. STAR: pull in everything the module defines. Convenient, but you inherit
//    every public name, clash risk and all.
#import "lib.typ": *

Star. Press #kbd("Space"), still #text(fill: accent)[on accent].
