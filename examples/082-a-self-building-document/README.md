# Example 082 · A self-building document

The payoff: one array of session records drives an entire page. A `for` sums
the total minutes, and a spread `..for` inside `#table(...)` emits one row per
record. Edit the data — add, remove, or reorder a session — and the table and
the totals rebuild themselves. Used in
[Chapter 15, *Control flow*](../../book/15-control-flow.md).

```sh
typst compile main.typ out.pdf
```
