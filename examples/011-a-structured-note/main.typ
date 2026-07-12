// A small but complete document: a meeting note that combines
// headings, emphasis, lists, a link, and a raw block.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Weekly sync --- 12 July

/ Present: Lars, Maya, Sven
/ Absent: Tom (on leave)

== Decisions

- We ship the *beta* on Friday, not Monday.
- Docs move to Typst; see #link("https://typst.app/docs")[the docs].
- Maya owns the release notes.

== Action items

+ _Lars:_ freeze the feature list by Wednesday.
+ _Sven:_ tag the release once tests pass:

  ```sh
  git tag -a v0.9.0 -m "Public beta"
  git push --tags
  ```

+ _Maya:_ draft the announcement and circulate for review.

== Notes

Turnout was good. Next sync is in two weeks---same time, same room.
