local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- cmp UX

-- Plugins
require("lazy").setup({
  -- Theme
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "deep" })
      require("onedark").load()
    end,
  },

  -- Telescope core
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = { file_ignore_patterns = { "node_modules", ".git/" } },
      })
    end,
  },
  -- Telescope project switcher
  { "nvim-telescope/telescope-project.nvim", dependencies = { "nvim-telescope/telescope.nvim" } },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "javascript", "typescript", "tsx",
          "html", "css", "json",
          "c", "cpp", "bash", "markdown", "python",
        },
        highlight        = { enable = true },
        indent           = { enable = true },
      })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30, side = "left" },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  -- Bufferline (tabs for buffers)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          offsets = { { filetype = "NvimTree", text = "Explorer", text_align = "left" } },
        },
      })
      local map, o = vim.keymap.set, { noremap = true, silent = true }
      map("n", "<S-l>", ":BufferLineCycleNext<CR>", o)
      map("n", "<S-h>", ":BufferLineCyclePrev<CR>", o)
      for i = 1, 9 do
        map("n", ("<leader>%d"):format(i), (":BufferLineGoToBuffer %d<CR>"):format(i), o)
      end
      map("n", "<leader>bd", ":bdelete<CR>", o)
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup({ options = { theme = "onedark" } }) end,
  },

  -- QoL
  { "windwp/nvim-autopairs",                 event = "InsertEnter",                             config = true },
  { "numToStr/Comment.nvim",                 config = true },
  { "lukas-reineke/indent-blankline.nvim",   main = "ibl",                                      config = true },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end
  },

  -- Flash motions (standard keys)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local flash = require("flash")
      flash.setup(opts)
      vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash Jump" })
      vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter" })
      vim.keymap.set({ "o" }, "r", flash.remote, { desc = "Remote Flash" })
      vim.keymap.set({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter Search" })
      vim.keymap.set({ "c" }, "<C-s>", flash.toggle, { desc = "Toggle Flash Search" })
    end,
  },

  -- Completion stack
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip",        dependencies = { "rafamadriz/friendly-snippets" } },

  -- Copilot ghost text
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>", -- accept via cmp <CR>
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-e>",
        },
      },
    },
    config = function(_, opts)
      local ok, copilot = pcall(require, "copilot")
      if not ok then return end
      copilot.setup(opts)
      local has_cmp, cmp = pcall(require, "cmp")
      local has_snip, luasnip = pcall(require, "luasnip")
      local function set_trigger(on) pcall(require("copilot.suggestion").toggle_auto_trigger, on) end
      if has_cmp then
        cmp.event:on("menu_opened", function() set_trigger(false) end)
        cmp.event:on("menu_closed", function()
          set_trigger(not (has_snip and luasnip.expand_or_locally_jumpable()))
        end)
      end
      if has_snip then
        vim.api.nvim_create_autocmd("User", {
          pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
          callback = function() set_trigger(not luasnip.expand_or_locally_jumpable()) end,
        })
      end
    end,
  },

  -- CopilotChat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = { "nvim-lua/plenary.nvim", "zbirenbaum/copilot.lua" },
    opts = {},
  },

  -- Harpoon 2
  { "ThePrimeagen/harpoon",             branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },

  -- LSP + Mason
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- Formatter orchestrator
  { "stevearc/conform.nvim" },

  -- Integrated terminal
  { "akinsho/toggleterm.nvim",          version = "*",       config = true },
})

-- Telescope extensions
pcall(function() require("telescope").load_extension("project") end)

-- nvim-cmp setup
do
  local ok_cmp, cmp = pcall(require, "cmp")
  local ok_snip, luasnip = pcall(require, "luasnip")
  if ok_cmp then
    if ok_snip then require("luasnip.loaders.from_vscode").lazy_load() end
    cmp.setup({
      snippet = { expand = function(args) if ok_snip then luasnip.lsp_expand(args.body) end end },
      preselect = cmp.PreselectMode.None,
      window = {
        completion    = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),
        ["<Tab>"]     = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif ok_snip and luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"]   = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif ok_snip and luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-n>"]     = cmp.mapping.select_next_item(),
        ["<C-p>"]     = cmp.mapping.select_prev_item(),
        ["<C-d>"]     = cmp.mapping.scroll_docs(4),
        ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", keyword_length = 2, max_item_count = 15 },
        { name = "luasnip",  keyword_length = 2, max_item_count = 10 },
      }, {
        { name = "path", max_item_count = 10 },
        {
          name = "buffer",
          keyword_length = 3,
          max_item_count = 5,
          option = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
      }),
      performance = { max_view_entries = 20 },
      formatting = {
        format = function(entry, item)
          item.menu = ({ nvim_lsp = "[LSP]", luasnip = "[SNIP]", buffer = "[BUF]", path = "[PATH]" })[entry.source.name]
          return item
        end,
      },
    })
  end
end

