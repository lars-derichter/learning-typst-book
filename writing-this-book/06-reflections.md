# Reflections

> [!NOTE]
> The book is finished. The shape it reached that day: a preface, 24 chapters,
> and 5 appendices — about 97,000 words — alongside 117 self-contained example
> projects, every one compiled against Typst 0.15.0 and committed with its
> rendered output. The whole thing typesets itself from its Markdown source,
> through the Chapter 24 pipeline, into a ~185-page A4 PDF — styled by the very
> book template Chapter 22 builds by hand. It arrived in roughly 40 atomic
> commits on a single branch. The observations below held steady from early on.

Lars's stated reason for keeping this record was that he wants to reuse the
repository as an example of using generative AI in a *meaningful* way. So this
file steps back from the how and asks the harder question: what actually made
this a good use of the technology, as opposed to a flashy one?

## What made it work

**A human owned the decisions that were the human's to make.** The AI never
chose the audience, the depth, the license, or the shape of the labor. It
*proposed*; Lars *decided*. Four scoping questions and two rounds of plan
feedback — maybe fifteen minutes of human attention — set the direction for
everything that followed. The leverage was enormous and it was entirely at the
front.

**Verification replaced trust.** The recurring anxiety about AI-written
technical content is that it's confidently wrong — a function that doesn't
exist, a flag that was renamed three versions ago. The antidote here wasn't a
better model; it was a compiler. Every code example had to survive Typst 0.15.0,
cleanly, or it never reached the page. When you can mechanically check the AI's
output, a whole category of failure just disappears, and you can relax about the
rest.

**The work was structured so quality could be enforced.** Small commits, each
gated by inspection. A written standard the work was measured against. A split
between writing and editing so no single pass had to be perfect. None of this is
AI-specific — it's ordinary good engineering and editing practice. The lesson is
that using AI well looks a lot like using anything well: the process carries the
quality, not the tool.

## What it didn't do

Honesty demands the other column too.

**It didn't remove the human from the loop — it relocated them.** This wasn't
"press a button, get a book." It was a human setting a high bar, an AI doing the
volume of work against that bar, and the bar being checked constantly. The human
effort moved from *writing* to *directing and judging*. That's a real shift, and
for some people it's a less enjoyable kind of work than writing itself. Worth
knowing before you sign up for it.

**It isn't a substitute for genuine expertise on the subject.** The verification
catches code that doesn't *run*; it does not catch an explanation that runs fine
but teaches a subtly wrong mental model. Catching *that* still takes a reader
who knows the material, or is willing to learn it well enough to smell when
something is off. AI lowers the cost of producing a draft; it does not lower the
cost of knowing whether the draft is right.

**Originality has limits.** A book like this is, honestly, a *synthesis* — it
organizes and explains things that are already known and documented. That's a
task AI is genuinely good at and a legitimately useful thing to make. It is not
the same as original research or a genuinely novel argument, and it would be a
mistake to let fluent prose disguise the difference.

## For anyone trying something similar

If there's a transferable recipe here, it's roughly this:

1. **Write a real brief.** Name the genre, the quality bar, and the hard
   constraints. Leave the AI room to propose the rest.
2. **Answer scoping questions before planning, not during execution.** Cheap
   ambiguity resolution up front prevents expensive rework later.
3. **Insist on a plan, and be willing to send it back.** The most valuable
   feedback is often about *how the work is done*, not what it says.
4. **Make the output checkable.** If a machine can verify it — a compiler, a
   test suite, a linter — wire that in and make it a gate, not a suggestion.
5. **Separate producing from judging.** Even with one underlying model,
   splitting the writer and editor roles keeps a big job coherent.
6. **Commit small and inspect before you do.** The history becomes your audit
   trail and your undo button.

## The honest bottom line

This book exists because one person wanted a specific thing that didn't exist,
had good judgment about what "good" looked like, and used AI to do the labor
while keeping the judgment for himself. That division — human taste and
accountability, machine volume and tirelessness, a compiler holding both to
account — is, as far as this project can tell, what "meaningful use" actually
means in practice. Not the absence of human effort. The concentration of it on
the parts that matter.

> [!NOTE]
> This was written the day the book was first declared finished. Finishing, it
> turned out, was not the end of the work — only the end of the *first* round.
> What happened next, and why "done" proved such a soft word, is the subject of
> the next file, [After the first finish](07-after-the-first-finish.md).
