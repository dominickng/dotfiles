return {
  mason = {
    bashls = {},
    clangd = {},
    cssls = {},
    gh_actions_ls = {},
    html = {},
    jsonls = {},
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    },
    pyright = {},
    terraformls = {},
    -- ts_ls = {
    --   filetypes = {
    --     "typescript",
    --     "javascript",
    --     "javascriptreact",
    --     "typescriptreact",
    --   },
    --   init_options = {
    --     preferences = {
    --       includeCompletionsForModuleExports = true,
    --       includeCompletionsForImportStatements = true,
    --       importModuleSpecifierPreference = "relative",
    --     },
    --   },
    -- },
    svelte = {},
    astro = {},
    tsgo = {},
    vtsls = {
      root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          tsserver = {
            globalPlugins = {
              --   {
              --     name = "@vue/typescript-plugin",
              --     location = vim.fn.stdpath("data") ..
              --         "/mason/packages/vue-language-server/node_modules/@vue/language-server",
              --     languages = { "vue" },
              --     configNamespace = "typescript",
              --   }
            },
          },
        },
      },
      before_init = function(params, config)
        if vim.bo.filetype ~= "vue" then
          return
        end
        local vuePluginConfig = {
          name = "@vue/typescript-plugin",
          languages = { "vue" },
          location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        }
        table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
      end,
      typescript = {
        tsserver = {
          nodePath = vim.fn.exepath("node"),
          maxTsServerMemory = 4096,
        },
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifier = "relative",
        },
      },
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
      },
      filetypes = {
        -- "typescript",
        -- "javascript",
        -- "javascriptreact",
        -- "typescriptreact",
        "vue",
      },
    },
    vue_ls = {
      typescript = {},
    },
  },
  others = {
    sourcekit = {},
  },
}
