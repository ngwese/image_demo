position = {0, 0}
dirty = true

show_bg = false
show_fg = false

digit = 0
digit_width = 0
digit_height = 0
digit_x = 0
digit_y = 0

function redraw()
  if not dirty then return end
  
  screen.clear()
  screen.blend_mode('over')

  if show_bg then 
    screen.display_image(hairs_top, 0, -20 - position[1] * 0.3)  
  end
  
  screen.display_image_region(mistral, digit * digit_width, 0, digit_width, digit_height, position[1], position[2])
  
  if show_fg then
    screen.blend_mode('xor')
    screen.display_image(mistral, position[1] + digit_width, position[2])
    screen.blend_mode('over')
  end
  
  screen.display_image(hairs_a, 50, util.clamp(28 + position[1] * 0.2, 28, 64))
  screen.blend_mode('screen')
  screen.display_image(hairs_b, 0 + position[1], 35)

  screen.update()

  dirty = false
end

function enc(n, delta)
  if n == 2 then
    position[1] = util.clamp(position[1] + delta, -64, 128)
    dirty = true
    redraw()
  elseif n == 3 then
    position[2] = util.clamp(position[2] + delta, -32, 64)
    dirty = true
    redraw()
  end
end

function key(n, z)
  print("key", n, z)
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
  print("image name: ", mistral:name())
  print("image size: ", mistral:extents())
  digit_width, digit_height = mistral:extents()
  digit_width = digit_width / 10.0

  hairs_a = screen.load_png(paths.this.path .. "hairs-only-positive.png")
  hairs_b = screen.load_png(paths.this.path .. "hairs-only-dim.png")
  hairs_top = screen.load_png(paths.this.path .. "hairs-top-darker.png")
    
  redraw_clock = clock.run(function()
    local interval = 1/15
    while true do
      redraw()
      clock.sleep(interval)
    end
  end)
  
  digit_clock = clock.run(function()
    while true do
      clock.sleep(1/4)
      digit = (digit + 1) % 10
      dirty = true
    end
  end)
end

function cleanup()
  if redraw_clock then
    clock.cancel(redraw_clock)
  end
  if digit_clock then
    clock.cancel(digit_clock)
  end
end
