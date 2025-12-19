return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      -- standard jump mode
      search = {
        enabled = true,
      },
      -- OPERATOR MODE (this is what you want)
      char = {
        enabled = false,
      },
    },
    -- CUSTOMIZE COLORS HERE
    highlight = {
      -- backdrop color (dims the rest of the text)
      backdrop = true,
      -- highlight groups for the labels
      groups = {
        match = "FlashMatch", -- matched text
        current = "FlashCurrent", -- current match
        backdrop = "FlashBackdrop", -- backdrop
        label = "FlashLabel", -- the jump labels
      },
    },
  },
  keys = {
    -- Jump (normal/visual/operator)
    {
      "s",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash Jump",
    },
    -- Treesitter jump
    {
      "S",
      mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter",
    },
    -- REMOTE OPERATOR (y/d/c at a distance)
    {
      "r",
      mode = "o",
      function() require("flash").remote() end,
      desc = "Flash Remote Operator",
    },
  },
  -- ADD THIS CONFIG FUNCTION TO SET CUSTOM COLORS
  config = function(_, opts)
    require("flash").setup(opts)

    -- Define your custom colors here
    vim.api.nvim_set_hl(0, "FlashLabel", {
      fg = "#ff007c", -- bright pink/magenta
      bg = "#1a1a1a", -- dark background
      bold = true,
    })

    vim.api.nvim_set_hl(0, "FlashMatch", {
      fg = "#61afef", -- blue
      bg = "NONE",
    })

    vim.api.nvim_set_hl(0, "FlashCurrent", {
      fg = "#e5c07b", -- yellow/gold
      bg = "#3e4451",
      bold = true,
    })
  end,
}
