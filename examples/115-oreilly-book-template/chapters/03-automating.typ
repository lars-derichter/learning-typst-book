#import "../template/admonitions.typ": *
#import "../template/index.typ": idx

= Automating the boring parts

Underneath the friendly markup sits a real programming language, and you reach
it with a `#`. That is the feature that separates Typst from ordinary markup:
your document can compute parts of itself.

== Loops write your lists

Suppose you want a table of the first few powers of two. You could type it out,
or you could describe it once with a #idx("loop") and let the machine
elaborate:

```typ
#for n in range(1, 6) [
  / $2^#n$: #calc.pow(2, n)
]
```

Change the `6` to `60` and you get sixty rows without touching the list. The
same idea — a #idx("loop") over some data — fills in a multiplication table, a
calendar, or a hundred certificates with a hundred different names.

#warning[
  A computed list is only as trustworthy as its input. If the data feeding a
  loop is wrong, the loop will cheerfully typeset the wrong thing sixty times
  over. Check the source, not just the page.
]

== Functions bottle a pattern

When the same shape of content repeats — a callout box, a labelled figure, a
styled title — you wrap it in a #idx("function") and call it by name. The edit
loop from @fig:loop still applies: define the function, use it, watch the
preview, adjust. A book's worth of these, gathered into files, is exactly the
#idx("template") this book builds in its final part.

#tip[
  The rule of thumb: the second time you copy and paste a piece of layout, stop
  and make it a #idx("function"). The third time, you will be glad you did.
]
