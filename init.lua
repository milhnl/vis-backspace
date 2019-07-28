local backspace = function(tabwidth)
  tabwidth = tabwidth or vis.win.tabwidth or 1
  if tabwidth == nil then
    vis:feedkeys('<vis-delete-char-prev>')
  else
    vis:command('?\n|' .. string.rep(' ', tabwidth) .. '|.?d')
  end
  vis:feedkeys('<vis-mode-insert>')
end

vis.events.subscribe(vis.events.INIT, function()
  vis:map(vis.modes.INSERT, '<Backspace>', function() backspace() end)
end)

return backspace
