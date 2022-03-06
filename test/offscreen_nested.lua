-- offscreen_nested
--
-- test that drawing is not broken if
-- the function drawing into one image
-- draws into a second image (they should
-- not affect each other)
--

one = nil
two = nil
show_one = true
show_two = true

function create_two()
  two = screen.create_image(16, 48)
  screen.draw_to(two, function()
    local w, h = two:extents()
    screen.level(4)
    screen.clear()
    screen.rect(1, 1, w, h)
    screen.fill()
    screen.update()
  end)
end

function create_one()
  one = screen.create_image(32, 32)
  screen.draw_to(one, function()
    local w, h = one:extents()
    screen.level(15)
    screen.clear()
    create_two() -- this should not break the drawing for one
    screen.rect(1, 1, w, h)
    screen.fill()
    screen.update()
  end)
end

function redraw()
  screen.clear()
  if show_one then screen.display_image(one, 1, 1) end
  if show_two then screen.display_image(two, 10, 10) end
  screen.update()
end

function key(n, z)
  if z == 1 then
    if n == 2 then
      show_one = not show_one
      redraw()
    elseif n == 3 then
      show_two = not show_two
      redraw()
    end
  end
end

function init()
  create_one()
  redraw()
end

