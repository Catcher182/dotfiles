return {
  {
    "nvim-java/nvim-java",
    config = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            jdtls = {
              -- Your custom jdtls settings goes here
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
}
