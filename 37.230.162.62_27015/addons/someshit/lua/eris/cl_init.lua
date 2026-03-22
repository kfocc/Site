/*---------------------------------------------------------------------------
	Panel functions
---------------------------------------------------------------------------*/
local blur = Material("pp/blurscreen")
function Eris:DrawBlur(pnl, amount)
	local x, y = pnl:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 8))
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local sin, cos, rad = math.sin, math.cos, math.rad
local circle = {}
for i = 1, 360 do
	circle[i] = {}
end
function Eris:DrawCircle(x, y, r)
	for i = 1, 360 do
		circle[i].x = x + cos(rad(i * 360) / 360) * r
		circle[i].y = y + sin(rad(i * 360) / 360) * r
	end

	draw.NoTexture()
	surface.DrawPoly(circle)
end

local panelMeta = FindMetaTable("Panel")

function panelMeta:ErisClickyEffect(click, speed, alpha)
	click = click || self
	speed = speed || 4
	alpha = alpha || 80

	self.rad = 0
	self.clickAlpha = alpha
	local oldPaint = self.PaintOver || function() end
	self.PaintOver = function(s, w, h)
		oldPaint(s, w, h)

		if(s.clickX && s.clickY && s.rad && s.clickAlpha != 0) then
			surface.SetDrawColor(255, 255, 255, s.clickAlpha)
			Eris:DrawCircle(s.clickX, s.clickY, s.rad)
			s.rad = Lerp(FrameTime() * speed, s.rad, w)
			s.clickAlpha = Lerp(FrameTime() * speed, s.clickAlpha, 0)
		end
	end

	local oldClick = click.DoClick

	click.DoClick = function(s)
		oldClick(s)

		self.clickX, self.clickY = self:CursorPos()
		self.rad = 0
		self.clickAlpha = alpha
	end
end

function panelMeta:ErisHoverEffect(col, fn)
	col = col || Eris:Theme("accent")

	local old = self.PaintOver

	self.Alpha = 0
	self.PaintOver = function(s, w, h)
		if(old) then old(s, w, h) end

		s.Alpha = Lerp(FrameTime()*12, s.Alpha, s:IsHovered() && 1 || 0)
		if(s.Alpha > 0.01) then
			local bar = math.Round(w*s.Alpha)

			local col = ColorAlpha(col, s.Alpha*150)
			surface.SetDrawColor(col)
			surface.DrawRect(w/2-bar/2, h-2, bar, 2)

			if(fn) then
				fn(s, w, h, s.Alpha*30)
			else
				surface.SetDrawColor(ColorAlpha(col, s.Alpha*30))
				surface.DrawRect(0, 0, w, h)
			end
		end
	end
end


/*---------------------------------------------------------------------------
	Scrollbar
---------------------------------------------------------------------------*/
function panelMeta:ErisScrollbar()
	local sb = self:GetVBar()

	local bw = 20
	sb:SetWide(bw)
	--sb:SetHideButtons(true)

	sb.Paint = function(s, w, h)
		local grip = s.btnGrip:GetTall()/2
		surface.SetDrawColor(ColorAlpha(Eris:Theme("accent"), 150))
		surface.DrawRect(w/2-1, grip, 2, h-grip*2)
	end

	sb.btnGrip.Paint = function(s, w, h)
		surface.SetDrawColor(Eris:Theme("accent"))
		Eris:DrawCircle(w/2, h/2, w/3)
	end

	sb.btnUp.Paint = nil

	sb.btnDown.Paint = nil
end

function Eris:Lang(str)
	return Eris.Config.Language[str] || str
end

function Eris:Theme(str)
	return Eris.Themes[Eris.Config.Theme || "frost"][str]
end

function Eris:StringRequest(title, description, placeholder, func, button)
	local pnl = Derma_StringRequest(
		title,
		description,
		placeholder,
		func,
		nil,
		button
	)

	pnl.FadeTime = SysTime()
	pnl.Paint = function(s, w, h)
		Derma_DrawBackgroundBlur(s, s.FadeTime)
		draw.RoundedBoxEx(6,0,0,w,h,Eris:Theme("background"),true,true)
		draw.RoundedBoxEx(6,0,0,w,24,Eris:Theme("accent"),true,true)
	end
end

function Eris:Notify(text, type)
	notification.AddLegacy(text, type || NOTIFY_ERROR, 4)
	surface.PlaySound("buttons/lightswitch2.wav")
end


