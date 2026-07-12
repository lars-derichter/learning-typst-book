// Code blocks vs content blocks: [...] produces content you can store
// and place; {...} runs statements and evaluates to their joined
// result.  Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 12pt)

= Two kinds of block

A content block `[...]` produces content --- markup you can name,
store, and drop into the page later:

#let reminder = [Remember to *save* first.]

#reminder

A code block `{...}` runs a little sequence of statements and
evaluates to their joined result. Reach for it when you need to
compute before you show:

#{
  let w = 8
  let h = 5
  [The rectangle is #w by #h, so its area is ]
  [#(w * h).]
}

The two content lines inside the braces are joined into one piece of
content, which the block hands back to the page.
