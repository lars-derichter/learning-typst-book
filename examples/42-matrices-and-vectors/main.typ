// Matrices, column vectors, and case distinctions, plus custom
// delimiters.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Matrices, vectors, and cases

In `mat`, a semicolon ends a row and a comma separates columns:

$ A = mat(1, 2; 3, 4) $

`vec` stacks its arguments into a column vector:

$ v = vec(x, y, z) $

Pick the fence with `delim`. Square brackets, or bars for a
determinant:

$ mat(delim: "[", 1, 0; 0, 1) quad mat(delim: "|", a, b; c, d) $

`cases` branches a definition; the `&` lines the conditions up:

$ abs(x) = cases(
  x   & "if" x >= 0,
  -x  & "if" x < 0,
) $
