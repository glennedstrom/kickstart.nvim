-- ~/.config/nvim/lua/custom/plugins/magma.lua
-- Magma-nvim: Interactive Jupyter notebook experience in Neovim

return {
  'dccsillag/magma-nvim',
  -- Load on these events for better performance
  event = { 'BufReadPost *.py', 'BufReadPost *.ipynb', 'BufNewFile *.py' },
  -- Run UpdateRemotePlugins after installation/update
  build = ':UpdateRemotePlugins',

  config = function()
    -- Core configuration options
    vim.g.magma_automatically_open_output = false -- Don't auto-open output window
    vim.g.magma_image_provider = 'ueberzug' -- Image display method (use 'kitty' if using Kitty terminal)
    vim.g.magma_wrap_output = true -- Wrap text in output window
    vim.g.magma_output_window_borders = true -- Show borders around output window
    vim.g.magma_cell_highlight_group = 'CursorLine' -- Highlight group for cells
    vim.g.magma_save_path = vim.fn.stdpath 'data' .. '/magma' -- Save/load path
    vim.g.magma_copy_output = false -- Don't automatically copy output to clipboard
    vim.g.magma_show_mimetype_debug = false -- Don't show mimetype debug info

    -- Keymaps for Magma functionality
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Main evaluation keymaps (using <leader>m for magma)
    map('n', '<leader>mr', ':MagmaEvaluateOperator<CR>', { expr = true, desc = 'Magma evaluate operator' })
    map('n', '<leader>ml', ':MagmaEvaluateLine<CR>', { desc = 'Magma evaluate line' })
    map('x', '<leader>mr', ':<C-u>MagmaEvaluateVisual<CR>', { desc = 'Magma evaluate visual selection' })
    map('n', '<leader>mc', ':MagmaReevaluateCell<CR>', { desc = 'Magma re-evaluate cell' })

    -- Cell management
    map('n', '<leader>md', ':MagmaDelete<CR>', { desc = 'Magma delete cell' })
    map('n', '<leader>mo', ':MagmaShowOutput<CR>', { desc = 'Magma show output' })
    map('n', '<leader>mq', ':noautocmd MagmaEnterOutput<CR>', { desc = 'Magma enter output window' })

    -- Kernel management
    map('n', '<leader>mi', ':MagmaInit<CR>', { desc = 'Magma init kernel' })
    map('n', '<leader>mD', ':MagmaDeinit<CR>', { desc = 'Magma deinit kernel' })
    map('n', '<leader>mI', ':MagmaInterrupt<CR>', { desc = 'Magma interrupt kernel' })
    map('n', '<leader>mR', ':MagmaRestart!<CR>', { desc = 'Magma restart kernel' })

    -- Save/Load functionality
    map('n', '<leader>ms', ':MagmaSave<CR>', { desc = 'Magma save session' })
    map('n', '<leader>mL', ':MagmaLoad<CR>', { desc = 'Magma load session' })

    -- Quick initialization functions for common kernels
    local function magma_init_python()
      vim.cmd 'MagmaInit python3'
      -- Optionally run some initial setup
      -- vim.cmd('MagmaEvaluateArgument import numpy as np; import pandas as pd; import matplotlib.pyplot as plt')
    end

    local function magma_init_python_conda()
      vim.cmd 'MagmaInit python3'
      -- You can customize this for your conda environment
    end

    -- Commands for quick kernel initialization
    vim.api.nvim_create_user_command('MagmaInitPython', magma_init_python, { desc = 'Initialize Python3 kernel' })
    vim.api.nvim_create_user_command('MagmaInitConda', magma_init_python_conda, { desc = 'Initialize Python3 kernel with conda' })

    -- Quick keymap for Python initialization
    map('n', '<leader>mp', ':MagmaInitPython<CR>', { desc = 'Magma init Python kernel' })

    -- Auto-commands for better UX
    local magma_group = vim.api.nvim_create_augroup('MagmaCustom', { clear = true })

    -- Show a message when kernel is initialized
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MagmaInitPost',
      group = magma_group,
      callback = function()
        vim.notify('Magma kernel initialized', vim.log.levels.INFO)
      end,
    })

    -- Show a message when kernel is deinitialized
    vim.api.nvim_create_autocmd('User', {
      pattern = 'MagmaDeinitPost',
      group = magma_group,
      callback = function()
        vim.notify('Magma kernel deinitialized', vim.log.levels.INFO)
      end,
    })
  end,

  -- Dependencies and requirements check
  dependencies = {
    -- Optional: nvim-notify for better notifications
    { 'rcarriga/nvim-notify', opts = {} },
  },

  -- Condition to only load if Python is available
  cond = function()
    return vim.fn.executable 'python3' == 1
  end,
}
