return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  opts = {
    extra_groups = {
      "NormalFloat",
      "NvimTreeNormal",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "NeoTreeFloatNormal",
      "NeoTreeFloatBorder",
      "NeoTreeTabInactive",
      "NeoTreeTabActive",
      "NeoTreeTabSeparatorInactive",
      "NeoTreeTabSeparatorActive",
      "NeoTreeWinSeparator",
      "NeoTreeVertSplit",
      "NeoTreeStatusLine",
      "NeoTreeStatusLineNC",
      "TelescopeNormal",
      "TelescopeBorder",
      "TelescopePromptBorder",
      "TelescopePromptNormal",
      "TelescopeResultsBorder",
      "TelescopeResultsNormal",
      "TelescopePreviewBorder",
      "TelescopePreviewNormal",
      "WhichKeyFloat",
      "FloatBorder",
      "FloatTitle",
      "Pmenu",
      "PmenuSel",
      "MasonNormal",
      "LazyNormal",
      "LspInfoBorder",
      "SnacksDashboardNormal",
      "TabLine",
      "TabLineFill",
      "TabLineSel",
      "BufferLineFill",
      "BufferLineBackground",
      "BufferLineOffset",
    },
  },
  config = function(_, opts)
    local transparent = require("transparent")
    transparent.setup(opts)
    transparent.clear_prefix("NeoTree")
    transparent.clear_prefix("Telescope")
    transparent.clear_prefix("BufferLine")
    transparent.clear_prefix("WhichKey")
    vim.cmd("TransparentEnable")
  end,
}
