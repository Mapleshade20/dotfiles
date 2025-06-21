return {
  "CRAG666/code_runner.nvim",
  config = true,
  cmd = "RunCode",
  keys = {

    { "<Leader>r", "", desc = " Execute" },
    {
      "<Leader>rr",
      "<cmd>RunFile<cr>",
      desc = "Run Current",
    },
    {
      -- Modify this section to detect between Go and C++
      "<Leader>rb",
      function()
        -- Get the file extension of the current buffer
        local file_ext = vim.fn.expand "%:e"

        -- Check if it's a Go file
        if file_ext == "go" then
          vim.cmd "!go mod tidy && go build ."
        -- Check if it's a Rust file
        elseif file_ext == "rs" then
          vim.cmd "!cargo build"
          print "Rust cargo built in debug mode"
        -- Check if it's a C++ file
        elseif file_ext == "cpp" then
          -- Compile and build the C++ file in debug mode
          vim.cmd "!cd '%:h' && g++-11 -g -o '%:t:r.debug.bin' '%:t'"
          print "C++ file built in debug mode"
        else
          print "Unsupported file type for building"
        end
      end,
      desc = "Build Current",
    },
  },
  opts = {
    mode = "toggleterm",
    focus = true,
    startinsert = true,
    filetype = {
      python = "python3 -u",
      typescript = "deno run",
      go = { "cd $dir ;", "go mod tidy;", "go run ." },
      cpp = { "g++-11 -o /tmp/%:t:r $dir/%:t ;", "/tmp/%:t:r" },
      rust = { "cargo run$end" },
    },
  },
}
