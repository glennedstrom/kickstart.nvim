return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  keys = {
    -- Only navigation keybindings, no <leader>b* commands (conflicts with debug breakpoint)
    { '<S-h>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
    { ']b', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
  },
  opts = {
    options = {
      mode = 'buffers', -- 'tabs' or 'buffers'
      themable = true,
      numbers = 'none', -- 'none' | 'ordinal' | 'buffer_id' | 'both'
      close_command = 'bdelete! %d',
      right_mouse_command = 'bdelete! %d',
      left_mouse_command = 'buffer %d',
      middle_mouse_command = nil,
      indicator = {
        icon = '▎',
        style = 'icon', -- 'icon' | 'underline' | 'none'
      },
      buffer_close_icon = '󰅖',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      max_name_length = 18,
      max_prefix_length = 15,
      truncate_names = true,
      tab_size = 20,
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match 'error' and ' ' or ' '
        return ' ' .. icon .. count
      end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          text_align = 'center',
          separator = true,
        },
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      separator_style = 'thin', -- 'slant' | 'slope' | 'thick' | 'thin' | { 'any', 'any' }
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
      sort_by = 'insert_after_current',
    },
  },
}
