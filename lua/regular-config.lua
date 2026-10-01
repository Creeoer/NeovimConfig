local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

local platform = require("platform")

if platform.is_windows then
  -- Prefer user-managed development tools over bundled application runtimes
  -- such as Inkscape's incomplete python.exe and BusyBox utilities.
  local preferred_paths = {
    vim.fn.expand("~/scoop/apps/python/current"),
    vim.fn.expand("~/scoop/shims"),
  }
  for index = #preferred_paths, 1, -1 do
    local path = preferred_paths[index]
    if vim.fn.isdirectory(path) == 1 then
      vim.env.PATH = path .. ";" .. vim.env.PATH
    end
  end
end

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
  { "folke/lazy.nvim", version = "*" },
  -- Theme
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("carbonfox")
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
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "lua", "vim", "vimdoc", "query", "bash", "python", "rust", "sql", "dockerfile", "toml",
        "javascript", "typescript", "tsx", "json", "html", "css",
        "vue", "svelte", "astro", "diff", "markdown", "markdown_inline", "yaml",
      }
      vim.treesitter.language.register("json", "jsonc")
      local treesitter = require("nvim-treesitter")
      if type(treesitter.install) == "function" then
        -- Current nvim-treesitter API.
        treesitter.setup({
          install_dir = vim.fn.stdpath("data") .. "/site",
        })
        treesitter.install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
          callback = function()
            pcall(vim.treesitter.start)
          end,
        })
      else
        -- Compatibility with the legacy API used by older lockfiles.
        treesitter.setup()
        require("nvim-treesitter.configs").setup({
          ensure_installed = parsers,
          highlight = { enable = true },
        })
      end
    end,
  },
  -- Markdown editing and preview
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = { "markdown" },
    cond = function() return vim.fn.isdirectory(require("obsidian_vault").path()) == 1 end,
    dependencies = { "nvim-telescope/telescope.nvim", "hrsh7th/cmp-nvim-lsp" },
    opts = function() return require("obsidian_vault").options() end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = { render_modes = { "n", "c" } },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown buf_toggle<CR>", desc = "Markdown: Toggle rendered view" },
    },
  },
  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("livepreview.config").set({ address = "127.0.0.1", picker = "telescope" })
    end,
    keys = {
      { "<leader>mp", "<cmd>LivePreview start<CR>", desc = "Markdown: Browser preview" },
      { "<leader>mP", "<cmd>LivePreview close<CR>", desc = "Markdown: Stop browser preview" },
    },
  },
  --Overseer (Tasks)
  {
    "stevearc/overseer.nvim",
    config = function()
      require("overseer").setup({
        templates = {
          "builtin",
          "user.c_cpp_build_run",
          "user.python_run",
          "user.python_test",
          "user.java_build_run",
          "user.npm_build",
          "user.npm_test",
          "user.npm_dev",
        },
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
    "dlyongemallo/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git: Review working tree" },
      { "<leader>gD", "<cmd>DiffviewFileHistory<CR>", desc = "Git: File history" },
    },
    opts = {},
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
          theme = "auto",
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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = { "nvim-lua/plenary.nvim", "zbirenbaum/copilot.lua" },
    opts = {
      window = {
        layout = "float",
        width = 0.8,
        height = 0.7,
        border = "rounded",
      },
    },
  },

  -- Agent workflows (Codex ACP + authenticated Claude/Codex CLIs)
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        acp = {
          codex = function()
            local command = platform.is_windows and "codex-acp.cmd" or "codex-acp"
            return require("codecompanion.adapters").extend("codex", {
              commands = {
                default = { command },
              },
              defaults = {
                auth_method = "chat-gpt",
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "codex",
        },
        cli = {
          agent = "claude_code",
          agents = {
            claude_code = {
              cmd = platform.is_windows and "claude.cmd" or "claude",
              args = {},
              description = "Claude Code CLI (subscription)",
            },
            codex = {
              cmd = platform.is_windows and "codex.exe" or "codex",
              args = {},
              description = "OpenAI Codex CLI (ChatGPT subscription)",
            },
          },
          opts = {
            auto_insert = true,
            reload = true,
          },
        },
      },
    },
  },

  -- Harpoon 2
  { "ThePrimeagen/harpoon",           branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Formatter orchestrator
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
          lua = { "stylua" },
          java = { "google-java-format" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          vue = { "prettierd", "prettier", stop_after_first = true },
          svelte = { "prettierd", "prettier", stop_after_first = true },
          astro = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          jsonc = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          scss = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
        },
        -- Unconfigured projects should not be reformatted just by saving.
        -- Space F still formats explicitly using the installed formatter.
        format_on_save = function(bufnr)
          local filetype = vim.bo[bufnr].filetype
          local web_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro", "json", "jsonc", "html", "css", "scss", "markdown", "yaml" }
          if vim.tbl_contains(web_filetypes, filetype) then
            local info = require("conform").get_formatter_info("prettier", bufnr)
            if not info.available then return end
            local result = vim.system({ info.command, "--find-config-path", vim.api.nvim_buf_get_name(bufnr) }, { text = true }):wait(1000)
            if result.code ~= 0 or not result.stdout or vim.trim(result.stdout) == "" then return end
          end
          return { lsp_format = "fallback", timeout_ms = 2000 }
        end,
      })
    end
  },

  -- Integrated terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- SQL diagnostics are independent of language-server attachment.
  {
    "mfussenegger/nvim-lint",
    ft = { "sql" },
    config = function() require("sql_diagnostics").setup() end,
  },

  -- ===================================================
  -- ===== LSP, Mason, and DAP Configuration Stack =====
  -- ===================================================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lsp_group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
          local map = function(m, l, r, desc)
            vim.keymap.set(m, l, r, { buffer = bufnr, silent = true, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "LSP: Definition")
          map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
          map("n", "gr", vim.lsp.buf.references, "LSP: References")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
          map("n", "[d", vim.diagnostic.goto_prev, "Diagnostic: Previous")
          map("n", "]d", vim.diagnostic.goto_next, "Diagnostic: Next")
          map("n", "<leader>F", function()
            require("conform").format({ async = true, lsp_format = "fallback" })
          end, "Format buffer")
          map("n", "<leader>lo", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source.organizeImports" }, diagnostics = {} },
            })
          end, "LSP: Organize imports")
          map("n", "<leader>lx", function()
            if vim.fn.exists(":LspEslintFixAll") == 2 then
              vim.cmd.LspEslintFixAll()
            else
              vim.notify("ESLint is not attached to this buffer", vim.log.levels.WARN)
            end
          end, "ESLint: Fix all")
        end,
      })

      -- Neovim 0.11+ owns LSP configuration. Apply shared settings before
      -- Mason enables the installed server definitions from nvim-lspconfig.
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("marksman", {
        root_dir = function(bufnr, on_dir)
          if require("obsidian_vault").is_note(bufnr) then return end
          local root = vim.fs.root(bufnr, { ".marksman.toml", ".git" })
          if root then on_dir(root) end
        end,
      })

      local function typescript_root(bufnr, on_dir)
        local lockfiles = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
        local project_files = { "tsconfig.json", "jsconfig.json", "package.json" }
        -- Each package can use its own TypeScript version (Kinetic uses both
        -- 5.7 and 5.9). Start from the owning package so its SDK wins.
        local root = vim.fs.root(bufnr, { "package.json" }) or vim.fs.root(bufnr, project_files) or vim.fs.root(bufnr, lockfiles)
        if not root then
          local filename = vim.api.nvim_buf_get_name(bufnr)
          root = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
        end
        on_dir(root)
      end

      local vue_plugin_path = vim.fs.joinpath(
        vim.fn.stdpath("data"),
        "mason", "packages", "vue-language-server", "node_modules", "@vue", "language-server"
      )
      vim.lsp.config("vtsls", {
        root_dir = typescript_root,
        filetypes = {
          "javascript", "javascriptreact",
          "typescript", "typescriptreact", "vue",
        },
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_plugin_path,
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
      })

      vim.lsp.config("tailwindcss", {
        settings = {
          tailwindCSS = { classFunctions = { "cn", "clsx", "cva", "twMerge" } },
        },
      })
      -- Tailwind owns its at-rule validation; retain ordinary CSS checks.
      vim.lsp.config("cssls", {
        settings = {
          css = { lint = { unknownAtRules = "ignore" } },
          scss = { lint = { unknownAtRules = "ignore" } },
        },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } },
        },
      })
      vim.lsp.config("pyright", {
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = config.settings.python.pythonPath
            or require("python_env").python(config.root_dir)
        end,
        settings = { pyright = { disableOrganizeImports = true } },
      })
      -- vscode-eslint-language-server's legacy FlatESLint path was removed in
      -- ESLint 10. The standard ESLint class supports flat config and works
      -- across ESLint 9 and 10.
      local eslint_before_init = vim.lsp.config.eslint.before_init
      vim.lsp.config("eslint", {
        filetypes = {
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "vue", "svelte", "astro", "htmlangular",
        },
        before_init = function(params, config)
          if eslint_before_init then
            eslint_before_init(params, config)
          end
          config.settings = config.settings or {}
          config.settings.experimental = config.settings.experimental or {}
          config.settings.experimental.useFlatConfig = false
        end,
      })

      -- The richer vtsls client replaces ts_ls and also supplies Vue's
      -- TypeScript features through the official Vue plugin.
      vim.lsp.enable("ts_ls", false)

      require("mason-lspconfig").setup({
        ensure_installed = {
          "vtsls", "eslint", "vue_ls", "svelte", "astro", "tailwindcss", "emmet_language_server",
          "html", "cssls", "jsonls", "yamlls", "bashls", "dockerls", "lua_ls", "marksman",
          "clangd", "pyright", "ruff", "rust_analyzer", "jdtls",
        },
        automatic_enable = { exclude = { "ts_ls" } },
      })
    end,
  },

  { "mason-org/mason.nvim", config = true }, -- NOTE: `config = true` calls mason.setup()
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "black", "clang-format", "google-java-format", "prettier",
        "prettierd", "ruff", "stylua", "sqlfluff",
      },
      run_on_start = true,
      start_delay = 500,
    },
  },

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
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      automatic_installation = true,
      ensure_installed = { "python", "js", "codelldb", "coreclr", "php", "bash" },
      handlers = {
        js = function(config)
          -- mason-nvim-dap installs js-debug but does not define its adapter.
          config.adapters = {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
              command = platform.first_executable(platform.is_windows and { "js-debug-adapter.cmd", "js-debug-adapter" } or { "js-debug-adapter" }),
              args = { "${port}", "127.0.0.1" },
            },
          }
          require("mason-nvim-dap").default_setup(config)
          local dap = require("dap")
          dap.adapters["pwa-node"] = dap.adapters.js
          dap.adapters["pwa-chrome"] = dap.adapters.js
        end,
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
}, {
  rocks = { enabled = false },
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
  local python_env = require("python_env")
  local debugpy_python = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv",
    platform.is_windows and "Scripts/python.exe" or "bin/python")
  local dap_python = require("dap-python")
  dap_python.setup(debugpy_python, { include_configs = false })
  dap_python.resolve_python = function() return python_env.python(0) end
  pcall(require("dap-go").setup)

  local dap = require("dap")
  dap.configurations.python = {
    {
      type = "python", request = "launch", name = "Python: Current file",
      program = "${file}", console = "integratedTerminal",
      pythonPath = function() return python_env.python(0) end,
      cwd = function() return python_env.root(0) end,
    },
    {
      type = "python", request = "launch", name = "Python: pytest",
      module = "pytest", console = "integratedTerminal",
      pythonPath = function() return python_env.python(0) end,
      cwd = function() return python_env.root(0) end,
    },
    {
      type = "python", request = "attach", name = "Python: Attach (debugpy)",
      connect = function()
        local port = tonumber(vim.fn.input("Local debugpy port [5678]: ")) or 5678
        return { host = "127.0.0.1", port = port }
      end,
    },
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. platform.path_separator, 'file')
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
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. platform.path_separator, 'file')
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
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Node / Next.js (inspect)",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    },
  }
  dap.configurations.typescript = dap.configurations.javascript
  dap.configurations.javascriptreact = dap.configurations.javascript
  dap.configurations.typescriptreact = dap.configurations.javascript
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
map({ "n", "v" }, "<leader>F", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer or selection" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic: Previous" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic: Next" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Diagnostic: Details" })

