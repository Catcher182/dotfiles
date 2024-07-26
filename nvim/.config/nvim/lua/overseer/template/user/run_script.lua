return {
  name = "run script",
  builder = function()
    local file = vim.fn.expand("%:p")
    local filer = vim.fn.expand("%:r")
    local cmd = { file }
    if vim.bo.filetype == "go" then
      cmd = { "go", "run", file }
    elseif vim.bo.filetype == "sh" then
      cmd = { "bash", file }
    elseif vim.bo.filetype == "cpp" then
      cmd = { "sh", "-c", string.format("g++ %s -o %s && ./%s", file, filer, filer) }
    elseif vim.bo.filetype == "java" then
      cmd = {
        "sh",
        "-c",
        string.format("/usr/lib/jvm/default/bin/javac %s && /usr/lib/jvm/default/bin/java %s", file, filer),
      }
    end
    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "sh", "python", "go", "cpp", "java" },
  },
}
