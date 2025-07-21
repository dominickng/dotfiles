return {
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
    },
    opts = {
      skipInsignificantPunctuation = false,
      consistentOperatorPending = false,
      subwordMovement = true,
      customPatterns = {},
    }
  },
  {
    "echasnovski/mini.bracketed",
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
    "jinh0/eyeliner.nvim",
    opts = {
      dim = true,
      max_length = 100,
      highlight_on_key = true,
      disabled_filetypes = { "gitcommit", "help", "json", "terminal" },
      disabled_buftypes = { "nofile", "ministarter" }
    }
  },
}
