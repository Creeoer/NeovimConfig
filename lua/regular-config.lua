local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Core opts
vim.g.mapleader = " "
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
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.diagnostic.config({
  virtual_text = true, -- Shows messages on the right
  signs = true,        -- Shows icons in the signcolumn
  underline = true,    -- Underlines the text with errors
})

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
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
  },
  -- Telescope core
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = { file_ignore_patterns = { "node_modules", ".git/" } },
      })
      pcall(require("telescope").load_extension, "project")
    end,
  },
  { "nvim-telescope/telescope-project.nvim" },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "java",
          "javascript", "typescript", "tsx", "html", "css", "json",
          "c", "cpp", "bash", "markdown", "python",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  --Overseer (Tasks)
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup({

        templates = { "builtin", "user.c_cpp_build_run", "user.python_run", "user.java_build_run" },
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
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
    config = function(_, opts)
      vim.notify = require("notify")
      require("notify").setup(opts)
    end,
  },
  -- Bufferline
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
  {
    "echasnovski/mini.files",
    version = "*",
    -- OPTIONAL: icons (mini.files can use mini.icons or devicons)
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local mf = require("mini.files")
      mf.setup({
        options = {
          use_as_default_explorer = true, -- replaces netrw dir buffers
          permanent_delete = false,     -- move to trash instead of hard delete
        },
        windows = { preview = true, width_focus = 30, width_preview = 30 },
      })

      local uv = vim.uv or vim.loop
      -- Launchers (match your old Telescope file-browser keys)
      vim.keymap.set("n", "<leader>fe", function() mf.open(uv.cwd(), true) end,
        { desc = "MiniFiles (cwd)" })
      vim.keymap.set("n", "<leader>fE", function() mf.open(vim.api.nvim_buf_get_name(0), true) end,
        { desc = "MiniFiles (here)" })

      -- In-mini.files: toggle dotfiles with `g.`
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(ev)
          local show = true
          local show_all = function(_) return true end
          local hide_dot = function(x) return not vim.startswith(x.name, ".") end
          vim.keymap.set("n", "g.", function()
            show = not show
            mf.refresh({ content = { filter = show and show_all or hide_dot } })
          end, { buffer = ev.buf, desc = "MiniFiles: Toggle dotfiles" })
        end,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, -- using default configuration
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Document Symbols (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "onedark",
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" }, -- Added 'branch' here
          lualine_c = { "filename" },
          lualine_x = { "diagnostics", "encoding", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  -- QoL
  { "windwp/nvim-autopairs",                event = "InsertEnter", config = true },
  { "numToStr/Comment.nvim",                config = true },
  { "lukas-reineke/indent-blankline.nvim",  main = "ibl",          config = true },
  { "folke/which-key.nvim",                 event = "VeryLazy",    config = true },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local flash = require("flash")
      flash.setup(opts)
      vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash Jump" })
    end,
  },
  -- Completion stack
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "luasnip" },
        }, {
          { name = "buffer" }, { name = "path" },
        }),
      })
    end
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip",        dependencies = { "rafamadriz/friendly-snippets" } },
  --Nvim-Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Custom config here
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      suggestion = {
        auto_trigger = true,
        -- This keymap table explicitly sets the bindings for suggestions
        keymap = {
          accept = "<C-l>",      -- Accept the full suggestion
          accept_word = "<M-w>", -- Accept one word
          accept_line = "<M-l>", -- Accept one line
          next = "<M-]>",        -- See the next suggestion
          prev = "<M-[>",        -- See the previous suggestion
          dismiss = "<C-e>",     -- Dismiss the current suggestion
        },
      },
      panel = {
        enabled = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
        },
      },
    },
  },
  { "CopilotC-Nvim/CopilotChat.nvim", branch = "main",     dependencies = { "nvim-lua/plenary.nvim", "zbirenbaum/copilot.lua" }, opts = {} },

  -- Harpoon 2
  { "ThePrimeagen/harpoon",           branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Formatter orchestrator
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black", "ruff" },
          lua = { "stylua" },
          java = { "google-java-format" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          --   ["*"] = { "prettierd", "prettier" },
        },
        format_on_save = { lsp_fallback = true, timeout_ms = 500 },
      })
    end
  },

  -- Integrated terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- ===================================================
  -- ===== LSP, Mason, and DAP Configuration Stack =====
  -- ===================================================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- This function contains all LSP setup logic
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local function on_attach(_, bufnr)
        local map = function(m, l, r) vim.keymap.set(m, l, r, { buffer = bufnr, silent = true }) end
        map("n", "gd", vim.lsp.buf.definition)
        map("n", "K", vim.lsp.buf.hover)
        map("n", "gr", vim.lsp.buf.references)
        map("n", "<leader>ca", vim.lsp.buf.code_action)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "[d", vim.diagnostic.goto_prev)
        map("n", "]d", vim.diagnostic.goto_next)
        map("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end)
      end

      -- Setup mason-lspconfig to bridge Mason and lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "html", "cssls", "jsonls", "clangd", "pyright",
          "gopls", "rust_analyzer" },
        automatic_installation = true,
        handlers = {
          function(server) require("lspconfig")[server].setup({ capabilities = capabilities, on_attach = on_attach }) end,
        },
      })

      -- Specific setup for Java (jdtls)
      require("lspconfig").jdtls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  },

  { "williamboman/mason.nvim", config = true }, -- NOTE: `config = true` calls mason.setup()

  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup({
        layouts = {
          { elements = { "scopes", "breakpoints", "stacks", "watches" }, size = 40, position = "right" },
          { elements = { "repl", "console" },                            size = 10, position = "bottom" },
        },
      })
      -- Auto open/close dap-ui listeners
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" }, opts = { commented = true } },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      automatic_installation = true,
      ensure_installed = { "python", "js", "codelldb", "delve", "coreclr", "php", "bash" },
      handlers = {
        codelldb = function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },

  -- Language helpers
  { "mfussenegger/nvim-dap-python" },
  { "leoluz/nvim-dap-go" },
  -- Java nvim
  { "nvim-java/nvim-java" },
})

