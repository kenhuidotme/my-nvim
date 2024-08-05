local base30 = require("base46").get_theme_tbl("base_30")

return {
  -- LSP References
  LspReferenceText = { fg = base30.darker_black, bg = base30.white },
  LspReferenceRead = { fg = base30.darker_black, bg = base30.white },
  LspReferenceWrite = { fg = base30.darker_black, bg = base30.white },

  -- Lsp Diagnostics
  DiagnosticHint = { fg = base30.purple },
  DiagnosticError = { fg = base30.red },
  DiagnosticWarn = { fg = base30.yellow },
  DiagnosticInformation = { fg = base30.green },
  LspSignatureActiveParameter = { fg = base30.black, bg = base30.green },
}
