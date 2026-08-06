-- options
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.linebreak = true
vim.opt.showbreak = "…"
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.wildmode = "longest,list,full"
vim.opt.background = "light"
vim.opt.termguicolors = false
vim.opt.clipboard = "unnamedplus"
vim.opt.linespace = 7 -- only relevant in a GUI

-- keybinds
vim.g.mapleader = " "
vim.keymap.set("n", "-", "g,")
vim.keymap.set("n", "_", "g;")
vim.keymap.set("v", ".", ':normal .<cr>')
-- buffer navigation
vim.keymap.set("n", "<leader><Tab>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<leader><S-Tab>", ":bprev<cr>", { silent = true })
vim.keymap.set("n", "<leader>B", ":buffers<cr>", { silent = true })
vim.keymap.set("n", "<leader>b", ":buffer<cr>")
vim.keymap.set("n", "<leader>e", ":e ")
-- shorter split commands
vim.keymap.set("n", "<leader>s", ":vsplit<cr>", { silent = true })
vim.keymap.set("n", "<leader>vs", ":split<cr>", { silent = true })
-- quickly turn off search highlighting
vim.keymap.set("n", "<Esc>", ":nohlsearch<cr>", { silent = true })
-- inserting blank lines
vim.keymap.set("n", "ö", function() vim.fn.append(vim.fn.line("."), "") end, { silent = true })
vim.keymap.set("n", "Ö", function() vim.fn.append(vim.fn.line(".")-1, "") end, { silent = true })
-- window navigation with alt
vim.keymap.set("n", "<A-h>", ":wincmd h<cr>")
vim.keymap.set("n", "<A-j>", ":wincmd j<cr>")
vim.keymap.set("n", "<A-k>", ":wincmd k<cr>")
vim.keymap.set("n", "<A-l>", ":wincmd l<cr>")
vim.keymap.set("n", "<A-c>", ":close<cr>", { silent = true })
-- normie word deletion on commandline
vim.keymap.set("c", "<A-BS>", "<C-W>")

-- highlight a yank action
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout=400, })
    end,
})

-- plugins
vim.pack.add({
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/nvim-mini/mini.operators",
})

require("nvim-autopairs").setup()
require("mini.operators").setup({
    replace = { prefix = "<leader>r", reindent_linewise = true, }
})

