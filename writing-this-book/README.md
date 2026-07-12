# Writing this book

This folder is the book's own paper trail. *Learning Typst* was written by a
human (Lars) directing an AI system (Anthropic's Claude, running in the Claude
Code agent harness), and this is the honest, unglamorous record of how — the
first prompt, the questions that shaped the plan, the plan itself, the style
guide the AI held itself to, and the workflow that turned all of that into
chapters and verified example code.

It exists for two reasons.

First, transparency. A book written with AI should say so plainly and show its
work, so a reader can judge the result knowing how it was made. Nothing here is
hidden.

Second, and more interesting: this repository is meant to double as a small
**case study in using generative AI meaningfully** — not as a slot machine you
pull for paragraphs, but as a capable collaborator held to a real standard. The
difference between those two uses is almost entirely in the *process*, and the
process is what this folder documents.

## What's here

- [01 · The initial prompt](01-the-initial-prompt.md) — the exact brief Lars
  gave, verbatim, warts and all.
- [02 · Questions and answers](02-questions-and-answers.md) — the clarifying
  questions the AI asked before planning, and the decisions that came out of
  them.
- [03 · The plan](03-the-plan.md) — the full implementation plan, including the
  two rounds of human feedback that reshaped it before approval.
- [04 · The style guide](04-the-style-guide.md) — the authoring guide every
  chapter was written against: voice rules, banned "AI tells," verification
  requirements, and the numbering maps that let chapters be written in parallel
  without colliding.
- [05 · The workflow](05-the-workflow.md) — how it actually ran: one AI acting
  as managing editor, delegating chapters to sub-agents, quality-checking every
  one, and committing only what passed. Plus the tooling that made "every
  example really compiles" a promise instead of a hope.
- [06 · Reflections](06-reflections.md) — what worked, what didn't, and what
  this suggests about doing this kind of thing well.

## The one-paragraph version

A human wrote a detailed brief and answered four scoping questions. The AI wrote
a plan; the human sent it back twice with pointed feedback ("you are the editor,
delegate the writing"; "commit atomically, only after inspection") and then
approved it. From there the AI ran as a managing editor: it hand-wrote the
preface and first chapter to fix the book's voice, distilled that voice into a
written style guide, and then dispatched the remaining chapters to sub-agents —
each of which had to make every code example compile against a real Typst
binary. The managing editor read every chapter, re-compiled every example
itself, fixed or rejected what fell short, and committed the survivors one unit
at a time. The book you're reading is the output of that loop.
