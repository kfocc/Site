textscreenFonts = {}
local function addFont(font, t)
	if CLIENT then
		for i = 1, 100 do
			t.size = i
			surface.CreateFont(font .. i, t)
		end
	end

	table.insert(textscreenFonts, font)
end

-- Trebuchet
addFont("Screens_Trebuchet outlined", {
	font = "Open Sans",
	weight = 400,
	antialias = false,
	extended = true,
	outline = true
})

addFont("Screens_Trebuchet", {
	font = "Open Sans",
	weight = 400,
	antialias = false,
	extended = true,
})

-- Arial
addFont("Screens_Arial outlined", {
	font = "Arial",
	weight = 600,
	antialias = false,
	extended = true,
	outline = true
})

addFont("Screens_Arial", {
	font = "Arial",
	weight = 600,
	antialias = false,
	extended = true,
})

-- Roboto Bk
addFont("Screens_Roboto outlined", {
	font = "Roboto Bk",
	weight = 400,
	antialias = false,
	extended = true,
	outline = true
})

addFont("Screens_Roboto", {
	font = "Roboto Bk",
	weight = 400,
	antialias = false,
	extended = true,
})

-- Helvetica
addFont("Screens_Helvetica outlined", {
	font = "Helvetica",
	weight = 400,
	antialias = false,
	extended = true,
	outline = true
})

addFont("Screens_Helvetica", {
	font = "Helvetica",
	weight = 400,
	antialias = false,
	extended = true,
})

-- akbar
addFont("Screens_akbar outlined", {
	font = "akbar",
	weight = 400,
	antialias = false,
	extended = true,
	outline = true
})

addFont("Screens_akbar", {
	font = "akbar",
	weight = 400,
	antialias = false,
	extended = true,
})

-- boogaloo
addFont("Screens_boogaloo outlined", {
	font = "Roboto",
	weight = 400,
	antialias = false,
	extended = true,
	outline = true
})

addFont("Screens_boogaloo", {
	font = "Roboto",
	weight = 400,
	antialias = false,
	extended = true,
})
