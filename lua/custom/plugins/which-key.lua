return {
  'folke/which-key.nvim',
  opts = function(_, opts)
    opts.spec = opts.spec or {}
    vim.list_extend(opts.spec, {
      { '<leader>c', group = '[C]ompetitive' },
      { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
      { '<leader>h', group = '[H]arpoon' },
      { '<leader>n', group = '[N]eotree' },
      { '<leader>T', group = '[T]est' },
    })
  end,
}
