local api = vim.api
local gen_group = api.nvim_create_augroup("GenericGroup", {})

local function toggle_guideline(enable)
  if enable == 1 then
    vim.opt_local.laststatus = 0
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
  else
    vim.opt_local.number = true
    vim.opt_local.cursorline = true
    vim.opt_local.laststatus = 3
  end
end

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = gen_group,
  pattern = { "COMMIT_EDITMSG" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

api.nvim_create_autocmd({ "BufRead, BufNewFile" }, {
  group = gen_group,
  pattern = { "gitconfig" },
  callback = function()
    vim.bo.filetype = "gitconfig"
  end,
})

api.nvim_create_autocmd({ "FileType" }, {
  group = gen_group,
  pattern = { "help" },
  callback = function()
    pcall(vim.cmd, "only")
  end,
})

api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    require("internal").restore_buf_cursor()
  end,
})

api.nvim_create_autocmd({ "VimResized" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

api.nvim_create_autocmd({ "VimEnter" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    api.nvim_set_hl(0, "@visual", { link = "Visual" }) -- custom markdown tree-sitter highlight

    if vim.o.diff then
      for _, win in ipairs(api.nvim_list_wins()) do
        api.nvim_set_current_win(win)
        toggle_guideline(1)
      end
      vim.cmd("normal! gg")
      return
    end
  end,
})

--- Code format.

local fmt_group = api.nvim_create_augroup("FormatGroup", {})

api.nvim_create_autocmd({ "BufWritePost" }, {
  group = fmt_group,
  pattern = {
    "*.c",
    "*.cpp",
    "*.cc",
    "*.C",
    "*.cxx",
    "*.c++",
    "*.h",
    "*.hh",
    "*.H",
    "*.hxx",
    "*.hpp",
    "*.h++",
  },
  callback = function()
    require("formatter"):formatter()
  end,
})
