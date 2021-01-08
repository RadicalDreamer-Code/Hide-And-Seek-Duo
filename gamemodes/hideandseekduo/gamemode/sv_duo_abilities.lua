-- Contains all abilities

TeamAbilityTbl = {}
invisibleTbl = {}
print("Incoming Tbl")
PrintTable(PartnersTbl)

ABILITY_STATE_READY = 0
ABILITY_STATE_ACTIVE = 1
ABILITY_STATE_USED = 2

local enableabilties = CreateConVar("has_enableabilities",
                "1",
                {FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE,FCVAR_ARCHIVE},
                "Allows ablities")


function GoInvisible(ply, distance, partner)
    if distance < 110 then
        local inv = Color(0, 0, 0, 3)
        local plyColor = ply:GetColor()
        for i = 1, #invisibleTbl do
            if player.GetByID(i) == ply and not invisibleTbl[i] then -- noch nich invis gewesen
                ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
                ply:SetColor(inv)
                ply:EmitSound("AlyxEMP.Charge")
                ply:SetMaterial( "sprites/heatwave" )
                invisibleTbl[i] = true
                ply:PrintMessage(HUD_PRINTTALK, "Du bist für 15 Sekunden unsichtbar")
                -- Send Client Ability State
                net.Start("AbilityState")
                    net.WriteInt(ABILITY_STATE_ACTIVE, 4)
                net.Send(ply)
                timer.Simple(15, function()
                    ply:SetColor(plyColor)
                    --ply:EmitSound("AlyxEMP.Charge")
                    ply:SetMaterial("models/glass")
                    ply:PrintMessage(HUD_PRINTTALK, "Du bist wieder sichtbar")
                    net.Start("AbilityState")
                        net.WriteInt(ABILITY_STATE_USED, 4)
                    net.Send(ply)
                end)
            end
            if player.GetByID(i) == partner and not invisibleTbl[i] then
                print("Make him/her invis")
                partner:SetRenderMode(RENDERMODE_TRANSCOLOR)
                partner:SetColor(inv)
                partner:SetMaterial( "sprites/heatwave" )
                invisibleTbl[i] = true
                partner:PrintMessage(HUD_PRINTTALK, "Du bist für 15 Sekunden unsichtbar")
                net.Start("AbilityState")
                    net.WriteInt(ABILITY_STATE_ACTIVE, 4)
                net.Send(partner)
                timer.Simple(16, function()
                    partner:SetColor(plyColor)
                    partner:SetMaterial("models/glass")
                    --partner:EmitSound("AlyxEMP.Charge")
                    partner:PrintMessage(HUD_PRINTTALK, "Du bist wieder sichtbar")
                    net.Start("AbilityState")
                        net.WriteInt(ABILITY_STATE_USED, 4)
                    net.Send(partner)
                end)
            end
        end
    end
end

function GoProp(ply)
    -- TODO: set the person into third person if possible
    ply:PrintMessage(HUD_PRINTTALK, "Foo")
    -- get a random entity and change player to that entity
    local entities = ents.GetAll()
    local entity = entities[math.random(#entities)]
    PrintTable(entities)
    print(entity)
    -- found in "steamapps\common\GarrysMod\garrysmod\settings\spawnlist_default"
    ply:SetModel("models/maxofs2d/button_slider.mdl")
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

function ExecuteAbility(ply, distance, partner)
    local ability = 0 -- Invisibility (TODO: Make multiple of these)
    if ability == 0 then
        GoInvisible(ply, distance, partner)
    end
end

hook.Add( "KeyPress", "keypressForAction", function( ply, key )
    if has_enableabilities == 0 then return end -- disable abilities

    -- use a nice switch-case
    local switch = {
        [IN_RELOAD] = function()
            --GoProp(ply)
        end,
        [IN_USE] = function()
            -- Distance Calc
            local playerPos = ply:GetPos()
            local partner = GetPartner(ply, ACTIVEPARTNERS)
            if not partner then return end

            local partnerPos = partner:GetPos()
            local distance = math.Distance( playerPos.x, playerPos.y, partnerPos.x, partnerPos.y )

            ExecuteAbility(ply, distance, partner)
        end,
    }

    local action = switch[key]
    if(action) then
        action()
    end
end)