return {
  {
    "AndreM222/copilot-lualine"
  },
  {
    "arkav/lualine-lsp-progress"
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      -- local function filename()
      --   return require('lspsaga.symbol.winbar').get_bar()
      -- end
      local colors = require("solarized-osaka.colors").setup()

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "onedark",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {},
          always_divide_middle = true,
          always_show_tabline = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff",
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " }
            }
          },
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = false,
              path = 4,
              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[No Name]',
                newfile = '[New]',
              }
            }
          },
          lualine_x = { {
            'lsp_progress',
            display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
            colors = {
              percentage      = colors.cyan,
              title           = colors.cyan,
              message         = colors.cyan,
              spinner         = colors.cyan,
              lsp_client_name = colors.magenta,
              use             = true,
            },
            separators = {
              component = ' ',
              progress = ' | ',
              percentage = { pre = '', post = '%% ' },
              title = { pre = '', post = ': ' },
              lsp_client_name = { pre = '[', post = ']' },
              spinner = { pre = '', post = '' },
              message = { pre = '(', post = ')', commenced = 'In Progress', completed = 'Completed' },
            },
            timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
            spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
          }, "copilot", "encoding", "fileformat", "filetype" },
          lualine_y = { "progress", "selectioncount", "searchcount" },
          lualine_z = { "location" },
          tabline = {},
          extensions = {}
        },
        inactive_sections = {
          lualine_c = {
            {
              'filename',
              file_status = true,
              newfile_status = false,
              path = 4,
              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
              symbols = {
                modified = '[+]',
                readonly = '[-]',
                unnamed = '[No Name]',
                newfile = '[New]',
              }
            }
          },
          lualine_x = { 'location' },
        },
        tabline = {
          lualine_a = {
            {
              'tabs',
              tab_max_length = 40,        -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
              max_length = vim.o.columns, -- Maximum width of tabs component.
              -- Note:
              -- It can also be a function that returns
              -- the value of `max_length` dynamically.
              mode = 2, -- 0: Shows tab_nr
              -- 1: Shows tab_name
              -- 2: Shows tab_nr + tab_name

              path = 3, -- 0: just shows the filename
              -- 1: shows the relative path and shorten $HOME to ~
              -- 2: shows the full path
              -- 3: shows the full path and shorten $HOME to ~

              -- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
              use_mode_colors = false,

              show_modified_status = false, -- Shows a symbol next to the tab name if the file has been modified.
              symbols = {
                modified = '[+]',           -- Text to show when the file is modified.
              },

              fmt = function(name, context)
                -- Show + if buffer is modified in tab
                local buflist = vim.fn.tabpagebuflist(context.tabnr)
                local winnr = vim.fn.tabpagewinnr(context.tabnr)
                local bufnr = buflist[winnr]
                local mod = vim.fn.getbufvar(bufnr, '&mod')
                local tabname = vim.fn.bufname(bufnr) or "No Name"

                return vim.fn.pathshorten(tabname) ..
                    "[" .. #buflist .. "]" .. (mod == 1 and '+' or '')
              end
            }
          }
        },
        extensions = { "fugitive" }
      })
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({})
    end
  },
  {
    'tzachar/highlight-undo.nvim',
    opts = {
      hlgroup = "HighlightUndo",
      duration = 300,
      pattern = { "*" },
      ignored_filetypes = { "neo-tree", "fugitive", "mason", "lazy" },
      -- ignore_cb = nil,
    },
  },
}
