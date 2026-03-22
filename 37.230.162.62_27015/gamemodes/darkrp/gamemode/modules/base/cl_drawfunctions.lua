-- concatenate a space to avoid the text being parsed as valve string
local string_match = string.match
local function safeText(text)
  return string_match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

DarkRP.deLocalise = safeText
local draw_DrawText = draw.DrawText
function draw.DrawNonParsedText(text, font, x, y, color, xAlign)
  return draw_DrawText(safeText(text), font, x, y, color, xAlign)
end

local draw_SimpleText = draw.SimpleText
function draw.DrawNonParsedSimpleText(text, font, x, y, color, xAlign, yAlign)
  return draw_SimpleText(safeText(text), font, x, y, color, xAlign, yAlign)
end

local draw_SimpleTextOutlined = draw.SimpleTextOutlined
function draw.DrawNonParsedSimpleTextOutlined(text, font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
  return draw_SimpleTextOutlined(safeText(text), font, x, y, color, xAlign, yAlign, outlineWidth, outlineColor)
end

local surface_DrawText = surface.DrawText
function surface.DrawNonParsedText(text)
  return surface_DrawText(safeText(text))
end

local chat_AddText = chat.AddText
function chat.AddNonParsedText(...)
  local tbl = {...}
  for i = 2, #tbl, 2 do
    tbl[i] = safeText(tbl[i])
  end
  return chat_AddText(unpack(tbl))
end