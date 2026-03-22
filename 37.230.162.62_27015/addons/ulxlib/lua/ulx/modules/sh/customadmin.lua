local PRICE_FOR_NAME = 300
local PRICE_FOR_ICON = 100

CATEGORY_NAME = "Custom Admin"

function ulx.admin_setcustomname(ply, arg)
    local ok, err = CustomAdmins.IsNameValid(arg)
    if not ok then
        DarkRP.notify(ply, 1, 4, err)
        return
    end
    if ply:GetDBVar("CustomRank.Name") then
        if not IGS.CanAfford(ply, PRICE_FOR_NAME) then
            DarkRP.notify(ply, 1, 4, "Недостаточно средств. Стоимость: " .. IGS.SignPrice(PRICE_FOR_NAME))
            return
        end
        ply:AddIGSFunds(-PRICE_FOR_NAME, "Смена названия привилегии")
    end
    CustomAdmins.SetCustomName(ply, arg)
    DarkRP.notify(ply, 0, 4, "Вы успешно установили новое название привилегии")
end
local admin_setcustomname = ulx.command( CATEGORY_NAME, "ulx admin_setcustomname", ulx.admin_setcustomname, "!admin_setcustomname")
admin_setcustomname:addParam{ type=ULib.cmds.StringArg, hint="Название привилегии", ULib.cmds.takeRestOfLine }
admin_setcustomname:help("Установка нового названия привилегии. Стоимость - " .. PRICE_FOR_NAME .. ". Первая установка - бесплатно")

function ulx.admin_setcustomicon(ply, arg)
    local ok, err = CustomAdmins.IsIconExists(arg)
    if not ok then
        DarkRP.notify(ply, 1, 4, err)
        return
    end
    if ply:GetDBVar("CustomRank.Icon") then
        if not IGS.CanAfford(ply, PRICE_FOR_ICON) then
            DarkRP.notify(ply, 1, 4, "Недостаточно средств. Стоимость: " .. IGS.SignPrice(PRICE_FOR_ICON))
            return
        end
        ply:AddIGSFunds(-PRICE_FOR_ICON, "Смена иконки привилегии")
    end
    CustomAdmins.SetCustomIcon(ply, arg)
    DarkRP.notify(ply, 0, 4, "Вы успешно установили новую иконку привилегии")
end
local admin_setcustomicon = ulx.command( CATEGORY_NAME, "ulx admin_setcustomicon", ulx.admin_setcustomicon, "!admin_setcustomicon")
admin_setcustomicon:addParam{ type=ULib.cmds.StringArg, hint="Название иконки", ULib.cmds.takeRestOfLine }
admin_setcustomicon:help("Установка новой иконки привилегии. Стоимость - " .. PRICE_FOR_ICON .. ". Первая установка - бесплатно")