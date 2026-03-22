UAnim = UAnim or {}
local styles = {
	{
		{
			act = ACT_HL2MP_IDLE,
			name = "Стандарт"
		},
		{
			act = ACT_HL2MP_IDLE_COWER,
			name = "Укрывается от бомбёжки"
		},
		{
			act = ACT_HL2MP_IDLE_ANGRY,
			name = "Злой"
		},
		{
			act = ACT_HL2MP_IDLE_SCARED,
			name = "Напуган"
		},
		{
			act = ACT_HL2MP_IDLE_ZOMBIE,
			name = "Зомби"
		},
		{
			act = ACT_GMOD_SHOWOFF_STAND_01,
			name = "Перекрещивает руки"
		},
		{
			act = ACT_GMOD_SHOWOFF_STAND_02,
			name = "Руки на бока"
		},
		{
			act = ACT_GMOD_SHOWOFF_STAND_03,
			name = "Представляет что-то левой рукой"
		},
		{
			act = ACT_GMOD_SHOWOFF_STAND_04,
			name = "Большие пальцы вверх"
		}
	},
	{
		{
			act = ACT_HL2MP_WALK,
			name = "Стандарт"
		},
		{
			act = ACT_HL2MP_RUN,
			name = "Пробежка"
		},
		{
			act = ACT_HL2MP_RUN_FAST,
			name = "Быстрая ходьба"
		},
		{
			act = ACT_HL2MP_RUN_CHARGING,
			name = "Попытка прорваться"
		},
		{
			act = ACT_HL2MP_RUN_PANICKED,
			name = "Паника"
		},
		{
			act = ACT_HL2MP_RUN_PROTECTED,
			name = "Защита головы"
		}
	},
	{
		{
			act = ACT_HL2MP_RUN,
			name = "Стандарт"
		},
		{
			act = ACT_HL2MP_RUN_FAST,
			name = "Быстрая ходьба"
		},
		{
			act = ACT_HL2MP_RUN_CHARGING,
			name = "Попытка прорваться"
		},
		{
			act = ACT_HL2MP_RUN_PANICKED,
			name = "Паника"
		},
		{
			act = ACT_HL2MP_RUN_PROTECTED,
			name = "Защита головы"
		}
	},
	{
		{
			act = ACT_HL2MP_IDLE_CROUCH,
			name = "Стандарт"
		},
		{
			act = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
			name = "Зомби"
		},
		{
			act = ACT_GMOD_SHOWOFF_DUCK_01,
			name = "На колено"
		},
		{
			act = ACT_GMOD_SHOWOFF_DUCK_02,
			name = "Поза лотоса"
		}
	}
}

UAnim.Styles = styles
UAnim.StyleNames = {"Стойка", "Ходьба", "Бег", "Сидя"}
local act_to_netvar = {
	[ACT_MP_STAND_IDLE] = "style.idle",
	[ACT_MP_WALK] = "style.walk",
	[ACT_MP_RUN] = "style.run",
	[ACT_MP_CROUCH_IDLE] = "style.crouch"
}
UAnim.ActToNetVar = act_to_netvar

local act_to_style = {
	[ACT_MP_STAND_IDLE] = 1,
	[ACT_MP_WALK] = 2,
	[ACT_MP_RUN] = 3,
	[ACT_MP_CROUCH_IDLE] = 4
}
UAnim.ActToStyle = act_to_style

local id_to_netvar = {}
for k, v in pairs(act_to_netvar) do
	local id = act_to_style[k]
	id_to_netvar[id] = v
end
UAnim.IdToNetVar = id_to_netvar

if CLIENT then
	local function GetAct(ply, act)
		local nv, style = act_to_netvar[act], act_to_style[act]
		if not nv or not style then return end

		local override_id, style_list = ply:GetNetVar(nv), styles[style]
		if not override_id or not style_list then return end

		local new_act = style_list[override_id]
		if not new_act then return end
		return new_act.act
	end

	local b
	timer.Simple(5, function()
		local w = weapons.Get("weapon_base")
		b = w.TranslateActivity
	end)

	hook.Add("TranslateActivity", "Animations.Replace", function(ply, act)
		if ply:IsHandcuffed() or ply.animationIndex or ply:IsPlayingTaunt() then return end

		local weap = ply:GetActiveWeapon()
		if IsValid(weap) and weap:GetHoldType() ~= "normal" or weap.TranslateActivity and weap.TranslateActivity ~= b then return end

		local cur = GetAct(ply, act)
		if cur then return cur end
	end)
else
	netstream.Hook("SetStyle", function(ply, cat, id)
		if not isnumber(id) or not isnumber(cat) then return end
		local nv, style = id_to_netvar[cat], styles[cat]
		if not nv or not style then return end
		if not style[id] then return end

		ply:SetNetVar(nv, id)
	end)
end
