---@brief
---
--- https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli
---
--- `graphql-lsp` can be installed via `npm`:
---
--- ```sh
--- npm install -g graphql-language-service-cli
--- ```
---
--- Note that you must also have [the graphql package](https://github.com/graphql/graphql-js) installed within your project and create a [GraphQL config file](https://the-guild.dev/graphql/config/docs).

---@type vim.lsp.Config
return {
  cmd = { "graphql-lsp", "server", "-m", "stream" },
  filetypes = { "graphql", "typescriptreact", "javascriptreact" },
  root_markers = { "graphql.config.*" },
}
