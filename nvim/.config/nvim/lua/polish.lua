-- This runs LAST in AstroNvim startup

-- Prevent accidentally quitting Neovim with <Leader>q by asking for confirmation.
vim.keymap.set("n", "<Leader>q", function()
  local choice = vim.fn.confirm("Quit Neovim?", "&Yes\n&No", 2)

  if choice == 1 then vim.cmd "qa" end
end, { desc = "Quit Neovim (confirm)" })
