return function()
  local overseer = require "overseer"

  overseer.setup()

  vim.keymap.set("n", "<space><cr>", function()
    local tasks = overseer.list_tasks { recent_first = true }
    if not vim.tbl_isempty(tasks) then
      overseer.run_action(tasks[1], "restart")
    end
  end, { desc = "[overseer] run last" })

  vim.keymap.set("n", "<space>r", "<cmd>OverseerRun<cr>", { desc = "[overseer] run" })

  vim.keymap.set("n", "<space>t", "<cmd>OverseerToggle bottom<cr>", { desc = "[overseer] toggle" })
end
