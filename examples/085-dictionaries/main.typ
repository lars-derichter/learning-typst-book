// Dictionaries store values under string keys. Read a field with dot syntax or
// with .at(), list the keys/values/pairs, and grow or shrink the dictionary
// with .insert() and .remove().
// See Chapter 16, "Arrays, dictionaries, and strings".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let ada = (
  name: "Ada Lovelace",
  born: 1815,
  field: "computing",
)

#ada.name was born in #ada.born and worked in #ada.field.
The dot form `ada.field` and the string form `ada.at("field")` fetch the
same value: #ada.at("field").

Keys: #ada.keys().join(", ").
Values, as text: #ada.values().map(str).join(", ").
The record has #ada.pairs().len() key--value pairs.

#{
  let record = ada
  record.insert("died", 1852)
  let dropped = record.remove("field")
  [Insert a death year, then remove the "field" key --- .remove hands back
   its value ("#dropped"). The record now holds: #record.keys().join(", ").]
}

Because assignment copies the value, the original is untouched:
"died" in ada is #("died" in ada).
