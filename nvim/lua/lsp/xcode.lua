local M = {}

local xcode_scheme_cache = {} -- pinned scheme per root

local function get_xcode_project(root)
  local workspace = vim.fn.glob(root .. "/*.xcworkspace", false, true)
  local project = vim.fn.glob(root .. "/*.xcodeproj", false, true)
  return workspace, project
end

local function get_schemes(root)
  local list_output = vim.fn.system({ "xcodebuild", "-list", "-json" })
  if vim.v.shell_error ~= 0 then
    return nil, "xcodebuild -list failed"
  end
  local ok, decoded = pcall(vim.json.decode, list_output)
  if not ok then
    return nil, "failed to parse xcodebuild output"
  end
  return (decoded.project or decoded.workspace or {}).schemes or {}, nil
end

local function pick_default_scheme(schemes, workspace, project)
  local project_name = vim.fn.fnamemodify(#workspace > 0 and workspace[1] or project[1], ":t:r")
  local scheme = schemes[1]
  local prefix_match = nil
  for _, s in ipairs(schemes) do
    if s == project_name then
      return s
    end
    if vim.startswith(s, project_name) then
      if not prefix_match or #s < #prefix_match then
        prefix_match = s
      end
    end
  end
  return prefix_match or scheme
end

local function run_xcode_build_server(root, force, explicit_scheme)
  -- Pure SPM projects don't need buildServer.json — sourcekit-lsp handles them natively
  local workspace, project = get_xcode_project(root)
  if #workspace == 0 and #project == 0 then
    return
  end

  local build_server_json = root .. "/buildServer.json"
  if not force and not explicit_scheme and vim.fn.filereadable(build_server_json) == 1 then
    return
  end

  local scheme = explicit_scheme or xcode_scheme_cache[root]
  if not scheme then
    local schemes, err = get_schemes(root)
    if not schemes then
      vim.notify("xcode-build-server: " .. err, vim.log.levels.WARN)
      return
    end
    if #schemes == 0 then
      vim.notify("xcode-build-server: no schemes found", vim.log.levels.WARN)
      return
    end
    scheme = pick_default_scheme(schemes, workspace, project)
  end

  if explicit_scheme then
    xcode_scheme_cache[root] = explicit_scheme
  end

  local xbs_args = { "xcode-build-server", "config", "-scheme", scheme }
  if #project > 0 then
    vim.list_extend(xbs_args, { "-project", project[1] })
  else
    vim.list_extend(xbs_args, { "-workspace", workspace[1] })
  end

  local result = vim.fn.system(xbs_args)
  if vim.v.shell_error ~= 0 then
    vim.notify("xcode-build-server config failed: " .. result, vim.log.levels.WARN)
  else
    vim.notify("xcode-build-server: buildServer.json updated (scheme: " .. scheme .. ")", vim.log.levels.INFO)
  end
end

local function restart_sourcekit(root)
  for _, client in ipairs(vim.lsp.get_clients({ name = "sourcekit" })) do
    if client.root_dir == root then
      vim.lsp.stop_client(client.id)
    end
  end
  vim.defer_fn(function()
    vim.cmd.edit()
  end, 500)
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("sourcekit-build-server", { clear = true }),
    pattern = "swift",
    callback = function()
      local root = vim.fs.root(0, { "*.xcworkspace", "*.xcodeproj", "Package.swift", ".git" })
      if root then
        run_xcode_build_server(root)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("sourcekit-pbxproj-refresh", { clear = true }),
    pattern = "*.pbxproj",
    callback = function()
      local root = vim.fs.root(0, { "*.xcworkspace", "*.xcodeproj", "Package.swift", ".git" })
      if root then
        run_xcode_build_server(root, true)
        restart_sourcekit(root)
      end
    end,
  })

  vim.api.nvim_create_user_command("SourcekitRefresh", function(opts)
    local root = vim.fs.root(0, { "*.xcworkspace", "*.xcodeproj", "Package.swift", ".git" })
    if not root then
      vim.notify("SourcekitRefresh: no project root found", vim.log.levels.WARN)
      return
    end
    local scheme = opts.args ~= "" and opts.args or nil
    run_xcode_build_server(root, true, scheme)
    restart_sourcekit(root)
  end, {
    desc = "Regenerate buildServer.json and restart sourcekit-lsp",
    nargs = "?",
    complete = function(arglead)
      local root = vim.fs.root(0, { "*.xcworkspace", "*.xcodeproj", "Package.swift", ".git" })
      if not root then
        return {}
      end
      local workspace, project = get_xcode_project(root)
      if #workspace == 0 and #project == 0 then
        return {}
      end
      local schemes, _ = get_schemes(root)
      if not schemes then
        return {}
      end
      return vim.tbl_filter(function(s)
        return arglead == "" or vim.startswith(s, arglead)
      end, schemes)
    end,
  })
end

return M
