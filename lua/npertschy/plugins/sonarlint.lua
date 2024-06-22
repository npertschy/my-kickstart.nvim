return {
  url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
  config = function()
    local data_dir = vim.fn.stdpath 'data'
    require('sonarlint').setup {
      server = {
        cmd = {
          'java',
          '-jar',
          vim.fn.expand(data_dir .. '/mason/packages/sonarlint-language-server/sonarlint-ls.jar'),
          '-stdio',
          '-analyzers',
          vim.fn.expand(data_dir .. '/mason/packages/sonarlint-language-server/sonarhtml.jar'),
          vim.fn.expand(data_dir .. '/mason/packages/sonarlint-language-server/sonarjava.jar'),
          vim.fn.expand(data_dir .. '/mason/packages/sonarlint-language-server/sonarjs.jar'),
          vim.fn.expand(data_dir .. '/mason/packages/sonarlint-language-server/sonartext.jar'),
          vim.fn.expand(data_dir .. '/mason/packages/sonarlint-language-server/sonarxml.jar'),
        },
      },
      filetypes = {
        'java',
        'gradle',
        'js',
        'ts',
        'vue',
      },
    }
  end,
}
