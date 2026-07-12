// The shapes a single citation can take: parenthetical, prose, author-only,
// year-only, and with a page-number locator.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 15cm, height: auto, margin: 2cm)
#set text(size: 11pt)

= Citation forms

/ Parenthetical (the default): The load matters @sweller1988.

/ Prose (name in the sentence): #cite(<sweller1988>, form: "prose")
  made the case directly.

/ Author only: The framework is due to
  #cite(<deci2000>, form: "author").

/ Year only: It was published in
  #cite(<deci2000>, form: "year").

/ With a page locator (bracket syntax): One clear statement is on
  @sweller1988[p.~262].

/ With a page range (supplement argument):
  #cite(<deci2000>, supplement: [pp.~230--231]) narrows it further.

#bibliography("refs.yml", style: "apa")
