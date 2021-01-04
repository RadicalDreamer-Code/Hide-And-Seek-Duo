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
end)