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

## The book had to be able to leave home

Everything so far assumed the book lived in its repository, where the license,
the process notes, and the author all sit right next to the PDF. But a PDF
travels. Lars named the thing the repo had let us ignore: once
`learning-typst.pdf` is emailed, uploaded, or dropped into a course folder, it
is on its own — and it carried none of what a book normally carries on its own
pages.

So it grew the matter a distributed book needs. A colophon on the last page,
saying how the book was made and — the part that actually matters once the file
is loose — carrying the full license, Creative Commons badges and all. An "About
the authors" page introducing the human who directed the book and the model that
drafted it, each in its own voice. A back-cover blurb, the copy you'd skim
before deciding to open it. And, while we were rounding things off, a sixth
appendix: a practical Pandoc reference, because the pipeline chapter had earned
a companion you could keep open while you worked.

None of it needed new machinery. The Chapter 22 template gained a single
optional slot — a `cover` — and the pipeline gained a short back-matter file
glued on after the body. The same template that dresses the chapters now dresses
the covers too.

The lesson is quiet but real: the repository had been silently doing part of a
book's job — holding its license, its provenance, its author — and a loose PDF
can't lean on a repository. Anything that travels has to carry its own context.

## The cover, and a prompt that boomeranged

A book in this tradition needs an animal on the cover, and the choice made
itself: an ouroboros, the snake that eats its own tail — the exact image Chapter
24 closes on, and the exact thing this book does when it typesets itself.

Getting the drawing took a detour worth recording, because it's a tidy picture
of how the human-and-AI division of labor really plays out. I started by
*making* one: a procedural ouroboros generated from a small Python script —
clean, symmetric, and honestly a bit mechanical. Lars wanted something closer to
the old engraved natural-history plates the whole tradition is an homage to. So
he took the throwaway image-generation prompt I'd written to describe exactly
that look, fed it to Gemini, and got back a proper stippled engraving: a scaled
snake biting a real tail. He handed it over; I swapped it in, matched the
cover's background to the plate's cream ground so it sat seamlessly, and trimmed
the paper margins so the snake filled its frame.

Two things there are worth keeping. First, the design decision underneath it:
the cover is a deliberate *homage* to the animal-book tradition, not a copy of
any one publisher's trade dress — framed differently, in the book's own colors,
with a line on the cover that says as much, so it reads as affection rather than
imitation. Second, the shape of the collaboration didn't shift even as a third
tool joined it: a human still made the judgment call about which image was good
enough, and the machines still did the volume. Even the AI's *leftover* — a
prompt written for one purpose — turned out to be the useful thing.

## Two things only a reader would have caught

The last round was pure last mile: gaps that never show up in the source and
appear only when someone actually *uses* the output.

The first: the new About and Colophon pages weren't in the table of contents.
They'd been built as bare, hand-laid pages, which looked right but were
invisible to the template's outline — it collects headings, and these had none.
The fix was to make them ordinary unnumbered headings, exactly like the Preface
and the appendices, so the contents page picked them up for free and they got
matching openers into the bargain.

The second is the dead-links lesson in new clothes. The README's new "download
the book" callout rendered perfectly on GitHub and broke in the Marked app,
mangling a run of links into gibberish. The culprit was two constructs GitHub
tolerates and stricter Markdown engines don't: a code span tucked inside a
bolded link, and a lone `~` that some processors read as the start of a
subscript. The diagnosis was the interesting part — run through six different
Markdown parsers, *none* reproduced the break, and that was itself the finding:
the file was technically valid, so the only way to catch the problem was to open
it in the one tool a reader happened to use. "Renders on GitHub" is not "renders
everywhere," and there is no substitute for looking.

## A tip that fell off the edge of a page

Then a fault the source could never show, only the printed page. Near the foot
of the first chapter, a Tip admonition had torn in two: its green "TIP" label
sat alone at the bottom of one page, and the sentence it belonged to began at
the top of the next. A stranded label is bad anywhere; in a book *about
typesetting* it is an admission against interest.

The cause was a default doing its job. A Typst `block` is breakable — it will
split across a page boundary so that prose flows naturally — and the admonition
box was a plain block that had never said otherwise. Body text wants that
behaviour; a callout is a single visual object and wants the opposite. The fix
was one line in the template's `admonition` function, `breakable: false`, which
tells Typst to move the whole box to the next page rather than tear it. Because
every admonition — note, tip, warning, and the rest — is stamped from that one
function, and because the Markdown pipeline of Chapter 24 imports the very same
function, the single line repaired the sampler and the full book at once. That
is the template thesis of Chapter 22 collecting on itself again: fix the box
once, and all five boxes in both books are fixed. The prose in Chapter 22 that
walks through the box now names the line and says why it is there, so the rule
is taught, not just applied.

It is worth naming why this one hid so long. It is invisible in the Markdown, in
the Typst body, in every intermediate file; it exists only at the moment a
specific box lands a specific distance down a specific page, and only a person
paging through the actual PDF would ever meet it. The same lesson as the dead
links and the missing contents entries, wearing a third costume: the source can
be flawless and the output still wrong, and there is no substitute for looking
at what came out.

## The real lesson

A book, like a program, is never finished, only shipped. What lets it keep
improving *well* is the same discipline that built it: small, inspected, atomic
commits, so every change is legible and reversible; a build you can run to prove
nothing broke; and a habit of looking at the actual output, not just the source,
because that is where the gap between *intended* and *produced* becomes visible.
Every change in these rounds came from that gap.

This document stays open. When the next substantive change lands, it gets a
heading here — and this is not resignation but the opposite: a record kept by
someone who expects the book to go on getting better.
