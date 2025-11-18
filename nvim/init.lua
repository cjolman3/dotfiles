-- ~/.config/nvim/init.lua
-- ===========================
-- Basic settings
-- ===========================
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.hidden = true

-- Enable system clipboard for copy/paste
vim.o.clipboard = "unnamedplus"

vim.g.mapleader = " "  -- Space as leader

-- ===========================
-- LSP keymaps
-- ===========================
local function on_attach_notify(client, bufnr)
    if client and client.name == "clangd" then
        print("clangd is attached to buffer" .. bufnr)
    end

    local opts = { noremap = true, silent = true, buffer = bufnr }
    local keymap = vim.keymap.set
    keymap('n', 'gd', vim.lsp.buf.definition, opts)
    keymap('n', 'gD', vim.lsp.buf.declaration, opts)
    keymap('n', 'gr', vim.lsp.buf.references, opts)
    keymap('n', 'gi', vim.lsp.buf.implementation, opts)
    keymap('n', 'K', vim.lsp.buf.hover, opts)
    keymap('n', '<leader>rn', vim.lsp.buf.rename, opts)
    keymap('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    keymap('n', '[d', vim.diagnostic.goto_prev, opts)
    keymap('n', ']d', vim.diagnostic.goto_next, opts)
end

-- ===========================
-- Diagnostics configuration
-- ===========================
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
})

-- ===========================
-- LSP setup for clangd
-- ===========================
local function setup_clangd()
    vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
        pattern = {"*.c", "*.cpp", "*.h", "*.hpp"},
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()

            -- Set omnifunc for basic LSP completion
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

            -- Start clangd if not already attached
            if not vim.lsp.buf_is_attached(bufnr, "clangd") then
                vim.lsp.start({
                    name = "clangd",
                    cmd = {"clangd"},
                    root_dir = vim.fn.getcwd(),
                    on_attach = on_attach_notify,
                })
            end
        end,
    })
end

setup_clangd()

-- ===========================
-- Optional: easier autocomplete trigger
-- ===========================
vim.api.nvim_set_keymap('i', '<C-Space>', '<C-x><C-o>', { noremap = true, silent = true })

-- ===========================
-- Optional: auto-popup LSP completion while typing (Step 7)
-- ===========================
-- Uncomment the following block if you want automatic completion popup
-- vim.api.nvim_create_autocmd("InsertCharPre", {
--     pattern = {"*.c", "*.cpp", "*.h", "*.hpp"},
--     callback = function()
--         local char = vim.v.char
--         if char:match("[%w_.]") then  -- only trigger on word chars, dot, underscore
--             vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), 'n')
--         end
--     end,
-- })

