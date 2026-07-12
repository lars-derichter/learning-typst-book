# Example 088 · Data to table

The practical payoff of the chapter: an array of dictionaries becomes a
formatted table. `.sorted()` orders the records, `.map()` turns each record
into a four-cell row (including a computed "century" column), `.flatten()`
plus the spread `..` feed those cells to `table`, and a
`show table.cell.where(y: 0)` rule bolds the header. From
[Chapter 16, *Arrays, dictionaries, and strings*](../../book/16-arrays-dictionaries-strings.md).

```sh
typst compile main.typ out.pdf
```
