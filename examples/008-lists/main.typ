// Bulleted, numbered, nested, mixed, and term lists.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Lists of every kind

A bullet list uses hyphens:

- Bread
- Cheese
- A quiet afternoon

A numbered list uses plus signs, and Typst counts for you:

+ Boil the water.
+ Add the pasta.
+ Wait, impatiently.

Nest by indenting, and mix the two freely:

- Fruit
  + Apples
  + Pears
- Vegetables
  - Leafy
  - Root

A term list pairs a term with its description:

/ Markup: the content layer you type by hand.
/ Set rule: a way to change a default, covered in Chapter 9.
