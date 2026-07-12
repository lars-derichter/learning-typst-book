-- github-alerts.lua — a Pandoc filter for the Learning Typst book build.
--
-- Pandoc's gfm reader turns a GitHub alert
--     > [!NOTE]
--     > text
-- into a Div with a class ("note", "tip", "important", "warning",
-- "caution") wrapping an inner Div of class "title". The Typst writer, left
-- to itself, flattens that to a plain #block and loses the alert's flavour.
--
-- This filter rewrites each alert Div into a call to a Typst function,
--     #admonition("note")[ ... the alert body ... ]
-- which the book template defines and styles. The body blocks are left as
-- ordinary Pandoc blocks so the writer still converts them normally; only
-- thin RawBlock wrappers of Typst code are added around them.
--
-- It also drops raw HTML (the <!-- SOLUTIONS --> comments in the chapters)
-- so nothing meant for the author leaks into the printed book.

local kinds = {
  note = true, tip = true, important = true,
  warning = true, caution = true,
}

function Div(el)
  for _, class in ipairs(el.classes) do
    if kinds[class] then
      -- Collect the alert body, skipping the inner ".title" Div.
      local body = {}
      for _, blk in ipairs(el.content) do
        local is_title = blk.t == "Div" and blk.classes
          and blk.classes:includes("title")
        if not is_title then
          table.insert(body, blk)
        end
      end

      local out = { pandoc.RawBlock("typst", '#admonition("' .. class .. '")[') }
      for _, blk in ipairs(body) do
        table.insert(out, blk)
      end
      table.insert(out, pandoc.RawBlock("typst", "]"))
      return out
    end
  end
  return nil
end

-- Strip HTML comments and any other raw HTML; the book is Typst-only.
function RawBlock(el)
  if el.format == "html" then
    return {}
  end
  return nil
end

-- Pandoc renders a Markdown thematic break (`---`) as a bare `#horizontalrule`,
-- which Typst has no such function for. Draw it as a faint centered rule.
function HorizontalRule()
  return pandoc.RawBlock(
    "typst",
    "#v(2pt) #align(center, line(length: 30%, stroke: 0.5pt + luma(180))) #v(2pt)"
  )
end

-- The book writes its inline and display math in *Typst* syntax inside `$...$`
-- (e.g. `$sum_(i=1)^n$`), not LaTeX. Pandoc, told to read dollar-math, hands us
-- the raw text; we wrap it straight back in Typst math delimiters so it is
-- reproduced verbatim rather than being run through the LaTeX-to-Typst
-- converter (which would mangle Typst-native spellings like `pi` or `oo`).
function Math(el)
  if el.mathtype == "InlineMath" then
    return pandoc.RawInline("typst", "$" .. el.text .. "$")
  else
    return pandoc.RawInline("typst", "$ " .. el.text .. " $")
  end
end

-- Front and back matter shouldn't eat chapter numbers. The Preface and each
-- Appendix are top-level headings, but the chapters between them should number
-- 1..N cleanly, so we emit the front/back-matter headings as *unnumbered*
-- (which Typst does not count) while leaving ordinary chapter headings alone.
-- The flag also unnumbers the *sub*sections inside the Preface and Appendices,
-- which would otherwise keep counting from the last numbered chapter (e.g.
-- "24.24"), since the unnumbered H1 above them never advanced the counter.
local numbered_body = true

function Header(el)
  local text = pandoc.utils.stringify(el)
  if el.level == 1 then
    if text == "Preface" or text:match("^Appendix") then
      numbered_body = false
      return pandoc.RawBlock(
        "typst", "#heading(level: 1, numbering: none)[" .. text .. "]"
      )
    else
      numbered_body = true
      return nil
    end
  elseif not numbered_body then
    return pandoc.RawBlock(
      "typst",
      "#heading(level: " .. el.level .. ", numbering: none)[" .. text .. "]"
    )
  end
  return nil
end
