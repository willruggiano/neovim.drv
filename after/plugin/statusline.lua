vim.opt.cmdheight = 0
vim.opt.laststatus = 3

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("BanishStatusline", { clear = true }),
  callback = function()
    if vim.v.event.new_mode == "c" then
      vim.opt.laststatus = 0
    elseif vim.v.event.old_mode == "c" then
      vim.opt.laststatus = 3
    end

    pcall(function()
      vim.cmd.redraw { mods = { emsg_silent = true } }
    end)
  end,
})
