vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local file = vim.api.nvim_buf_get_name(0)
    if file ~= '' then vim.cmd('lcd ' .. vim.fn.fnamemodify(file, ':p:h')) end
  end,
})

-- Table to store timers per buffer
local autosave_timers = {}

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
  pattern = '*',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)

    -- Check if file is in excluded directories
    local excluded_patterns = {
      vim.fn.expand '~/AppData/Local/nvim',
      vim.fn.expand '~/.config/nvim',
      '/etc/nvim',
      -- Add more if needed
    }

    local should_exclude = false
    for _, pattern in ipairs(excluded_patterns) do
      if filename:match(vim.pesc(pattern)) then
        should_exclude = true
        break
      end
    end

    if should_exclude or not vim.bo.modifiable or vim.bo.filetype == '' or vim.bo.buftype ~= '' then return end

    -- Cancel any existing timer for this buffer
    if autosave_timers[bufnr] then
      autosave_timers[bufnr]:stop()
      autosave_timers[bufnr]:close()
    end

    -- Start a new timer
    local timer = vim.loop.new_timer()
    timer:start(
      5000,
      0,
      vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modifiable then vim.api.nvim_buf_call(bufnr, function() vim.cmd 'silent! write' end) end
      end)
    )

    -- Store the timer so we can cancel if needed
    autosave_timers[bufnr] = timer
  end,
})
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath 'state' .. '/undo'
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { desc = 'Toggle Undo Tree' })
-- Additional useful mappings:
vim.keymap.set('n', '<leader>U', '<cmd>UndotreeShow<cr>', { desc = 'Show Undo Tree' })
vim.keymap.set('n', '<leader>uf', '<cmd>UndotreeFocus<cr>', { desc = 'Focus Undo Tree' })
