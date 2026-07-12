# Example 064 · A BibTeX source file

Exactly the setup of example 061, but the data lives in a BibTeX `refs.bib`
instead of a Hayagriva `.yml`. `#bibliography("refs.bib", style: "apa")` reads
it directly; the `@key` and `#cite` syntax is identical. Existing LaTeX `.bib`
files work without conversion. From
[Chapter 12, *Citations and bibliographies*](../../book/12-citations-and-bibliographies.md).

Data file: `refs.bib`.

```sh
typst compile main.typ out.pdf
```
