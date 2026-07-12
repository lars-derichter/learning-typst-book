# Example 061 · A first citation

The minimal end-to-end setup: a Hayagriva `refs.yml` with two sources, two
`@key` citations in prose, and one `#bibliography("refs.yml", style: "apa")`
call that renders an APA reference list. From
[Chapter 12, *Citations and bibliographies*](../../book/12-citations-and-bibliographies.md).

Data file: `refs.yml`.

```sh
typst compile main.typ out.pdf
```
