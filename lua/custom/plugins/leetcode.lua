vim.pack.add {
  'https://github.com/kawre/leetcode.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('leetcode').setup {
  lang = 'cpp',
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
vim.keymap.set('n', '<leader>cL', '<cmd>Leet lang<CR>', { desc = '[C]ompetitive Select [L]anguage' })
