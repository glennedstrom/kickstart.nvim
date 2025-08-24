return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  config = function()
    require('competitest').setup {
      -- Basic configuration
      local_config_file_name = '.competitest.lua',
      -- Language-specific settings
      compile_command = {
        cpp = { exec = 'g++', args = { '-Wall', '-O2', '-std=gnu++23', '$(FNAME)', '-o', '$(FNOEXT)' } },
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

    -- Auto-fold template imports after loading
    local augroup = vim.api.nvim_create_augroup('CompetitestAutoFold', { clear = true })

    -- Function to check if current buffer matches template
    local function is_fresh_template()
      local filetype = vim.bo.filetype
      if filetype ~= 'cpp' then
        return false
      end

      -- Get template file path
      local template_path = vim.fn.expand '~/.config/nvim/templates/cp.cpp'

      -- Read template file content
      local template_file = io.open(template_path, 'r')
      if not template_file then
        return false
      end

      local template_content = template_file:read '*all'
      template_file:close()

      -- Get current buffer content
      local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local current_content = table.concat(current_lines, '\n')

      -- Add newline at end if template has it
      if not current_content:match '\n$' and template_content:match '\n$' then
        current_content = current_content .. '\n'
      end

      -- Compare contents
      return current_content == template_content
    end

    -- Function to handle auto-folding
    local function auto_fold_template(should_jump_and_edit)
      local filetype = vim.bo.filetype

      if filetype == 'cpp' then
        -- Get all lines in the buffer
        local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local last_template_line = 0

        -- Find the last line that contains #include, #define, or using
        for i, line in ipairs(all_lines) do
          if line:match '^#include' or line:match '^#define' or line:match '^using' then
            last_template_line = i
          end
        end

        -- Only proceed if we found template lines
        if last_template_line > 0 then
          -- Enable manual folding temporarily
          local old_foldmethod = vim.opt_local.foldmethod:get()
          vim.opt_local.foldmethod = 'manual'

          -- Create a fold from line 1 to the last template line
          vim.cmd('1,' .. last_template_line .. 'fold')

          -- Restore original fold method
          vim.opt_local.foldmethod = old_foldmethod

          -- Only jump and run cc if this is a fresh template
          if should_jump_and_edit then
            -- Move cursor 3 lines below the folded section
            local target_line = last_template_line + 3
            -- Make sure we don't go past the end of the file
            local total_lines = vim.api.nvim_buf_line_count(0)
            if target_line > total_lines then
              target_line = total_lines
            end

            -- Set cursor position first
            vim.api.nvim_win_set_cursor(0, { target_line, 0 })
            -- Then use feedkeys to simulate pressing 'cc'
            vim.api.nvim_feedkeys('cc', 'n', true)
          end
        end
      end
    end

    -- Function to toggle template folds only
    local function toggle_template_folds()
      local filetype = vim.bo.filetype

      if filetype == 'cpp' then
        -- Check if line 1 is currently folded
        local fold_start = vim.fn.foldclosed(1)
        if fold_start == -1 then
          -- Not folded, so create the fold (without jumping or running cc)
          auto_fold_template(false)
        else
          -- Currently folded, so open the fold
          vim.cmd '1foldopen'
        end
      end
    end

    -- Main autocmd for handling C++ files
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      group = augroup,
      pattern = { '*.cpp' },
      callback = function()
        vim.defer_fn(function()
          -- Check if this is a fresh template
          local is_template = is_fresh_template()

          -- Set buffer-local variable for future reference
          vim.b.is_fresh_template = is_template

          -- Always fold headers, but only jump+cc for fresh templates
          auto_fold_template(is_template)
        end, 50)
      end,
    })

    -- Manual keymap to toggle template folds
    vim.keymap.set('n', '<leader>ct', function()
      toggle_template_folds()
    end, { desc = '[C]ompetitive [T]oggle template fold' })

    -- Keymaps
    vim.keymap.set('n', '<leader>cr', '<cmd>CompetiTest run<CR>', { desc = '[C]ompetitive [R]un tests' })
    vim.keymap.set('n', '<leader>ca', '<cmd>CompetiTest add_testcase<CR>', { desc = '[C]ompetitive [A]dd test case' })
    vim.keymap.set('n', '<leader>ce', '<cmd>CompetiTest edit_testcase<CR>', { desc = '[C]ompetitive [E]dit test case' })
    vim.keymap.set('n', '<leader>cd', '<cmd>CompetiTest delete_testcase<CR>', { desc = '[C]ompetitive [D]elete test case' })
    vim.keymap.set('n', '<leader>cp', '<cmd>CompetiTest receive problem<CR>', { desc = '[C]ompetitive receive [P]roblem' })
    vim.keymap.set('n', '<leader>cc', '<cmd>CompetiTest receive contest<CR>', { desc = '[C]ompetitive receive [C]ontest' })
  end,
}