/*---------------------------------------------------------------------------
	Permission functions
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
	Returns:
		(Bool) able to switch
		(Bool) if we can't switch, should we still see the job
		(String) reason for not being able to switch
---------------------------------------------------------------------------*/
function Eris:CanSwitchJob(job)
	if(LocalPlayer():Team() == job.team) then return false, true, Eris:Lang("already_have_job") end
	if(job.customCheck && !job.customCheck(LocalPlayer())) then return false, Eris.Config.ShowCustomChecks, job.CustomCheckFailMsg || Eris:Lang("check_failed") end
	if(job.admin == 1 && !LocalPlayer():IsAdmin()) then return false end
	if(job.max && job.max > 0 && table.Count(team.GetPlayers(job.team)) >= job.max) then return false, true, Eris:Lang("job_full") end

	return true
end


/*---------------------------------------------------------------------------
	Returns:
		(Bool) Able to purchase
		(Bool) If they can't purchase it, will they be able to see it in the menu?
		(String) reason for not being able to purchase it
		(Number) Purchase price if different from the normal price of the item
---------------------------------------------------------------------------*/
function Eris:CanBuyWeapon(wep)
	if(GAMEMODE.Config.restrictbuypistol && !table.HasValue(wep.allowed, LocalPlayer():Team())) then return false end
	if(wep.customCheck && !wep.customCheck(LocalPlayer())) then return false, Eris.Config.ShowCustomChecks, wep.CustomCheckFailMsg || Eris:Lang("check_failed") end

	local canbuy, suppress, message, price = hook.Call("canBuyPistol", nil, LocalPlayer(), wep)
	local cost = price || wep.getPrice && wep.getPrice(LocalPlayer(), wep.pricesep) || wep.pricesep

	if(!LocalPlayer():canAfford(cost)) then return false, true, Eris:Lang("cannot_afford"), cost end

	if(canbuy == false) then
		return false, !suppress, message, cost
	end

	return true, nil, nil, cost
end

function Eris:CanBuyShipment(ship)
	if(!table.HasValue(ship.allowed, LocalPlayer():Team())) then return false end
	if(ship.customCheck && !ship.customCheck(LocalPlayer())) then return false, Eris.Config.ShowCustomChecks, ship.CustomCheckFailMsg || Eris:Lang("check_failed") end

	local canbuy, suppress, message, price = hook.Call("canBuyShipment", nil, LocalPlayer(), ship)
	local cost = price || ship.getPrice && ship.getPrice(LocalPlayer(), ship.price) || ship.price

	if(!LocalPlayer():canAfford(cost)) then return false, true, Eris:Lang("cannot_afford"), cost end

	if(canbuy == false) then
		return false, !suppress, message, cost
	end

	return true, nil, nil, cost
end

function Eris:CanBuyAmmo(ammo)
	if(ammo.customCheck && !ammo.customCheck(LocalPlayer())) then return false end

	local canbuy, suppress, message, price = hook.Call("canBuyAmmo", nil, LocalPlayer(), ammo)
	local cost = price || ammo.getPrice && ammo.getPrice(LocalPlayer(), ammo.price) || ammo.price
	if(!LocalPlayer():canAfford(cost)) then return false, true, Eris:Lang("cannot_afford"), cost end

	if(canbuy == false) then
		return false, !suppress, message, cost
	end

	return true, nil, nil, cost
end

function Eris:CanBuyEntity(ent)
	if(istable(ent.allowed) && !table.HasValue(ent.allowed, LocalPlayer():Team())) then return false end
	if(ent.customCheck && !ent.customCheck(LocalPlayer())) then return false, true, ent.CustomCheckFailMsg || Eris:Lang("check_failed") end

	local canbuy, suppress, message, price = hook.Call("canBuyCustomEntity", nil, LocalPlayer(), ent)
	local cost = price || ent.getPrice && ent.getPrice(LocalPlayer(), ent.price) || ent.price
	if(!LocalPlayer():canAfford(cost)) then return false, true, Eris:Lang("cannot_afford"), cost end

	if(canbuy == false) then
		return false, !suppress, message, cost
	end

	return true, nil, nil, cost
end

function Eris:CanBuyFood(food)
	if((food.requiresCook == nil || food.requiresCook == true) && !LocalPlayer():isCook()) then return false end
	if(food.customCheck && !food.customCheck(LocalPlayer())) then return false end

	if(!LocalPlayer():canAfford(food.price)) then return false, true, Eris:Lang("cannot_afford") end

	return true
end

