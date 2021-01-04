-- Contains all abilities

local enableabilties = CreateConVar("has_enableabilities",
				"1",
				{FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE},
				"Allows ablities")


function goInvisible(ply, distance)
	if distance < 110 then
		inv = Color(0, 0, 0, 3)
		plyColor = ply:GetColor()
		for i = 1, #invisibleTbl do
			if player.GetByID(i) == ply && !invisibleTbl[i] then
				ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
				ply:SetColor(inv)
				ply:EmitSound("AlyxEMP.Charge")
				ply:SetMaterial( "sprites/heatwave" )
				invisibleTbl[i] = true
				ply:PrintMessage(HUD_PRINTTALK, "Du bist für 15 Sekunden unsichtbar")
				timer.Simple(15, function()
					ply:SetColor(plyColor)
					--ply:EmitSound("AlyxEMP.Charge")
					ply:SetMaterial("models/glass")
					ply:PrintMessage(HUD_PRINTTALK, "Du bist wieder sichtbar")
				end)
			end
			if player.GetByID(i) == partner && !invisibleTbl[i] then
				partner:SetRenderMode(RENDERMODE_TRANSCOLOR)
				partner:SetColor(inv)
				partner:SetMaterial( "sprites/heatwave" )
				invisibleTbl[i] = true
				partner:PrintMessage(HUD_PRINTTALK, "Du bist für 15 Sekunden unsichtbar")
				timer.Simple(15, function()
					partner:SetColor(plyColor)
					--partner:EmitSound("AlyxEMP.Charge")
					partner:PrintMessage(HUD_PRINTTALK, "Du bist wieder sichtbar")
					partner:SetMaterial("models/glass")
				end)
			end
		end
	end
end

function goProp(ply, distance)
	ply:PrintMessage(HUD_PRINTTALK, "Foo")
end

function setInvisibleTbl(Players)
	for i = 1, #Players do
		invisibleTbl[i] = false
	end
end

function getInvisibleTblValue(ply)
	for i = 1, #invisibleTbl do

	end
end



function executeAbility(ply, distance)
	ability = 0 -- Invisibility (TODO: Make multiple of these)
	if ability == 0 then
		goInvisible(ply, distance)
	end
end

local requiredDistance = 150
local invisibleTime = 15
function goInvisible(ply, distance)
	if !ply then return end -- Nothing happens
	if distance > requiredDistance then return end -- Maybe UI-Feedback?
	for i = 1, #invisibleTbl do
	end

	partner = getPartner(ply, Partners)
	timer.Simple(invisibleTime, function()

	end)
end


hook.Add( "KeyPress", "keypressForAction", function( ply, key )
	if has_enableabilities == 0 then return end -- disable abilities

	-- use a nice switch-case
	local switch = {
		[IN_RELOAD] = function()
			goProp(ply)
		end,
		[IN_USE] = function()
			-- Distance Calc
			playerPos = ply:GetPos()
			partner = getPartner(ply, ACTIVEPARTNERS)
			if !partner then return end

			partnerPos = partner:GetPos()
			distance = math.Distance( playerPos.x, playerPos.y, partnerPos.x, partnerPos.y )

			executeAbility(ply, distance)
		end,
	}
	
	local action = switch[key]
	if(action) then
		action()
	end
end)