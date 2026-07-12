// A small but real document generated from one array of data: a workshop
// schedule. Change the data and the whole page — table rows and the computed
// total — rebuilds itself.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 13cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

// The single source of truth. Everything below is computed from it.
#let sessions = (
  ("09:00", "Welcome & setup", 30),
  ("09:30", "Markup basics", 60),
  ("10:30", "Coffee break", 15),
  ("10:45", "Styling with rules", 75),
  ("12:00", "Lunch", 60),
)

// Accumulate the total scheduled minutes in a running variable.
#let minutes = 0
#for (time, session, length) in sessions {
  minutes = minutes + length
}

= Typst workshop --- schedule

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, right),
  stroke: (x: none, y: 0.5pt + gray),
  inset: 8pt,
  table.header([*Time*], [*Session*], [*Min*]),
  // Spread one row per data record straight into the table.
  ..for (time, session, length) in sessions {
    (time, session, [#length])
  }
)

Total scheduled: *#minutes minutes* (#{ minutes / 60 } hours) across
#sessions.len() sessions.