--File creation
map("n", "<leader>fn", function()
  local file = vim.fn.input("New file path: ", vim.fn.getcwd() .. platform.path_separator, "file")
  if file ~= "" then
    vim.cmd.edit(vim.fn.fnameescape(file))
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
map("n", "<leader>ob", function() require("project_tasks").run("build") end, { desc = "Package: Build" })
map("n", "<leader>ot", function() require("project_tasks").run("test") end, { desc = "Package: Test" })
map("n", "<leader>od", function() require("project_tasks").run("dev") end, { desc = "Package: Dev server" })
map("n", "<leader>oc", function() require("project_tasks").run("typecheck") end, { desc = "Package: Typecheck" })
map("n", "<leader>oB", function() require("project_tasks").run("build", true) end, { desc = "Workspace: Build" })
map("n", "<leader>oT", function() require("project_tasks").run("test", true) end, { desc = "Workspace: Test" })
map("n", "<leader>oC", function() require("project_tasks").run("typecheck", true) end, { desc = "Workspace: Typecheck" })
map("n", "<leader>pr", function() require("python_env").run("run") end, { desc = "Python: Run file" })
map("n", "<leader>pt", function() require("python_env").run("pytest") end, { desc = "Python: pytest" })
map("n", "<leader>ms", function() require("project_tasks").run_mobile("start") end, { desc = "Mobile: Start Metro / Expo" })
map("n", "<leader>mi", function() require("project_tasks").run_mobile("ios") end, { desc = "Mobile: Run iOS" })
map("n", "<leader>ma", function() require("project_tasks").run_mobile("android") end, { desc = "Mobile: Run Android" })


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

-- CodeCompanion
map({ "n", "v" }, "<leader>aa", ":CodeCompanionActions<CR>", { desc = "CodeCompanion: Actions" })
map("n", "<leader>ac", ":CodeCompanionChat Toggle<CR>", { desc = "CodeCompanion: Toggle Codex chat" })
map("v", "<leader>ap", ":CodeCompanionChat Add<CR>", { desc = "CodeCompanion: Add selection" })
map("n", "<leader>al", ":CodeCompanionCLI<CR>", { desc = "CodeCompanion: Claude CLI" })
map("n", "<leader>aL", ":CodeCompanionCLI agent=codex<CR>", { desc = "CodeCompanion: Codex CLI" })

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
  map("n", "<leader>dt", function() require("dap-python").test_method() end, { desc = "Python: Debug test method" })
  map("n", "<leader>dT", function() require("dap-python").test_class() end, { desc = "Python: Debug test class" })

  if dapui_ok then
    map("n", "<leader>dU", dapui.toggle, { desc = "DAP: Toggle UI" })
    map({ "n", "v" }, "<leader>de", require("dap.ui.widgets").hover, { desc = "DAP: Evaluate Hover" })
  end
end
