// A fuller APA example: five sources of different types (book, journal
// articles by one, two, and three authors, and a web page), mixed prose
// and parenthetical cites, and an APA reference list titled "References".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 15cm, height: auto, margin: 2cm)
#set text(size: 11pt)
#set par(justify: true)

= Feedback and cognitive load

#cite(<sweller1988>, form: "prose") showed that instruction which overloads
working memory hurts learning rather than helping it. Feedback is one of the
strongest levers a teacher has, but only when it lands on a manageable load
@hattie2007. Motivation matters too: learners persist when the work meets
their needs for competence and autonomy @deci2000.

None of this is new in spirit. #cite(<mcluhan1964>, form: "prose") argued
sixty years ago that the medium of instruction shapes the message as much as
its content does. What is new is the tooling: Typst's own documentation
explains how to wire up citations in a single compile pass @typst-bib.

#bibliography("refs.yml", title: [References], style: "apa")
