-- lua/custom/plugins/file_runner.lua

-- Language-specific file runner function
local function run_current_file()
  -- Save the current file first
  vim.cmd 'w'

  -- Get the current file extension
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand '%'
  local filename_no_ext = vim.fn.expand '%:r'

  -- Define commands for different file types
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

  -- Get the command for the current filetype
  local command = run_commands[filetype]

  if command then
    -- Run the command in a terminal
    vim.cmd('!' .. command)
  else
    -- Show error message for unsupported file types
    vim.notify('No run command defined for filetype: ' .. filetype, vim.log.levels.WARN)
  end
end

-- Set up the keymap when this module is loaded
vim.keymap.set('n', '<leader><CR>', run_current_file, { desc = 'Run current file' })

-- Return an empty table since lazy.nvim expects a plugin spec
return {}
