local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error "This plugin requires telescope.nvim"
end

local dotfiles = function(opts)
  assert(vim.env.DOTFILES, "$DOTFILES must be set")
  opts = opts or {}
  require("telescope.builtin").find_files(vim.tbl_deep_extend("keep", opts, {
    prompt_title = "~ dotfiles ~",
    search_dirs = { vim.env.DOTFILES, vim.env.DOTFILES .. "/.config" },
  }))
end

return telescope.register_extension {
  exports = {
    dotfiles = dotfiles,
  },
}
