return {
  {
    "nvim-java/nvim-java",
    ft = {
      "java",
      "xml",
      "properties",
      "yaml",
      "yml",
      "gradle",
      "groovy",
    },
    config = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            jdtls = {
              -- Your custom jdtls settings goes here
              init_options = {
                documentSymbol = {
                  dynamicRegistration = true,
                  hierarchicalDocumentSymbolSupport = true,
                  labelSupport = true,
                  symbolKind = {
                    valueSet = {
                      1,
                      2,
                      3,
                      4,
                      5,
                      6,
                      7,
                      8,
                      9,
                      10,
                      11,
                      12,
                      13,
                      14,
                      15,
                      16,
                      17,
                      18,
                      19,
                      20,
                      21,
                      22,
                      23,
                      24,
                      25,
                      26,
                      27,
                      28,
                      29,
                      30,
                      31,
                    },
                  },
                },
              },

              single_file_support = true,
              settings = {
                java = {
                  autobuild = { enabled = true },
                  server = { launchMode = "Hybrid" },
                  eclipse = {
                    downloadSources = true,
                  },
                  maven = {
                    downloadSources = true,
                  },
                  import = {
                    gradle = {
                      enabled = true,
                    },
                    maven = {
                      enabled = true,
                    },
                  },
                  references = {
                    includeDecompiledSources = true,
                  },
                  implementationsCodeLens = {
                    enabled = true,
                  },
                  referenceCodeLens = {
                    enabled = true,
                  },
                  -- https://github.com/eclipse-jdtls/eclipse.jdt.ls/issues/2948
                  inlayHints = {
                    parameterNames = {
                      ---@type "none" | "literals" | "all"
                      enabled = "all",
                    },
                  },
                  signatureHelp = {
                    enabled = true,
                    description = {
                      enabled = true,
                    },
                  },
                  symbols = {
                    includeSourceMethodDeclarations = true,
                  },
                  -- https://stackoverflow.com/questions/74844019/neovim-setting-up-jdtls-with-lsp-zero-mason
                  rename = { enabled = true },

                  contentProvider = {
                    preferred = "fernflower",
                  },
                  sources = {
                    organizeImports = {
                      starThreshold = 9999,
                      staticStarThreshold = 9999,
                    },
                  },
                },
                redhat = { telemetry = { enabled = false } },
              },
            },
          },
          setup = {
            jdtls = function()
              require("java").setup({
                -- Your custom nvim-java configuration goes here
              })
            end,
          },
        },
      },
    },
  },
  {
    "eatgrass/maven.nvim",
    ft = {
      "java",
      "xml",
      "properties",
      "yaml",
      "yml",
      "gradle",
      "groovy",
    },
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    opts = function()
      -- 获取当前文件所在目录
      local current_directory = vim.fn.expand("%:p:h")

      local executable = "/usr/bin/mvn"
      -- 从当前目录开始向上遍历，查找pom.xml文件
      local function find_pomxml_directory(directory)
        repeat
          local pom_path = directory .. "/pom.xml"
          local pom_file = io.open(pom_path, "r")
          if pom_file then
            io.close(pom_file)
            local mvnw_path = directory .. "/mvnw"
            local mvnw_file = io.open(mvnw_path, "r")
            if mvnw_file then
              io.close(mvnw_file)
              executable = mvnw_path
            end
            return directory
          end
          directory = directory:match("(.*)/")
        until directory == nil
        return nil -- 未找到
      end

      local pomxml_directory = find_pomxml_directory(current_directory)
      return {
        executable = executable,
        cwd = pomxml_directory,
      }
    end,
  },
  {
    "chaosystema/nvim-springtime",
    lazy = true,
    cmd = { "Springtime", "SpringtimeUpdate" },
    dependencies = {
      "chaosystema/nvim-popcorn",
      "chaosystema/nvim-spinetta",
      "hrsh7th/nvim-cmp",
    },
    build = function()
      require("springtime.core").update()
    end,
    opts = {
      -- Workspace is where the generated Spring project will be saved
      workspace = {
        -- Default where Neovim is open
        path = vim.fn.expand("%:p:h"),

        -- Spring Initializr generates a zip file
        -- Decompress the file by default
        decompress = true,

        -- If after generation you want to open the folder
        -- Opens the generated project in Neovim by default
        open_auto = true,
      },

      -- This could be enabled for debugging purposes
      -- Generates a springtime.log with debug and errors.
      internal = {
        log_debug = false,
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    opts = {
      providers = {
        priority = { "lsp", "coc", "markdown", "norg" },
        lsp = {
          -- Lsp client names to ignore
          blacklist_clients = { "spring-boot" },
        },
        markdown = {
          filetypes = { "markdown" },
        },
      },
    },
  },
}
