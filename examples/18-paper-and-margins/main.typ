// Page size and margins. The margin is one argument — a single length for
// all four sides, or a dictionary to set them apart.
// Compile with:  typst compile main.typ out.pdf
//
// A real paper size would be `paper: "a4"` (or "us-letter"); we use a small
// fixed page here so the margins are visible in the preview. For landscape,
// add `flipped: true` and Typst swaps width and height for you.
#set page(
  width: 9cm,
  height: 12cm,
  margin: (x: 1cm, y: 2cm), // wide top/bottom, narrow left/right
)

= The margin box

Everything you type lives inside the margins. Here the left and right margins
are 1cm and the top and bottom are 2cm, so the text block is tall and narrow.
Change the numbers and the block moves with them.

#lorem(45)
