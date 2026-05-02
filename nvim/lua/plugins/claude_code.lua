return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function(_, opts)
      require("claudecode").setup(opts)

      -- Sticky-terminal logic: neovim windows are tab-local, so by default the
      -- Claude split lives only in the tab where it's opened. Enforce a
      -- "single window that follows the active tab" model by managing the
      -- window and ignoring snacks' internal `terminal.win` tracking
      -- (which only ever points at one window and gets confused across tabs).

      -- Pull the buffer id from snacks' provider. Returns nil if the terminal
      -- has never been opened or has been wiped.
      local function get_claude_bufnr()
        local ok, provider = pcall(require, "claudecode.terminal.snacks")
        if not ok then
          return nil
        end
        return provider.get_active_bufnr()
      end

      -- Find the window in `tabpage` displaying `bufnr`, if any. Pass 0 for
      -- the current tab.
      local function find_win_in_tab(bufnr, tabpage)
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
          if vim.api.nvim_win_get_buf(win) == bufnr then
            return win
          end
        end
        return nil
      end

      -- Tear down stale Claude windows in every tab except the current one,
      -- so the terminal is only ever visible in one place at a time. This is
      -- what makes it feel like the same window "moves" with you.
      local function close_claude_in_other_tabs(bufnr)
        local current = vim.api.nvim_get_current_tabpage()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          if tab ~= current then
            local win = find_win_in_tab(bufnr, tab)
            if win then
              vim.api.nvim_win_close(win, true)
            end
          end
        end
      end

      -- Open the Claude buffer as a right-side vertical split in the current
      -- tab and force a consistent width. 30% matches the first step of the
      -- <S-Up>/<S-Down> resize sequence in mappings.lua and claudecode.nvim's
      -- own split_width_percentage default, so the initial width lines up
      -- with the smallest manual resize step.
      local function open_claude_here(bufnr)
        vim.cmd("vertical rightbelow sbuffer " .. bufnr)
        vim.api.nvim_win_set_width(0, math.floor(vim.o.columns * 0.3))
      end

      -- Custom toggle bound to <leader>cc. We bypass `:ClaudeCode` (whose
      -- toggle relies on snacks' single tracked win id) and instead operate
      -- on whichever window in the current tab shows the Claude buffer.
      vim.api.nvim_create_user_command("ClaudeCodeStickyToggle", function()
        local bufnr = get_claude_bufnr()
        -- No terminal yet — fall back to the plugin's bootstrap path so it
        -- spawns the Claude process and creates the buffer.
        if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
          vim.cmd("ClaudeCode")
          return
        end
        local win = find_win_in_tab(bufnr, 0)
        if win then
          -- Visible here → hide it.
          vim.api.nvim_win_close(win, true)
        else
          -- Hidden (or visible only in another tab) → move it here.
          close_claude_in_other_tabs(bufnr)
          open_claude_here(bufnr)
        end
      end, {})

      -- "Should the terminal follow me on the next tab switch?" derived from
      -- whether Claude was visible in the tab we're leaving. This means
      -- hiding Claude with <leader>cc keeps it hidden across tab switches —
      -- we only drag it along if it was on screen when you left.
      local drag_to_next_tab = false

      vim.api.nvim_create_autocmd("TabLeave", {
        callback = function()
          local bufnr = get_claude_bufnr()
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
            drag_to_next_tab = false
            return
          end
          drag_to_next_tab = find_win_in_tab(bufnr, 0) ~= nil
        end,
      })

      -- On tab switch, drag the Claude window into the new tab iff it was
      -- visible when we left the previous tab. Combined with the per-tab
      -- close above, this keeps exactly one Claude window pinned to the
      -- active tab while still respecting an explicit hide.
      -- Note: this also fires when the diff workflow opens its own tab,
      -- giving you a 3-pane "original | proposed | claude" review layout.
      vim.api.nvim_create_autocmd("TabEnter", {
        callback = function()
          if not drag_to_next_tab then
            return
          end
          local bufnr = get_claude_bufnr()
          if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          if find_win_in_tab(bufnr, 0) then
            return
          end
          close_claude_in_other_tabs(bufnr)
          open_claude_here(bufnr)
        end,
      })
    end,
    opts = {
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_new_tab = true,
        keep_terminal_focus = false,
      },
    },
    keys = {
      {
        "<leader>c",
        nil,
        desc = "Claude Code",
      },
      {
        "<leader>cc",
        "<cmd>ClaudeCodeStickyToggle<cr>",
        desc = "[C]laude [C]ode Toggle",
      },
      {
        "<leader>cf",
        "<cmd>ClaudeCodeFocus<cr>",
        desc = "[C]laude Code [F]ocus",
      },
      {
        "<leader>cr",
        "<cmd>ClaudeCode --resume<cr>",
        desc = "[C]laude Code [R]esume",
      },
      {
        "<leader>cC",
        "<cmd>ClaudeCode --continue<cr>",
        desc = "[C]laude Code [C]ontinue",
      },
      {
        "<leader>cA",
        "<cmd>ClaudeCodeAdd %<cr>",
        desc = "[C]laude Code [A]dd current buffer",
      },
      {
        "<leader>cS",
        "<cmd>ClaudeCodeSend<cr>",
        mode = "v",
        desc = "[C]laude Code [S]end",
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
        desc = "[C]laude Code [Y]es Diff",
      },
      {
        "<leader>cn",
        "<cmd>ClaudeCodeDiffDeny<cr>",
        desc = "[C]laude Code [N]o Diff",
      },
      {
        "<leader>cm",
        "<cmd>ClaudeCodeSelectModel<cr>",
        desc = "[C]laude Code Select [M]odel",
      },
    },
  },
}
