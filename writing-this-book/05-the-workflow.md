# The workflow

The plan described the *shape* of the work. This is how it actually ran, tool by
tool, decision by decision — the part that turns "an AI wrote a book" from a
vague claim into a reproducible process.

## The cast

- **The managing editor.** One long-running Claude instance (in the Claude Code
  agent harness) that owned the whole job: it scaffolded the repository, wrote
  the voice-setting chapters itself, delegated the rest, quality-checked
  everything, and made every commit. It never let a sub-agent commit.
- **Chapter sub-agents.** Short-lived Claude instances, each spawned with one
  job: write a single chapter and build its examples. Each started cold, read
  the style brief and the two exemplar chapters, did its chapter, verified its
  examples, and reported back. Then it was gone.
- **Two real tools, not simulations.** Typst 0.15.0 compiled every example.
  Pandoc 3.10 (in the capstone) converted the book's Markdown to Typst. Nothing
  about the output was imagined; a compiler checked it.

## The loop, per chapter

1. **Dispatch.** The managing editor spawned a sub-agent with a detailed brief:
   the chapter's outline, its slice of the example-numbering space, the style
   guide, and the verification contract. Chapters with no dependency on each
   other went out in parallel batches.
2. **Draft + self-verify.** The sub-agent wrote the chapter and built its
   examples, compiling each one against Typst until it was clean, then reported
   exactly which files it had created and pasted its compile output as proof.
3. **Quality control.** The managing editor read the whole chapter for accuracy
   and voice, then — this is the important bit — **re-compiled every example
   itself**, from scratch, rather than trusting the sub-agent's report. It also
   ran a character-aware line-width check and scanned for banned phrases.
4. **Fix or bounce.** Small issues (a line one column too long, a slightly weak
   sentence) the editor fixed inline. A chapter that missed the bar in a
   structural way would be handed back to a *fresh* sub-agent with specific
   notes — cheaper and cleaner than arguing with the original.
5. **Render + commit.** Once a chapter passed, the editor rendered each example
   to a committed `out.pdf` and `out.png`, and made one atomic commit for that
   chapter and its examples. Then on to the next.

## Verification as a first-class citizen

The single most important design choice was making "every example works" a
*mechanical* guarantee rather than a matter of trust. Two scripts enforce it:

- `scripts/build-examples.sh` walks every example folder, compiles it to a PDF,
  renders a preview PNG, and **exits non-zero if anything breaks**. Examples
  that are *meant* to fail (they teach an error message) carry a marker file,
  and the script asserts that they fail. Run it and either everything is green
  or the build tells you precisely what isn't.
- `scripts/build-book.sh` (the capstone) runs the whole Markdown-to-PDF
  pipeline, so the claim "this book can typeset itself" is something you can
  check in one command, not something you have to believe.

Because of this, an AI hallucinating a function that doesn't exist — the usual
failure mode for AI-written code — simply couldn't survive to the page. It would
fail to compile, the build would go red, and QC would catch it. The compiler is
an unforgiving, tireless reviewer, and leaning on it hard is most of why the
code in this book can be trusted.

## Atomic commits: the audit trail

Every unit of work is its own commit on the `write-book` branch, made only after
inspection:

```
Scaffold repo: README, license, and example build script
Add preface
Add Chapter 1: Why Typst?
Add Chapter 2: Getting Typst running
…
```

This does more than tidy the history. It makes the whole run **reviewable** (you
can read the book's construction commit by commit), **resumable** (a long job
can stop and restart without losing work), and **honest** (nothing lands without
passing through the quality gate that its commit represents). If you want to see
how the book was actually built, `git log` is the real record; this folder is
just the narrated version.

## Why not just let one model write the whole thing?

It could have. The reason it didn't is quality control at scale. A single model
writing twenty-four chapters in one long sitting tends to drift — the voice
wanders, earlier decisions get forgotten, and errors compound with no checkpoint
to catch them. Splitting the roles fixes this:

- The **sub-agents** each hold only one chapter in their head, so they stay
  sharp and on-brief.
- The **managing editor** holds the *standard* — the voice, the numbering, the
  cross-references, the verification — and applies it uniformly to everyone's
  output.

It's the same reason human publishing separates writers from editors. The editor
isn't a better writer than the writers; the editor is the one keeping the whole
thing coherent and honest. Giving that role explicitly to one AI, and the
writing to others, is what let a large job stay at a high standard from the
first page to the last.
