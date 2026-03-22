include("shared.lua")

local size = 750

local function CreateLabel(parent, text, posX, posY, color)
    local label = vgui.Create("MLabel", parent)
    label:SetText(text)
    label:SetPos(posX, posY)
    label:SizeToContents()
    label:SetColor(color or col.w)
    return label
end

local function CreateImage(parent, imagePath, posX, posY, sizeX, sizeY)
    local image = vgui.Create("DImage", parent)
    image:SetImage(imagePath)
    image:SetPos(posX, posY)
    image:SetSize(sizeX, sizeY)
    return image
end

local function CreateModelPanel(parent, ply)
    local face = vgui.Create("DModelPanel", parent)
    face:SetPos(20, 80)
    face:SetSize(100, 130)
    face:SetModel(ply:GetModel())
    face:SetAnimSpeed(0)
    local ent = face.Entity
    if ent:LookupBone("ValveBiped.Bip01_Head1") then
        local eyepos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
        eyepos:Add(Vector(0, 0, 2))
        face:SetLookAt(eyepos)
        face:SetCamPos(eyepos - Vector(-15, 0, 0))
        --ent:SetSequence("idle")
        --ent:SetAngles(Angle(0, 90, 0))
    end

    function face:LayoutEntity(entity)
        entity:SetIK(false)
        entity:ResetSequence(entity:SelectWeightedSequence(ACT_IDLE))

				if IsValid(ply) then
					for k, v in pairs(entity:GetBodyGroups()) do
							local val = ply:GetBodygroup(v.id)
							entity:SetBodygroup(v.id, val)
					end
				end
        entity:SetAngles(Angle(0, 5, 0))
        local head = entity:LookupBone("ValveBiped.Bip01_Head1")
        if head then
            local eyepos = entity:GetBonePosition(head)
            eyepos:Add(Vector(0, 0, 2))
            self:SetLookAt(eyepos)
            self:SetCamPos(eyepos - Vector(-15, 0, 0))
        end
    end

    face:SetAnimated(false)
    -- Установка освещения с использованием методов DModelPanel
    face:SetAmbientLight(Color(128, 128, 128)) -- Установка фонового света (мягкий серый свет)

    -- Установка направленного света
    face:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255)) -- Свет спереди (белый)
    face:SetDirectionalLight(BOX_LEFT, Color(200, 200, 200)) -- Свет слева (мягкий белый)

    return face
end

local function ShowCID(ply)
    if not IsValid(ply) then return end

    local screenW, screenH = ScrW(), ScrH()
    local panelHeight = 320
    local panelY = screenH / 2 - panelHeight / 2

    local house = ply:GetNetVar("UnionRP.HouseName", "Отсутствует")
    local houseText = string.format("Недвижимость: %s", house)
    surface.SetFont("HeaderFont")
    local textWidth = surface.GetTextSize(houseText)
    local panelWidth = math.max(size, textWidth + 160)

    if main_editable_menu and IsValid(main_editable_menu) then
        main_editable_menu:Remove()
    end

    main_editable_menu = vgui.Create("DPanel")
    main_editable_menu:SetSize(panelWidth, panelHeight)
    main_editable_menu:SetPos(screenW, panelY) -- Начальная позиция за пределами экрана
    main_editable_menu.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, col.ba)
        draw.RoundedBox(10, 0, 0, w, h * 0.2, col.o)
        draw.RoundedBox(0, 0, h * 0.2 - 5, w, 5, col.w)
    end

    main_editable_menu:MoveTo(screenW - panelWidth - 10, panelY, 0.5, 0, 1)

    timer.Simple(10, function()
        if IsValid(main_editable_menu) then
            main_editable_menu:MoveTo(screenW, panelY, 0.5, 0, 1, function()
                if IsValid(main_editable_menu) then
                    main_editable_menu:Remove()
                end
            end)
        end
    end)

    -- Модель игрока
    CreateModelPanel(main_editable_menu, ply)

    -- Информация
    CreateLabel(main_editable_menu, "Удостоверение личности #" .. ply:GetID(), 140, 10)
    CreateLabel(main_editable_menu, "Данные: " .. ply:Name(), 140, 80)
    CreateLabel(main_editable_menu, ply:Team() == 1 and string.format("Город отбытия: C%s", tostring(ply:GetNetVar("CIDCity"))) or houseText, 140, 118)

    local jobn = ply:GetNetVar("TeamNum") or ply:Team()
    local jtbl = RPExtraTeams[jobn]
    local job = jobn == TEAM_CITIZEN and "Прибывший" or jobn == TEAM_BICH1 and "Гражданин" or jtbl.citizen and "Гражданин" or jtbl.gang and "Гражданин" or jtbl.gsr and team.GetName(jobn) or (jtbl.loyal or ply:isCP()) and (jtbl.fakejobname or team.GetName(jobn)) or "Ошибка"
    job = string.gsub(job, "C17.", "")
    CreateLabel(main_editable_menu, "Деятельность: " .. job, 140, 156)

    CreateLabel(main_editable_menu, "Возраст: " .. ply:GetNetVar("CIDAge"), 140, 194)
    CreateLabel(main_editable_menu, "Лояльность: " .. ply:GetLoyalPoints(), 140, 232)

    local reason = ply:isWanted() and ply:getWantedReason() or "Отсутствует"
    CreateLabel(main_editable_menu, "Розыск: " .. reason, 140, 270)

    -- Логотип и QR-код
    CreateImage(main_editable_menu, "materials/union/logo.png", panelWidth - 70, panelHeight - 70, 70, 70)
    CreateImage(main_editable_menu, "materials/union/qr2.png", 5, 200, 130, 120)
end


netstream.Hook("CIDCard", ShowCID)

local ss = util.ScreenScale
local color_black = Color(15, 15, 15)
local function drawShadowText(text, font, x, y, color, align1, align2)
    local w, h = draw.SimpleText(text, font, x, y, color_black, align1, align2)
    draw.SimpleText(text, font, x - 1, y - 1, color, align1, align2)
    return w, h
end

local instructions = {{"Предъявить свою CID-карту игроку на которого вы смотрите", "Левая кнопка мыши"}, {"Посмотреть свою CID-карту", "Правая кнопка мыши"},}
local stencil = "[ %s ] - %s"
local stepW, stepH, stepY = ss(15), ss(25), ss(10)
function SWEP:DrawHUD()
    local w = ScrW() - stepW
    local h = ScrH() - stepH
    local y, _
    local tab = instructions
    for k, v in ipairs(tab) do
        _, y = drawShadowText(stencil:format(v[1], v[2]), "handsIntructionsFont", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        h = h - y - stepY
    end
end

function SWEP:PrimaryAttack()
    return
end

function SWEP:SecondaryAttack()
    return
end
