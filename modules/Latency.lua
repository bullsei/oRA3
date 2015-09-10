
-- Latency is requested/transmitted when opening the list.
-- This module is a display wrapper for LibLatency.

local addonName, scope = ...
local oRA = scope.addon
local util = oRA.util
local module = oRA:NewModule("Latency")
local L = scope.locale
local LL = LibStub("LibLatency")

local latency = {}

function module:OnRegister()
	oRA:RegisterList(
		L.latency,
		latency,
		L.name,
		L.home,
		L.world
	)
	oRA.RegisterCallback(self, "OnShutdown")
	oRA.RegisterCallback(self, "OnListSelected")
	oRA.RegisterCallback(self, "OnGroupChanged")

	SLASH_ORALATENCY1 = "/ralag"
	SLASH_ORALATENCY2 = "/ralatency"
	SlashCmdList.ORALATENCY = function()
		oRA:OpenToList(L.latency)
	end
end

function module:OnGroupChanged()
	oRA:UpdateList(L.latency)
end

function module:OnShutdown()
	wipe(latency)
end

function module:OnListSelected(event, list)
	if list == L.latency then
		LL:RequestLatency()
	end
end

do
	local function update(latencyHome, latencyWorld, player, channel)
		if channel == "GUILD" then return end

		local k = util.inTable(latency, player, 1)
		if not k then
			k = #latency + 1
			latency[k] = { player }
		end
		latency[k][2] = latencyHome
		latency[k][3] = latencyWorld

		oRA:UpdateList(L.latency)
	end
	LL:Register(module, update)
end

