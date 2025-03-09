return {
  {
    "AndreM222/copilot-lualine"
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("gitsigns").setup()
    end,
  },
  -- {
  --   'maxmx03/solarized.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function(_, opts)
  --     require("solarized").setup(opts)
  --     vim.cmd.colorscheme "solarized"
  --   end,
  -- },
  -- {
  -- 	"mhartington/oceanic-next",
  -- 	config = function()
  -- 		vim.g.oceanic_next_terminal_bold = true
  -- 		vim.g.oceanic_next_terminal_italic = true
  -- 		vim.cmd.colorscheme("OceanicNext")
  -- 	end,
  -- },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {},
          always_divide_middle = true
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
          lualine_c = { "filename" },
          lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {},
          extensions = {}
        }
      })
    end,
  },
  {
    "sainnhe/edge",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.edge_enable_italic = true
      vim.cmd.colorscheme("edge")
    end,
  },
  {
    "tpope/vim-fugitive",
  },
}
