return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<A-a>', function()
      harpoon:list():add()
    end)
    vim.keymap.set('n', '<A-x>', function()
      harpoon:list():remove()
    end)
    vim.keymap.set('n', '<A-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<A-k>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<A-j>', function()
      harpoon:list():next()
    end)

    local extensions = require 'harpoon.extensions'
    harpoon:extend(extensions.builtins.navigate_with_number())

    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set('n', '<C-x>', function()
          harpoon.ui:select_menu_item { vsplit = true }
        end, { buffer = cx.bufnr })

        vim.keymap.set('n', '<C-s>', function()
          harpoon.ui:select_menu_item { split = true }
        end, { buffer = cx.bufnr })
      end,
    }
  end,
}
