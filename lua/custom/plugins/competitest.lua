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
      },
      run_command = {
        cpp = { exec = './$(FNOEXT)' },
        c = { exec = './$(FNOEXT)' },
      },
      -- Template settings
      template_file = {
        cpp = '~/.config/nvim/templates/cp.cpp',
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

      -- Fix for spaces in filenames: Use JAVA_TASK_CLASS modifier
      -- This removes all non-alphabetic and non-numeric characters, including spaces
      received_problems_path = '$(CWD)/$(JAVA_TASK_CLASS).$(FEXT)',
      received_contests_problems_path = '$(JAVA_TASK_CLASS).$(FEXT)',

      -- Alternative: Use a custom function if you want more control
      -- received_problems_path = function(task, file_extension)
      --   local problem_name = task.name:gsub('%s+', '_') -- Replace spaces with underscores
      --   problem_name = problem_name:gsub('[^%w_-]', '') -- Remove other special characters
      --   return string.format('%s/%s.%s', vim.fn.getcwd(), problem_name, file_extension)
      -- end,
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
