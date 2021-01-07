DeriveGamemode("hideandseek")

local targetPartner = nil
local Partners = {}
local abilityId = nil

function GotTable(len, Player)
    print("Incoming")
    Partners = net.ReadTable() -- Prints the order server side
    -- Duo Marker
    local me = LocalPlayer()
    local found = false
    -- Check partner
    if Partners then
        for i = 1, #Partners do
            for j = 1, #Partners[i] do
                if Partners[i][j] == me then
                    found = true
                    abilityId = Partners[i]["ability"]
                    if j == 1 then
                        targetPartner = Partners[i][2]
                    else
                        targetPartner = Partners[i][1]
                    end
                end
            end
        end

        if not found then
            targetPartner = nil
        end
    else
        targetPartner = nil
        print("Du hast kein Partner")
    end
    --
end

-- Ability Name
ABILITY_STATE_READY = 0
ABILITY_STATE_ACTIVE = 1
ABILITY_STATE_USED = 2

local AbilityTbl = {
    [1] = {
        ["id"] = 0,
        ["name"] = "Invisibilty",
        ["duration"] = 15,
        ["cooldown"] = 120,
    },
    [2] = {
        ["id"] = 1,
        ["name"] = "Prop Transformation",
        ["duration"] = 15,
        ["cooldown"] = 120,
    },
    [3] = {
        ["id"] = 2,
        ["name"] = "Fake Runner",
        ["duration"] = 15,
        ["cooldown"] = 120,
    },
}

local abilityState = ABILITY_STATE_READY

function setAbilityState(len, play)
    print("Wuuuuuh")
    abilityState = net.ReadInt(4)
end
net.Receive("AbilityState", setAbilityState)

function PaintHUD()
    if Partners == nil or targetPartner == nil then return end

    -- TODO: Make bigger
    draw.DrawText("Your buddy is: "..targetPartner:Name(), "DermaDefault", ScrW() - 210, ScrH() - 90, Color(255,255,255,255), TEXT_ALIGN_LEFT)

    -- Ability Display

    draw.RoundedBox(1, ScrW() - 210, ScrH() - 50, 200, 40, Color( 0, 0, 0, 200))

    if abilityState == ABILITY_STATE_READY then
        draw.RoundedBox(1, ScrW() - 206, ScrH() - 46, 192, 32, Color(0, 200, 0, 200))
    end

    if abilityState == ABILITY_STATE_ACTIVE then
        draw.RoundedBox(1, ScrW() - 206, ScrH() - 46, 192, 32, Color(200, 200, 0, 200))
    end

    if abilityState == ABILITY_STATE_USED then
        draw.RoundedBox(1, ScrW() - 206, ScrH() - 46, 192, 32, Color(200, 0, 0, 200))
    end

    if abilityId == nil then return end

    --draw.DrawText(AbilityTbl[abilityId]["name"], "DermaDefault", ScrW() - 140, ScrH() - 38, Color(255,255,255,255), 0)
end

net.Receive("PartnerData", GotTable)

function RemoveTargetPartner()
    print("targetPartner removed")
    targetPartner = nil
end
net.Receive("TargetPartnerRemove", RemoveTargetPartner)

hook.Add("HUDPaint", "HUDForDuo", function()
    -- Mark Partner with name
    if targetPartner then
        local Position = ( targetPartner:GetPos() + Vector( 0,0,80 ) ):ToScreen()
        draw.DrawText(
            targetPartner:Name(),
            "DermaDefault",
            Position.x,
            Position.y,
            Color( 255, 255, 255, 255 ),
            1
        )
    end

    PaintHUD()
    -- TODO: Draw Ability-Icons
end)