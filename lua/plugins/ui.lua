return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        progress = { enabled = true },
        hover = { enabled = true, focusable = true },
        signature = { enabled = true, focusable = true },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function(_, opts)
      require("noice").setup(opts)
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#E66A61", bg = "NONE" })
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 10000,
    },
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
      },
    },
  },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "b0o/incline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified

          local bg_color = props.focused and "#E66A61" or "#2e2a44"
          local fg_color = props.focused and "#ffffff" or "#aaaaaa"

          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold", guifg = fg_color },
            " ",
            guibg = bg_color,
          }
        end,
      })
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███████╗██████╗  █████╗ ███╗   ██╗██╗  ██╗████████╗██████╗  ██████╗ ███╗   ██╗██╗ ██████╗███████╗
██╔════╝██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝╚══██╔══╝██╔══██╗██╔═══██╗████╗  ██║██║██╔════╝██╔════╝
█████╗  ██████╔╝███████║██╔██╗ ██║█████╔╝    ██║   ██████╔╝██║   ██║██╔██╗ ██║██║██║     ███████╗
██╔══╝  ██╔══██╗██╔══██║██║╚██╗██║██╔═██╗    ██║   ██╔══██╗██║   ██║██║╚██╗██║██║██║     ╚════██║
██║     ██║  ██║██║  ██║██║ ╚████║██║  ██╗   ██║   ██║  ██║╚██████╔╝██║ ╚████║██║╚██████╗███████║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝╚══════╝
          ]],
        },
      },
    },
  },
}
