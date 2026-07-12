// Emphasis, strong, nesting, and raw (verbatim) text.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Emphasis and raw text

Wrap a word in underscores for _emphasis_ (italic) and in asterisks for
*strong* (bold). They nest: *bold with _italic_ inside* reads fine.

Inline code goes in backticks: run `typst watch main.typ`. Inside raw
text nothing is markup, so `*this stays literal*` and `_so does this_`.

For a whole block, fence it with three backticks and name the language:

```rust
fn main() {
    println!("Hello, Typst!");
}
```

The block keeps every space and line break exactly as typed, and the
language tag turns on syntax highlighting.
