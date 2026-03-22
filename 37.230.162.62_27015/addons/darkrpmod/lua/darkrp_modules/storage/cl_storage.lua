local storage_panels = {}
local function getPrintName(class)
    local ent = weapons.GetStored(class) or scripted_ents.GetStored(class)
    if ent then return ent.PrintName or ent.t.PrintName end
end

local function getContext(class)
    local item_data = Storage.pocketable[class]
    if not item_data then return end
    local interactions = item_data.interactions
    if not interactions then return end
    local context = {}
    for k, v in ipairs(interactions) do
        table.insert(context, v.name)
    end
    return context
end

local function Drop(ent, slot)
    netstream.Start("Storage.Drop", ent, slot)
end

local function Split(ent, slot, amount)
    netstream.Start("Storage.Split", ent, slot, amount)
end

local slots_in_line = 5
local function Fill(parent, size, items, ignore_size, ignore_interactions)
    local Scroll = parent.scroll
    if not IsValid(Scroll) then
        if not ignore_size then
            local slots_w = math.min(size, slots_in_line)
            local w = 83 * slots_w + 7
            parent:SetSize(w, 32 + 80 * math.ceil(size / 5) + 3 * math.ceil(size / 5))
        else
            ignore_size(parent, size)
        end

        Scroll = vgui.Create("DScrollPanel", parent)
        Scroll:Dock(FILL)
        local sbar = Scroll:GetVBar()
        sbar:SetWide(3)
        parent.scroll = Scroll
    end

    if not IsValid(parent.List) then
        parent.List = vgui.Create("DIconLayout", Scroll)
        parent.List:Dock(FILL)
        parent.List:SetSpaceY(3)
        parent.List:SetSpaceX(3)
    else
        parent.List:Clear()
    end

    for i = 1, size do
        local ListItem = parent.List:Add("DPanel")
        ListItem:SetSize(80, 80)
        ListItem.Index = i
        if not ignore_interactions then
            ListItem:Receiver("item", function(receiver, tbl, dropped)
                if not dropped then return end
                local cur_slot = ListItem.Index -- Индекс слота, в который переносим предмет
                local cur_ent = parent.ent -- В какой энтити переносим преддмет

                local target = tbl[1] -- Панель предмета
                local old_parent = target:GetParent() -- ListItem предмета
                local old_slot = old_parent.Index -- Индекс предмета, который забрали
                local old_panel = old_parent:GetParent():GetParent():GetParent():GetParent()
                local old_ent = old_panel.ent -- Откуда предмет забрали
                local old_panel_items = old_panel.items

                local cur_item = old_panel_items[old_slot]
                local can, reason = hook.Run("canMovePocketItem", LocalPlayer(), old_ent, cur_ent, old_slot, cur_slot, cur_item)
                if can == false then
                    notification.AddLegacy(reason or "Вы не можете сделать это", NOTIFY_ERROR, 5)
                    return
                end

                -- Проверка, не пустой ли новый слот
                if #ListItem:GetChildren() > 0 then old_parent:Add(ListItem:GetChildren()[1]) end
                ListItem:Add(target)
                netstream.Start("Storage.Move", old_ent, cur_ent, old_slot, cur_slot)
            end)
        end

        local v = items[i]
        if v then
            local itemName = v.name or getPrintName(v.real_class or v.class)
            local context = getContext(v.class)
            local icon = vgui.Create("SpawnIcon", ListItem)
            icon:SetModel(v.model)
            icon:SetSize(80, 80)
            icon:SetTooltip(itemName)
            if not ignore_interactions then
                icon:Droppable("item")
                icon.DoRightClick = function(self)
                    local menu = DermaMenu()
                    for k, name in ipairs(context or {}) do
                        menu:AddOption(name, function() netstream.Start("Storage.Context", parent.ent, ListItem.Index, k) end)
                    end

                    menu:AddSpacer()
                    if v.amount and v.amount > 1 then
                        local split = menu:AddSubMenu("Разделить", function() Split(parent.ent, ListItem.Index, 1) end)
                        split:AddOption("1", function() Split(parent.ent, ListItem.Index, 1) end)
                        local half = math.floor(v.amount / 2)
                        if half > 1 and half ~= v.amount then split:AddOption(half, function() Split(parent.ent, ListItem.Index, half) end) end
                        split:AddOption("Другое количество", UI_Request("Введите количество", "Сколько предметов вы желаете разделить?", function(amount) Split(parent.ent, ListItem.Index, tonumber(amount)) end))
                    end

                    menu:AddOption("Выбросить", function() Drop(parent.ent, ListItem.Index) end)
                    menu:Open()
                end
            end

            local amount = v.amount or 1
            if amount > 1 then
                local countPanel = icon:Add("DPanel")
                countPanel:SetSize(24, 24)
                local countLabel = countPanel:Add("DLabel")
                countLabel:Dock(FILL)
                countLabel:SetFont("HudSelectionText")
                countLabel:SetText(amount)
                countLabel:SetContentAlignment(5)
            end
        end
    end
