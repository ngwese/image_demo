-- offscreen_error
--
-- test that drawing is not broken if
-- an error is raised while drawing into
-- the image
--

image = nil
count = 0

function create_kaboom()
  image = screen.create_image(1024, 1024)
  screen.draw_to(image, function()
    local w, h = image:extents()
    error("kaboom")
  end)
end

function redraw()
  screen.clear()
  screen.move(64, 32)
  pcall(create_kaboom)
  screen.text(tostring(count))
  screen.update()
end

function init()
  -- case 1: the drawing context should be reset to the screen
  pcall(create_kaboom)

  redraw_clock = clock.run(function()
    local interval = 1/15
    while true do
      redraw()
      count = count + 1
      if count % 100 == 0 then
        --collectgarbage("count")
        print("FORCING GC")
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


