local ls = require "luasnip"
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("html", {
  s({ trig = "html", name = "HTML Boilerplate" }, {
    t {
      "<!DOCTYPE html>",
      '<html lang="en">',
      "<head>",
      '  <meta charset="UTF-8">',
      '  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
      "  <title>",
    },
    i(1, "YourTitle"),
    t { "</title>", "</head>", "<body>", "  " },
    i(2),
    t { "", "</body>", "</html>" },
  }),
})
