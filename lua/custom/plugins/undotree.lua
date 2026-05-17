return {
  'mbbill/undotree',
  cmd = 'UndotreeToggle', -- Lazy load on command
  keys = {
    { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = '[U]ndo tree' },
  },
  config = function()
    -- Undotree window configuration
    vim.g.undotree_WindowLayout = 2 -- Layout style
    vim.g.undotree_ShortIndicators = 1 -- Use short time indicators
    vim.g.undotree_SetFocusWhenToggle = 1 -- Focus undotree when opened
    vim.g.undotree_DiffAutoOpen = 1 -- Auto open diff window
  end,
}
