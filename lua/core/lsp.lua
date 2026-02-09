vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end
  end,
})

local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_dir = vim.fn.stdpath('config') .. '/lsp'
local lsp_files = vim.fn.readdir(lsp_dir)

for _, file in ipairs(lsp_files) do
  if file:match('%.lua$') then
    local server_name = file:gsub('%.lua$', '')
    local config = dofile(lsp_dir .. '/' .. file)
    
    if not configs[server_name] then
      configs[server_name] = { default_config = config }
    end
    
    config.capabilities = capabilities
    lspconfig[server_name].setup(config)
  end
end
