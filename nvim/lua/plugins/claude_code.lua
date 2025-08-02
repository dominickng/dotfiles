return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {
      terminal_cmd = "~/.claude/local/claude",
    },
    keys = {
      {
        "<leader>c",
        nil,
        desc = "Claude Code"
      },
      {
        "<leader>cc",
        "<cmd>ClaudeCode<cr>",
        desc = "[C]laude [C]ode Toggle"
      },
      {
        "<leader>cf",
        "<cmd>ClaudeCodeFocus<cr>",
        desc = "[C]laude Code [F]ocus"
      },
      {
        "<leader>cr",
        "<cmd>ClaudeCode --resume<cr>",
        desc = "[C]laude Code [R]esume"
      },
      {
        "<leader>cC",
        "<cmd>ClaudeCode --continue<cr>",
        desc = "[C]laude Code [C]ontinue"
      },
      {
        "<leader>cA",
        "<cmd>ClaudeCodeAdd %<cr>",
        desc = "[C]laude Code [A]dd current buffer"
      },
      {
        "<leader>cS",
        "<cmd>ClaudeCodeSend<cr>",
        mode = "v",
        desc = "[C]laude Code [S]end"
      },
      {
        "<leader>cA",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "[C]laude Code [A]dd File",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      {
        "<leader>cy",
        "<cmd>ClaudeCodeDiffAccept<cr>",
        desc = "[C]laude Code [Y]es Diff"
      },
      {
        "<leader>cn",
        "<cmd>ClaudeCodeDiffDeny<cr>",
        desc = "[C]laude Code [N]o Diff"
      },
      {
        "<leader>cm",
        "<cmd>ClaudeCodeSelectModel<cr>",
        desc = "[C]laude Code Select [M]odel"
      },
    },
  }
}
