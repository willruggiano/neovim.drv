---@brief
---
--- https://github.com/regen100/cmake-language-server
---
--- CMake LSP Implementation

---@type vim.lsp.Config
return {
  cmd = { "cmake-language-server" },
  filetypes = { "cmake" },
  root_markers = { "CMakeLists.txt" },
}
