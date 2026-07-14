return {
  "code-biscuits/nvim-biscuits",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  -- 'User AstroFile' ensures it only loads when you actually open a file, keeping startup fast
  event = "User AstroFile", 
  opts = {
    default_config = {
      max_length = 12,
      min_distance = 5,
      prefix_string = " 󰡱 ", -- A nice icon to prefix the biscuit text
    },
  },
  config = function(_, opts)
    require("nvim-biscuits").setup(opts)
  end,
}