function Eris:CanBuyVehicle(veh)
	if(istable(veh.allowed) && !table.HasValue(veh.allowed, LocalPlayer():Team())) then return false end
	if(veh.customCheck && !veh.customCheck(LocalPlayer())) then return false, true, veh.CustomCheckFailMsg || Eris:Lang("check_failed") end

	local canbuy, suppress, message, price = hook.Call("canBuyVehicle", nil, LocalPlayer(), veh)
	local cost = price || veh.getPrice && veh.getPrice(LocalPlayer(), veh.price) || veh.price

	if(!LocalPlayer():canAfford(cost)) then return false, true, Eris:Lang("cannot_afford"), cost end

	if(canbuy == false) then
		return false, !suppress, message, cost
	end

	return true, nil, nil, cost
end


/*---------------------------------------------------------------------------
	Tab functionality
---------------------------------------------------------------------------*/
function Eris:AddTab(name, tbl)
	if(tbl.jobs) then
		tbl.panel = "ErisF4Jobs"
	elseif(tbl.food) then
		tbl.panel = "ErisF4Food"
		tbl.canSee = function()
			local count = 0
			for k, v in pairs(FoodItems || {}) do
				local buyable, visible = hook.Call("CanBuyFood", Eris, v)
				if(!buyable && !visible) then continue end
				count = count + 1
			end

			return count != 0
		end
	elseif(tbl.weapons) then
		tbl.panel = "ErisF4Weapons"
		tbl.canSee = function()
			local count = 0

			for k, v in pairs(CustomShipments) do
				if(!v.noship && !v.separate) then continue end
				local buyable, visible = hook.Call("CanBuyWeapon", Eris, v)
				if(!buyable && !visible) then continue end
				count = count + 1
			end

			return count != 0
		end
	elseif(tbl.shipments) then
		tbl.panel = "ErisF4Shipments"
		tbl.canSee = function()
			local count = 0

			for k, v in pairs(CustomShipments) do
				local buyable, visible = hook.Call("CanBuyShipment", Eris, v)
				if(!buyable && !visible) then continue end
				count = count + 1
			end

			return count != 0
		end
	elseif(tbl.ammo) then
		tbl.panel = "ErisF4Ammo"
		tbl.canSee = function()
			-- return #GAMEMODE.AmmoTypes > 0
			local gm = GM or GAMEMODE
			local count = 0

			for k, v in ipairs(gm.AmmoTypes or {}) do
				local buyable, visible = hook.Call("CanBuyAmmo", Eris, v)
				if(!buyable && !visible) then continue end
				count = count + 1
			end
			return count != 0
		end
	elseif(tbl.entities) then
		tbl.panel = "ErisF4Entities"
		tbl.canSee = function()
			local count = 0

			for k, v in pairs(DarkRPEntities || {}) do
				local buyable, visible = hook.Call("CanBuyEntity", Eris, v)
				if(!buyable && !visible) then continue end
				count = count + 1
			end

			return count != 0
		end
	elseif(tbl.vehicles) then
		tbl.panel = "ErisF4Vehicles"
		tbl.canSee = function()
			local count = 0
			for k, v in pairs(CustomVehicles || {}) do
				local buyable, visible = hook.Call("CanBuyVehicle", Eris, v)
				if(!buyable && !visible) then continue end
				count = count + 1
			end

			return count != 0
		end
	elseif(tbl.dashboard) then
		tbl.func = function(pnl) pnl:OpenDashboard() end
	end

	tbl.name = name
	table.insert(Eris.Tabs, tbl)
end

function Eris:AddDivider(...)
	local tabs = {...}

	table.insert(Eris.Tabs, {
		divider = true,
		canSee = function()
			local count = 0

			for k, v in pairs(tabs) do
				for _, tab in pairs(Eris.Tabs) do
					if(tab.name == v) then
						if(tab && tab.canSee && !tab.canSee()) then continue end
						count = count + 1
						break
					end
				end
			end

			return #tabs == 0 || count != 0
		end
	})
end


