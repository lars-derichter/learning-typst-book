# The plan

With the scoping questions answered, the AI wrote an implementation plan. It did
*not* get approved on the first try — and that's the interesting part.

## Two rounds of feedback

Lars read the first draft of the plan and sent it back twice, each time with a
short, pointed instruction that changed how the work would be done:

> For workflow: You are the central manager and you are in charge of quality
> control. Use agents to do most of the main work, only step in yourself for
> simple inline fixes or when quality does not meet the standard.

> Make atomic commits: when a chapter is finished, when an example was created,
> etc. Only commit after a quality inspection.

Neither comment touched the book's *content* — the table of contents, the depth,
the capstone were all fine. Both were about *process*: who does the writing, and
how the work is checkpointed. The first turned the AI from an author into a
managing editor with a team of sub-agents. The second imposed a discipline of
small, inspected commits so the long run would be reviewable and resumable
rather than one giant undifferentiated diff.

This is worth dwelling on. The highest-leverage human input on a big AI job is
often not "write it differently" but "*work* differently." A plan can be
factually complete and still have the wrong shape of labor. Catching that before
execution — while it's still cheap to change — is exactly what a
plan-and-approve step is for.

The version below is the final plan, as approved, with both pieces of feedback
already folded in (see especially the "Workflow" section).

---

## The approved plan

### Context

Lars wants a complete, book-length introduction to the Typst typesetting system,
written in the register of a classic O'Reilly *Learning* book (the *Learning
Perl* lineage: warm, funny, genuinely readable, but thorough and high-quality).
No such book exists yet. It is primarily for his own learning and to share under
a non-commercial license.

The toolchain was verified up front: **Typst 0.15.0** on `PATH` (bundles its own
fonts, so examples compile anywhere), and **Pandoc 3.10** with a working native
`typst` writer. This means every code example can be compiled and verified, and
the "book typesets itself" capstone can genuinely build a PDF two ways: from
hand-authored Typst, and from the book's own Markdown via Pandoc.

**Decisions locked with Lars:** general lightly-technical audience (no LaTeX or
programming assumed); comprehensive depth (authoring *and* the full scripting
language, packages, templates, advanced topics); capstone = a reusable
O'Reilly-style Typst template plus some real chapters, *plus* a Pandoc
Markdown↔Typst part complete enough to typeset the whole book; every example
compiled and committed with a rendered PDF + preview PNG.

### Deliverable: repository layout

```
README.md                     # blurb, full annotated TOC, how-to-build
LICENSE                       # CC BY-NC-SA 4.0 (official legal code)
book/                         # the book text, one NN-slug.md per chapter
examples/                     # runnable code, one NN subfolder per example
  NN-.../ main.typ, out.pdf, out.png, README.md
  NN-oreilly-book-template/   # capstone A: hand-authored Typst book
  NN-pandoc-book-build/       # capstone B: Pandoc pipeline for the whole book
scripts/
  build-examples.sh           # compile every example -> pdf + png
  build-book.sh               # pandoc(book/*.md) -> typst -> the whole book PDF
```

Everything kebab-case. Example folders use a single global running number `NN`;
each chapter names the example numbers it uses.

### Table of contents

Six parts, 24 chapters, a preface, and five appendices:

- **Part I — Meeting Typst** (1–3): why Typst; getting it running; markup
  basics.
- **Part II — Everyday documents** (4–8): text and fonts; pages and layout;
  figures; tables and grids; math.
- **Part III — Styling** (9–12): set rules; show rules; references; citations
  and bibliographies (including APA).
- **Part IV — Programming Typst** (13–17): markup vs code and the type system;
  functions and closures; control flow; arrays/dictionaries/strings; context,
  state, and counters.
- **Part V — Reusable design** (18–21): your own functions; templates; packages
  (using and publishing); advanced layout and escape hatches.
- **Part VI — The book typesets itself** (22–24): designing an O'Reilly-style
  Typst book template; building the book; the Pandoc bridge that typesets this
  whole book.
- **Appendices A–E:** exercise solutions; LaTeX→Typst map; Word→Typst map; a
  quick-reference cheat sheet; resources.

### Style, examples, and verification

- Voice: conversational, dry humour, second person, forward momentum; sentence
  case; GitHub alerts as the O'Reilly "boxes"; "Coming from LaTeX/Word"
  sidebars; exercises per chapter with solutions in Appendix A. A written list
  of banned "AI tells."
- Each example: `main.typ` + `README.md` + committed `out.pdf` and `out.png`.
- `scripts/build-examples.sh` compiles and renders every example and *fails
  loudly* on any breakage, so "verified" is enforced, not claimed.

### Workflow: orchestration, quality control, and commits

The AI acts as the **central manager and quality gate**. Sub-agents do most of
the drafting and example-building; the manager steps in only for small inline
fixes or when quality falls short — and inspects everything before it's
committed.

- **Anchor the voice first.** The manager personally writes the preface and
  Chapter 1, plus a written style brief. Those two chapters become the exemplar
  every sub-agent imitates.
- **Delegate drafting.** For each remaining chapter, a sub-agent gets the
  chapter outline, the style brief, its assigned example-number range, and the
  verification contract. It must produce the chapter *and* compile its examples.
- **Quality control, every time, before any commit.** The manager reads the
  chapter for accuracy and voice, independently *re-compiles* every example
  (never trusting a reported "it compiles"), fixes small issues inline, and
  bounces a whole chapter back to a fresh agent if it misses the bar.
- **Atomic commits, only after QC passes.** Work happens on a `write-book`
  branch; one focused commit per verified unit (each example, each finished
  chapter, scaffold, license, each capstone piece, each appendix).

### Execution order

1. Scaffold + anchor (branch, README, LICENSE, scripts, style brief,
   hand-written preface and Chapter 1).
2. Delegate Parts I–VI in batches; QC, fix/bounce, commit each atomically.
3. Capstone: build the Typst template and the Pandoc pipeline; run both builds
   end to end.
4. Appendices (solutions depend on the final exercises, so they come last).
5. Final pass: run both build scripts clean; verify every cross-reference and
   example number resolves; a voice/consistency sweep.

### Verification

- `scripts/build-examples.sh` exits 0; every example folder has a fresh
  `out.pdf` + `out.png`.
- `scripts/build-book.sh` produces the whole-book PDF from `book/*.md` with no
  errors.
- README TOC links point at real files; every referenced example number exists.

---

## A later addition

After execution was already under way, Lars asked for one more thing: this very
folder, `writing-this-book/`, documenting the process — because he intends to
reuse the repository as an example of using generative AI in a meaningful,
quality-controlled way. It was slotted in as an independent deliverable, written
in parallel with the chapters it describes. Plans are allowed to grow; the trick
is to add work as clean, self-contained units rather than by disturbing what's
already in flight.
