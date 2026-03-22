local background = Color(0, 0, 0, 175)
function ApplyScrollPanelStyle(scroll)
	scroll.VBar:SetWide(8 + 5)
	scroll.VBar:SetHideButtons(true)
	scroll.VBar.Paint = function(s, w, h)
		draw.RoundedBox(6, 5, 0, w - 5, h, background)
	end

	scroll.VBar.btnGrip.Paint = function(s, w, h)
		draw.RoundedBox(6, 5, 0, w - 5, h, col.o)
	end
end