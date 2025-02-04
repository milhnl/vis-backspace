
--[[
  on_win_open detects indentation
  saves it on files[file] = indentation
  backspace gets tabwidth from files[file] or its 1
--]]

local M = {
  NAME = "vis-backspace"
  ,DESC = "backspace key deletes tabwidth spaces"

  ,spacelimit = 8 -- tw is guessed from the file

  ,search_limit = 500 -- lines to search
  -- set to math.huge to search completely
}

local vis = _G.vis
local string = string

local files = {
  -- [filepath or win.file.path] = indentation_number
}

--[[
  Iterate through entire file, looking for indentation
  on first indentation is found, try to mimic it on settings
--]]

local examine_line = function (line)
  line = line:match"^%g+%s+vim:%s+(.+)"
  if line==nil then return nil end
  return line:match"tw=(%d)"
end

local examine_head = function (file)
  local NR = 0
  local search_limit = M.search_limit
  local spacelimit = M.spacelimit
  for line in file:lines_iterator() do
    NR = NR + 1
    local indent = line:match"^%s+"
    if indent then
      local _, count = indent:gsub(" ", "")
      if count==0 then -- tab
        return 1 -- tab
      elseif count>0 and count<=spacelimit then
        return count
      end
    end
    if NR>search_limit then
      break
    end
  end
  return nil
end

local guess_and_set_indentation = function (win)
  local file = win.file

  -- no name? new file, don't care.
  if file==nil or file.path==nil then return end

  local lines = file.lines
  if #lines==0 then return end

  files[file.path] =
    examine_line(lines[#lines])
      or examine_line(lines[2])
      or examine_line(lines[3])
      or examine_line(lines[4])
      or examine_line(lines[5])
      or examine_head(file)
      or 1
end

local on_win_open = guess_and_set_indentation

local tw = 1 -- default_tabwidth

local backspace = function()
  local win = vis.win
  local tabwidth = win and win.options and win.options.tabwidth
    or win and win.file and win.file.path and files[win.file.path]
    or tw
  local file = win.file
  for sel in win:selections_iterator() do
    if sel.pos ~= nil and sel.pos ~= 0 then
      local pos, col = sel.pos, sel.col
      local delete, move = 1, 1
      local start = file.lines[sel.line]:match" +()"
      if
          (win.options == nil or win.options.expandtab)
          and start ~= nil
          and col <= start
      then
        delete = (start - 2) % tabwidth + 1
        move = math.max(col - 2, 0) % tabwidth + 1
      end
      file:delete(math.max(pos - move, 0), delete)
      sel.pos = math.max(pos - move, 0)
    end
  end
  win:draw()
end

vis.events.subscribe(vis.events.WIN_OPEN, on_win_open)

vis.events.subscribe(vis.events.INIT, function()
  vis:map(vis.modes.INSERT, '<Backspace>', backspace)
end)

return M
