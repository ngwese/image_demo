-- offscreen_gc
--
-- generate a lot of garabage, verify
-- deallocation
--

image = nil
count = 0
force_gc = false

function redraw()
  screen.clear()
  pcall(function()
    -- create_image will throw a lua error if it fails, catch and keep going
    image = screen.create_image(1024, 1024)
  end)
  screen.move(10, 10)
  screen.text(" created: " .. tostring(count))
  screen.move(10, 18)
  screen.text("gc space: " .. collectgarbage("count"))
  screen.move(10, 26)
  screen.text("gc force: " .. tostring(force_gc))
  screen.update()
end

function key(n, z)
  if z == 1 then
    if n == 2 then
      force_gc = not force_gc
    end
  end
end

function init()
  redraw_clock = clock.run(function()
    local interval = 1/15
    while true do
      redraw()
      count = count + 1
      if force_gc and (count % 100 == 0) then
        collectgarbage("collect")
      end
      clock.sleep(interval)
    end
  end)
end

function cleanup()
  if redraw_clock then
    clock.cancel(redraw_clock)
  end
end


