-- ~/.config/nvim/lua/custom/scroll-lock.lua

-- Scroll lock state
local scroll_lock_enabled = false

-- Store original keymaps so we can restore them
local original_j_map = nil
local original_k_map = nil

-- Function to enable scroll lock
local function enable_scroll_lock()
  -- Center the current line immediately
  vim.cmd 'normal! zz'

  -- Store original keymaps if they exist
  local j_map = vim.fn.maparg('j', 'n', false, true)
  local k_map = vim.fn.maparg('k', 'n', false, true)

  if j_map and j_map.rhs then
    original_j_map = j_map
  end
  if k_map and k_map.rhs then
    original_k_map = k_map
  end

  -- Set new keymaps that center after movement
  vim.keymap.set('n', 'j', function()
    vim.cmd 'normal! j'
    vim.cmd 'normal! zz'
  end, { desc = 'Move down and center (scroll lock)' })

  vim.keymap.set('n', 'k', function()
    vim.cmd 'normal! k'
    vim.cmd 'normal! zz'
  end, { desc = 'Move up and center (scroll lock)' })

  -- Show status message
  print 'Scroll lock enabled - cursor will stay centered'
end

-- Function to disable scroll lock
local function disable_scroll_lock()
  -- Remove our custom keymaps
  vim.keymap.del('n', 'j')
  vim.keymap.del('n', 'k')

  -- Restore original keymaps if they existed
  if original_j_map and original_j_map.rhs then
    vim.keymap.set('n', 'j', original_j_map.rhs, {
      desc = original_j_map.desc or 'Move down',
      silent = original_j_map.silent == 1,
      noremap = original_j_map.noremap == 1,
      expr = original_j_map.expr == 1,
    })
  end

  if original_k_map and original_k_map.rhs then
    vim.keymap.set('n', 'k', original_k_map.rhs, {
      desc = original_k_map.desc or 'Move up',
      silent = original_k_map.silent == 1,
      noremap = original_k_map.noremap == 1,
      expr = original_k_map.expr == 1,
    })
  end

  -- Clear stored maps
  original_j_map = nil
  original_k_map = nil

  -- Show status message
  print 'Scroll lock disabled - normal movement restored'
end

-- Main toggle function
local function toggle_scroll_lock()
  scroll_lock_enabled = not scroll_lock_enabled

  if scroll_lock_enabled then
    enable_scroll_lock()
  else
    disable_scroll_lock()
  end
end

-- Set up the zl keymap
vim.keymap.set('n', 'zl', toggle_scroll_lock, {
  desc = 'Toggle scroll lock (cursor stays centered)',
  silent = true,
})

-- Optional: Add to which-key if it's available
local ok, which_key = pcall(require, 'which-key')
if ok then
  which_key.add {
    { 'zl', desc = 'Toggle scroll lock' },
  }
end
