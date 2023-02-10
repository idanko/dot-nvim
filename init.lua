local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

local ok, packer = pcall(require, "packer")
if not ok then
  return
end

local function ensure_vars()
  local vars = require("vars")
  vars:load_variables()
  vars:ensure_dir()
end

packer.startup(function(use)
  ensure_vars()

  use({ "wbthomason/packer.nvim" }) -- add packer itself

  require("tools.project_nvim").config(use)
  require("tools.icon_picker").config(use)
  require("tools.lf").config(use)
  require("tools.colorizer").config(use)
  require("tools.close_buffers").config(use)
  require("tools.tmux").config(use)
  require("tools.rest_client").config(use)
  require("tools.markdown_preview").config(use)

  require("formatter_diagnostics").config(use)
  require("general_completion").config(use)
  require("edit_completion").config(use)
  require("frontend").config(use)
  require("treesitter").config(use)
  require("debugger").config(use)
  require("edit").config(use)
  require("vc").config(use)

  if packer_bootstrap then
    packer.sync()
  end
end)

ensure_vars()

require("options")
require("keymap").setup()
require("event")
require("event_gpg")

require("vc").setup()
require("notes").setup()

vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
