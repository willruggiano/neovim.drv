return function()
  require("overseer").setup()
  vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "OverseerRun" })
  vim.keymap.set("n", "<leader>os", function()
    vim.ui.input({ prompt = "> ", completion = "shellcmdline" }, function(cmd)
      local task = require("overseer").new_task { cmd = cmd }
      task:start()
    end)
  end, { desc = "OverseerShell" })
  vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle!<cr>", { desc = "OverseerToggle!" })
end
