return {
  {
    "folke/snacks.nvim",
    opts = {
      scope = { enabled = false },
      picker = {
        hidden = true,
        ignored = false,
        sources = {
          files = {
            hidden = true,
            ignored = false,
          },
        },
      },
      explorer = {
        enabled = true,
        hidden = true,
        auto_close = false,
        replace_netrw = false,
      },
    },
    keys = function(_, keys)
      for i, key in ipairs(keys) do
        if key[1] == "<leader>e" or key[1] == "<leader>E" then
          keys[i] = nil
        end
      end
      table.insert(keys, {
        "<leader>e",
        function()
          require("snacks").explorer({ cwd = vim.loop.cwd() })
        end,
        desc = "Explore (cwd)",
      })
      table.insert(keys, {
        "<leader>E",
        function()
          require("snacks").explorer({ cwd = nil })
        end,
        desc = "Explore (root dir)",
      })
      return keys
    end,
  },
}
