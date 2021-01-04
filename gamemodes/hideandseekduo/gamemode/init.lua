DeriveGamemode("hideandseek")
include("sv_partners.lua") -- PARTNERS, ACTIVEPARTNERS
include("sv_duo_abilities.lua")

local activeRoundCounter = 0

-- wat?
local hook = hook
local util = util
local net = net
local CreateConVar = CreateConVar

local roundsuntilrandomize = CreateConVar("has_roundsuntilrandomize",
				"1",
				{FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE},
				"Sets amount of rounds until the teams will be randomized")

local partnermatching = CreateConVar("has_partnermatching",
				"0",
				{FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE},
				"Makes partner-less players match to a new duo")

if not ConVarExists("has_allowsbonds") then
	CreateConVar("has_allowsbonds",
				"0",
				{FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE},
				"Allows bond between two players.")
end

-- Pool network names
util.AddNetworkString("PartnerData")
util.AddNetworkString("TargetPartnerRemove")



-- Mark Partner

-- TODO: Leaderboard for duo-teams
-- TODO: Ingame-Voice restriction to duo
-- TODO: if two hiders are partner-less, make them love | random ability select
-- TODO: bond request?

-- Abilites
-- Invisibility for 15 secs
-- glue seeker for 10 secs
-- blink for short distance
-- prop-Verwandlung for 20 secs
-- zombie-attack
-- smoke, flash
-- infinite sprint
-- fake person -> puff in konfetti


-- Seeker Abilities
-- Uncover area in meters (show in UI how far it can reach)
-- Grappling hook
-- Speed boost (the more seekers are close the faster they become)
-- Ren, if hiders move in a certain distance, the seeker will be notified that someone is there
-- stun-bat primary weapon of the first seeker



hook.Add("HASRoundStarted", "Duo_Round_Started", function()
	-- round check for randomize
	activeRoundCounter = activeRoundCounter + 1
	if activeRoundCounter >= roundsuntilrandomize:GetInt() then
		activeRoundCounter = 0
		PARTNERS = createRandomPartner(player.GetAll())
		ACTIVEPARTNERS = PARTNERS
	else
		ACTIVEPARTNERS = PARTNERS
	end
	--setInvisibleTbl(player.GetAll())
	
end)


hook.Add("HASPlayerCaught", "duo_player_caught", function(seeker, entply)
	removeFromPartner(entply)
end)

hook.Add("PlayerDeath", "duo_player_dead", function(victim, inflictor, attacker)
	-- TODO: remove any status effects 
	removeFromPartner(victim)
end)

hook.Add("HASGameEnded", "duo_game_ended", function(winner)
	-- TODO: remove any status effects 
	-- Reset Partners
end)

-- hook.Call("HASPlayerCaught",GAMEMODE,sekr,entply)
-- removeFromPartner(entply)
-- local scont = hook.Call("HASGameEnded",GAMEMODE,winner) (returns true)

