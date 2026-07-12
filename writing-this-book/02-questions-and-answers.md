# Questions and answers

Before writing a plan, the AI did two cheap, high-value things: it checked the
ground it was standing on, and it asked about the decisions it genuinely
couldn't make alone.

## First, it checked the toolchain

Rather than assume, it ran a few read-only commands to establish reality:

- **Typst 0.15.0** was installed (`/usr/local/bin/typst`), with ~393 fonts
  available. This meant every code example could actually be *compiled and
  verified* rather than merely written and hoped over — which became a
  cornerstone of the whole approach.
- **Pandoc 3.10** was installed, and its native `typst` writer worked (a quick
  `echo '# Hi' | pandoc -t typst` confirmed it). This made the "typeset the
  whole Markdown book via Pandoc" idea a real, testable pipeline instead of a
  handwave.
- The repository was an empty greenfield (a stub README, one commit), so there
  was no existing code to explore — this was a from-scratch authoring project.

Establishing this first changed later decisions. "Verify every example" is only
a reasonable promise if there's a compiler on the machine to enforce it.

## Then, four scoping questions

The AI asked exactly the questions whose answers would change the shape of the
book, and no more. Each is paired below with Lars's decision.

### 1. Who is the reader?

**Options offered:** general lightly-technical · LaTeX refugees · non-technical
academics · programmers.

**Decision: general, lightly technical.** Comfortable with a computer, plain
text, and Markdown, but assuming *no* LaTeX and *no* programming background.
LaTeX and Word comparisons live in optional sidebars rather than driving the
main text. This is the closest match to the *Learning Perl* register the brief
asked for.

### 2. How deep should it go?

**Options offered:** comprehensive · practical · authoring-focused.

**Decision: comprehensive.** Not just document authoring but the full scripting
language, writing your own functions/packages/templates, and advanced topics
(context, state, show rules, layout internals, plugins). A genuinely complete
book, not a quick-start.

### 3. How far should the "book typesets itself" capstone go?

**Options offered:** a reusable template plus a few real chapters · a full
re-authoring of every chapter in Typst · a minimal skeleton.

**Decision: template plus some chapters — with an addition.** In Lars's words:

> Template + some chapters. Also add a part on integrating markdown and typst
> with pandoc workflows, from there it should be possible to typeset the whole
> book.

This was the single most valuable answer in the exchange. It took a good idea
(hand-build an O'Reilly-style Typst template) and made it complete: a second
pipeline that converts the book's *own Markdown source* into Typst via Pandoc,
so the entire manuscript can be typeset end to end. The book doesn't just
describe how to typeset a book — it typesets *itself*, two different ways.

### 4. How rigorous should example verification be?

**Options offered:** verify all, source only · verify and commit renders · write
without compiling.

**Decision: verify and commit renders.** Every example is compiled against the
installed Typst, *and* its rendered output (a PDF and a preview PNG) is
committed alongside the source, so a reader sees the result without building
anything.

## The pattern worth stealing

Four questions, each with the trade-offs spelled out, each answerable in a
sentence. None of them was "what should I do?" — that's the AI's job to propose.
They were all "which of these genuinely different directions do you want?" —
which is the human's job to decide. Getting that division right at the start is
most of what makes a long unsupervised run go well.
