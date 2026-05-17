-- Legacy lazy.nvim plugin spec archived during vim.pack migration. This file no longer works as-is.
return {
  'nvim-treesitter/nvim-treesitter',
  build = false,
  config = function()
    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
      if not vim.treesitter.language.add(language) then
        return
      end

      vim.treesitter.start(buf, language)

      local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
      if has_indent_query then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('custom-treesitter-attach', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local filetype = args.match
        local language = vim.treesitter.language.get_lang(filetype)

        if not language then
          return
        end

        local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
        if vim.tbl_contains(installed_parsers, language) then
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end,
}
