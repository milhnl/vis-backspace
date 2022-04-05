local backspace = function(tabwidth)
  tabwidth = tabwidth or vis.win.tabwidth or 1
  local file = vis.win.file
  for sel in vis.win:selections_iterator() do
    if sel.pos ~= nil and sel.pos ~= 0 then
      local pos, col = sel.pos, sel.col
      local delete, move = 1, 1
      local l, r = file:match_at(lpeg.P(" ") ^ 1, pos - 1, 200)
      if l ~= nil and r ~= nil then
        delete = (r - l - 1) % tabwidth + 1
        move = (col - 2) % tabwidth + 1
      end
      file:delete(pos - delete, delete)
      sel.pos = math.max(pos - move, 0)
    end
  end
  vis.win:draw()
end

vis.events.subscribe(vis.events.INIT, function()
  vis:map(vis.modes.INSERT, '<Backspace>', function() backspace() end)
end)

return backspace
