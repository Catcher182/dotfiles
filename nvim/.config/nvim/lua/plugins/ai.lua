return {
  {
    "luozhiya/fittencode.nvim",
    -- enabled = false,
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<a-down>",
        function()
          if require("fittencode").has_suggestions() then
            return require("fittencode").accept_all_suggestions()
          end
        end,
        mode = { "i" },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanionChat Toggle", mode = { "n", "v" } },
      { "<leader>av", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanionActions", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanionChat Add<cr>", desc = "CodeCompanionChat Add", mode = { "n", "v" } },
      { "<leader>ag", ":CodeCompanion ", desc = "CodeCompanion", mode = { "n", "v" } },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "openai",
          slash_commands = {
            ["buffer"] = {
              opts = {
                provider = "default", -- default|telescope|mini_pick|fzf_lua
              },
            },
            ["file"] = {
              opts = {
                provider = "fzf_lua", -- telescope|mini_pick|fzf_lua
              },
            },
          },
        },
        inline = {
          adapter = "openai",
        },
        agent = {
          adapter = "openai",
        },
      },
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            url = "https://api.gptgod.online/v1/chat/completions",
            -- url = "https://api.moonshot.cn/v1/chat/completions",
            env = {
              api_key = "OPENAI_API_KEY",
            },
            schema = {
              model = {
                -- default = "moonshot-v1-8k",
                default = "gpt-4o-mini",
                choices = {
                  "gpt-4o-mini",
                  "gpt-3.5-turbo",
                },
              },
            },
          })
        end,
      },

      prompt_library = {
        ["Custom Prompt"] = {
          opts = {
            mapping = "<leader>ac",
          },
        },
        ["Explain"] = {
          opts = {
            mapping = "<leader>ae",
          },
        },
        ["Unit Tests"] = {
          opts = {
            mapping = "<leader>au",
          },
        },
        ["Fix code"] = {
          opts = {
            mapping = "<leader>af",
          },
        },
        ["Buffer selection"] = {
          opts = {
            mapping = "<leader>as",
          },
        },
        ["Explain LSP Diagnostics"] = {
          opts = {
            mapping = "<leader>al",
          },
        },
        ["Generate a Commit Message"] = {
          opts = {
            mapping = "<leader>am",
          },
        },
        ["Find Bugs"] = {
          strategy = "chat",
          description = "Find Bugs",
          opts = {
            index = 4,
            is_default = true,
            mapping = "<leader>ab",
            modes = { "v" },
            slash_cmd = "findbugs",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[When asked to search for code bugs, please follow these steps:

1. Identify programming languages.
2. Describe the purpose of the code and refer to core concepts in programming languages.
3. Identify potential bugs in the code.
4. If there are bugs, try to provide solutions as much as possible.]],
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return string.format(
                  [[Please search for bugs in these codes:

```%s
%s
```
]],
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

        ["CodeReview"] = {
          strategy = "chat",
          description = "Code Review",
          opts = {
            index = 4,
            is_default = true,
            mapping = "<leader>ar",
            modes = { "v" },
            slash_cmd = "codereview",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[When asked to conduct a code review on the code, please follow these steps:

1. Identify programming languages.
2. Describe the purpose of the code and refer to core concepts in programming languages.
3. Identify potential errors in the code.
4. Check the code style and programming standards.
5. Conduct code review from the perspectives of code structure, code logic, code readability and maintainability, code reliability, and code testability.
6. Provide suggestions.]],
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return string.format(
                  [[Please conduct a Code Review on the given code:

```%s
%s
```
]],
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
      },

      display = {
        inline = {
          -- If the inline prompt creates a new buffer, how should we display this?
          layout = "vertical", -- vertical|horizontal|buffer
          diff = {
            enabled = true,
            -- mini_diff is using inline diff in the same buffer but requires the plugin to be installed: https://github.com/echasnovski/mini.diff
            diff_method = "default", -- default|mini_diff
            close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
            layout = "vertical", -- vertical|horizontal
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          },
        },
      },

      opts = {
        system_prompt = [[You are an Al programming assistant named "CodeCompanion".
You are currently plugged in to the Neovim text editor on a user's machine.

Your tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Try to answer in Chinese as much as possible.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return relevant code.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail.
2. Output the code in a single code block.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. Try to answer in Chinese as much as possible.
5. You can only give one reply for each conversation turn.]],
      },
    },
  },
}
