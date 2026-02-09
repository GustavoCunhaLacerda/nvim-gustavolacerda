return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  branch = 'master',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { "lua", "zig", "c", "python", "vue", "php", "typescript", "javascript" },
      highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
