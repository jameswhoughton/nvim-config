return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  init = function()
    local harpoon = require 'harpoon'

    harpoon:setup()

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon [A]dd file' })
    vim.keymap.set('n', '<leader>hr', function()
      harpoon:list():remove()
    end, { desc = '[H]arpoon [R]emove file' })
    vim.keymap.set('n', '<leader>hc', function()
      harpoon:list():clear()
    end, { desc = '[H]arpoon [C]lear list' })
    vim.keymap.set('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon [L]ist' })

    vim.keymap.set('n', '<C-1>', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<C-2>', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<C-3>', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<C-4>', function()
      harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<C-p>', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():next()
    end)

    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set('n', '<C-e>', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })
  end,
}
