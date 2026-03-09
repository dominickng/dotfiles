return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        styles = {
          comments = { italic = false },
        },
      })
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
}
