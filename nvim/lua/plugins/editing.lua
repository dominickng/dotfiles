return {
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter" },
    branch = "v0.6",
    opts = {
      extensions = {
        alpha = {
          after = true,
        },
      },
    },
  },

  {
    "AndrewRadev/switch.vim",
    event = { "BufReadPost" },
    dependencies = {
      {
        "monaqa/dial.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        opts = function()
          local augend = require("dial.augend")

          local logical_alias = augend.constant.new({
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          })

          return {
            dials_by_ft = {
              astro = "web",
              css = "css",
              html = "web",
              htmldjango = "web",
              javascript = "typescript",
              javascriptreact = "typescript",
              json = "json",
              lua = "lua",
              markdown = "markdown",
              python = "python",
              sass = "css",
              scss = "css",
              svelte = "web",
              typescript = "typescript",
              typescriptreact = "typescript",
              vue = "web",
            },
            groups = {
              default = {
                augend.integer.alias.decimal,  -- nonnegative decimal number (0, 1, 2, 3, ...)
                -- augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
                augend.integer.alias.hex,      -- nonnegative hex number  (0x01, 0x1a1f, etc.)
                augend.date.alias["%Y/%m/%d"], -- date (2022/02/19)
                augend.date.alias["%Y-%m-%d"], -- date (2022-02-19)
                augend.date.alias["%d/%m/%Y"], -- date (19/02/2022)
                augend.constant.alias.bool,    -- boolean value (true <-> false)
                logical_alias,
              },
              web = {
                augend.constant.new({ elements = { "let", "const" } }),
                augend.hexcolor.new({ case = "lower" }),
                augend.hexcolor.new({ case = "upper" }),
              },
              typescript = {
                augend.constant.new({ elements = { "let", "const" } }),
              },
              css = {
                augend.hexcolor.new({
                  case = "lower",
                }),
                augend.hexcolor.new({
                  case = "upper",
                }),
              },
              markdown = {
                augend.constant.new({
                  elements = { "[ ]", "[x]" },
                  word = false,
                  cyclic = true,
                }),
                augend.misc.alias.markdown_header,
              },
              json = {
                augend.semver.alias.semver, -- versioning (v1.1.2)
              },
              lua = {
                augend.constant.new({
                  elements = { "and", "or" },
                  word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                  cyclic = true, -- "or" is incremented into "and".
                }),
              },
              python = {
                augend.constant.new({
                  elements = { "and", "or" },
                }),
              },
            },
          }
        end,
        config = function(_, opts)
          -- copy defaults to each group
          for name, group in pairs(opts.groups) do
            if name ~= "default" then
              vim.list_extend(group, opts.groups.default)
            end
          end
          require("dial.config").augends:register_group(opts.groups)
          vim.g.dials_by_ft = opts.dials_by_ft
        end,
      },
    },
    config = function()
      vim.g.switch_mapping = ""
      local fk = [=[\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>]=]
      local fv = [=[\=toupper(submatch(1)) . submatch(2)]=]
      local sk = [=[\<\(\u\l\+\)\(\u\l\+\)\+\>]=]
      local sv = [=[\=tolower(substitute(submatch(0), '\(\l\)\(\u\)', '\1_\2', 'g'))]=]
      local tk = [=[\<\(\l\+\)\(_\l\+\)\+\>]=]
      local tv = [=[\U\0]=]
      local fok = [=[\<\(\u\+\)\(_\u\+\)\+\>]=]
      local fov = [=[\=tolower(substitute(submatch(0), '_', '-', 'g'))]=]
      local fik = [=[\<\(\l\+\)\(-\l\+\)\+\>]=]
      local fiv = [=[\=substitute(submatch(0), '-\(\l\)', '\u\1', 'g')]=]
      vim.g["switch_custom_definitions"] = {
        vim.fn["switch#NormalizedCaseWords"]({
          "sunday",
          "monday",
          "tuesday",
          "wednesday",
          "thursday",
          "friday",
          "saturday",
        }),
        vim.fn["switch#NormalizedCaseWords"]({
          "january",
          "february",
          "march",
          "april",
          "may",
          "june",
          "july",
          "august",
          "september",
          "october",
          "november",
          "december",
        }),
        vim.fn["switch#NormalizedCaseWords"]({
          "first",
          "second",
          "third",
          "fourth",
          "fifth",
          "sixth",
          "seventh",
          "eighth",
          "ninth",
          "tenth",
        }),
        vim.fn["switch#NormalizedCaseWords"]({
          "1st",
          "2nd",
          "3rd",
          "4th",
          "5th",
          "6th",
          "7th",
          "8th",
          "9th",
          "10th",
        }),
        vim.fn["switch#NormalizedCase"]({ "yes", "no" }),
        vim.fn["switch#NormalizedCase"]({ "on", "off" }),
        vim.fn["switch#NormalizedCase"]({ "left", "right" }),
        vim.fn["switch#NormalizedCase"]({ "up", "down" }),
        vim.fn["switch#NormalizedCase"]({ "enable", "disable" }),
        vim.fn["switch#NormalizedCase"]({ "true", "false" }),
        { "==", "!=" },
        {
          [fk] = fv,
          [sk] = sv,
          [tk] = tv,
          [fok] = fov,
          [fik] = fiv,
        },
      }
      vim.keymap.set({ "n", "x" }, "<C-a>", function()
        vim.cmd([[
        :if !switch#Switch() | lua require("dial.map").manipulate("increment", "normal")
        :endif
        ]])
      end, {
        desc = "Switch variant or increment number/date",
      })
      vim.keymap.set({ "n", "x" }, "<C-x>", function()
        vim.cmd([[
        :if !switch#Switch({"reverse": 1}) | lua require("dial.map").manipulate("decrement", "normal")
        :endif
        ]])
      end, {
        desc = "Switch reverse variant or decrement number/date",
      })
    end,
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.api.nvim_set_hl(0, "MatchParen", { bg = "green" })
    end,
  },

  {
    "duqcyxwd/stringbreaker.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("string-breaker").setup()
    end,
  },

  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },

  {
    "Goose97/timber.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "ruicsh/tailwindcss-dial.nvim",
    dependencies = { "monaqa/dial.nvim" },
    opts = {
      group = "web",
    },
  },

  {
    "tpope/vim-abolish",
  },

  {
    "tpope/vim-ragtag",
  },

  {
    "Wansmer/sibling-swap.nvim",
    opts = {
      allowed_separators = {
        ",",
        ";",
        "and",
        "or",
        "&&",
        "&",
        "||",
        "|",
        "==",
        "===",
        "!=",
        "!==",
        "-",
        "+",
        ["<"] = ">",
        ["<="] = ">=",
        [">"] = "<",
        [">="] = "<=",
      },
      use_default_keymaps = true,
      -- Highlight recently swapped node. Can be boolean or table
      -- If table: { ms = 500, hl_opts = { link = "IncSearch" } }
      -- `hl_opts` is a `val` from `nvim_set_hl()`
      highlight_node_at_cursor = true,
      -- keybinding for movements to right or left (and up or down, if `allow_interline_swaps` is true)
      -- (`<C-,>` and `<C-.>` may not map to control chars at system level, so are sent by certain terminals as just `,` and `.`. In this case, just add the mappings you want.)
      keymaps = {
        ["g>"] = "swap_with_right",
        ["g<"] = "swap_with_left",
      },
      ignore_injected_langs = false,
      -- allow swaps across lines
      allow_interline_swaps = true,
      -- swaps interline siblings without separators (no recommended, helpful for swaps html-like attributes)
      interline_swaps_without_separator = false,
      -- Fallbacks for tiny settings for langs and nodes. See #fallback
      fallback = {},
    },
  },
}