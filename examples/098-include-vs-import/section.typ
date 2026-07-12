// section.typ — CONTENT. This is a chunk of the document itself: markup that is
// meant to appear on the page. main.typ pulls it in with #include, which
// splices these words wherever the #include sits. See Chapter 18.

== From the archives

This whole section lives in its own file. `#include` drops its rendered content
into the document at the point of the call — text, heading, and all.
