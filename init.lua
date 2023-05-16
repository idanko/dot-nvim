local function ensure_vars()
  local vars = require("vars")
  vars:load_variables()
  vars:ensure_dir()
end

ensure_vars()
require("options").setup()
require("keymap").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  error("lazy nvim is not installed")
  return
end

lazy.setup({
  { "ahmedkhalf/project.nvim", config = require("tools.project_nvim").config },
  { "akinsho/toggleterm.nvim", config = require("tools.toggleterm").config },
  {
    "navarasu/onedark.nvim",
    dependencies = { "rktjmp/fwatch.nvim" },
    config = require("theme").config,
  },
  { "nvim-lualine/lualine.nvim", config = require("status_line").config },
  { "ziontee113/icon-picker.nvim", config = require("tools.icon_picker").config },
  { "aserowy/tmux.nvim", config = require("tools.tmux").config },
  {
    "lmburns/lf.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    config = require("tools.file_manager").config,
  },
  { "norcalli/nvim-colorizer.lua", config = require("tools.colorizer").config },
  { "kazhala/close-buffers.nvim", config = require("tools.close_buffers").config },
  { "rest-nvim/rest.nvim", ft = "http", config = require("tools.rest_client").config },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = require("tools.markdown_preview").config,
  },
  { "jose-elias-alvarez/null-ls.nvim", config = require("formatter_diagnostics").config },
  { "folke/zen-mode.nvim", config = require("my_zen_mode").config },
  { "folke/which-key.nvim", config = require("my_which_key").config },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "stevearc/dressing.nvim" },
    config = require("fuzzy_finder").config,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "andersevenrud/cmp-tmux",
      "hrsh7th/cmp-calc",
    },
    config = require("completion").config,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "p00f/nvim-ts-rainbow", "windwp/nvim-ts-autotag" },
    config = require("treesitter").config,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = require("debugger").config,
  },
  { "numToStr/Comment.nvim", config = require("edit.my_comment").config },
  { "kylechui/nvim-surround", config = require("edit.my_surround").config },
  { "windwp/nvim-autopairs", config = require("edit.my_surround").config },
  { "gbprod/yanky.nvim", config = require("edit.my_yanky").config },
  { "phaazon/hop.nvim", branch = "v2", config = require("edit.my_hop").config },
  { "ruifm/gitlinker.nvim", config = require("vc.my_gitlinker").config },
  { "lewis6991/gitsigns.nvim", config = require("vc.my_gitsigns").config },
})

require("event").config()
require("tools.notes").config()
require("tools.gpg").config()
require("tools.fzf_project").config()
require("vc.git_save_file_remote").config()
