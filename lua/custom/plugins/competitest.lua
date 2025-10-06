return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  config = function()
    local template_file = {
      cpp = '~/.config/nvim/templates/cp.cpp',
      py = '~/.config/nvim/templates/cp.py',
    }

    local fold_patterns = {
      cpp = { '^#include', '^#define', '^using' },
      python = { '^import ', '^from ', '^#.*template', '^#.*Template' },
    }

    local last_ft_file = vim.fn.stdpath 'data' .. '/last_problem_ft'

    -- Save last_ft to disk
    local function save_last_ft(ft)
      local f = io.open(last_ft_file, 'w')
      if f then
        f:write(ft)
        f:close()
      end
    end

    -- Load last_ft from disk
    local function load_last_ft()
      local f = io.open(last_ft_file, 'r')
      if not f then
        return 'cpp'
      end
      local ft = f:read '*l'
      f:close()
      return ft or 'cpp'
    end

    local last_ft = load_last_ft()

    -- Helper: map vim filetype -> template_file key
    local function ext_key_for_filetype(ft)
      if ft == 'python' then
        return 'py'
      end
      return ft
    end

    local function read_file(path)
      local f = io.open(path, 'r')
      if not f then
        return nil
      end
      local content = f:read '*a'
      f:close()
      return content
    end

    local function is_fresh_template()
      local ft = vim.bo.filetype
      local ext_key = ext_key_for_filetype(ft)
      local tpl = template_file[ext_key]
      if not tpl then
        return false
      end

      local tpl_path = vim.fn.expand(tpl)
      local tpl_content = read_file(tpl_path)
      if not tpl_content then
        return false
      end

      tpl_content = tpl_content:gsub('\r\n', '\n')
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local cur = table.concat(lines, '\n'):gsub('\r\n', '\n')
      if tpl_content:sub(-1) == '\n' and cur:sub(-1) ~= '\n' then
        cur = cur .. '\n'
      end

      return cur == tpl_content
    end

    local function auto_fold_template(should_jump)
      local ft = vim.bo.filetype
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local last_line = 0

      if ft == 'cpp' then
        for i, line in ipairs(lines) do
          if line:match '^#include' or line:match '^#define' or line:match '^using' then
            last_line = i
          end
        end
      elseif ft == 'python' then
        for i, line in ipairs(lines) do
          if line:match '^import%s' or line:match '^from%s+[%w_.]+%s+import' then
            last_line = i
          end
        end
      else
        return
      end

      if last_line == 0 then
        return
      end

      local old_fold = vim.opt_local.foldmethod:get()
      vim.opt_local.foldmethod = 'manual'
      vim.cmd('silent! 1,' .. last_line .. 'fold')
      vim.opt_local.foldmethod = old_fold

      if not should_jump then
        return
      end

      local ext_key = ext_key_for_filetype(ft)
      local tpl_path = template_file[ext_key] and vim.fn.expand(template_file[ext_key]) or ''
      local cur_path = vim.fn.expand '%:p'
      local fresh = tpl_path ~= '' and is_fresh_template()

      if fresh and cur_path ~= tpl_path then
        local target = math.min(last_line + 3, vim.api.nvim_buf_line_count(0))
        vim.api.nvim_win_set_cursor(0, { target, 0 })
        vim.api.nvim_feedkeys('^', 'n', true)
      end
    end

    local function toggle_template_folds()
      local ft = vim.bo.filetype
      if not fold_patterns[ft] then
        return
      end

      local fold_start = vim.fn.foldclosed(1)
      if fold_start == -1 then
        auto_fold_template(false)
      else
        vim.cmd '1foldopen'
      end
    end

    require('competitest').setup {
      local_config_file_name = '.competitest.lua',
      compile_command = {
        --cpp = { exec = 'g++', args = { '-Wall', '-g', '-O2', '-std=c++23', '$(FNAME)', '-o', '$(FNOEXT)' } },
        cpp = {
          exec = 'g++',
          args = {
            '-fsanitize=address,undefined,leak',
            '-fno-omit-frame-pointer',
            '-Wall',
            '-Wno-unused-variable',
            '-Wno-unused-but-set-variable',
            '-Wno-sign-compare',
            '-g',
            '-O2',
            '-std=c++23',
            '$(FNAME)',
            '-o',
            '$(FNOEXT)',
          },
        },
        c = { exec = 'gcc', args = { '-Wall', '-O2', '$(FNAME)', '-o', '$(FNOEXT)' } },
      },
      run_command = {
        cpp = { exec = './$(FNOEXT)' },
        c = { exec = './$(FNOEXT)' },
        python = { exec = 'python3', args = { '-u', '$(FNAME)' } },
      },
      -- Enable split UI interface
      runner_ui = {
        interface = 'split',
        mappings = {
          run_again = 'R',
          run_all_again = '<C-r>',
          kill = 'K',
          kill_all = '<C-k>',
          view_input = { 'i', 'I' },
          view_output = { 'a', 'A' },
          view_stdout = { 'o', 'O' },
          view_stderr = { 'e', 'E' },
          toggle_diff = { 'd', 'D' },
          close = { 'Q' }, -- Removed 'q' from here, only 'Q' remains
        },
      },
      split_ui = {
        position = 'right',
        relative_to_editor = true,
        total_width = 0.3,
        vertical_layout = {
          { 1, 'tc' },
          { 1, { { 1, 'so' }, { 1, 'eo' } } },
          { 1, { { 1, 'si' }, { 1, 'se' } } },
        },
      },

      template_file = template_file,
      evaluate_template_modifiers = true,
      testcases_directory = './tests',
      testcases_auto_detect_storage = true,
      testcases_use_single_file = false,
      testcases_input_file_format = '$(FNOEXT)_input$(TCNUM).txt',
      testcases_output_file_format = '$(FNOEXT)_output$(TCNUM).txt',
      split_direction = 'horizontal',
      popup_width = 95,
      popup_height = 80,
      save_current_file = true,
      show_nu = true,
      show_rnu = true,

      received_problems_path = function(task, file_extension)
        local ext = last_ft or file_extension or 'cpp'
        local name = task.name:gsub('%s+', '_'):gsub('[^%w_-]', '')
        return string.format('%s/%s.%s', vim.fn.getcwd(), name, ext)
      end,

      received_contests_problems_path = function(task, file_extension)
        local ext = last_ft or file_extension or 'cpp'
        local name = task.name:gsub('%s+', '_'):gsub('[^%w_-]', '')
        return string.format('%s.%s', name, ext)
      end,

      received_contests_directory = function(task)
        local contest = task.group:match '-%s*(.+)' or 'NONE'
        contest = contest:gsub('^Codeforces%s*', '')
        contest = contest:gsub('%s+', '_'):gsub('[^%w_-]', '')
        return string.format('%s/%s', vim.fn.getcwd(), contest)
      end,
    }

    -- Auto-folding and file extension tracking
    local augroup = vim.api.nvim_create_augroup('CompetitestAutoFold', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      group = augroup,
      pattern = { '*.cpp', '*.py', '*.c' },
      callback = function()
        vim.defer_fn(function()
          vim.b.is_fresh_template = is_fresh_template()
          auto_fold_template(true)

          -- Update last_ft when entering a competitive programming file
          local current_file = vim.fn.expand '%:p'
          if current_file and current_file ~= '' then
            local ext = current_file:match '%.([^%.]+)$'
            if ext and (ext == 'cpp' or ext == 'py' or ext == 'c') then
              local cwd = vim.fn.getcwd()
              -- Only update if file is in current working directory (likely a competition file)
              if current_file:sub(1, #cwd) == cwd then
                last_ft = ext
                save_last_ft(ext)
              end
            end
          end
        end, 50)
      end,
    })

    -- Track when new competitive programming files are created
    vim.api.nvim_create_autocmd({ 'BufNewFile' }, {
      group = augroup,
      pattern = { '*.cpp', '*.py', '*.c' },
      callback = function()
        local current_file = vim.fn.expand '%:p'
        if current_file and current_file ~= '' then
          local ext = current_file:match '%.([^%.]+)$'
          if ext then
            local cwd = vim.fn.getcwd()
            if current_file:sub(1, #cwd) == cwd then
              last_ft = ext
              save_last_ft(ext)
            end
          end
        end
      end,
    })

    -- Track when competitive programming files are saved
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      group = augroup,
      pattern = { '*.cpp', '*.py', '*.c' },
      callback = function()
        local current_file = vim.fn.expand '%:p'
        if current_file and current_file ~= '' then
          local ext = current_file:match '%.([^%.]+)$'
          if ext then
            local cwd = vim.fn.getcwd()
            if current_file:sub(1, #cwd) == cwd and vim.b.is_fresh_template then
              last_ft = ext
              save_last_ft(ext)
            end
          end
        end
      end,
    })

    -- Keymaps
    vim.keymap.set('n', '<leader>ct', toggle_template_folds, { desc = '[C]ompetitive [T]oggle template fold' })

    -- Load template command
    vim.api.nvim_create_user_command('CompetitestLoadTemplate', function()
      local ft = vim.bo.filetype
      local ext_key = ext_key_for_filetype(ft)
      local path = template_file[ext_key]
      if not path then
        vim.notify('No template for filetype: ' .. ft, vim.log.levels.WARN)
        return
      end

      local full = vim.fn.expand(path)
      if vim.fn.filereadable(full) == 1 then
        local lines = {}
        for line in io.lines(full) do
          table.insert(lines, line)
        end
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.b.is_fresh_template = true
        auto_fold_template(true)
        vim.notify('Template loaded for ' .. ft, vim.log.levels.INFO)
      else
        vim.notify('Template not found: ' .. full, vim.log.levels.ERROR)
      end
    end, { desc = 'Load competitive programming template' })

    -- Competitive programming keymaps
    --vim.keymap.set('n', '<leader>cr', '<cmd>CompetiTest run<CR>', { desc = '[C]ompetitive [R]un tests' })
    vim.keymap.set('n', '<leader>cr', function()
      vim.cmd 'CompetiTest run'
      vim.schedule(function()
        vim.cmd 'wincmd W'
      end)
    end, { desc = '[C]ompetitive [R]un tests' })
    vim.keymap.set('n', '<leader>ca', '<cmd>CompetiTest add_testcase<CR>', { desc = '[C]ompetitive [A]dd test case' })
    vim.keymap.set('n', '<leader>ce', '<cmd>CompetiTest edit_testcase<CR>', { desc = '[C]ompetitive [E]dit test case' })
    vim.keymap.set('n', '<leader>cd', '<cmd>CompetiTest delete_testcase<CR>', { desc = '[C]ompetitive [D]elete test case' })
    vim.keymap.set('n', '<leader>cp', '<cmd>CompetiTest receive problem<CR>', { desc = '[C]ompetitive receive [P]roblem' })
    vim.keymap.set('n', '<leader>cc', '<cmd>CompetiTest receive contest<CR>', { desc = '[C]ompetitive receive [C]ontest' })
    vim.keymap.set('n', '<leader>cl', '<cmd>CompetitestLoadTemplate<CR>', { desc = '[C]ompetitive [L]oad template' })
  end,
}
