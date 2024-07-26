return {
  {
    "stevearc/conform.nvim",
    opts = {

      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        html = { "prettier" },
        css = { "prettier" },
        js = { "prettier" },
        vue = { "prettier" },
        ts = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
    },
  },
}
