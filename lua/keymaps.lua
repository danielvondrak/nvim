-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

--vim.keymap.set('n', '<leader>k', ':sp | term gcc % -o %:t:r && %:t:r', { desc = 'Compile C file' })
vim.keymap.set('n', '<leader><F5>', ':sp | term build<cr>', { desc = 'build' })

vim.keymap.set('n', '<leader>st', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 15)
end, { desc = 'Open [S]mall [T]erminal' })

function jump_pair()
  local ext = vim.fn.expand '%:e'

  local source_exts = { 'cpp', 'c' }
  local header_exts = { 'hpp', 'h' }

  local target_exts = nil
  if vim.tbl_contains(header_exts, ext) then
    target_exts = source_exts
  elseif vim.tbl_contains(source_exts, ext) then
    target_exts = header_exts
  else
    print 'Not a recognized file pair'
    return
  end

  local base_name = vim.fn.expand '%:r'
  for _, target_ext in ipairs(target_exts) do
    local target_file = base_name .. '.' .. target_ext
    if (vim.fn.filereadable(target_file)) == 1 then
      vim.cmd('edit ' .. target_file)
      return
    end
  end

  print 'Corresponding file not found!'
end

vim.keymap.set('n', '<leader>h', ':lua jump_pair()<CR>', { desc = 'Jump to/from header', silent = true })
