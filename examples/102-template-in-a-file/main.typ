// The document imports the template and applies it. All the styling lives in
// template.typ; this file is just configuration plus content. Chapter 19.
// Compile with:  typst compile main.typ out.pdf

#import "template.typ": article

#show: article.with(
  title: "On importing templates",
  author: "A. Reader",
)

= Why split the file?
#lorem(30)

= What you import
#lorem(22)
