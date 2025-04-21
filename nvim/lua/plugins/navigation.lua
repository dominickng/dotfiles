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
        treesitter = { suffix = "" },
      })
    end,
    version = false
  },
  {
    "jinh0/eyeliner.nvim",
    config = function()
      require("eyeliner").setup({})
    end
  },
}
