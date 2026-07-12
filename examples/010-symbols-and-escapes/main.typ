// Dashes, non-breaking space, ellipsis, escapes, Unicode, comments.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Symbols and escapes

Two hyphens make an en dash for ranges: pages 12--18.
Three make an em dash for a break in thought---like this one.
Three dots become a proper ellipsis... see?

// This line is a comment and never appears in the output.
A non-breaking space keeps a value glued to its unit: 10~kg. /* inline
block comments work too */

To print a literal special character, escape it with a backslash:
\*not strong\*, a real \# hash, and an \_underscore\_.

And any character by codepoint with a Unicode escape:
\u{2713} done, \u{2192} onward.
