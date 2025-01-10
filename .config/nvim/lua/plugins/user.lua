-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

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
            rosewater = "#f5e0dc",
            flamingo = "#f2cdcd",
            pink = "#f5c2e7",
            mauve = "#DD97F1",
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

  {
    "windwp/nvim-ts-autotag",
    event = "BufEnter",
    config = true,
  },

  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("venv-selector").setup {
        settings = {
          options = {
            debug = true,
          },
          search = {
            mamba = {
              command = "fd 'bin/python$' $MAMBA_ROOT_PREFIX/envs --full-path --color never",
            },
          },
        },
      }
    end,
  },

  -- == Overriding Default Plugins ==

  {
    "L3MON4D3/LuaSnip",
    config = function()
      local config_path = "~/.config/nvim/lua/plugins/LuaSnip/"
      require("luasnip.loaders.from_lua").lazy_load { paths = { config_path } } -- WARNING: fails on Windows
    end,
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

  {
    "rcarriga/nvim-notify",
    opts = {
      -- fps = 60,
      -- background_colour = "NONE",
      render = "compact",
      stages = "static",
    },
  },

  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        "       ████ ██████           █████      ██",
        "      ███████████             █████ ",
        "      █████████ ███████████████████ ███   ███████████",
        "     █████████  ███    █████████████ █████ ██████████████",
        "    █████████ ██████████ █████████ █████ █████ ████ █████",
        "  ███████████ ███    ███ █████████ █████ █████ ████ █████",
        " ██████  █████████████████████ ████ █████ █████ ████ ██████",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  --{ "max397574/better-escape.nvim", enabled = false },
  -- { "nmac427/guess-indent.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
}
