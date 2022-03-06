-- offscreen_toplevel
--
-- test that drawing is not broken if
-- drawing is done at script load
-- (outside of init)
--

image = screen.create_image(32, 32)
screen.draw_to(image, function()
  local w, h = image:extents()
  screen.level(15)
  screen.clear()
  screen.rect(1, 1, w, h)
  screen.fill()
  screen.update()
end)

function redraw()
  screen.clear()
  screen.display_image(image, 1, 1)
  screen.update()
end

function init()
  redraw()
end

