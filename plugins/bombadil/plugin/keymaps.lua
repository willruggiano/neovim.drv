local jump = require "bombadil.lib.jump"
local keymap = require "bombadil.lib.keymap"

local noremap = keymap.noremap
local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap

-- <A-q> behaves like <C-w>q
nnoremap("<A-q>", ":quit<CR>")

-- `:e %%/` expands to `:e /path/to/dir/`
vim.cmd "cabbrev %% %:p:h"

-- Add large jumps to the jump list
for _, d in ipairs { "j", "k" } do
  nnoremap(d, function()
    jump(d)
  end)
end

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

vim.keymap.set("v", "<leader>lp", function()
  vim.cmd "noau normal! vy"
  local filetype = vim.bo.filetype
  local prompt_template = "%s\n```%s\n%s\n```"
  local selection = vim.fn.getreg "v"
  vim.ui.input({ prompt = "> " }, function(input)
    if input and #input > 0 then
      local prompt = prompt_template:format(input, filetype, selection)
      -- FIXME: not quite :(
      vim.cmd("pedit term://llm -t concise '" .. vim.fn.shellescape(prompt) .. "'")
    end
  end)
end, { desc = "Prompt" })

require("which-key").add {
  { "<leader>h", group = "Hunk" },
  { "<leader>l", group = "LM" },
  { "<leader>t", group = "Toggle" },
}

vim.keymap.set("n", "Q", "<nop>")
