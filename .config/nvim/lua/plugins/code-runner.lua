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
          vim.cmd "!cd $dir && g++ -std=c++14 -g -o $fileNameWithoutExt.debug.bin $fileName"
          print "C++ file built in debug mode"
        else
          print "Unsupported file type for building"
        end
      end,
      desc = "Build Current",
    },
    {
      -- run when is rust and do cargo test
      "<Leader>rt",
      function()
        local file_ext = vim.fn.expand "%:e"
        if file_ext == "rs" then
          vim.cmd "!cargo test"
        else
          print "Not a Rust file, cannot run tests"
        end
      end,
      desc = "Run Tests",
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
      cpp = { "g++ -std=c++14 -o /tmp/$fileNameWithoutExt $dir/$fileName &&", "/tmp/$fileNameWithoutExt" },
      rust = { "cargo run$end" },
    },
  },
}
