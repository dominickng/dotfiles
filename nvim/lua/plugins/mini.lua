return {
  {
    "nvim-mini/mini.ai",
    dependencies = {
      {
        "nvim-mini/mini.extra",
        version = false,
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    config = function()
      local gen_spec = require("mini.ai").gen_spec
      local gen_ai_spec = require("mini.extra").gen_ai_spec
      local get_find_pattern = function(pattern)
        return function(line, init)
          local from, to = line:find(pattern, init)
          return from, to
        end
      end
      local get_pattern_textobj_spec = function(pattern)
        return function(ai_type)
          if ai_type == "i" then
            return { pattern }
          end
          return { get_find_pattern(pattern), { "^().*()$" } }
        end
      end
      require("mini.ai").setup({
        custom_textobjects = {
          -- Function definition
          F = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),

          -- the nearest enclosing conditional or loop
          o = gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),

          -- variable
          v = gen_spec.treesitter({
            a = "@variable.outer",
            i = "@variable.inner",
          }),

          -- key: value property
          [":"] = gen_spec.treesitter({
            a = "@property.outer",
            i = "@property.inner",
          }),

          -- assignment
          ["="] = gen_spec.treesitter({
            a = "@assignment.outer",
            i = "@assignment.inner",
          }),

          -- line without whitespace
          L = gen_ai_spec.line(),

          -- number (possibly including a decimal)
          -- %f is the frontier pattern: http://lua-users.org/wiki/FrontierPattern
          N = get_pattern_textobj_spec("%f[%d-%.]-?[%d%.]+[%d,.]*%f[%D]"),

          -- function usage
          u = gen_spec.function_call(),

          -- URL
          U = get_pattern_textobj_spec([[%f[%l]%l+://[^%s{}"'`<>]+]]),

          -- UUID
          D = get_pattern_textobj_spec("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"),
        },
      })
    end,
    version = false,
  },

  {
    "nvim-mini/mini.move",
    opts = {
      mappings = {
        left = "<C-H>",
        right = "<C-L>",
        down = "<C-J>",
        up = "<C-K>",
      },
    },
    version = false,
  },

  {
    "nvim-mini/mini.operators",
    opts = {},
    version = false,
  },

  {
    "nvim-mini/mini.splitjoin",
    opts = {},
    version = false,
  },

  {
    "nvim-mini/mini.surround",
    opts = {
      respect_selection_type = true,
      search_method = "cover_or_nearest",
    },
    version = false,
  },

  {
    "nvim-mini/mini.basics",
    opts = {
      options = {
        basic = false,
        extra_ui = false,
        win_borders = "double",
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
    },
    version = false
  },

  {
    "nvim-mini/mini.bracketed",
    opts = {
      comment = { suffix = "" },
      diagnostic = { suffix = "" },
      file = { suffix = "" },
      indent = { suffix = "" },
      oldfile = { suffix = "" },
    },
    version = false
  },

  {
    "nvim-mini/mini.clue",
    config = function()
      local miniclue = require('mini.clue')
      miniclue.setup({
        window = {
          config = { anchor = "SE", row = "auto", col = "auto", width = 60 },
          delay = 750,
        },
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<leader>" },
          { mode = "x", keys = "<leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- Movement comments
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },

          -- fzf-lua
          { mode = "n", keys = "<Bslash>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
    version = false
  },

  {
    "nvim-mini/mini.cursorword",
    config = function()
      _G.cursorword_blocklist = function()
        local curword = vim.fn.expand("<cword>")
        local filetype = vim.bo.filetype

        local blocklist = {}
        if filetype == "lua" then
          blocklist = {
            "local",
            "require",
            "end",
            "function",
            "return",
            "if",
            "else",
            "require",
          }
        elseif filetype == "javascript" or filetype == "typescript" then
          blocklist = {
            "import",
            "const",
            "let",
            "function",
            "class",
            "export",
            "await",
            "async",
            "return",
            "for",
            "if",
            "while",
            "else",
            "private",
            "implements",
            "try",
            "catch",
          }
        end

        vim.b.minicursorword_disable = vim.tbl_contains(blocklist, curword)
      end
      vim.cmd("au CursorMoved * lua _G.cursorword_blocklist()")
      require("mini.cursorword").setup()

      vim.api.nvim_set_hl(0, "MiniCursorword", { italic = true, bg = "#2F4640" })
      vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { italic = true, bg = "#2F4640" })
    end,
    version = false
  },

  {
    "nvim-mini/mini.hipatterns",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          fixme     = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack      = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo      = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note      = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        }
      })
    end,
    version = false
  },

  {
    "nvim-mini/mini.indentscope",
    config = function()
      require("mini.indentscope").setup({
        draw = {
          animation = require("mini.indentscope").gen_animation.none()
        }
      })
    end,
    version = false
  },

  {
    "nvim-mini/mini.starter",
    opts = {},
    version = false
  },
}