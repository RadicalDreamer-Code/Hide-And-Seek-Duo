DeriveGamemode("hideandseek")

local targetPartner = nil
local Partners = {}

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
-- Cooldown
-- Useable/?MateNotInRange?/Used/Active

-- net.Receive("abilityData", abilityPlayerData)

local abilityPlayerData = {}
abilityPlayerData["name"] = "Invisibility"
abilityPlayerData["state"] = 0
abilityPlayerData["time"] = ""
abilityPlayerData[""] = ""



function PaintHUD()
    -- Ability Display
    if abilityPlayerData == nil then return end

    draw.RoundedBox(1, ScrW() - 210, ScrH() - 50, 200, 40, Color( 0, 0, 0, 200 ))
    draw.RoundedBox(1, ScrW() - 206, ScrH() - 46, 192, 32, Color(200, 0, 0, 200))


    draw.DrawText(tostring(LocalPlayer():Health()), "DermaDefault", 105, ScrH() - 35, color_white, 0)
    draw.DrawText(abilityPlayerData["name"], "DermaDefault", ScrW() - 140, ScrH() - 40, Color(255,255,255,255), 0)
end



net.Receive("PartnerData", GotTable)

function RemoveTargetPartner()
    print("targetPartner removed")
    targetPartner = nil
end
net.Receive("TargetPartnerRemove", RemoveTargetPartner)

hook.Add("HUDPaint", "HUDForDuo", function()
    -- Duo shit --
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


    -- Draw Ability-Icons
end)