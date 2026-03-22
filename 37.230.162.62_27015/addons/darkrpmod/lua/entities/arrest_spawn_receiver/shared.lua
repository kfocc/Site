ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Монитор спавнера"
ENT.Author = ""
ENT.Category = "Заключенные"

ENT.Spawnable = true
ENT.AdminSpawnable = true

local recipes = arrestSystem.recipes
if SERVER then
	function ENT:SetCurrentQuest(id)
		if not recipes[id] then return end
		self.currentQuest = id
		self:SetNetVar("currentQuest", id)
	end

	function ENT:SetCurrentNeeds(args)
		if not args then
			self:SetNetVar("currentNeeds", nil)
			table.Empty(self.currentNeeds)
			return
		end

		self:SetNetVar("currentNeeds", args)
	end

	function ENT:SetWorking(bool)
		self:SetNetVar("isWorking", bool)
	end

	function ENT:SetReadyToWorking(bool)
		self:SetNetVar("readyToWorking", bool)
	end
end

function ENT:GetCurrentQuest()
	return self:GetNetVar("currentQuest", 0)
end

function ENT:GetCurrentRecipe()
	local currentQuest = self:GetCurrentQuest()
	return recipes[currentQuest]
end

function ENT:GetCurrentNeeds()
	return self:GetNetVar("currentNeeds", {})
end

function ENT:IsWorking()
	return self:GetNetVar("isWorking", false)
end

function ENT:IsReadyToWorking()
	return self:GetNetVar("readyToWorking", false)
end
