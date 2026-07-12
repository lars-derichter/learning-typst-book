// main.typ — physica gives you compact operators for calculus and vector
// notation, so you write `pdv(phi, x)` instead of hand-building every symbol.
// Compile with:  typst compile main.typ out.pdf   (needs network the first time)
#import "@preview/physica:0.9.4": *
#set page(width: 9.5cm, height: auto, margin: 0.8cm)
#set text(font: "New Computer Modern", size: 11pt)

= Vector calculus, without the finger-typing

The gradient of a scalar field $phi$:
$ grad phi = pdv(phi, x) vu(x) + pdv(phi, y) vu(y) + pdv(phi, z) vu(z) $

A total derivative and Gauss's law, in notation the package builds for you:
$ dv(f, t) quad div vb(E) = rho / epsilon_0 $
