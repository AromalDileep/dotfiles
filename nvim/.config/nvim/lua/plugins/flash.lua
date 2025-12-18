return {
  {
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
          enabled = true,
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
  },
}
