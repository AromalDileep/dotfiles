-- AstroCommunity: import any community modules here
-- This file is imported before the plugins/ folder

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Language packs (keep existing behavior)
  { import = "astrocommunity.pack.lua" },

  -- Colorscheme: Catppuccin
  { import = "astrocommunity.colorscheme.catppuccin" },
}

