return {
  'kawre/leetcode.nvim',
  build = ':TSUpdate html',
  cmd = { 'Leet' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>cq', '<cmd>Leet<CR>', desc = '[C]ompetitive LeetCode Dashboard' },
  },
  opts = {
    lang = 'pick my own',
    picker = {
      provider = 'telescope',
    },
    injector = {
      cpp = {
        imports = function()
          return {
            '#include <bits/stdc++.h>',
            'using namespace std;',
          }
        end,
      },
    },
    plugins = {
      non_standalone = true,
    },
  },
}
