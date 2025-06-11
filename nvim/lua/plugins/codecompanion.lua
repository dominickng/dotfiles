return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" }
      },
    },
    opts = {
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt: ",
          provider = "fzf_lua",
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
      },
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "gemini",
        }
      },
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.5-pro-preview-06-05",
              },
            },
          })
        end,
      },
      prompt_library = {
        ["Unit Tests"] = {
          strategy = "inline",
          description = "Generate unit tests for the selected code",
          opts = {
            index = 7,
            is_default = true,
            is_slash_cmd = false,
            modes = { "v" },
            short_name = "tests",
            auto_submit = true,
            user_prompt = true,
            placement = "new",
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[When generating unit tests, follow these steps:

1. Identify the programming language.
2. Identify the purpose of the function or module to be tested.
3. List the edge cases and typical use cases that should be covered in the tests and share the plan with the user.
4. Generate unit tests using an appropriate testing framework for the identified programming language.
5. Ensure the tests cover:
      - Normal cases
      - Edge cases
      - Error handling (if applicable)
6. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.
7. Follow these additional instructions: %s ]],
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return string.format(
                  [[<user_prompt>
Please generate unit tests for this code from buffer %d:

```%s
%s
```
</user_prompt>
]],
                  context.bufnr,
                  context.filetype,
                  code
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Review the code diff"] = {
          strategy = "chat",
          description = "Perform a code review",
          opts = {
            auto_submit = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = "user",
              content = function()
                local target_branch = vim.fn.input("Target branch for merge base diff (default: main): ", "main")

                return string.format(
                  [[
          You are a senior software engineer performing a code review. Analyze the following code changes.
           Identify any potential bugs, performance issues, security vulnerabilities, or areas that could be refactored for better readability or maintainability.
           Explain your reasoning clearly and provide specific suggestions for improvement.
           Consider edge cases, error handling, and adherence to best practices and coding standards.

           Here are the code changes:
           ```
            %s
           ```
           ]],
                  vim.fn.system("git diff --merge-base " .. target_branch)
                )
              end,
            },
          },
        },
        ["Generate a Commit Message"] = {
          strategy = "chat",
          description = "Generate a commit message",
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = "commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
                return string.format(
                  [[You are an expert at writing clear git commit messages per the following instructions:
               - Always break lines at a maximum width of 80 characters
               - Write in the present tense

              Always use the following format exactly:

              ```
              One line summary of the change (do not put a full stop at the end)

              One paragraph explaining why the commit is needed. You may add additional
              paragraphs if absolutely needed, but please avoid being too verbose.

              One or more paragraphs explaining the changes in the commit and why they address
              the reason in the first (few) paragraphs. Call out how the changes are tested.
              ```

              Please generate a commit message for me per your instructions given the git diff listed below:

```diff
%s
```
]],
                  vim.fn.system("git diff --no-ext-diff --staged")
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      }
    },
    init = function()
      vim.keymap.set({ "n", "v" }, "<Bslash>a", "<cmd>CodeCompanionActions<CR>",
        { noremap = true, silent = true, desc = "CodeCompanion [A]ctions" }
      )
      vim.keymap.set({ "n", "v" }, "<Leader>h", "<cmd>CodeCompanionChat Toggle<CR>",
        { noremap = true, silent = true, desc = "CodeCompanion C[h]at" }
      )

      vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<CR>",
        { noremap = true, silent = true, desc = "CodeCompanion Chat [A]dd" }
      )
      vim.cmd([[cab cc CodeCompanion]])
    end
  },
}
