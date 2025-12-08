local jump = require "bombadil.lib.jump"

local noremap = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", opts or {}, { noremap = true, silent = true }))
end
local nnoremap = function(lhs, rhs, opts)
  noremap("n", lhs, rhs, opts)
end
local xnoremap = function(lhs, rhs, opts)
  noremap("x", lhs, rhs, opts)
end

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

vim.keymap.set("n", "Q", "<nop>")

-- Auto-select first item on confirm
vim.keymap.set("i", "<C-y>", function()
  if vim.fn.pumvisible() ~= 0 then
    local info = vim.fn.complete_info { "selected" }
    if info.selected == -1 then
      vim.api.nvim_select_popupmenu_item(0, true, true, {})
    else
      vim.api.nvim_select_popupmenu_item(info.selected, true, true, {})
    end
  end
end)
