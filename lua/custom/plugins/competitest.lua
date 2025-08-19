return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  config = function()
    require('competitest').setup {
      -- Basic configuration
      local_config_file_name = '.competitest.lua',
      -- Language-specific settings
      compile_command = {
        cpp = { exec = 'g++', args = { '-Wall', '-O2', '-std=c++17', '$(FNAME)', '-o', '$(FNOEXT)' } },
        c = { exec = 'gcc', args = { '-Wall', '-O2', '$(FNAME)', '-o', '$(FNOEXT)' } },
        -- Python doesn't need compilation, so use a no-op command
        python = { exec = 'true' },
      },
      run_command = {
        cpp = { exec = './$(FNOEXT)' },
        c = { exec = './$(FNOEXT)' },
        -- Python execution with unbuffered output
        python = { exec = 'python3', args = { '-u', '$(FNAME)' } },
      },
      -- Template settings
      template_file = {
        cpp = '~/.config/nvim/templates/cp.cpp',
        -- Optionally add a Python template
        python = '~/.config/nvim/templates/cp.py',
      },
      -- Test case settings
      testcases_directory = './tests',
      testcases_use_single_file = true,
      -- UI settings
      split_direction = 'horizontal',
      popup_width = 95,
      popup_height = 80,
      -- Automatically save before running tests
      save_current_file = true,
      -- Show test case details
      show_nu = true,
      show_rnu = true,
    }

    -- Keymaps
    vim.keymap.set('n', '<leader>cr', '<cmd>CompetiTest run<CR>', { desc = '[C]ompetitive [R]un tests' })
    vim.keymap.set('n', '<leader>ca', '<cmd>CompetiTest add_testcase<CR>', { desc = '[C]ompetitive [A]dd test case' })
    vim.keymap.set('n', '<leader>ce', '<cmd>CompetiTest edit_testcase<CR>', { desc = '[C]ompetitive [E]dit test case' })
    vim.keymap.set('n', '<leader>cd', '<cmd>CompetiTest delete_testcase<CR>', { desc = '[C]ompetitive [D]elete test case' })
    vim.keymap.set('n', '<leader>cp', '<cmd>CompetiTest receive problem<CR>', { desc = '[C]ompetitive receive [P]roblem' })
    vim.keymap.set('n', '<leader>cc', '<cmd>CompetiTest receive contest<CR>', { desc = '[C]ompetitive receive [C]ontest' })
  end,
}
