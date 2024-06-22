return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    -- PowerShell config
    local powershell_options = {
      shell = vim.fn.executable 'pwsh' == 1 and 'pwsh' or 'powershell',
      shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
      shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait',
      shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode',
      shellquote = '',
      shellxquote = '',
    }

    for option, value in pairs(powershell_options) do
      vim.opt[option] = value
    end
    require('toggleterm').setup {}

    -- Git Bash config
    -- require('toggleterm').setup {
    --   open_mapping = '<C-\\>',
    --   start_in_insert = true,
    --   direction = 'float',
    -- }
    --
    -- vim.cmd [[let &shell = 'C:/Users/npertschy/AppData/Local/Programs/Git/git-bash.exe']]
    -- vim.cmd [[let &shellcmdflag = '-s']]
    -- vim.cmd [[let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait']]

    vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>')
    vim.keymap.set('n', '<leader>ts', '<C-w><C-w>i')

    vim.api.nvim_create_user_command('RunInTerminal', function()
      local commandToRun = vim.fn.input 'Run: '
      require('toggleterm').exec(commandToRun, 1, 12)
    end, {})

    vim.keymap.set('n', '<A-r>', '<cmd>RunInTerminal<CR>')
    vim.keymap.set('t', '<esc>', '<C-\\><C-n><C-w><C-w>')
  end,
}
