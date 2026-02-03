return {
  {
    'mbbill/undotree',
    lazy = true, -- Optional: lazy load
    keys = { -- Define key mappings for lazy loading
      { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Undo Tree Toggle' },
    },
  },
}
