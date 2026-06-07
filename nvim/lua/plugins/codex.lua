return {
  {
    "ishiooon/codex.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "Codex", "CodexFocus", "CodexSend", "CodexStickyToggle" },
    config = function(_, opts)
      require("codex").setup(opts)

      require("sticky_terminal").setup({
        command = "CodexStickyToggle",
        bootstrap_command = "Codex",
        provider = "codex.terminal.snacks",
      })
    end,
    opts = {
      diff_opts = {
        layout = "vertical",
        open_in_new_tab = true,
        keep_terminal_focus = false,
      },
      terminal_cmd = "/opt/homebrew/bin/codex",
      env = {
        ENABLE_IDE_INTEGRATION = "true",
        CODEX_CODE_SSE_PORT = "12345",
      },
    },
    keys = {
      { "<leader>cd", "<cmd>CodexStickyToggle<cr>", desc = "Codex: Toggle" },
      { "<leader>cdf", "<cmd>CodexFocus<cr>", desc = "Codex: Focus" },
      { "<leader>cds", "<cmd>CodexSend<cr>", mode = "v", desc = "Codex: Send selection" },
    },
  },
}
