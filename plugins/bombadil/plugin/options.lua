vim.opt.autoindent = true
vim.opt.belloff = "all"
vim.opt.breakindent = true
vim.opt.cindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.conceallevel = 3
vim.opt.cursorline = true
vim.opt.equalalways = false
vim.opt.expandtab = true
vim.opt.exrc = true
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = " ",
  foldsep = " ",
}
vim.opt.foldenable = true
vim.opt.foldlevel = 99
-- stylua: ignore start
vim.opt.formatoptions =
  vim.opt.formatoptions
    - "a"
    + "c"
    + "j"
    + "n"
    - "o"
    + "q"
    + "r"
    - "t"
-- stylua: ignore end
vim.opt.grepprg = "rg --vimgrep --smart-case --follow"
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.laststatus = 3
vim.opt.linebreak = false
vim.opt.listchars = { space = "." }
vim.opt.modelines = 1
vim.opt.more = false
vim.opt.mouse = "n"
vim.opt.number = true
vim.opt.pumblend = 17
vim.opt.relativenumber = true
-- vim.opt.ruler = true
-- vim.opt.rulerformat = "%20(%t %y %l:%c%)"
vim.opt.scrolloff = 10
vim.opt.secure = true
vim.opt.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"
vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }
vim.opt.shortmess = vim.opt.shortmess + "a" + "F"
vim.opt.showbreak = "   "
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false

vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1 -- use shiftwidth
vim.opt.tabstop = 2

vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.updatetime = 1000
vim.opt.wildmode = { "longest", "full" }
vim.opt.wildoptions = { "pum" }
vim.opt.wrap = true
