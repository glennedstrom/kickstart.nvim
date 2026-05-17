vim.pack.add {
  'https://github.com/kawre/leetcode.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('leetcode').setup {
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
}

vim.keymap.set('n', '<leader>cq', '<cmd>Leet<CR>', { desc = '[C]ompetitive LeetCode Dashboard' })