-- Harpoon 2 setup
do
  local harpoon = require("harpoon")
  local harpoon_ui = require("harpoon.ui")
  harpoon.setup({})
  vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
  vim.keymap.set("n", "<leader>hh", function() harpoon_ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Harpoon: Menu" })
  vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon to file 1" })
  vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon to file 2" })
end

-- ToggleTerm setup
require("toggleterm").setup({ open_mapping = [[<c-\>]], direction = "horizontal" })

-- DAP setup (language-specific configurations)
do
  pcall(require("dap-python").setup, "python3")
  pcall(require("dap-go").setup)

  local dap = require("dap")
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        local path_sep = vim.fn.has("win32") and "\\" or "/"
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. path_sep, 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug (Launch)",
      request = "launch",
      program = "${fileDirname}",
    },
  }
  -- For Rust
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb", -- Uses the same adapter as C/C++
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }
  -- For JavaScript/TypeScript/React (using Node)
  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }
  dap.configurations.typescript = dap.configurations.javascript
end

-- =========================================================================
-- =====                               KEYMAPS                           =====
-- =========================================================================
local map, o = vim.keymap.set, { noremap = true, silent = true }

-- General
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
map("n", "<leader>w", ":w<CR>", { desc = "Write (save) file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlight" })

--File creation
map("n", "<leader>fn", function()
  local path_sep = vim.fn.has("win32") and "\\" or "/"

  local file = vim.fn.input("New file path: ", vim.fn.getcwd() .. path_sep, "file")
  if file ~= "" then
    vim.cmd("e " .. file)
  end
end, { desc = "Create and open a new file" })

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>h", ":split<CR>", { desc = "Horizontal split" })

-- Visual Mode
map("v", "<", "<gv", o)
map("v", ">", ">gv", o)

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live Grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find Buffers" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help Tags" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent Files" })
map("n", "<leader>fp", function() require("telescope").extensions.project.project {} end, { desc = "Find Projects" })
map("n", "<leader>gc", ":Telescope git_commits<CR>", { desc = "Git Commits" })
map("n", "<leader>gs", ":Telescope git_status<CR>", { desc = "Git Status" })


-- Overseer (Tasks runner)
map("n", "<leader>or", ":OverseerRun<CR>", { desc = "Overseer: Run Task" })
map("n", "<leader>ol", ":OverseerToggle<CR>", { desc = "Overseer: Toggle" })
map("n", "<leader>oq", ":OverseerQuickAction<CR>", { desc = "Overseer: Quick Action" })


-- CopilotChat
local chat = pcall(require, "CopilotChat")
if chat then
  map("v", "<leader>ce", function() require("CopilotChat").ask("Explain this code") end,
    { desc = "CopilotChat: Explain" })
  map("v", "<leader>cd", function() require("CopilotChat").ask("Write a docstring for this") end,
    { desc = "CopilotChat: Docstring" })
  map("v", "<leader>ct", function() require("CopilotChat").ask("Write unit tests for this") end,
    { desc = "CopilotChat: Tests" })
  map("n", "<leader>cc", function() require("CopilotChat").toggle() end, { desc = "CopilotChat: Toggle" })
end
-- DAP (Debugging)
do
  local dap_ok, dap = pcall(require, "dap")
  local dapui_ok, dapui = pcall(require, "dapui")
  if not dap_ok then return end

  map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
  map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end,
    { desc = "DAP: Conditional Breakpoint" })
  map("n", "<leader>dm", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log Message: ")) end,
    { desc = "DAP: Log Point" })
  map("n", "<leader>dc", dap.continue, { desc = "DAP: Continue / Start" })
  map("n", "<leader>dn", dap.step_over, { desc = "DAP: Step Over" })
  map("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
  map("n", "<leader>do", dap.step_out, { desc = "DAP: Step Out" })
  map("n", "<leader>dC", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })
  map("n", "<leader>dr", dap.restart, { desc = "DAP: Restart" })
  map("n", "<leader>dx", dap.terminate, { desc = "DAP: Stop / Terminate" })
  map("n", "<leader>dR", dap.repl.toggle, { desc = "DAP: Toggle REPL" })

  if dapui_ok then
    map("n", "<leader>dU", dapui.toggle, { desc = "DAP: Toggle UI" })
    map({ "n", "v" }, "<leader>de", require("dap.ui.widgets").hover, { desc = "DAP: Evaluate Hover" })
  end
end
