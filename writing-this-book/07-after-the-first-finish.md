# After the first finish

The previous file ends with the book declared done: a preface, 24 chapters, five
appendices, 117 verified examples, a PDF that typesets itself. "Done" turned out
to be a soft word. What follows is what happened *after* the book was finished —
because the most instructive part of this whole exercise may be that finishing
and improving are different events, and the second one is driven by something
the first can't supply: actually using the thing.

Each change below started the same way — not with a plan, but with a look at the
real artifact, or a sentence from Lars after he'd seen it.

## The whole-book PDF was styled worse than the book's own example

The book teaches you, in Chapter 22, to build a proper O'Reilly-style book
template: chapter openers, running heads, admonition boxes, a generated table of
contents. Then Chapter 24's pipeline typeset the *actual* book — and used a
plainer, hand-rolled preamble instead. Lars noticed immediately: after reading
Chapter 22, the real book's design "feels as a step back."

He was right, and the fix was better than a patch. The Chapter 22 template's
page size was hard-coded for a small sampler, so we made the page a *parameter*
— one line — and then the pipeline could import and apply that very template, on
an A4 page, to the whole book. The result: the book is now typeset by the exact
design it spends a chapter teaching you to build. The "book typesets itself"
claim got literally truer, and Chapter 24 was rewritten to tell that story.

The lesson is the one worth keeping: the strongest improvement in this round
came not from new work but from *noticing an inconsistency between what the book
taught and what it did* — something only visible once both existed side by side.

## The links were dead, and looked it

Reading the generated PDF, Lars hit links that went nowhere. A cross-chapter
"see Appendix A" pointed at a Markdown filename that doesn't exist inside a
single PDF; a link to an example folder pointed at a relative path that isn't
there either. They rendered as oddly styled text that clicked into the void.

Nobody caught this in review, because review reads the *source*, where
`[Appendix A](25-appendix-a-solutions.md)` looks perfectly correct. Only opening
the PDF and clicking showed the problem. The fix was another small filter pass:
chapter links became internal PDF jumps (each chapter heading now carries a
label matching its file name), and example links became real GitHub URLs that a
reader can follow. Chapter 24 grew a section explaining it and lost its
now-false apology that the links were left unresolved "because it would take
another filter." It took another filter.

## A name that had stopped being true

The Pandoc filter was born to convert GitHub alerts, and was called
`github-alerts.lua`. By the time it also passed math through, fixed links,
renumbered front matter, and dropped author comments, the name was a small lie.
Lars asked for it to be renamed; it became `book-filter.lua`. A trivial change,
and a good habit: a name that describes a third of what a thing does is a name
that will mislead the next person to read it — often you.

## Making the project legible to its future self

Finally, two documents so that the next round of changes starts from solid
ground rather than from re-reading a thousand lines: a `CLAUDE.md` at the
repository root — the practical map of the project's structure, conventions, and
build commands, for whoever (human or AI) edits it next — and this file, which
keeps the honest record going past the point where the book was "done."

## The real lesson

A book, like a program, is never finished, only shipped. What lets it keep
improving *well* is the same discipline that built it: small, inspected, atomic
commits, so every change is legible and reversible; a build you can run to prove
nothing broke; and a habit of looking at the actual output, not just the source,
because that is where the gap between *intended* and *produced* becomes visible.
Every change in this round came from that gap.

This document stays open. When the next substantive change lands, it gets a
heading here — and this is not resignation but the opposite: a record kept by
someone who expects the book to go on getting better.
