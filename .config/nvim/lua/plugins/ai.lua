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

local prefix = "<Leader>a"

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
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has "win32" ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "User AstroFile", -- load on file open because Avante manages it's own bindings
    cmd = {
      "AvanteAsk",
      "AvanteBuild",
      "AvanteEdit",
      "AvanteRefresh",
      "AvanteSwitchProvider",
      "AvanteShowRepoMap",
      "AvanteModels",
      "AvanteChat",
      "AvanteToggle",
      "AvanteClear",
      "AvanteFocus",
      "AvanteStop",
    },

    ---@module 'avante'
    ---@type avante.Config
    opts = {
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      ---@type Provider
      provider = "copilot", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
      ---@alias Mode "agentic" | "legacy"
      ---@type Mode
      mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
      -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
      -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
      -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
        auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
        -- Examples:
        -- auto_approve_tool_permissions = true,                -- Auto-approve all tools (no prompts)
        -- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
      },
      prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
        enabled = true, -- toggle logging entirely
        log_dir = vim.fn.stdpath "cache" .. "/avante_prompts", -- directory where logs are saved
        fortune_cookie_on_success = false, -- shows a random fortune after each logged prompt (requires `fortune` installed)
        next_prompt = {
          normal = "<C-n>", -- load the next (newer) prompt log in normal mode
          insert = "<C-n>",
        },
        prev_prompt = {
          normal = "<C-p>", -- load the previous (older) prompt log in normal mode
          insert = "<C-p>",
        },
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]c",
          prev = "[c",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        cancel = {
          normal = { "<C-c>", "<Esc>", "q" },
          insert = { "<C-c>" },
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          retry_user_request = "r",
          edit_user_request = "e",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
          remove_file = "d",
          add_file = "@",
          close = { "<Esc>", "q" },
          close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
        },
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = "center", -- left, center, right for title
          rounded = true,
        },
        spinner = {
          thinking = { "🤯", "🙄" }, -- Spinner characters for the 'thinking' state
        },
        input = {
          prefix = "> ",
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          border = "rounded",
          start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
          floating = false, -- Open the 'AvanteAsk' prompt in a floating window
          start_insert = true, -- Start insert mode when opening the ask window
          border = "rounded",
          ---@type "ours" | "theirs"
          focus_on_apply = "ours", -- which diff to focus after applying
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
        --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --- Disable by setting to -1.
        override_timeoutlen = 500,
      },
      suggestion = {
        debounce = 600,
        throttle = 600,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "folke/snacks.nvim", -- for input provider snacks
      "echasnovski/mini.icons", -- for icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Avante" } end },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- make sure `Avante` is added as a filetype
        "OXY2DEV/markview.nvim",
        opts = function(_, opts)
          if not opts.preview then opts.preview = {} end
          if not opts.preview.filetypes then opts.preview.filetypes = { "markdown", "quarto", "rmd" } end
          opts.preview.filetypes = require("astrocore").list_insert_unique(opts.preview.filetypes, { "Avante" })
        end,
      },
    },
    specs = { -- configure optional plugins
      { "AstroNvim/astroui", opts = { icons = { Avante = "" } } },
      {
        "Kaiser-Yang/blink-cmp-avante",
        lazy = true,
        specs = {
          {
            "Saghen/blink.cmp",
            optional = true,
            opts = {
              sources = {
                default = { "avante" },
                providers = {
                  avante = { module = "blink-cmp-avante", name = "Avante" },
                },
              },
            },
          },
        },
      },
      {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
        opts = {
          filesystem = {
            commands = {
              avante_add_files = function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                local relative_path = require("avante.utils").relative_path(filepath)

                local sidebar = require("avante").get()

                local open = sidebar:is_open()
                -- ensure avante sidebar is open
                if not open then
                  require("avante.api").ask()
                  sidebar = require("avante").get()
                end

                sidebar.file_selector:add_selected_file(relative_path)

                -- remove neo tree buffer
                if not open then sidebar.file_selector:remove_selected_file "neo-tree filesystem [1]" end
              end,
            },
            window = {
              mappings = {
                ["oa"] = "avante_add_files",
              },
            },
          },
        },
      },
    },
  },

  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {
  --     adapters = {
  --       copilot = function()
  --         return require("codecompanion.adapters").extend("copilot", {
  --           schema = {
  --             model = {
  --               default = "gemini-2.5-pro",
  --             },
  --           },
  --         })
  --       end,
  --     },
  --     strategies = {
  --       chat = {
  --         adapter = "copilot",
  --       },
  --       inline = {
  --         adapter = "copilot",
  --       },
  --     },
  --     display = {
  --       chat = {
  --         -- show_settings = true,
  --       },
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "zbirenbaum/copilot.lua",
  --   },
  --   keys = {
  --     {
  --       "<C-a>",
  --       "<cmd>CodeCompanionActions<CR>",
  --       desc = "Open CodeCompanion action palette",
  --     },
  --     {
  --       "<Leader>A",
  --       "<cmd>CodeCompanionChat Toggle<CR>",
  --       desc = "CodeCompanion Chat",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "ga",
  --       "<cmd>CodeCompanionChat Add<CR>",
  --       desc = "Add selected to chat buffer",
  --       mode = { "n", "v" },
  --     },
  --   },
  -- },
}
