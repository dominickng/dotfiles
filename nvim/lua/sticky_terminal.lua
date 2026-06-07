local M = {}

local function find_win_in_tab(bufnr, tabpage)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

function M.setup(opts)
  local last_width_frac = nil
  local drag_to_next_tab = false
  local tab_count_at_leave = nil

  local function get_bufnr()
    local ok, provider = pcall(require, opts.provider)
    if not ok then
      return nil
    end
    return provider.get_active_bufnr()
  end

  local function close_in_other_tabs(bufnr)
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

  local function set_width(win)
    vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * (last_width_frac or opts.default_width_frac or 0.3)))
  end

  local function open_here(bufnr)
    vim.cmd("vertical rightbelow sbuffer " .. bufnr)
    set_width(0)
  end

  local function drag_here()
    local bufnr = get_bufnr()
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    local prev_win = vim.api.nvim_get_current_win()
    close_in_other_tabs(bufnr)
    local existing = find_win_in_tab(bufnr, 0)
    if existing then
      set_width(existing)
    else
      open_here(bufnr)
    end
    if vim.api.nvim_win_is_valid(prev_win) and vim.api.nvim_get_current_win() ~= prev_win then
      vim.api.nvim_set_current_win(prev_win)
    end
  end

  vim.api.nvim_create_user_command(opts.command, function()
    local bufnr = get_bufnr()
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
      vim.cmd(opts.bootstrap_command)
      return
    end
    local win = find_win_in_tab(bufnr, 0)
    if win then
      last_width_frac = vim.api.nvim_win_get_width(win) / vim.o.columns
      vim.api.nvim_win_close(win, true)
    else
      close_in_other_tabs(bufnr)
      open_here(bufnr)
    end
  end, {})

  vim.api.nvim_create_autocmd("TabLeave", {
    callback = function()
      tab_count_at_leave = #vim.api.nvim_list_tabpages()
      local bufnr = get_bufnr()
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        drag_to_next_tab = false
        return
      end
      local win = find_win_in_tab(bufnr, 0)
      if win then
        last_width_frac = vim.api.nvim_win_get_width(win) / vim.o.columns
        drag_to_next_tab = true
      else
        drag_to_next_tab = false
      end
    end,
  })

  vim.api.nvim_create_autocmd("TabEnter", {
    callback = function()
      if not drag_to_next_tab then
        return
      end
      local is_new_tab = tab_count_at_leave and #vim.api.nvim_list_tabpages() > tab_count_at_leave
      if not is_new_tab then
        drag_here()
        return
      end
      local entered_tab = vim.api.nvim_get_current_tabpage()
      vim.schedule(function()
        if not vim.api.nvim_tabpage_is_valid(entered_tab) then
          return
        end
        if vim.api.nvim_get_current_tabpage() ~= entered_tab then
          return
        end
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(entered_tab)) do
          if vim.wo[win].diff then
            drag_here()
            return
          end
        end
      end)
    end,
  })
end

return M
