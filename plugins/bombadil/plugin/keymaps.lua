local jump = require "bombadil.lib.jump"
local keymap = require "bombadil.lib.keymap"

local noremap = keymap.noremap
local inoremap = keymap.inoremap
local nnoremap = keymap.nnoremap
local tnoremap = keymap.tnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap

-- Add large jumps to the jump list
for _, d in ipairs { "j", "k" } do
  nnoremap(d, function()
    jump(d)
  end)
end

-- Opens line above or below the current line
inoremap("<C-k>", "<C-o>O")
inoremap("<C-j>", "<C-o>o")

-- Better pane navigation
nnoremap("<C-j>", "<C-w><C-j>")
nnoremap("<C-k>", "<C-w><C-k>")
nnoremap("<C-h>", "<C-w><C-h>")
nnoremap("<C-l>", "<C-w><C-l>")

-- Better window resize
nnoremap("+", "<C-w>+")
nnoremap("_", "<C-w>-")
nnoremap(">", "<C-w>>")
nnoremap("<", "<C-w><")

-- Leave terminal mode more ergonomically than ctrl-\ + ctrl-n
tnoremap("<esc><esc>", "<C-\\><C-n>")

-- Thanks, Prime
xnoremap("<leader>p", [["_dP]])
noremap({ "n", "v" }, "<leader>y", [["+y]])
nnoremap("<leader>Y", [["+Y]])
noremap({ "n", "v" }, "<leader>d", [["_d]])

-- Move lines
nnoremap("<D-j>", function()
  vim.cmd [[m .+1<CR>==]]
end, { desc = "Move line down" })

nnoremap("<D-k>", function()
  vim.cmd [[m .-2<CR>==]]
end, { desc = "Move line up" })

-- Silent save
nnoremap("<C-s>", function()
  vim.cmd.update { bang = true, mods = { silent = true } }
end, { desc = "save" })

-- Move lines
vnoremap("<D-j>", function()
  vim.cmd [[m '>+1<CR>gv=gv]]
end, { desc = "Move line down" })

vnoremap("<D-k>", function()
  vim.cmd [[m '<-2<CR>gv=gv]]
end, { desc = "Move line up" })

-- Toggle the quickfix list
nnoremap("<space>q", function()
  local open = (function()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win["quickfix"] == 1 then
        return true
      end
    end
    return false
  end)()
  if open then
    vim.cmd.cclose()
  else
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd.copen()
    end
  end
end, { desc = "Toggle quickfix" })

require("which-key").add {
  { "<leader>h", group = "Hunk" },
  { "<leader>t", group = "Toggle" },
}

vim.keymap.set("n", "Q", "<nop>")