-- LSP via mason-lspconfig
do
  local ok_lsp, lspconfig = pcall(require, "lspconfig")
  if not ok_lsp then return end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmpcaps, cmp_caps = pcall(require, "cmp_nvim_lsp")
  if ok_cmpcaps then
    capabilities = cmp_caps.default_capabilities(capabilities)
  else
    capabilities.textDocument.completion.completionItem.snippetSupport = true
  end

  local function on_attach(_, bufnr)
    local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true }) end
    map("n", "gd", vim.lsp.buf.definition)
    map("n", "gD", vim.lsp.buf.declaration)
    map("n", "gr", vim.lsp.buf.references)
    map("n", "gi", vim.lsp.buf.implementation)
    map("n", "K", vim.lsp.buf.hover)
    map("n", "<leader>rn", vim.lsp.buf.rename)
    map("n", "<leader>ca", vim.lsp.buf.code_action)
    map("n", "[d", vim.diagnostic.goto_prev)
    map("n", "]d", vim.diagnostic.goto_next)
    map("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end)
  end

  -- Mason core
  local ok_mason, mason = pcall(require, "mason")
  if ok_mason then mason.setup() end

  local wanted = { "ts_ls", "html", "cssls", "jsonls", "clangd", "pyright" }
  local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")
  if ok_mlsp then
    mlsp.setup({ ensure_installed = wanted, automatic_installation = true })

    if type(mlsp.setup_handlers) == "function" then
      mlsp.setup_handlers({
        function(server)
          lspconfig[server].setup({ capabilities = capabilities, on_attach = on_attach })
        end,
        ["ts_ls"] = function()
          lspconfig.ts_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
          })
        end,
      })
    else
      -- Fallback path for older mason-lspconfig
      local servers = mlsp.get_installed_servers and mlsp.get_installed_servers() or wanted
      for _, server in ipairs(servers) do
        if server == "tsserver" or server == "ts_ls" then
          local name = lspconfig.ts_ls and "ts_ls" or "tsserver"
          lspconfig[name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
          })
        else
          lspconfig[server].setup({ capabilities = capabilities, on_attach = on_attach })
        end
      end
    end
  else
    -- No Mason: set up directly
    for _, server in ipairs(wanted) do
      if lspconfig[server] then
        lspconfig[server].setup({ capabilities = capabilities, on_attach = on_attach })
      end
    end
  end
end

-- Conform (formatters)
require("conform").setup({
  formatters_by_ft = {
    python = { "black", "ruff" },
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
    html = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
  },

  format_on_save = function(bufnr)
    if vim.bo[bufnr].buftype ~= "" then return end
    return { lsp_fallback = true, timeout_ms = 500 }
  end,
})

-- Harpoon 2
do
  local ok, harpoon = pcall(require, "harpoon")
  if ok then
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon menu" })
    vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
    vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
    vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
    vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
  end
end

-- ToggleTerm (integrated terminal)
do
  local ok, toggleterm = pcall(require, "toggleterm")
  if ok then
    toggleterm.setup({
      size = 12,
      open_mapping = [[<C-\>]],
      direction = "horizontal", -- "float" | "vertical" | "tab"
      shade_terminals = true,

      cwd = function()
        return vim.loop.cwd() -- respects `:pwd` / project root
      end,
    })
    local map = vim.keymap.set
    map({ "n", "t" }, "<C-\\>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
    map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
    map("t", "<C-h>", [[<C-\><C-n><C-w>h]])
    map("t", "<C-j>", [[<C-\><C-n><C-w>j]])
    map("t", "<C-k>", [[<C-\><C-n><C-w>k]])
    map("t", "<C-l>", [[<C-\><C-n><C-w>l]])
  end
end


-- Keymaps
local map, o = vim.keymap.set, { noremap = true, silent = true }
-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", o)
-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", o)
map("n", "<leader>fg", ":Telescope live_grep<CR>", o)
map("n", "<leader>fb", ":Telescope buffers<CR>", o)
map("n", "<leader>fh", ":Telescope help_tags<CR>", o)
map("n", "<leader>fr", ":Telescope oldfiles<CR>", o)
map("n", "<leader>fp", function() require("telescope").extensions.project.project {} end, o) -- project picker
map("n", "<leader>gc", ":Telescope git_commits<CR>", o)
map("n", "<leader>gs", ":Telescope git_status<CR>", o)
-- Window navigation
map("n", "<C-h>", "<C-w>h", o)
map("n", "<C-j>", "<C-w>j", o)
map("n", "<C-k>", "<C-w>k", o)
map("n", "<C-l>", "<C-w>l", o)
map("n", "<leader>v", ":vsplit<CR>", o)
map("n", "<leader>h", ":split<CR>", o)
-- Visual helpers
map("v", "<", "<gv", o)
map("v", ">", ">gv", o)
map("v", "J", ":m '>+1<CR>gv=gv", o)
map("v", "K", ":m '<-2<CR>gv=gv", o)
map("v", "p", '"_dP', o)
-- Misc
map("n", "<leader>w", ":w<CR>", o)
map("n", "<leader>W", ":wa<CR>", o)
map("n", "<leader>q", ":q<CR>", o)
map("n", "<leader>Q", ":qa<CR>", o)
map("n", "<leader>/", ":nohlsearch<CR>", o)
map("n", "<leader><leader>", ":so %<CR>", o)

-- CopilotChat
local ok_chat, chat = pcall(require, "CopilotChat")
if ok_chat then
  map("v", "<leader>ce", function() chat.ask("Explain this code") end, { desc = "CopilotChat Explain" })
  map("v", "<leader>cd", function() chat.ask("Write a docstring for this") end, { desc = "CopilotChat Docstring" })
  map("v", "<leader>ct", function() chat.ask("Write unit tests for this") end, { desc = "CopilotChat Tests" })
  map("n", "<leader>cc", chat.toggle, { desc = "CopilotChat Toggle" })
end
