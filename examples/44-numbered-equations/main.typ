// Numbering block equations and referring to one by a label.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#set math.equation(numbering: "(1)")

= Numbered and referenced

Switch numbering on once and every block equation earns a tag on the
right. Attach a label in angle brackets to the ones you want to cite:

$ e^(i pi) + 1 = 0 $ <eq:euler>

$ a^2 + b^2 = c^2 $ <eq:pyth>

Point at one with an `@` reference and Typst fills in its number as a
live link: Euler's identity is @eq:euler and the Pythagorean theorem is
@eq:pyth. Shuffle the equations and the numbers follow.

Inline math such as $1 + 1 = 2$ is never numbered.
