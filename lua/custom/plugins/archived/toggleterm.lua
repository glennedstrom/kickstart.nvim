-- Legacy lazy.nvim plugin spec archived during vim.pack migration. This file no longer works as-is.
return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = { 'ToggleTerm', 'TermExec' },
  keys = {
    -- Quick toggle (last active terminal)
    { '<C-\\>', '<cmd>ToggleTerm<CR>', desc = 'Toggle terminal', mode = { 'n', 'i', 't' } },

    -- Numbered terminals (recommended for multi-terminal workflow)
    { '<leader>t1', '<cmd>1ToggleTerm direction=horizontal<CR>', desc = '[T]erminal [1]' },
    { '<leader>t2', '<cmd>2ToggleTerm direction=horizontal<CR>', desc = '[T]erminal [2]' },
    { '<leader>t3', '<cmd>3ToggleTerm direction=horizontal<CR>', desc = '[T]erminal [3]' },

    -- Special purpose terminals
    { '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', desc = '[T]erminal [F]loat' },
    { '<leader>ta', '<cmd>ToggleTermToggleAll<CR>', desc = '[T]erminal toggle [A]ll' },
  },
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = 'horizontal', -- 'vertical' | 'horizontal' | 'tab' | 'float'
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        winblend = 3,
      },
    }

    -- Terminal mode keymaps for easy escape
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd 'autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()'

    -- Create specific terminal instances for competitive programming
    local Terminal = require('toggleterm.terminal').Terminal

    -- Python REPL terminal
    local python_repl = Terminal:new {
      cmd = 'python3',
      direction = 'float',
      close_on_exit = false,
      on_open = function(term)
        vim.cmd 'startinsert!'
      end,
    }

    function _PYTHON_TOGGLE()
      python_repl:toggle()
    end

    vim.keymap.set('n', '<leader>tp', '<cmd>lua _PYTHON_TOGGLE()<CR>', { desc = '[T]erminal [P]ython REPL' })
  end,
}
