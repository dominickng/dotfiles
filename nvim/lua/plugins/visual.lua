return {
  {
    "AndreM222/copilot-lualine"
  },
  {
    "arkav/lualine-lsp-progress"
  },
  {
    "echasnovski/mini.basics",
    config = function()
      require("mini.basics").setup({
        options = {
          basic = false,
          extra_ui = false,
          win_borders = 'double',
        },
        mappings = {
          basic = false,
          option_toggle_prefix = [[|]],
          windows = false,
          move_with_alt = false,
        },
        autocommands = {
          basic = false,
          relnum_in_visual_mode = false
        }
      })
    end,
    version = false
  },
  {
    "echasnovski/mini.cursorword",
    config = function()
      _G.cursorword_blocklist = function()
        local curword = vim.fn.expand('<cword>')
        local filetype = vim.bo.filetype

        local blocklist = {}
        if filetype == "lua" then
          blocklist = { "local", "require", "end", "function", "return", "if", "else", "require" }
        elseif filetype == "javascript" or filetype == "typescript" then
          blocklist = { "import", "const", "let", "function", "class", "export", "await", "async", "return", "for", "if",
            "while", "else", "private", "implements", "try", "catch" }
        end

        vim.b.minicursorword_disable = vim.tbl_contains(blocklist, curword)
      end
      vim.cmd('au CursorMoved * lua _G.cursorword_blocklist()')
      require("mini.cursorword").setup()
      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { standout = true })
    end,
    version = false
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup({
        draw = {
          animation = require("mini.indentscope").gen_animation.none()
        }
      })
    end,
    version = false
  },
  -- {
  --   "echasnovski/mini.starter",
  --   config = function()
  --     require("mini.starter").setup({})
  --   end,
  --   version = false
  -- },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
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
            },
            {
              require("nvim-possession").status,
              cond = function()
                return require("nvim-possession").status() ~= nil
              end,
            },
          },
          lualine_x = { 'location' },
        },
        tabline = {
          lualine_a = {
            {
              'tabs',
              tab_max_length = 40,             -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
              max_length = vim.fn.winwidth(0), -- Maximum width of tabs component.
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
    "nvim-tree/nvim-web-devicons",
  },
  {
    "y3owk1n/undo-glow.nvim",
    version = "*",
    event = { "VeryLazy" },
    ---@type UndoGlow.Config
    opts = {
      animation = {
        enabled = true,
        duration = 500,
        animtion_type = "zoom",
        window_scoped = true,
      },
      highlights = {
        undo = {
          hl_color = { bg = "#693232" }, -- Dark muted red
        },
        redo = {
          hl_color = { bg = "#2F4640" }, -- Dark muted green
        },
        yank = {
          hl_color = { bg = "#7A683A" }, -- Dark muted yellow
        },
        paste = {
          hl_color = { bg = "#325B5B" }, -- Dark muted cyan
        },
        search = {
          hl_color = { bg = "#5C475C" }, -- Dark muted purple
        },
        comment = {
          hl_color = { bg = "#7A5A3D" }, -- Dark muted orange
        },
        cursor = {
          hl_color = { bg = "#793D54" }, -- Dark muted pink
        },
      },
      priority = 2048 * 3,
    },
    keys = {
      {
        "u",
        function()
          require("undo-glow").undo()
        end,
        mode = "n",
        desc = "Undo with highlight",
        noremap = true,
      },
      {
        "U",
        function()
          require("undo-glow").redo()
        end,
        mode = "n",
        desc = "Redo with highlight",
        noremap = true,
      },
      {
        "p",
        function()
          require("undo-glow").paste_below()
        end,
        mode = "n",
        desc = "Paste below with highlight",
        noremap = true,
      },
      {
        "P",
        function()
          require("undo-glow").paste_above()
        end,
        mode = "n",
        desc = "Paste above with highlight",
        noremap = true,
      },
      {
        "n",
        function()
          require("undo-glow").search_next({
            animation = {
              animation_type = "strobe",
            },
          })
        end,
        mode = "n",
        desc = "Search next with highlight",
        noremap = true,
      },
      {
        "N",
        function()
          require("undo-glow").search_prev({
            animation = {
              animation_type = "strobe",
            },
          })
        end,
        mode = "n",
        desc = "Search prev with highlight",
        noremap = true,
      },
      {
        "gc",
        function()
          -- This is an implementation to preserve the cursor position
          local pos = vim.fn.getpos(".")
          vim.schedule(function()
            vim.fn.setpos(".", pos)
          end)
          return require("undo-glow").comment()
        end,
        mode = { "n", "x" },
        desc = "Toggle comment with highlight",
        expr = true,
        noremap = true,
      },
      {
        "gc",
        function()
          require("undo-glow").comment_textobject()
        end,
        mode = "o",
        desc = "Comment textobject with highlight",
        noremap = true,
      },
      {
        "gcc",
        function()
          return require("undo-glow").comment_line()
        end,
        mode = "n",
        desc = "Toggle comment line with highlight",
        expr = true,
        noremap = true,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        callback = function()
          require("undo-glow").yank()
        end,
      })

      -- This only handles neovim instance and do not highlight when switching panes in tmux
      vim.api.nvim_create_autocmd("CursorMoved", {
        desc = "Highlight when cursor moved significantly",
        callback = function()
          require("undo-glow").cursor_moved({
            animation = {
              animation_type = "slide",
            },
          })
        end,
      })

      -- This will handle highlights when focus gained, including switching panes in tmux
      vim.api.nvim_create_autocmd("FocusGained", {
        desc = "Highlight when focus gained",
        callback = function()
          ---@type UndoGlow.CommandOpts
          local opts = {
            animation = {
              animation_type = "slide",
            },
          }

          opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
          local pos = require("undo-glow.utils").get_current_cursor_row()

          require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
            s_row = pos.s_row,
            s_col = pos.s_col,
            e_row = pos.e_row,
            e_col = pos.e_col,
            force_edge = opts.force_edge == nil and true or opts.force_edge,
          }))
        end,
      })

      vim.api.nvim_create_autocmd("CmdLineLeave", {
        pattern = { "/", "?" },
        desc = "Highlight when search cmdline leave",
        callback = function()
          require("undo-glow").search_cmd({
            animation = {
              animation_type = "fade",
            },
          })
        end,
      })
    end,
  },
}
