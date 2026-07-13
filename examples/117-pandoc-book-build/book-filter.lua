-- book-filter.lua — a Pandoc filter for the Learning Typst book build.
--
-- It shapes Pandoc's Markdown-to-Typst conversion so the result is a real book:
--
--  * GitHub alerts (`> [!NOTE]`) become the template's #note/#tip/#important/
--    #warning/#caution admonition boxes.
--  * Typst-syntax math inside `$...$` is passed through verbatim (Pandoc would
--    otherwise treat it as LaTeX and mangle spellings like `pi` or `oo`).
--  * Markdown thematic breaks (`---`) become a faint rule.
--  * The <!-- SOLUTIONS --> HTML comments are dropped.
--  * The Preface and Appendices (and their subsections) are left unnumbered, so
--    the chapters number 1..N cleanly.
--  * Each chapter heading gets a label matching its file name, and links between
--    chapters (`[Appendix A](25-...md)`) become internal PDF jumps to it, while
--    links to example folders (`../examples/003-.../`) become working GitHub
--    URLs — instead of dead relative paths that render oddly in a PDF.
--
-- The build runs this filter once per chapter file, passing the file's base name
-- in the CHAPTER_NAME environment variable so the heading label can match it.

local repo_base =
  "https://github.com/lars-derichter/learning-typst-book/tree/main/"

-- Set per file by the build script (basename without .md, e.g. "01-why-typst").
local chapter_name = os.getenv("CHAPTER_NAME")

-- === Admonitions ===========================================================
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

      -- The template exports a function per kind: #note, #tip, #important, …
      local out = { pandoc.RawBlock("typst", "#" .. class .. "[") }
      for _, blk in ipairs(body) do
        table.insert(out, blk)
      end
      table.insert(out, pandoc.RawBlock("typst", "]"))
      return out
    end
  end
  return nil
end

-- === Raw HTML (drop the SOLUTIONS comments) ================================
function RawBlock(el)
  if el.format == "html" then
    return {}
  end
  return nil
end

-- === Thematic breaks =======================================================
function HorizontalRule()
  return pandoc.RawBlock(
    "typst",
    "#v(2pt) #align(center, line(length: 30%, stroke: 0.5pt + luma(180))) #v(2pt)"
  )
end

-- === Math (pass Typst-syntax math through untouched) =======================
function Math(el)
  if el.mathtype == "InlineMath" then
    return pandoc.RawInline("typst", "$" .. el.text .. "$")
  else
    return pandoc.RawInline("typst", "$ " .. el.text .. " $")
  end
end

-- === Links =================================================================
-- Turn the two kinds of in-repository link into something that works in a PDF.
function Link(el)
  local target = el.target

  -- External links are already fine.
  if target:match("^https?://") then
    return nil
  end

  -- Links into the examples/ folder point at real files in the repository, so
  -- send them to GitHub, keeping the visible text (a code span) intact.
  local repo_path = target:match("^%.%./(examples.*)$")
    or target:match("^(examples.*)$")
  if repo_path then
    el.target = repo_base .. repo_path
    return el
  end

  -- A link to another chapter/appendix Markdown file becomes an internal jump
  -- to that chapter's label (see Header). We land on the chapter, ignoring any
  -- #anchor. The visible text is spliced back in so its formatting survives.
  local md = target:match("^([%w%-]+)%.md")
  if md then
    local out = { pandoc.RawInline("typst", "#link(<" .. md .. ">)[") }
    for _, inl in ipairs(el.content) do
      out[#out + 1] = inl
    end
    out[#out + 1] = pandoc.RawInline("typst", "]")
    return out
  end

  return nil
end

-- === Headings ==============================================================
-- Level-1 headings become chapter openers in the template. We emit them as
-- explicit `#heading` calls so we can (a) attach a label matching the file name
-- (the anchor the cross-chapter links jump to) and (b) leave the Preface and
-- Appendices — and their subsections — unnumbered, so the numbered chapters
-- read 1..N and front/back matter stays clean.
local numbered_body = true

function Header(el)
  local text = pandoc.utils.stringify(el)
  local label = ""
  if chapter_name and chapter_name ~= "" then
    label = " <" .. chapter_name .. ">"
  end

  if el.level == 1 then
    local num = ""
    if text == "Preface" or text:match("^Appendix") then
      num = ", numbering: none"
      numbered_body = false
    else
      numbered_body = true
    end
    return pandoc.RawBlock(
      "typst",
      "#heading(level: 1" .. num .. ")[" .. text .. "]" .. label
    )
  elseif not numbered_body then
    return pandoc.RawBlock(
      "typst",
      "#heading(level: " .. el.level .. ", numbering: none)[" .. text .. "]"
    )
  end
  return nil
end

-- === Code listings: keep the intro with the code, and show the output ======
-- The book teaches by example. A code listing is almost always introduced by a
-- sentence ending in a colon ("... start to finish (`examples/030-basic-table/`):"),
-- and every example ships a small render (out.png). This pass, run over the
-- top-level block stream after the element rewrites above:
--
--   * wraps a colon-intro paragraph and its listing in `#keep[…]` so the pair is
--     sticky and never strands the intro (and its heading) at a page foot; and
--   * when the intro names an `examples/NNN-slug/` folder and the listing is
--     Typst, drops that example's render in beneath the code with `#preview(…)`.
--
-- Both `keep` and `preview` come from the template (previews.typ), imported in
-- head.typ. Some examples have no meaningful still render, so they never preview:
local preview_denylist = {
  ["117-pandoc-book-build"] = true, -- its out.png is the book's own title page
}

-- The example folder named in an intro, e.g. "030-basic-table".
local function example_slug(block)
  return pandoc.utils.stringify(block):match("examples/(%d%d%d%-[%w%-]+)")
end

-- A paragraph that ends in a colon is introducing whatever block follows it.
local function is_code_intro(block)
  return block.t == "Para"
    and pandoc.utils.stringify(block):match(":%s*$") ~= nil
end

-- Is this a Typst listing (so its example's render is what the code produces)?
local function is_typst_code(block)
  if block.t ~= "CodeBlock" then return false end
  local lang = block.classes[1]
  return lang == "typ" or lang == "typst"
end

function Pandoc(doc)
  local blocks = doc.blocks
  local out = {}
  local i = 1
  while i <= #blocks do
    local here = blocks[i]
    local nxt = blocks[i + 1]

    if nxt and nxt.t == "CodeBlock" and is_code_intro(here) then
      -- Glue the intro line to its listing.
      table.insert(out, pandoc.RawBlock("typst", "#keep["))
      table.insert(out, here)
      table.insert(out, pandoc.RawBlock("typst", "]"))

      local slug = example_slug(here)
      if slug and is_typst_code(nxt) and not preview_denylist[slug] then
        -- Keep the listing with its render, then show the render.
        table.insert(out, pandoc.RawBlock("typst", "#keep["))
        table.insert(out, nxt)
        table.insert(out, pandoc.RawBlock("typst", "]"))
        table.insert(out, pandoc.RawBlock(
          "typst", '#preview("/examples/' .. slug .. '/out.png")'))
      else
        table.insert(out, nxt)
      end
      i = i + 2
    else
      table.insert(out, here)
      i = i + 1
    end
  end
  doc.blocks = out
  return doc
end
