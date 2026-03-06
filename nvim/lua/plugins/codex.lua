return {
  {
    "ishiooon/codex.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "Codex", "CodexFocus", "CodexSend" },
    opts = {
      terminal_cmd = "/opt/homebrew/bin/codex",
    },
    keys = {
      { "<leader>cd", "<cmd>Codex<cr>", desc = "Codex: Toggle" },
      { "<leader>cdf", "<cmd>CodexFocus<cr>", desc = "Codex: Focus" },
      { "<leader>cds", "<cmd>CodexSend<cr>", mode = "v", desc = "Codex: Send selection" },
    },
  },
}
