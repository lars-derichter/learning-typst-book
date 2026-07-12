// The workhorse shape: an array of dictionaries, one dictionary per record.
// Loop over the records to pull fields, and use filter/map/sorted to reshape
// the whole dataset at once.
// See Chapter 16, "Arrays, dictionaries, and strings".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let pioneers = (
  (name: "Ada Lovelace", born: 1815, field: "computing"),
  (name: "Grace Hopper", born: 1906, field: "computing"),
  (name: "Alan Turing",  born: 1912, field: "logic"),
  (name: "Emmy Noether", born: 1882, field: "algebra"),
)

// iterate the records, reaching into each one by field
#for p in pioneers [
  - *#p.name* (b. #p.born) --- #p.field
]

// pull a single field from every record
Everyone: #pioneers.map(p => p.name).join(", ").

// filter first, then map -- the two compose cleanly
#let computing = pioneers.filter(p => p.field == "computing").map(p => p.name)
The computing people: #computing.join(" and ").

// sort the records by a field, then loop the sorted result
Eldest first:
#for p in pioneers.sorted(key: p => p.born) [
  \ #p.born --- #p.name
]
