local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function copilot_action(action)
  local copilot = require "copilot.suggestion"
  return function()
    if copilot.is_visible() then
      copilot[action]()
      return true -- doesn't run the next command
    end
  end
end

return {
  {
    "zbirenbaum/copilot.lua",
    specs = {
      { import = "astrocommunity.completion.copilot-lua" },
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = { "zbirenbaum/copilot.lua" },
        opts = function(_, opts)
          local cmp, copilot = require "cmp", require "copilot.suggestion"
          local snip_status_ok, luasnip = pcall(require, "luasnip")
          if not snip_status_ok then return end

          if not opts.mapping then opts.mapping = {} end

          opts.mapping["<S-CR>"] = cmp.mapping(function(fallback)
            if copilot.is_visible() then
              copilot.accept()
            else
              fallback() -- If Copilot suggestion is not visible, execute default fallback (e.g., insert newline)
            end
          end, { "i", "s" }) -- "i" for insert mode, "s" for select mode

          opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" })

          opts.mapping["<C-X>"] = cmp.mapping(copilot_action "next")
          opts.mapping["<C-Z>"] = cmp.mapping(copilot_action "prev")
          opts.mapping["<C-Right>"] = cmp.mapping(copilot_action "accept_word")
          opts.mapping["<C-L>"] = cmp.mapping(copilot_action "accept_word")
          opts.mapping["<C-Down>"] = cmp.mapping(copilot_action "accept_line")
          opts.mapping["<C-J>"] = cmp.mapping(copilot_action "accept_line")
          opts.mapping["<C-C>"] = cmp.mapping(copilot_action "dismiss")
        end,
      },
      {
        "Saghen/blink.cmp",
        optional = true,
        opts = function(_, opts)
          if not opts.keymap then opts.keymap = {} end

          opts.keymap["<Tab>"] = {
            -- copilot_action "accept",
            "select_next",
            "snippet_forward",
            function(cmp)
              if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
            end,
            "fallback",
          }

          opts.keymap["<S-CR>"] = { copilot_action "accept", "fallback" }

          opts.keymap["<C-X>"] = { copilot_action "next" }
          opts.keymap["<C-Z>"] = { copilot_action "prev" }
          opts.keymap["<C-Right>"] = { copilot_action "accept_word" }
          opts.keymap["<C-L>"] = { copilot_action "accept_word" }
          opts.keymap["<C-Down>"] = { copilot_action "accept_line" }
          opts.keymap["<C-J>"] = { copilot_action "accept_line", "select_next", "fallback" }
          opts.keymap["<C-C>"] = { copilot_action "dismiss" }
        end,
      },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      {
        "folke/snacks.nvim",
        opts = {
          input = { enabled = true },
          picker = { -- Enhances `select()`
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
          },
        },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          local maps = assert(opts.mappings)
          local prefix = "<Leader>O"
          maps.n[prefix] = { desc = require("astroui").get_icon("OpenCode", 1, true) .. "OpenCode" }
          maps.n[prefix .. "a"] = {
            function() require("opencode").ask("@this: ", { submit = true }) end,
            desc = "Ask about this",
          }
          maps.n[prefix .. "+"] = {
            function() require("opencode").prompt("@buffer", { append = true }) end,
            desc = "Add buffer to prompt",
          }
          maps.n[prefix .. "e"] = {
            function() require("opencode").prompt("Explain @this and its context", { submit = true }) end,
            desc = "Explain this code",
          }
          maps.n[prefix .. "n"] = {
            function() require("opencode").command "session.new" end,
            desc = "New session",
          }
          maps.n[prefix .. "s"] = {
            function() require("opencode").select() end,
            desc = "Select prompt",
          }
          maps.n["<S-C-u>"] = {
            function() require("opencode").command "session.half.page.up" end,
            desc = "Messages half page up",
          }
          maps.n["<S-C-d>"] = {
            function() require("opencode").command "session.half.page.down" end,
            desc = "Messages half page down",
          }

          maps.v[prefix] = { desc = require("astroui").get_icon("OpenCode", 1, true) .. "OpenCode" }
          maps.v[prefix .. "a"] = {
            function() require("opencode").ask("@this: ", { submit = true }) end,
            desc = "Ask about selection",
          }
          maps.v[prefix .. "+"] = {
            function() require("opencode").prompt "@this" end,
            desc = "Add selection to prompt",
          }
          maps.v[prefix .. "s"] = {
            function() require("opencode").select() end,
            desc = "Select prompt",
          }
        end,
      },
      { "AstroNvim/astroui", opts = { icons = { OpenCode = "" } } },
    },
  },
}
