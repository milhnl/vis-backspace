local backspace = function(tabwidth)
  tabwidth = tabwidth or vis.win.tabwidth
  if tabwidth == nil or win.selection.pos == 0 then
    vis:feedkeys('<vis-delete-char-prev>')
  else
    local sel = win.selection
    local l, r = win.file:match_at(lpeg.P(" ") ^ 1, sel.pos - 1, 200)
    if l ~= nil and r ~= nil then
      local pos = sel.pos
      local width = ((r - l - 1) % tabwidth) + 1
      vis:feedkeys(string.rep('<vis-delete-char-prev>', width))
    else
      vis:feedkeys('<vis-delete-char-prev>')
    end
  end
end

vis.events.subscribe(vis.events.INIT, function()
  vis:map(vis.modes.INSERT, '<Backspace>', function() backspace() end)
end)

return backspace
