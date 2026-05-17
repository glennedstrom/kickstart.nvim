local function is_current_leetcode_buffer()
  local ok, lc_utils = pcall(require, 'leetcode.utils')
  if ok then
    local question_ok, question = pcall(lc_utils.curr_question)
    if question_ok and question and question.bufnr == vim.api.nvim_get_current_buf() then
      return true
    end
  end

  local name = vim.api.nvim_buf_get_name(0)
  local leetcode_home = vim.fn.stdpath 'data' .. '/leetcode/'
  return name ~= '' and name:sub(1, #leetcode_home) == leetcode_home
end

vim.o.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.keymap.set('n', '<leader>ne', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })
vim.keymap.set('n', '<leader>nb', '<cmd>Neotree toggle show buffers right<CR>', { desc = 'Buffer explorer' })
vim.keymap.set('n', '<leader>ng', '<cmd>Neotree float git_status<CR>', { desc = 'Git explorer' })

vim.keymap.set('n', '<leader><CR>', function()
  if is_current_leetcode_buffer() then
    vim.cmd 'Leet run'
    return
  end

  vim.cmd 'w'

  local filetype = vim.bo.filetype
  local filename = vim.fn.expand '%'
  local filename_no_ext = vim.fn.expand '%:r'
  local run_commands = {
    python = 'echo && python3 "' .. filename .. '"',
    javascript = 'echo && node "' .. filename .. '"',
    typescript = 'echo && ts-node "' .. filename .. '"',
    lua = 'echo && lua "' .. filename .. '"',
    cpp = 'echo && g++ "' .. filename .. '" -o "' .. filename_no_ext .. '" && ./"' .. filename_no_ext .. '"',
    c = 'echo && gcc "' .. filename .. '" -o "' .. filename_no_ext .. '" && ./"' .. filename_no_ext .. '"',
    rust = 'echo && rustc "' .. filename .. '" && ./"' .. filename_no_ext .. '"',
    go = 'echo && go run "' .. filename .. '"',
    java = 'echo && javac "' .. filename .. '" && java "' .. filename_no_ext .. '"',
    sh = 'echo && bash "' .. filename .. '"',
    zsh = 'echo && zsh "' .. filename .. '"',
    ruby = 'echo && ruby "' .. filename .. '"',
    php = 'echo && php "' .. filename .. '"',
    perl = 'echo && perl "' .. filename .. '"',
    r = 'echo && Rscript "' .. filename .. '"',
    julia = 'echo && julia "' .. filename .. '"',
    dart = 'echo && dart "' .. filename .. '"',
    kotlin = 'echo && kotlinc "' .. filename .. '" -include-runtime -d "' .. filename_no_ext .. '.jar" && java -jar "' .. filename_no_ext .. '.jar"',
    swift = 'echo && swift "' .. filename .. '"',
  }

  local command = run_commands[filetype]
  if command then
    vim.cmd('!' .. command)
  else
    vim.notify('No run command defined for filetype: ' .. filetype, vim.log.levels.WARN)
  end
end, { desc = 'Run current file' })

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.c', '*.cpp', '*.cc', '*.cxx', '*.h', '*.hpp' },
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd 'keepjumps keeppatterns silent! %normal! ='
    vim.fn.winrestview(view)
  end,
  desc = 'Auto-indent C/C++ while keeping cursor and folds',
})

require 'custom.scroll-lock'
