local backspace = function(tabwidth)
  tabwidth = tabwidth
    or (vis.win and vis.win.options and vis.win.options.tabwidth)
    or 1
  local file = vis.win.file
  for sel in vis.win:selections_iterator() do
    if sel.pos ~= nil and sel.pos ~= 0 then
      local pos, col = sel.pos, sel.col
      local delete, move = 1, 1
      local start = string.match(file.lines[sel.line], '^ +()')
      if
          (vis.win.options == nil or vis.win.options.expandtab)
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
  vis.win:draw()
end

vis.events.subscribe(vis.events.INIT, function()
  vis:map(vis.modes.INSERT, '<Backspace>', function() backspace() end)
end)

return backspace
