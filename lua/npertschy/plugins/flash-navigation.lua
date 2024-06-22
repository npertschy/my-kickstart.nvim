return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    {
      '<A-s>',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  },
}
