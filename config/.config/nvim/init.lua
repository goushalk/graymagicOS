--Options --


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"
vim.lsp.ui = false
vim.opt.winborder = "rounded"

-- Keybindings --
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>e", ":Ex<CR>")
vim.keymap.set("n", "<leader>so", ":update<CR> :source<CR>")

-- Diagnostic navigation (Updated for Nvim 0.13+)
vim.keymap.set('n', 'gn', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Go to next diagnostic' })

vim.keymap.set('n', 'gh', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Go to previous diagnostic' })

-- Show diagnostic error in a floating window
vim.keymap.set('n', 'gf', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })

-- Open diagnostic list (Changed to <leader>ql to avoid conflict with :quit)
vim.keymap.set('n', '<leader>gl', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })-- Packages --

vim.keymap.set('n', '<leader>dt', function()
  local current_value = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current_value })
end, { desc = 'Toggle inline diagnostics' })

vim.pack.add({
	{src = "https://github.com/neovim/nvim-lspconfig.git" },
	{src = "https://github.com/williamboman/mason.nvim" },
	{src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{src = "https://github.com/nvim-lua/plenary.nvim"},
	{src = "https://github.com/nvim-telescope/telescope.nvim" },
	{src = "https://github.com/rebelot/kanagawa.nvim" },
	{src = "https://github.com/xiyaowong/transparent.nvim"},
	{src = "https://github.com/MeanderingProgrammer/render-markdown.nvim"},
	{src = "https://github.com/dhruvasagar/vim-table-mode"},
    {src = "https://github.com/kamykn/spelunker.vim"},
	{src = "https://github.com/chrisbra/Colorizer"},
	{src = "https://github.com/m4xshen/autoclose.nvim"},
})

-- System clipboard (Wayland)
vim.opt.clipboard = "unnamedplus"


-- Telescope keybinds --

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Transperent stuff --

vim.cmd("colorscheme kanagawa-dragon")
vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
vim.cmd('hi EndOfBuffer guibg=NONE ctermbg=NONE')
vim.cmd('hi statusline guibg=NONE')
vim.cmd('hi Signcolumn guibg=NONE ctermbg=NONE')
vim.api.nvim_set_hl(0, 'LineNr', { bg = "none" })
vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { bg = 'NONE' })	
vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = "none" })


-- LSP servers --
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "pyright", "bashls", "gopls", "rust_analyzer"}, -- auto install servers you want
	automatic_installation = true,
})
vim.lsp.enable({ "lua_ls", "pyright", "bashls", "gopls" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
-- Telescope keybinds --

-- AutoComplete --
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd([[set completeopt+=menuone,noselect,popup]])

-- Auto close --

require("autoclose").setup({
   keys = {
      ["<"] = { escape = true, close = false, pair = "<>" },
      ["("] = { escape = false, close = true, pair = "()" },
      ["["] = { escape = false, close = true, pair = "[]" },
      ["{"] = { escape = false, close = true, pair = "{}" },

      [">"] = { escape = true, close = false, pair = "<>" },
      [")"] = { escape = true, close = false, pair = "()" },
      ["]"] = { escape = true, close = false, pair = "[]" },
      ["}"] = { escape = true, close = false, pair = "{}" },

      ['"'] = { escape = true, close = true, pair = '""' },
      ["'"] = { escape = true, close = true, pair = "''" },
      ["`"] = { escape = true, close = true, pair = "``" },
   },
})



