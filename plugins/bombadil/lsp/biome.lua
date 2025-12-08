---@brief
--- https://biomejs.dev
---
--- Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
---
--- ```sh
--- npm install [-g] @biomejs/biome
--- ```
---
--- ### Monorepo support
---
--- `biome` supports monorepos by default. It will automatically find the `biome.json` corresponding to the package you are working on, as described in the [documentation](https://biomejs.dev/guides/big-projects/#monorepo). This works without the need of spawning multiple instances of `biome`, saving memory.

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, ...)
    return vim.lsp.rpc.start({ "biome", "lsp-proxy" }, dispatchers)
  end,
  filetypes = {
    "graphql",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
  },
  root_markers = { "biome.json" }, -- or an entry in package.json?
  workspace_required = true,
}
