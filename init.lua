local backspace = function(tabwidth)
  tabwidth = tabwidth or (vis.options and vis.win.options.tabwidth) or 1
  local file = vis.win.file
  for sel in vis.win:selections_iterator() do
    if sel.pos ~= nil and sel.pos ~= 0 then
      local pos, col = sel.pos, sel.col
      local delete, move = 1, 1
      local start = lpeg.match(lpeg.P(" ") ^ 1, file.lines[sel.line])
      if start ~= nil and col <= start then
        delete = (start - 2) % tabwidth + 1
        move = math.max(col - 2, 0) % tabwidth + 1
      end
      file:delete(math.max(pos - move, 0), delete)
      sel.pos = math.max(pos - move, 0)
    end
  end
  vis.win:draw()
end

vis.events.subscribe(vis.events.INIT, function()
  vis:map(vis.modes.INSERT, '<Backspace>', function() backspace() end)
end)

return backspace
