return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  config = function()
    require('render-markdown').setup {
      anti_conceal = {
        enabled = false,
      },
      file_types = { 'markdown' },
    }
    vim.keymap.set('n', '<leader>md', function()
      require('render-markdown').toggle() -- toggles raw/render
    end, { desc = 'Toggle Markdown Preview' })
  end,
}
