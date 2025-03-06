local jump = require "bombadil.lib.jump"
local keymap = require "bombadil.lib.keymap"

local noremap = keymap.noremap
local inoremap = keymap.inoremap
local nnoremap = keymap.nnoremap
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

-- Thanks Prime
xnoremap("<leader>p", [["_dP]])
noremap({ "n", "v" }, "<leader>y", [["+y]])
nnoremap("<leader>Y", [["+Y]])
noremap({ "n", "v" }, "<leader>d", [["_d]])

-- Silent save
nnoremap("<C-s>", function()
  vim.cmd.update { bang = true, mods = { silent = true } }
end, { desc = "save" })

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
