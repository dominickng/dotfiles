return {
  -- {
  --   "igorlfs/nvim-dap-view",
  --   ---@module 'dap-view'
  --   ---@type dapview.Config
  --   config = function()
  --     require("dap-view").setup()
  --
  --     local dap, dapview = require("dap"), require("dap-view")
  --
  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapview.open()
  --     end
  --     dap.listeners.before.event_terminated["dapui_config"] = function()
  --       dapview.close()
  --     end
  --     dap.listeners.before.event_exited["dapui_config"] = function()
  --       dapview.close()
  --     end
  --   end
  -- },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mason-org/mason.nvim"
    }
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "banjo/package-pilot.nvim",
      },
      -- "theHamsta/nvim-dap-virtual-text",
    },
    lazy = true,
    keys = {
      {
        "<leader>dn",
        function()
          require('dap').new()
        end,
        mode = "n",
        desc = "[D]ebugging [N]ew"
      },
      {
        "<leader>d<space>",
        function()
          require('dap').continue()
        end,
        mode = "n",
        desc = "[D]ebugging Continue"
      },
      {
        "<leader>di",
        function()
          require('dap').step_into()
        end,
        mode = "n",
        desc = "[D]ebugging Step [I]nto"
      },
      {
        "<leader>dj",
        function()
          require('dap').step_over()
        end,
        mode = "n",
        desc = "[D]ebugging Step Over"
      },
      {
        "<leader>do",
        function()
          require('dap').step_out()
        end,
        mode = "n",
        desc = "[D]ebugging Step [O]ut"
      },
      {

        "<leader>dz",
        "<cmd>ZoomWinTabToggle<CR>",
        mode = "n",
        desc = ""
      },
      {
        "<leader>dt",
        function()
          require('dap').set_log_level('TRACE')
        end,
        "<cmd>DapStepInto<CR>",
        mode = "n",
        desc = "[D]ebug [T]race"
      },
      {
        "<leader>de",
        function()
          vim.cmd(":edit " .. vim.fn.stdpath('cache') .. "/dap.log")
        end,
        mode = "n",
        desc = "[D]ebug [E]dit"
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
        mode = "n",
        desc = "[D]ebugging [R]estart"
      },
      {
        "<leader>d_",
        function()
          require("dap").terminate()
          require("dapui").close()
        end,
        mode = "n",
        desc = "[D]ebugging Step [I]nto"
      },
    },
    config = function()
      local dap = require("dap")
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}", --let both ports be the same for now...
        executable = {
          command = "node",
          -- -- 💀 Make sure to update this path to point to your installation
          args = { vim.fn.stdpath('data') .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
          -- command = "js-debug-adapter",
          -- args = { "${port}" },
        },
      }

      local function pick_script()
        local pilot = require("package-pilot")

        local current_dir = vim.fn.getcwd()
        local package = pilot.find_package_file({ dir = current_dir })

        if not package then
          vim.notify("No package.json found", vim.log.levels.ERROR)
          return require("dap").ABORT
        end

        local scripts = pilot.get_all_scripts(package)

        local label_fn = function(script)
          return script
        end

        local co, ismain = coroutine.running()
        local fzf = require("fzf-lua")
        local result = fzf.fzf_exec(scripts)
        return result or require("dap").ABORT
      end

      local ts_languages = { "typescript" }
      for _, language in ipairs(ts_languages) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "pnpm",
            runtimeExecutable = "pnpm",
            runtimeArgs = { "--filter=@relevanceai/nodeapi", "run", "dev" },
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          -- {
          --   type = "pwa-node",
          --   request = "attach",
          --   name = "Auto Attach",
          --   cwd = vim.fn.getcwd(),
          --   protocol = "inspector",
          -- },
          -- {
          --   type = "pwa-chrome",
          --   request = "launch",
          --   name = "Start Chrome with \"localhost\"",
          --   url = "http://localhost:3000",
          --   webRoot = "${workspaceFolder}",
          --   userDataDir = "${workspaceFolder}/.nvim/nvim-chrome-debug-userdatadir"
          -- },
          {
            type = "pwa-node",
            request = "launch",
            name = "pnpm",
            runtimeExecutable = "pnpm",
            runtimeArgs = { "run", pick_script },
            cwd = "${workspaceFolder}",
          }
        }
      end

      local js_languages = { "javascript" }
      for _, language in ipairs(js_languages) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Start Chrome with \"localhost\"",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            userDataDir = "${workspaceFolder}/.nvim/nvim-chrome-debug-userdatadir"
          },
        }
      end
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        mode = "n",
        desc = "Toggle [D]ebugging [U]I"
      }
    },
    config = function()
      require("dapui").setup()

      local dap, dapui = require("dap"), require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end
  }
}
