local M = {}

local window_buffer_history = {}

local function get_window_id()
  return vim.api.nvim_get_current_win()
end

local function init_window_history(win_id)
  if not window_buffer_history[win_id] then
    window_buffer_history[win_id] = { buffers = {}, current = 1 }
  end
end

local function add_buffer_to_window_history(win_id, buf_id)
  init_window_history(win_id)
  local history = window_buffer_history[win_id]

  for i, existing_buf in ipairs(history.buffers) do
    if existing_buf == buf_id then
      history.current = i
      return
    end
  end

  table.insert(history.buffers, buf_id)
  history.current = #history.buffers
end

local function remove_buffer_from_window_history(win_id, buf_id)
  if not window_buffer_history[win_id] then
    return
  end

  local history = window_buffer_history[win_id]
  for i, existing_buf in ipairs(history.buffers) do
    if existing_buf == buf_id then
      table.remove(history.buffers, i)
      if history.current > i then
        history.current = history.current - 1
      elseif history.current > #history.buffers and #history.buffers > 0 then
        history.current = #history.buffers
      end
      break
    end
  end
end

local function get_valid_buffers_for_window(win_id)
  init_window_history(win_id)
  local history = window_buffer_history[win_id]
  local valid_buffers = {}

  for _, buf_id in ipairs(history.buffers) do
    if vim.api.nvim_buf_is_valid(buf_id) and vim.bo[buf_id].buflisted then
      table.insert(valid_buffers, buf_id)
    end
  end

  if #valid_buffers == 0 then
    local current_buf = vim.api.nvim_get_current_buf()
    if vim.bo[current_buf].buflisted then
      table.insert(valid_buffers, current_buf)
    end
  end

  return valid_buffers
end

function M.switch_buffer_in_window(direction)
  local win_id = get_window_id()
  local current_buf = vim.api.nvim_get_current_buf()

  add_buffer_to_window_history(win_id, current_buf)

  local valid_buffers = get_valid_buffers_for_window(win_id)
  if #valid_buffers <= 1 then
    return
  end

  local history = window_buffer_history[win_id]
  local current_index = 1

  for i, buf_id in ipairs(valid_buffers) do
    if buf_id == current_buf then
      current_index = i
      break
    end
  end

  local next_index
  if direction == "next" then
    next_index = current_index == #valid_buffers and 1 or current_index + 1
  else
    next_index = current_index == 1 and #valid_buffers or current_index - 1
  end

  local target_buf = valid_buffers[next_index]
  vim.api.nvim_win_set_buf(win_id, target_buf)

  history.current = next_index
end

function M.close_buffer_smart()
  local win_id = get_window_id()
  local current_buf = vim.api.nvim_get_current_buf()

  if vim.bo[current_buf].modified then
    vim.cmd("write")
  end

  local valid_buffers = get_valid_buffers_for_window(win_id)

  if #valid_buffers > 1 then
    remove_buffer_from_window_history(win_id, current_buf)
    local remaining_buffers = get_valid_buffers_for_window(win_id)

    if #remaining_buffers > 0 then
      local history = window_buffer_history[win_id]
      local next_buf_index = math.min(history.current or 1, #remaining_buffers)
      vim.api.nvim_win_set_buf(win_id, remaining_buffers[next_buf_index])
    end
  else
    local all_windows = vim.api.nvim_list_wins()
    local windows_with_same_buf = 0

    for _, w in ipairs(all_windows) do
      if vim.api.nvim_win_get_buf(w) == current_buf then
        windows_with_same_buf = windows_with_same_buf + 1
      end
    end

    if windows_with_same_buf == 1 then
      vim.cmd("close")
    else
      vim.cmd("enew")
    end
  end

  vim.cmd("bdelete " .. current_buf)
end

function M.smart_split(vertical)
  local cur_win = vim.api.nvim_get_current_win()
  local cur_buf = vim.api.nvim_get_current_buf()
  
  remove_buffer_from_window_history(cur_win, cur_buf)
  
  local valid_buffers = get_valid_buffers_for_window(cur_win)
  local prev_buf = nil
  
  if #valid_buffers > 0 then
    prev_buf = valid_buffers[#valid_buffers]
  else
    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf_id) and vim.bo[buf_id].buflisted and buf_id ~= cur_buf then
        prev_buf = buf_id
        break
      end
    end
  end

  if vertical then
    vim.cmd("vsplit")
  else
    vim.cmd("split")
  end

  local new_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(new_win, cur_buf)
  add_buffer_to_window_history(new_win, cur_buf)

  vim.api.nvim_set_current_win(cur_win)

  if prev_buf and prev_buf ~= cur_buf then
    vim.api.nvim_win_set_buf(cur_win, prev_buf)
    add_buffer_to_window_history(cur_win, prev_buf)
  else
    vim.cmd("enew")
  end
end

local function move_buffer_to_window(current_win, target_win, current_buf)
  remove_buffer_from_window_history(current_win, current_buf)
  
  local remaining_buffers = get_valid_buffers_for_window(current_win)
  if #remaining_buffers > 0 then
    vim.api.nvim_win_set_buf(current_win, remaining_buffers[#remaining_buffers])
  else
    vim.cmd("enew")
  end
  
  vim.api.nvim_win_set_buf(target_win, current_buf)
  add_buffer_to_window_history(target_win, current_buf)
  
  vim.api.nvim_set_current_win(target_win)
end

function M.move_buffer_direction(direction)
  local current_win = get_window_id()
  local current_buf = vim.api.nvim_get_current_buf()
  
  local target_win = nil
  
  if direction == "h" then
    vim.cmd("wincmd h")
    target_win = vim.api.nvim_get_current_win()
  elseif direction == "j" then
    vim.cmd("wincmd j")
    target_win = vim.api.nvim_get_current_win()
  elseif direction == "k" then
    vim.cmd("wincmd k")
    target_win = vim.api.nvim_get_current_win()
  elseif direction == "l" then
    vim.cmd("wincmd l")
    target_win = vim.api.nvim_get_current_win()
  end
  
  vim.api.nvim_set_current_win(current_win)
  
  if target_win and target_win ~= current_win then
    move_buffer_to_window(current_win, target_win, current_buf)
  end
end

function M.handle_buffer_deletion_in_window(win_id, buf_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return
  end
  
  remove_buffer_from_window_history(win_id, buf_id)
  
  local remaining_buffers = get_valid_buffers_for_window(win_id)
  
  if #remaining_buffers > 0 then
    local history = window_buffer_history[win_id]
    local next_buf_index = math.min(history.current or 1, #remaining_buffers)
    vim.api.nvim_win_set_buf(win_id, remaining_buffers[next_buf_index])
  else
    local all_windows = vim.api.nvim_list_wins()
    if #all_windows > 1 then
      vim.api.nvim_win_close(win_id, false)
    else
      vim.api.nvim_win_set_buf(win_id, vim.api.nvim_create_buf(false, false))
    end
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local win_id = get_window_id()
    local buf_id = vim.api.nvim_get_current_buf()
    if vim.bo[buf_id].buflisted then
      add_buffer_to_window_history(win_id, buf_id)
    end
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(event)
    local win_id = tonumber(event.match)
    if win_id and window_buffer_history[win_id] then
      window_buffer_history[win_id] = nil
    end
  end,
})

return M