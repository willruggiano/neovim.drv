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

-- WhichKey doesn't seem to like these
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

-- Make ESC leave terminal mode
tnoremap("<esc>", "<C-\\><C-n>")
tnoremap("<esc><esc>", function()
  require("bombadil.lib.terminal").close()
end)

-- GOAT remaps?
xnoremap("<leader>p", [["_dP]])
noremap({ "n", "v" }, "<leader>y", [["+y]])
nnoremap("<leader>Y", [["+Y]])
noremap({ "n", "v" }, "<leader>d", [["_d]])

-- Jumplist as quickfix list
nnoremap("<leader>j", function()
  local jumplist = vim.fn.getjumplist()[1]
  local sorted_jumplist = {}
  for i = #jumplist, 1, -1 do
    if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
      table.insert(sorted_jumplist, jumplist[i])
    end
  end
  vim.fn.setqflist({}, "r", { id = "jl", title = "jumplist", items = sorted_jumplist })
  vim.cmd.copen { mods = { split = "botright" } }
end, { desc = "Jumplist" })

nnoremap("<leader>J", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local jumplist = vim.fn.getjumplist()[1]
  local sorted_jumplist = {}
  for i = #jumplist, 1, -1 do
    if bufnr == jumplist[i].bufnr then
      table.insert(sorted_jumplist, jumplist[i])
    end
  end
  vim.fn.setloclist(vim.api.nvim_get_current_win(), {}, "r", { id = "jl", title = "jumplist", items = sorted_jumplist })
  vim.cmd.lopen { mods = { split = "botright" } }
end, { desc = "Jumplist (local)" })

-- Move lines
nnoremap("<M-j>", function()
  vim.cmd [[m .+1<CR>==]]
end, { desc = "Move line down" })

nnoremap("<M-k>", function()
  vim.cmd [[m .-2<CR>==]]
end, { desc = "Move line up" })

-- Silent save
nnoremap("<C-s>", function()
  vim.cmd.update { bang = true, mods = { silent = true } }
end, { desc = "save" })

-- Move lines
vnoremap("<M-j>", function()
  vim.cmd [[m '>+1<CR>gv=gv]]
end, { desc = "Move line down" })

vnoremap("<M-k>", function()
  vim.cmd [[m '<-2<CR>gv=gv]]
end, { desc = "Move line up" })
