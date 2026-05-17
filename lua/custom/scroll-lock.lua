-- Scroll lock state
local scroll_lock_enabled = false

local original_j_map = nil
local original_k_map = nil

local function enable_scroll_lock()
  vim.cmd 'normal! zz'

  local j_map = vim.fn.maparg('j', 'n', false, true)
  local k_map = vim.fn.maparg('k', 'n', false, true)

  if j_map and j_map.rhs then
    original_j_map = j_map
  end
  if k_map and k_map.rhs then
    original_k_map = k_map
  end

  vim.keymap.set('n', 'j', function()
    vim.cmd 'normal! j'
    vim.cmd 'normal! zz'
  end, { desc = 'Move down and center (scroll lock)' })

  vim.keymap.set('n', 'k', function()
    vim.cmd 'normal! k'
    vim.cmd 'normal! zz'
  end, { desc = 'Move up and center (scroll lock)' })

  print 'Scroll lock enabled - cursor will stay centered'
end

local function disable_scroll_lock()
  vim.keymap.del('n', 'j')
  vim.keymap.del('n', 'k')

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

  original_j_map = nil
  original_k_map = nil

  print 'Scroll lock disabled - normal movement restored'
end

local function toggle_scroll_lock()
  scroll_lock_enabled = not scroll_lock_enabled

  if scroll_lock_enabled then
    enable_scroll_lock()
  else
    disable_scroll_lock()
  end
end

vim.keymap.set('n', 'zl', toggle_scroll_lock, {
  desc = 'Toggle scroll lock (cursor stays centered)',
  silent = true,
})

local ok, which_key = pcall(require, 'which-key')
if ok then
  which_key.add {
    { 'zl', desc = 'Toggle scroll lock' },
  }
end
