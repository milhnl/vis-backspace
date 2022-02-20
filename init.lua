local backspace = function(tabwidth)
  tabwidth = tabwidth or vis.win.tabwidth
  if tabwidth == nil or win.selection.pos == 0 then
    vis:feedkeys('<vis-delete-char-prev>')
  else
    for sel in win:selections_iterator() do
      local pos = sel.pos
      local l, r = win.file:match_at(lpeg.P(" ") ^ 1, pos - 1, 200)
      if l ~= nil and r ~= nil then
        win.file:delete(l, (r - l - 1) % tabwidth + 1)
      else
        win.file:delete(pos - 1, 1)
      end
    end
    vis.win:draw()
  end
end

vis.events.subscribe(vis.events.INIT, function()
  vis:map(vis.modes.INSERT, '<Backspace>', function() backspace() end)
end)

return backspace
