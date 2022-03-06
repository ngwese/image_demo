position = {128 / 2, 64 / 2}
rotation = 0
dirty = true

function block(func)
  screen.save()
  pcall(func)
  screen.restore()
end

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

function transform(func)
  local manip = {
    rotate = _norns.screen_rotate,
    transform = _norns.screen_transform,
  }
  screen.save()
  local ok, result = pcall(func, manip)
  screen.restore()
  if not ok then error(result) else return result end
end

function rotate_drawing(x, y, angle, func)
  screen.save()
  screen.translate(x, y)
  screen.rotate(util.degs_to_rads(angle))
  local ok, result = pcall(func)
  screen.restore()
  if not ok then print(result) else return result end
end

function translate_drawing(x, y, func)
  screen.save()
  screen.translate(x, y)
  pcall(func)
  screen.restore()
end
  

function redraw()
  if not dirty then return end

  --local c = function() cross(position[1], position[2], 9, true) end
  local c = function() cross(0, 0, 9, true) end
  local img = rec
  
  screen.clear()
  --translate_drawing(position[1], position[2], c)
  rotate_drawing(position[1], position[2], rotation, function()
    local w, h = rec_image:extents()
    screen.display_image(rec_image, -w/2, -h/2)
    screen.line_width(2)
    cross(0, 0, 11)
  end)
  --translate_drawing(0, 10, c)

  screen.update()

  dirty = false
end

function enc(n, delta)
  if n == 2 then
    position[1] = util.clamp(position[1] + delta, 0, 128)
    rotation = rotation + delta
    dirty = true
  elseif n == 3 then
    position[2] = util.clamp(position[2] + delta, 0, 64)
    dirty = true
  end
end

function key(n, z)
  -- print("key", n, z)
  if n == 2 and z == 1 then
    show_bg = not show_bg
    dirty = true
    redraw()
  elseif n == 3 and z == 1 then
    show_fg = not show_fg
    dirty = true
    redraw()
  end
end

function init()
  mistral = screen.load_png(paths.this.path .. "mistral-digits.png")
  rec_image = screen.load_png(paths.this.path .. "rec-big.png")
  play_image = screen.load_png(paths.this.path .. "paly.png")
  -- print("image name: ", mistral:name())
  -- print("image size: ", mistral:extents())
  -- digit_width, digit_height = mistral:extents()
  -- digit_width = digit_width / 10.0

  -- hairs_a = screen.load_png(paths.this.path .. "hairs-only-positive.png")
  -- hairs_b = screen.load_png(paths.this.path .. "hairs-only-dim.png")
  -- hairs_top = screen.load_png(paths.this.path .. "hairs-top-darker.png")

  redraw_clock = clock.run(function()
    local interval = 1/15
    while true do
      redraw()
      clock.sleep(interval)
    end
  end)

  -- digit_clock = clock.run(function()
    -- while true do
      -- clock.sleep(1/4)
      -- digit = (digit + 1) % 10
      -- dirty = true
    -- end
  -- end)
end

function cleanup()
  if redraw_clock then
    clock.cancel(redraw_clock)
  end
  if digit_clock then
    clock.cancel(digit_clock)
  end
end
