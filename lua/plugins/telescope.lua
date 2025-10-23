return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local buffer_manager = require("config.buffer_manager")
      
      local delete_buffer = function(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi_selection = picker:get_multi_selection()
        
        local buffers_to_delete = {}
        
        if #multi_selection > 0 then
          for _, entry in ipairs(multi_selection) do
            table.insert(buffers_to_delete, entry.bufnr)
          end
        else
          local entry = action_state.get_selected_entry()
          if entry then
            table.insert(buffers_to_delete, entry.bufnr)
          end
        end
        
        for _, buf_id in ipairs(buffers_to_delete) do
          if vim.bo[buf_id].modified then
            vim.api.nvim_buf_call(buf_id, function()
              vim.cmd("write")
            end)
          end
          
          local windows_with_buffer = {}
          for _, win_id in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win_id) == buf_id then
              table.insert(windows_with_buffer, win_id)
            end
          end
          
          for _, win_id in ipairs(windows_with_buffer) do
            buffer_manager.handle_buffer_deletion_in_window(win_id, buf_id)
          end
          
          vim.api.nvim_buf_delete(buf_id, { force = false })
        end
        
        actions.close(prompt_bufnr)
        vim.schedule(function()
          vim.cmd("Telescope buffers")
        end)
      end
      
      opts.defaults = opts.defaults or {}
      opts.defaults.mappings = opts.defaults.mappings or {}
      opts.defaults.mappings.n = opts.defaults.mappings.n or {}
      opts.defaults.mappings.i = opts.defaults.mappings.i or {}
      
      opts.pickers = opts.pickers or {}
      opts.pickers.buffers = {
        theme = "dropdown",
        initial_mode = "normal",
        mappings = {
          n = {
            ["d"] = delete_buffer,
            ["<Del>"] = delete_buffer,
          },
          i = {
            ["<C-d>"] = delete_buffer,
          }
        }
      }
      
      return opts
    end,
  }
}