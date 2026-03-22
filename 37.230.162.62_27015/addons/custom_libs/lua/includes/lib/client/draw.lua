local paint = paint
local math_floor = math.floor

local colors = {}
function surface.drawGradientBox(x, y, w, h, al, ...)
  len = select("#", ...)

  al = al == 1
  local part = al and h or w
  part = math_floor(part / (len - 1))

  for i = 1, len - 1 do
    local c1, c2 = select(i, ...)
    if al then
      colors[1] = c1
      colors[2] = c1
      colors[3] = c2
      colors[4] = c2
      paint.rects.drawRect(x, y + (i - 1) * part, w, part, colors)
    else
      colors[1] = c2
      colors[2] = c1
      colors[3] = c1
      colors[4] = c2
      paint.rects.drawRect(x + (i - 1) * part, y, part, h, colors)
    end
  end
end

function surface.drawGradientPanelBox(self, ...)
  paint.startPanel(self)
  surface.drawGradientBox(...)
  paint.stopPanel()
end

function surface.drawCircle(x, y, r, color)
  paint.circles.drawCircle(x, y, r, r, color)
end