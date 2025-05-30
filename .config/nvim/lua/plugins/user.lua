-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {

  -- == Adding Plugins ==

  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      {
        "gD",
        "<CMD>Glance definitions<CR>",
        desc = "Glance Definitions",
      },
      {
        "gR",
        "<CMD>Glance references<CR>",
        desc = "Glance References",
      },
      {
        "gY",
        "<CMD>Glance type_definitions<CR>",
        desc = "Glance Type Definitions",
      },
      {
        "gM",
        "<CMD>Glance implementations<CR>",
        desc = "Glance Implementations",
      },
    },
  },

  {
    "karb94/neoscroll.nvim",
    config = true,
    opts = {},
  },

  {
    "gbprod/cutlass.nvim",
    event = "BufEnter",
    config = true,
    opts = {
      cut_key = "m",
    },
  },

  {
    "kylechui/nvim-surround",
    event = "BufEnter",
    config = true,
  },

  -- Auto-tagging HTML/XML tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },

  {
    "brianhuster/live-preview.nvim",
    lazy = true,
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        transparent_background = true, -- disables setting background color.
        color_overrides = {
          mocha = {
            red = "#FF838B",
            maroon = "#FF838B",
            peach = "#DFAB25",
            yellow = "#DFAB25",
            green = "#87C05F",
            teal = "#4AC2B8",
            sky = "#A3A3AF",
            sapphire = "#74c7ec",
            blue = "#5EB7FF",
            lavender = "#FF838B",
            text = "#A3A3AF",
            subtext1 = "#bac2de",
            subtext0 = "#a6adc8",
            overlay2 = "#6f6f7f",
            overlay1 = "#7f849c",
            overlay0 = "#6c7086",
            surface2 = "#585b70",
            surface1 = "#45475a",
            surface0 = "#313244",
            base = "#1A1D23",
            mantle = "#1A1D23",
            crust = "#1A1D23",
          },
        },
        custom_highlights = function(colors)
          return {
            -- VSCode风格的高亮
            ["@keyword"] = { fg = "#569CD6" },
            ["@keyword.function"] = { fg = "#569CD6" },
            ["@keyword.return"] = { fg = "#569CD6" },
            ["@keyword.operator"] = { fg = "#569CD6" },

            -- C++特定关键词样式
            ["@keyword.cpp"] = { fg = "#569CD6" },
            ["@type.builtin.cpp"] = { fg = "#569CD6" },
            ["@type.qualifier.cpp"] = { fg = "#569CD6" },
            ["@storage.class.cpp"] = { fg = "#569CD6" },
            ["@storage.modifier.cpp"] = { fg = "#569CD6" },

            -- 类关键词和访问修饰符
            ["@module"] = { fg = "#4EC9B0" }, -- 类型名称为青色
            ["@type"] = { fg = "#4EC9B0" },
            ["@type.builtin"] = { fg = "#569CD6" },
            ["@type.qualifier"] = { fg = "#569CD6" },
            ["@type.definition"] = { fg = "#4EC9B0" },

            -- 函数和方法调用
            ["@function"] = { fg = "#DCDCAA" },
            ["@function.call"] = { fg = "#DCDCAA" },
            ["@function.method"] = { fg = "#DCDCAA" },
            ["@function.method.call"] = { fg = "#DCDCAA" },
            ["@function.builtin"] = { fg = "#DCDCAA" },
            ["@function.macro"] = { fg = "#DCDCAA" },

            -- 变量和成员
            ["@variable"] = { fg = "#A5DFFE" },
            ["@variable.member"] = { fg = "#A5DFFE" },
            ["@property"] = { fg = "#A5DFFE" },

            -- 字符串和常量
            ["@string"] = { fg = "#CE9178" },
            ["@number"] = { fg = "#B5CEA8" },
            ["@boolean"] = { fg = "#569CD6" },

            -- 注释
            ["@comment"] = { fg = "#597F49", style = { "italic" } },

            -- 符号
            ["@punctuation.bracket"] = { fg = "#C98ADB" },
          }
        end,
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }
      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  -- == Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            "       ████ ██████           █████      ██                    ",
            "      ███████████             █████                            ",
            "      █████████ ███████████████████ ███   ███████████  ",
            "     █████████  ███    █████████████ █████ ██████████████  ",
            "    █████████ ██████████ █████████ █████ █████ ████ █████  ",
            "  ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
            " ██████  █████████████████████ ████ █████ █████ ████ ██████",
          }, "\n"),
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_gitignored = false,
          hide_by_pattern = {
            "*.dSYM",
          },
          always_show = {
            ".gitignore",
          },
          never_show = {
            ".DS_Store",
          },
        },
        follow_current_file = {
          enabled = true,
        },
      },
    },
  },

  -- {
  --   "rcarriga/nvim-notify",
  --   opts = {
  --     -- fps = 60,
  --     -- background_colour = "NONE",
  --     render = "compact",
  --     stages = "static",
  --   },
  -- },
}
