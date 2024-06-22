return {
  'olimorris/onedarkpro.nvim',
  priority = 1000,
  config = function()
    require('onedarkpro').setup {
      highlights = {
        ['@attribute.java'] = { fg = '${cyan}' },
        ['@lsp.type.modifier.java'] = { fg = '${purple}' },
        ['@lsp.type.interface.java'] = { fg = '${green}', italic = true },
      },
      options = {
        cursorline = true,
      },
    }
    vim.cmd 'colorscheme onedark'
  end,
}
