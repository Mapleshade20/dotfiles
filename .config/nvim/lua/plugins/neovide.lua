if not vim.g.neovide then
  return {} -- do nothing if not in a Neovide session
end

local sysname = vim.loop.os_uname().sysname

local guifont_size
-- if package.config:sub(1, 1) == "\\" then
--   guifont_size = 13
-- end
if sysname == "Linux" then
  guifont_size = 11
  vim.g.neovide_transparency = 0.4
  -- local alpha = function() return string.format("%x", math.floor(255 * vim.g.neovide_transparency)) end
  -- vim.g.neovide_background_color = "#0f1117" .. alpha()
  vim.g.neovide_background_color = "NONE"
elseif sysname == "Darwin" then -- MacOS
  guifont_size = 17
else
  guifont_size = 13 -- Windows
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = { -- configure vim.opt options
        guifont = "JetBrainsMono Nerd Font:h" .. guifont_size,
        -- line spacing
        -- linespace = 0,
      },
      g = { -- configure vim.g variables
        -- configure scaling
        -- neovide_scale_factor = 1.0,
        -- configure padding
        -- neovide_padding_top = 0,
        -- neovide_padding_bottom = 0,
        -- neovide_padding_right = 0,
        -- neovide_padding_left = 0,
      },
    },
  },
}
