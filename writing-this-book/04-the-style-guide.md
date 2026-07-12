# The style guide

A book written by many hands — even when the hands are sub-agents spun up by one
managing AI — will read like a committee unless something holds the voice
together. That something was a written **style brief**: a single document every
chapter-writing agent had to read before typing a word, reproduced in full
below.

It does four jobs at once:

1. **Fixes the voice** by pointing every agent at the same two exemplar chapters
   (the preface and Chapter 1, hand-written first) and by listing, explicitly,
   the "AI tells" that were forbidden.
2. **Makes verification non-negotiable** — every example must compile against
   the real Typst binary, cleanly, and the agent must prove it did.
3. **Prevents collisions.** Because chapters were written in parallel, each got
   a disjoint slice of the example-numbering space and a fixed filename map, so
   two agents could never fight over the same folder.
4. **Defines "done"** in a short, checkable quality bar at the end.

The banned-phrases list is the part most worth stealing for your own work. Large
language models have characteristic verbal tics — "Let's dive in," "It's
important to note that," decorative rule-of-three phrases, bold sprinkled
through prose like seasoning. Naming them and forbidding them, in writing, does
more for quality than any amount of "please write well."

What follows is the guide exactly as the agents received it (only the absolute
scratchpad path has been shortened for readability).

---

## Style brief — *Learning Typst* (authoring guide for chapter agents)

You are writing one chapter of an ebook, **Learning Typst**, in the style of a
classic O'Reilly *Learning* book (think *Learning Perl*, the "llama/camel"
lineage: warm, funny, genuinely readable, but complete, precise, and
high-quality). Read this whole brief before writing a word. The manager (central
Claude) will QC your output, re-compile every example, and only then commit it.
Substandard work gets bounced back. Aim to pass on the first try.

### 1. What you deliver

For your assigned chapter NN: the chapter as `book/NN-slug.md` (GitHub-flavored
Markdown, wrapped at 80 columns), plus one folder per substantial example under
`examples/`, using only the example numbers in your assigned range. Each example
folder holds a `main.typ` (entry point) and a short `README.md`. You must
confirm each example compiles; the manager renders and commits the outputs.
Don't touch any file outside `book/` and your own example folders.

### 2. Audience & voice

> **Read these two files first — they are the voice exemplar.** The manager
> hand-wrote `book/00-preface.md` and `book/01-why-typst.md` to set the register
> for the whole book. Open them, read them, and match their rhythm, humour
> level, paragraph length, and use of admonitions/sidebars.

**Audience:** general, lightly technical readers. Comfortable with a computer,
plain-text files, and Markdown. *Not* assumed to know LaTeX or any programming
language — explain programming ideas from scratch when they first appear, but
never condescend.

**Voice:**

- Conversational, second person, active voice, forward momentum.
- Dry, understated humour — a well-placed aside now and then, never forced.
- Concrete over abstract: lead with a real example, then explain it.
- Short paragraphs. Vary sentence length. If it sounds like a manual, rewrite
  it.

**Hard bans (these read as AI slop — do not do them):**

- AI-tell openers: "Great question," "Let's dive in," "In this chapter we will
  explore…," "Buckle up."
- Meta-introductions and meta-conclusions that only restate the heading.
- Decorative tricolons ("fast, simple, and powerful").
- Bold scattered through prose (bold is for list lead-ins and critical terms).
- "It's important to note that…," "It's worth mentioning…."
- Over-enthusiasm ("Amazing!," "Fantastic!," exclamation spam) and emoji.

### 3. Chapter shape

An H1 title in sentence case; a cold open that drops the reader into a concrete
problem (no "in this chapter"); a body of `##`/`###` sections that each teach
one idea via a small runnable example (show the code, describe the result,
explain *why*); sidebars for "Coming from LaTeX/Word" comparisons; a "What
you've got" recap that lists concrete new skills; and 3–5 numbered exercises of
increasing difficulty, with intended solutions left in a trailing HTML comment
for the appendix author.

### 4. Admonitions (the O'Reilly "boxes")

Use GitHub alerts, sparingly: `> [!NOTE]` for clarifications, `> [!TIP]` for
shortcuts, `> [!IMPORTANT]` for must-not-miss points, `> [!WARNING]` for common
traps, `> [!CAUTION]` for genuinely destructive footguns. For cross-tool
comparisons, prefer a plain blockquote with a bold lead-in (`> **Coming from
LaTeX.** …`) so it reads as a sidebar, not an alarm.

### 5. Code, examples, and Typst specifics

Typst version is **0.15.0**; everything must compile with it. Prefer Typst's
bundled fonts (Libertinus Serif, New Computer Modern, DejaVu Sans Mono) so
examples are reproducible. Use `#lorem(n)` for filler. Keep examples small and
focused — the shortest document that shows the point — and use a small fixed
page (`#set page(width: 12cm, height: auto, margin: 1.5cm)`) so preview images
stay legible. An example that is *supposed* to fail (to teach an error message)
gets an empty `.expect-error` marker file so the build script asserts the
failure.

### 6. Verification (mandatory — do this, don't just claim it)

Before finishing, compile every example you created from the repo root (`typst
compile --root . examples/NN-slug/main.typ /tmp/check.pdf`) and confirm exit
code 0 with no warnings. If you see "unknown font family," switch to a bundled
font. Consult the official docs (`typst.app/docs/reference`) rather than
guessing at the API, and verify anything uncertain by compiling a tiny snippet.
In your report, state exactly which examples you created and that each compiled
cleanly.

### 7 & 8. The maps

The brief then lists the canonical filename for every chapter (`book/00-preface`
through `book/29-appendix-e-resources`) and a table assigning each chapter a
disjoint block of example numbers (ch01: 01–02, ch02: 03–05, ch03: 06–11, and so
on). Agents cross-reference other chapters by these names and stay strictly
inside their own number block, which is what makes safe parallel writing
possible.

### 9. Quality bar (what "done" means)

- A reader who knows nothing about Typst could follow the chapter start to
  finish and come out able to do the thing.
- Every claim about Typst is true for 0.15.0 and backed by a compiled example.
- The prose sounds like a person who enjoys the subject, not a spec.
- No banned AI-tells. No filler. No padding to hit a length.
- Every example compiles cleanly. You verified it. You said so.

---

## The meta-joke

There's a pleasing recursion here. This is a book *about* writing a formal
system of rules that a machine then executes faithfully to produce a document.
The style guide above is exactly that — a formal-ish system of rules that a
machine executed faithfully to produce this document. Typst compiles markup into
pages; the style guide "compiles" a chapter brief into prose. The analogy isn't
perfect, but it's not an accident either.
