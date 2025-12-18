return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,

      smear_insert_mode = true,
      smear_operator_mode = false, -- already fixed

      legacy_computing_symbols_support = false,

      -- Snappy tuning
      distance_stop_animating = 0.25,
      max_animation_time = 45,
      time_interval = 8,

      cursor_color = "none",
    },
    config = function(_, opts)
      local smear = require "smear_cursor"
      smear.setup(opts)

      -- 🔧 Flash integration: disable smear during Flash UI
      vim.api.nvim_create_autocmd("User", {
        pattern = "FlashEnter",
        callback = function() smear.enabled = false end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "FlashLeave",
        callback = function() smear.enabled = true end,
      })
    end,
  },
}
