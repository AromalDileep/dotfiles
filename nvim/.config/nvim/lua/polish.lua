-- This runs LAST in AstroNvim startup
-- Used to enforce transparency after all plugins & colorschemes

local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "CursorLine",
  "FoldColumn",
  "EndOfBuffer",
  "VertSplit",
  "WinSeparator",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "WinBar",
  "WinBarNC",

  -- NeoTree
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NeoTreeEndOfBuffer",
  "NeoTreeTabInactive",
  "NeoTreeTabActive",
  "NeoTreeTabSeparatorInactive",
  "NeoTreeTabSeparatorActive",
  "NeoTreeWinSeparator",
  "NeoTreeVertSplit",
  "NeoTreeStatusLine",
  "NeoTreeStatusLineNC",

  -- Telescope
  "TelescopeNormal",
  "TelescopeBorder",
}

local function make_transparent()
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE" })
  end
end

-- Apply on every colorscheme change (CRITICAL)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = make_transparent,
})

-- Apply once on startup
make_transparent()
