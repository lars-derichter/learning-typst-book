// main.typ — a LOCAL test of the template entrypoint, through a relative
// import, so this folder compiles with no network. The starter that
// `typst init @preview/tidy-report` actually hands a user lives in
// template/main.typ and imports the PUBLISHED package instead (open that file
// to see the one-line difference).
// Compile with:  typst compile main.typ out.pdf
#import "lib.typ": report

#show: report.with(
  title: [A Very Tidy Report],
  author: [A. Author],
)

= Introduction
#lorem(30)

= Method
#lorem(25)
