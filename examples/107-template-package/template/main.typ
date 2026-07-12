// template/main.typ — the starter file that `typst init @preview/tidy-report`
// copies into a NEW project. Here lib.typ is NOT next door: it lives in the
// registry, so the starter imports the published package by name and pinned
// version. This is the ONLY line that differs from the local test one level up.
//
// (This file is illustration only — it needs the published package to compile,
// so it is not part of the offline example build.)
#import "@preview/tidy-report:0.1.0": report

#show: report.with(
  title: [Your Title Here],
  author: [Your Name],
)

= Introduction
Start writing.
