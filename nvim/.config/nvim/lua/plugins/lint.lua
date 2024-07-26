return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        html = { "markuplint" },
        css = { "stylelint" },
        sass = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
      },
    },
  },
}
