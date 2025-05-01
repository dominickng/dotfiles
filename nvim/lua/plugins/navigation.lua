return {
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
    },
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = false,
        consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
        subwordMovement = true,
        customPatterns = {},               -- check "Custom Movement Patterns" in the README for details
      })
    end
  },
  {
    "echasnovski/mini.bracketed",
    config = function()
      require("mini.bracketed").setup({
        comment = { suffix = "" },
        diagnostic = { suffix = "" },
        file = { suffix = "" },
        indent = { suffix = "" },
        oldfile = { suffix = "" },
      })
    end,
    version = false
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  -- {
  --   "jinh0/eyeliner.nvim",
  --   config = function()
  --     require("eyeliner").setup({
  --       highlight_on_key = true,
  --     })
  --   end
  -- },
}