/*---------------------------------------------------------------------------
	Command functionality
---------------------------------------------------------------------------*/
function Eris:AddCommand(name, tbl)
	if(tbl.dropmoney) then
		tbl.func = function()
			Eris:StringRequest(
				"Drop Money",
				"How much money would you like to drop?",
				LocalPlayer():getDarkRPVar("money"),
				function(str)
					local num = tonumber(str)
					if(!num) then Eris:Notify("Please enter a valid number.") return end
					RunConsoleCommand("darkrp", "dropmoney", num)
				end,
				"Drop"
			)
		end
	elseif(tbl.dropweapon) then
		tbl.func = function() RunConsoleCommand("darkrp", "dropweapon") end
	elseif(tbl.changename) then
		tbl.func = function()
			Eris:StringRequest(
				"Изменение имени",
				"Какое имя вы хотите?",
				LocalPlayer():Nick(),
				function(str)
					RunConsoleCommand("darkrp", "rpname", str)
				end,
				"Изменить имя"
			)
		end
	elseif(tbl.changejob) then
		tbl.visible = function() return GAMEMODE.Config.customjobs end
		tbl.func = function()
			Eris:StringRequest(
				"Job Change",
				"What would you like your new job name to be?",
				LocalPlayer():getDarkRPVar("job"),
				function(str)
					RunConsoleCommand("darkrp", "job", str)
				end,
				"Change Job"
			)
		end
	elseif(tbl.sleep) then
		tbl.visible = function() return !DarkRP.disabledDefaults.modules.sleep end
		tbl.func = function() RunConsoleCommand("darkrp", "sleep") end
	elseif(tbl.requestlicense) then
		tbl.visible = function() return !GAMEMODE.Config.noguns && !LocalPlayer():getDarkRPVar("license") end
		tbl.func = function() RunConsoleCommand("darkrp", "requestlicense") end
	elseif(tbl.advert) then
		tbl.func = function()
			Eris:StringRequest(
				"Объявление",
				"Введите текст объявления?",
				LocalPlayer():getDarkRPVar("job"),
				function(str)
					RunConsoleCommand("darkrp", "advert", str)
				end,
				"Объявление"
			)
		end
	elseif(tbl.wanted) then
		tbl.visible = function() return LocalPlayer():isCP() end
		tbl.func = function()
			Eris:StringRequest(
				"Want Someone",
				"Enter the name of the person whom will be wanted.",
				"",
				function(str)
					RunConsoleCommand("darkrp", "wanted", str, "Wanted")
				end,
				"Want"
			)
		end
	elseif(tbl.warrant) then
		tbl.visible = function() return LocalPlayer():isCP() end
		tbl.func = function()
			Eris:StringRequest(
				"Request a Search Warrant",
				"Enter the name of the person whom you want to issue a warrant to.",
				"",
				function(str)
					RunConsoleCommand("darkrp", "warrant", str, "Warrant")
				end,
				"Request"
			)
		end
	elseif(tbl.lockdown) then
		tbl.visible = function() return LocalPlayer():isMayor() end
		tbl.func = function() RunConsoleCommand("darkrp", (netvars.GetNetVar("RP_Lockdown")&&"un"||"").."lockdown") end
	elseif(tbl.lawboard) then
		tbl.visible = function() return LocalPlayer():isMayor() end
		tbl.func = function() RunConsoleCommand("darkrp", "placelaws") end
	end

	tbl.name = name
	table.insert(Eris.Commands, tbl)
end


/*---------------------------------------------------------------------------
	Themes
---------------------------------------------------------------------------*/
function Eris:AddTheme(name, tbl, allowed)
	tbl.allowed = allowed

	Eris.Themes = Eris.Themes || {}
	Eris.Themes[name] = tbl
end

function Eris:SetTheme(name)
	if(!Eris.Config.ThemesEnabled) then return end
	Eris.Config.Theme = name
end


/*---------------------------------------------------------------------------
	Hooking the menu into DarkRP
---------------------------------------------------------------------------*/
local f4
timer.Simple(0, function()
	function DarkRP.openF4Menu()
		DarkRP.f4 = vgui.Create("ErisF4")
	end

	function DarkRP.closeF4Menu()
		if(IsValid(DarkRP.f4)) then DarkRP.f4:CloseAnim() end
	end

	function DarkRP.toggleF4Menu()
		DarkRP[(IsValid(DarkRP.f4)&&"close"||"open").."F4Menu"]()
	end

	GAMEMODE.ShowSpare2 = DarkRP.toggleF4Menu
end)


/*---------------------------------------------------------------------------
	Changing the money value in the F4 menu when the money is changed
---------------------------------------------------------------------------*/
hook.Add("DarkRPVarChanged", "ErisUpdateMoney", function(ply, varname, oldValue, newValue)
	if(ply == LocalPlayer() && varname == "money" && oldValue != newValue && IsValid(DarkRP.f4) && IsValid(DarkRP.f4.Money)) then
		DarkRP.f4.Money:SetText(DarkRP.formatMoney(newValue))
	end
end)