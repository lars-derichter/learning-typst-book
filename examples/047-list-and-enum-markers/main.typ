// Custom bullets and custom numbers, each set once. set list gives two
// markers that alternate by nesting depth; set enum swaps the plain "1."
// for a lettered "a)" pattern.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

#set list(marker: ([--], [·]))
#set enum(numbering: "a)")

Shopping, as a bullet list:

- bread
  - sourdough
  - rye
- cheese

Steps, as a lettered enumeration:

+ Preheat the oven.
+ Mix the dry ingredients.
+ Fold in the wet ones.
