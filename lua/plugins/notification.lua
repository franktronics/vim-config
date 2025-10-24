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
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      messages = {
        enabled = true,
      }
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
}