end

local function IsFree(x, y, storage_w, storage_h)
    local w, h = ScrW(), ScrH()
    for k, v in pairs(storage_panels) do
        local px, py = v:GetPos()
        local sx, sy = v:GetSize()
        if x + storage_w > px and x < px + sx and y + storage_h > py and y < py + sy then return false end
    end

    if x < 0 or y < 0 or x + storage_w > w or y + storage_h > h then return false end
    return true
end

local function GetBestPoses(new, old)
    local x, y = old:GetPos()
    local w, h = old:GetSize()
    local check_poses = {
        {
            x = x,
            y = y - new:GetTall() - 5
        },
        {
            x = x - new:GetWide() - 5,
            y = y
        },
        {
            x = x + w + 5,
            y = y
        },
        {
            x = x,
            y = y + h + 5
        },
    }
    return check_poses
end

local function FindFreePos(storage)
    local panels = {}
    for k, v in pairs(storage_panels) do
        table.insert(panels, v)
    end

    storage:MakePopup()
    if #panels == 0 then
        local x, y = (ScrW() - storage:GetWide()) * .5, ScrH() * .65
        storage:SetPos(x, y)
        if storage.ent == LocalPlayer() then gui.SetMousePos(x + storage:GetWide() * .5, y + storage:GetTall() * .5) end
        return
    end

    local storage_w, storage_h = storage:GetSize()
    local inventory = storage_panels[LocalPlayer()] -- В приоритете над инвентарём
    if inventory then
        local poses = GetBestPoses(storage, inventory)
        poses[#poses] = nil -- Убираем последнюю позицию, т.к. ниже делать элементы - такое себе
        for _, pos in ipairs(poses) do
            if IsFree(pos.x, pos.y, storage_w, storage_h) then
                storage:SetPos(pos.x, pos.y)
                return
            end
        end
    end

    for k, v in pairs(panels) do
        if v == storage then continue end
        for _, pos in ipairs(GetBestPoses(storage, v)) do
            if IsFree(pos.x, pos.y, storage_w, storage_h) then
                storage:SetPos(pos.x, pos.y)
                return
            end
        end
    end

    storage:Center() -- Не нашли. Пусть будет в центре
end

local function OpenStorage(ent, storage_slots, storage_items, ignore_size, craftable, ignore_interactions)
    local panel = storage_panels[ent]
    if IsValid(panel) then return end

    local storage = vgui.Create("DFrame")
    storage.btnMaxim:SetVisible(false)
    storage.btnMinim:SetVisible(false)
    storage:SetDraggable(true)
    storage:SetSkin(GAMEMODE.Config.DarkRPSkin)
    storage:CloseOnEscape()

    function storage:OnRemove()
        if not self.dontsend then netstream.Start("Storage.Close", ent) end
        storage_panels[ent] = nil
    end

    local name = IsValid(ent) and (ent.GetName and ent:GetName() or ent:GetNetVar("Storage.Name", "Хранилище")) or "Хранилище"
    storage:SetTitle(name)
    storage.ent = ent
    storage.slots = storage_slots
    storage.items = storage_items
    storage.ignore_size = ignore_size

    Fill(storage, storage_slots, storage_items, ignore_size, ignore_interactions)
    FindFreePos(storage)

    storage_panels[ent] = storage

    function storage:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            self:Close()
            gui.HideGameUI()
            timer.Simple(0, gui.HideGameUI)
        end

        DFrame.Think(self)
    end

    function storage:OnKeyCodePressed(key)
        if key == KEY_R then self:Close() end
    end

    function storage:SetCraftItem(craft_item)
        local craft_result = storage.craft_result
        if not craft_result then return end
        craft_result:Clear()
        if not craft_item then return end

        local item = craft_result:Add("SpawnIcon")
        item:SetModel(craft_item.model or "models/props_junk/watermelon01.mdl")
        item:SetSize(80, 80)
        item:SetTooltip(craft_item.name or "Создание")

        item.DoClick = function() netstream.Start("Storage.Craft", ent) end

        if craft_item.amount and craft_item.amount > 1 then
            local countPanel = item:Add("DPanel")
            countPanel:SetSize(24, 24)

            local countLabel = countPanel:Add("DLabel")
            countLabel:Dock(FILL)
            countLabel:SetFont("HudSelectionText")
            countLabel:SetText(craft_item.amount)
            countLabel:SetContentAlignment(5)
        end

        if craft_item.description then
            item.DoRightClick = function()
                local menu = DermaMenu()
                menu:AddOption(craft_item.name or "Создание")
                menu:AddOption(craft_item.description)
                menu:Open()
            end
            if ignore_interactions then
                item.DoClick = item.DoRightClick
            end
        end
    end

    if craftable then storage:SetCraftItem(craftable) end
    return storage
end

local function OpenPocket()
    local lp = LocalPlayer()
    local panel = storage_panels[lp]
    if IsValid(panel) then return end
    return OpenStorage(lp, GAMEMODE.Config.pocketitems, LocalPlayer():getPocketItems())
end

function DarkRP.openPocketMenu()
    local wep = LocalPlayer():GetActiveWeapon()
    if not wep:IsValid() or wep:GetClass() ~= "pocket" then return end
    return OpenPocket()
end

local function CraftSize(parent, slots)
    local slotSize = 80 -- Размер слота (ширина и высота)
    local rows = math.ceil(math.sqrt(slots)) -- Количество строк
    local cols = math.ceil(slots / rows) -- Количество столбцов
    local width = 5 * 2 + cols * slotSize + cols * 3 -- Ширина = (боковые отступы) (количество_столбцов * размер_слота) +(количество_столбцов - 1) * отступ_между_слотами
    local height = 34 + rows * slotSize + rows * 3 -- Высота = (количество_строк * размер_слота) + (количество_строк - 1)* отступ_между_слотами

    local totalwidth = width + slotSize * 2 + 2 * 3 -- + Ширина двух слотов + расстояние между слотами
    parent:SetSize(totalwidth, height)

    local right = parent:Add("DPanel")
    right:SetSize(totalwidth - width, height - 20) -- Высота хеадера dframe 20 пикселей

    right:Dock(RIGHT)
    right:DockMargin(0, 0, 0, 0)
    function right:Paint(w, h)
        return
    end

    local recipes_button = right:Add("DButton")
    recipes_button:SetText("Рецепты")
    recipes_button:SetFont("HudSelectionText")
    recipes_button:SetSize(74, 22)
    recipes_button:AlignRight(0)
    function recipes_button:DoClick()
        if IsValid(parent.RecipyList) then
            return
        end
        netstream.Start("Craft.RecipyList", parent.ent)
    end

    local inside_box = right:Add("DPanel")
    inside_box:SetSize(slotSize, slotSize)
    inside_box:SetPos((right:GetWide() - slotSize) / 2, (right:GetTall() - slotSize) / 2 - 6 - 1) -- -6 -1 - отступы убоксов
    parent.craft_result = inside_box
end

local function Open(ent, storage_slots, storage_items, is_craft, craft_item)
    DarkRP.openPocketMenu()
    if not ent then return end
    local slots = storage_slots or GAMEMODE.Config.pocketitems
    OpenStorage(ent, slots, storage_items or {}, is_craft and CraftSize, craft_item)
end

netstream.Hook("Storage.Open", Open)
netstream.Hook("Storage.Close", function(target)
    if target then
        local storage = storage_panels[target]
        if IsValid(storage) then
            storage.dontsend = true
            storage:Remove()
        end
        return
    end

    for k, v in pairs(storage_panels) do
        if IsValid(v) then
            v.dontsend = true
            v:Remove()
        end

        storage_panels[k] = nil
    end
end)

local function to_item(a)
    if a == nil or a == false then return nil end
    return a
end

netstream.Hook("Storage.NewItems", function(ent, items, full_update)
    if ent == LocalPlayer() then
        if full_update then
            DarkRP.LPPocket = items
        else
            for k, v in pairs(items) do
                DarkRP.LPPocket[k] = to_item(v)
            end
        end

        hook.Run("DarkRP.UpdatePocket")
    end

    local storage = storage_panels[ent]
    if not IsValid(storage) then
        netstream.Start("Storage.Close", ent)
        return
    end

    if full_update then
        storage.items = items
    else
        for k, v in pairs(items) do
            storage.items[k] = to_item(v)
        end
    end

    Fill(storage, storage.slots, storage.items, storage.ignore_size)
end)

netstream.Hook("Storage.Craft", function(ent, craft_item)
    local storage = storage_panels[ent]
    if not IsValid(storage) then return end
    storage:SetCraftItem(craft_item)
end)

netstream.Hook("Storage.Recipy", function(slots, items, info)
    OpenStorage("craft_example", slots, items, CraftSize, info, true)
end)

local COLOR_SLOT_BG = Color(0, 0, 0, 50)
local COLOR_RECIPE_BG = Color(50, 50, 50, 200)
local COLOR_RECIPE_SIDEBAR = Color(0, 0, 0, 150)
local COLOR_TEXT_SECONDARY = Color(200, 200, 200)
local COLOR_ICON_ALPHA = 150

local cacheTranslate = {}
local function translateModel(model)
    if cacheTranslate[model] ~= nil then return cacheTranslate[model] end
    for k, v in ipairs(FoodItems) do
        if v.model == model then
            cacheTranslate[model] = v.name
            return v.name
        end
    end

    cacheTranslate[model] = false
    return false
end

local function CreateCraftingSlot(parent, item, size)
    local slot = vgui.Create("DButton", parent)
    slot:SetSize(size, size)
    slot:SetText("")

    slot.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, COLOR_SLOT_BG)
    end

    if item then
        local icon = vgui.Create("SpawnIcon", slot)
        icon:Dock(FILL)
        icon:DockMargin(1, 1, 1, 1)
        icon:SetModel(item.model or "models/error.mdl")
        icon:SetAlpha(COLOR_ICON_ALPHA)
        local name = item.name or translateModel(item.model)
        if item.amount and item.amount > 1 then
            icon.PaintOver = function(self, w, h)
                draw.SimpleText(item.amount, "DermaDefault", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            end
            icon:SetTooltip(name .. " x" .. item.amount)
        else
            icon.PaintOver = function() end
            icon:SetTooltip(name)
        end
    end

    return slot
end

netstream.Hook("Craft.RecipyList", function(recipes, ent)
    cacheTranslate = {}
    local storage = storage_panels[ent]

    local frame = vgui.Create("DFrame")
    frame:SetSize(IsValid(storage) and storage:GetWide() or 460, 480)
    frame:SetTitle("Доступные рецепты")
    frame:SetSkin(GAMEMODE.Config.DarkRPSkin)
    frame:MakePopup()
    frame:Center()
    FindFreePos(frame)

    if IsValid(storage) then
        if IsValid(storage.RecipyList) then
            storage.RecipyList:Remove()
        end
        storage.RecipyList = frame
    end

    local mainContainer = frame:Add("DPanel")
    mainContainer:Dock(FILL)
    mainContainer:DockPadding(5, 5, 5, 5)
    mainContainer.Paint = function() end

    local scroll = vgui.Create("DScrollPanel", mainContainer)
    scroll:Dock(FILL)
    ApplyScrollPanelStyle(scroll)

    table.sort(recipes, function(a, b)
        return (a.name or "") < (b.name or "")
    end)

    for _, recipe in ipairs(recipes) do
        local recipePanel = vgui.Create("DButton", scroll)
        recipePanel:Dock(TOP)
        recipePanel:SetTall(100)
        recipePanel:DockMargin(0, 0, 0, 5)
        recipePanel:SetText("")

        local recipeContainer = vgui.Create("DPanel", recipePanel)
        recipeContainer:Dock(FILL)
        recipeContainer.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, COLOR_RECIPE_BG)
            draw.RoundedBox(4, 0, 0, 100, h, COLOR_RECIPE_SIDEBAR)
        end

        local resultPanel = vgui.Create("DPanel", recipeContainer)
        resultPanel:Dock(LEFT)
        resultPanel:SetWide(100)
        resultPanel.Paint = function() end

        local resultIcon = vgui.Create("SpawnIcon", resultPanel)
        resultIcon:Dock(FILL)
        resultIcon:DockMargin(10, 10, 10, 10)
        resultIcon:SetModel(recipe.model or "models/error.mdl")
        resultIcon:SetTooltip(recipe.name or "Результат")
        resultIcon.PaintOver = function() end

        -- Middle - Name and description
        local infoPanel = vgui.Create("DPanel", recipeContainer)
        infoPanel:Dock(LEFT)
        infoPanel:SetWide(200)
        infoPanel:DockPadding(10, 10, 10, 10)
        infoPanel.Paint = function() end

        local nameLabel = infoPanel:Add("DLabel")
        nameLabel:Dock(TOP)
        nameLabel:SetFont("HudSelectionText")
        nameLabel:SetText(recipe.name or translateModel(recipe.model) or "Безымянный рецепт")
        nameLabel:SetTextColor(color_white)
        nameLabel:SizeToContentsY(5)

        local descLabel = infoPanel:Add("DLabel")
        descLabel:Dock(TOP)
        descLabel:DockMargin(0, 5, 0, 0)
        descLabel:SetText(recipe.description or "")
        descLabel:SetTextColor(COLOR_TEXT_SECONDARY)
        descLabel:SetWrap(true)
        descLabel:SetAutoStretchVertical(true)

        local gridPanel = vgui.Create("DPanel", recipeContainer)
        gridPanel:Dock(RIGHT)
        gridPanel:SetWide(90)
        gridPanel:DockMargin(0, 5, 5, 5)
        gridPanel.Paint = function() end

        for y = 0, 2 do
            for x = 0, 2 do
                local idx = y * 3 + x + 1
                local item = recipe.items and recipe.items[idx]
                local slot = CreateCraftingSlot(gridPanel, item, 25)
                slot:SetPos(2 + x * 27, 2 + y * 27)
            end
        end

        recipePanel.DoClick = function()
            surface.PlaySound("ui/buttonclick.wav")
            frame:Remove()
            if Storage.Craft.ShowRecipy then
                Storage.Craft.ShowRecipy(LocalPlayer(), recipe)
            end
        end

        recipePanel:SetCursor("hand")
        recipePanel.OnCursorEntered = function()
            surface.PlaySound("ui/buttonrollover.wav")
        end
    end

    frame:InvalidateLayout(true)
    local x, y = frame:GetPos()
    local w, h = frame:GetSize()
    local sw, sh = ScrW(), ScrH()

    x = math.Clamp(x, 0, sw - w)
    y = math.Clamp(y, 0, sh - h)
    frame:SetPos(x, y)
end)