position = {0, 0}
offscreen = true

function cross(x, y, size, debug)
  local half = size / 2
  screen.move(x - half, y)
  screen.line(x + half, y)
  screen.move(x, y - half)
  screen.line(x, y + half)
  screen.stroke()
  if debug then
    screen.move(x + 2, y + 7)
    screen.text(tostring(x) .. ", " .. tostring(y))
  end
end

function draw_grid()
  for x = 0, 256, 32 do
    for y = 0, 128, 32 do
      cross(x, y, 9, true);
    end
  end
end

function translate_drawing(x, y, func)
  screen.save()
  screen.translate(x, y)
  pcall(func)
  screen.restore()
end

function redraw()
  local start = util.time()
  screen.clear()
  cross(64, 32, 13)
  if offscreen then
    screen.display_image(image, position[1], position[2])
  else
    translate_drawing(position[1], position[2], draw_grid)
  end
  screen.update()
  local elapsed = util.time() - start
  if offscreen then
    print("offscreen:", elapsed)
  else
    print("immediate:", elapsed)
  end
end

function enc(n, delta)
  if n == 2 then
    position[1] = util.clamp(position[1] + delta, -256, 256)
    redraw()
  elseif n == 3 then
    position[2] = util.clamp(position[2] + delta, -128, 128)
    redraw()
  end
end

function key(n, z)
  if n == 2 and z == 1 then
    offscreen = not offscreen
    print("offscreen = ", offscreen)
    redraw()
  end
end

function init()
  image = screen.create_image(256, 128)
  screen.draw_to(image, function()
    -- this is a completely separate graphics context, defaults need to be set
    screen.clear()
    screen.aa(0)
    screen.level(15)
    screen.line_width(1)
    screen.font_face(1)
    screen.font_size(8)
    draw_grid()
    screen.update()
  end)
end
