-- Contains all abilities

TeamAbilityTbl = {}

local enableabilties = CreateConVar("has_enableabilities",
                "1",
                {FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE},
                "Allows ablities")


function GoInvisible(ply, distance)
    if distance < 110 then
        local inv = Color(0, 0, 0, 3)
        local plyColor = ply:GetColor()
        for i = 1, #invisibleTbl do
            if player.GetByID(i) == ply and not invisibleTbl[i] then
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
            if player.GetByID(i) == partner and not invisibleTbl[i] then
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

function GoProp(ply, distance)
    ply:PrintMessage(HUD_PRINTTALK, "Foo")
end

function SetInvisibleTbl(Players)
    for i = 1, #Players do
        invisibleTbl[i] = false
    end
end

function GetInvisibleTblValue(ply)
    for i = 1, #invisibleTbl do

    end
end

function ExecuteAbility(ply, distance)
    local ability = 0 -- Invisibility (TODO: Make multiple of these)
    if ability == 0 then
        GoInvisible(ply, distance)
    end
end

hook.Add( "KeyPress", "keypressForAction", function( ply, key )
    if has_enableabilities == 0 then return end -- disable abilities

    -- use a nice switch-case
    local switch = {
        [IN_RELOAD] = function()
            GoProp(ply)
        end,
        [IN_USE] = function()
            -- Distance Calc
            local playerPos = ply:GetPos()
            local partner = GetPartner(ply, ACTIVEPARTNERS)
            if not partner then return end

            local partnerPos = partner:GetPos()
            local distance = math.Distance( playerPos.x, playerPos.y, partnerPos.x, partnerPos.y )

            ExecuteAbility(ply, distance)
        end,
    }

    local action = switch[key]
    if(action) then
        action()
    end
end)