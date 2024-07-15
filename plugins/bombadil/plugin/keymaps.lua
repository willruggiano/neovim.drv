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
nnoremap(">", "<C-w>>")
nnoremap("<", "<C-w><")

-- Leave terminal mode more ergonomically than ctrl-\ + ctrl-n
tnoremap("<esc><esc>", "<C-\\><C-n>")

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
  { "<leader>m", group = "Mark" },
  { "<leader>t", group = "Toggle" },
  { "<leader>w", group = "Workspace" },
  { "<leader>z", group = "Zk" },
}
