-- Partners Stuff --

PARTNERS = {}
ACTIVEPARTNERS = {}

--require("abilities")
--ability = abilities.GetStored("Invisibility")
--PrintTable(ability)
-- Partner/Team Management
function GetPartner(ply, partnersTbl)
	if partnersTbl == {} then return nil end
	for i = 1, table.Count(partnersTbl) do
		for j = 1, table.Count(partnersTbl[i]) do
			if (partnersTbl[i][j] == ply) then
				if j == 1 then
					return partnersTbl[i][2]
				else
					return partnersTbl[i][1]
				end
			end
		end
	end
	return nil
end

function ResetPartners()
	table.Empty(PARTNERS)
	net.Start("PartnerData")
		net.WriteTable(PARTNERS)
	net.Broadcast()
end

-- Random Partner Match
function CreateRandomPartner(playerTbl)
	if (playerTbl.isEmpty) then return end -- we have no players
	-- Index-Tbl for Randomizer
	PartnersTbl = {}
	local indexTbl = {}
	local removeTbl = {}

	for i = 1, #playerTbl do
		if (playerTbl[i]:Team() == 2 or playerTbl[i]:Team() == 3) then
			table.Add(removeTbl, i)
		else
			indexTbl[i] = i
		end
	end

	for i = 1, #removeTbl do
		table.remove(playerTbl, removeTbl[i])
	end

	local pIndex = 1
	for i = 1, table.Count(playerTbl) do
		if (playerTbl[i]:Team() == 1) then
			--net.Start("TargetPartnerRemove")
			--	net.WriteBit(true)
			--net.Send(playerTbl[i])
		end

		if (playerTbl[i]:Team() ~= 2 and playerTbl[i]:Team() ~= 3) then -- TODO: Check if not Seeker and Spectator!
            -- Random unused number
            local randomNumber = 0
            local randomize = true
            while (randomize) do
                randomNumber = math.random(#playerTbl)
                if (indexTbl[randomNumber] ~= 0) then
                    indexTbl[randomNumber] = 0
                    randomize = false
                end
			end

            if (pIndex == 1) then
                local partner = {
                    [1] = playerTbl[randomNumber],
                    [2] = nil,
                }
                table.insert(PartnersTbl, partner)
                pIndex = 0
            else
                local key = table.GetLastKey(PartnersTbl)
                PartnersTbl[key][2] = playerTbl[randomNumber]
                pIndex = 1
            end
		else
			indexTbl[i] = 0
			-- Discord
			-- if (playerTbl[i]:Team() == 2) then
			-- 	changeVoice(playerTbl[i], "700487069201465404")
			-- end
		end
	end
	for i = 1, table.Count(PartnersTbl) do
		for j = 1, table.Count(PartnersTbl[i]) do
			if (j == 1) then
				if (PartnersTbl[i][2]) then
					PartnersTbl[i][j]:PrintMessage(
						HUD_PRINTTALK, "Du bist mit " .. PartnersTbl[i][2]:Name().. " in einem Team!"
					)
				end
			else
				PartnersTbl[i][j]:PrintMessage(
						HUD_PRINTTALK, "Du bist mit " .. PartnersTbl[i][1]:Name() .. " in einem Team!"
				)
			end
		end
	end
	net.Start("PartnerData")
    	net.WriteTable(PartnersTbl)
	net.Broadcast()
	--changeVoiceList(PartnersTbl)
	PrintTable(PartnersTbl)
    return PartnersTbl
end



function removeFromPartner(ply)
	for i = 1, #ACTIVEPARTNERS do
		for j = 1, #ACTIVEPARTNERS[i] do
			if ACTIVEPARTNERS[i][j] == ply then
				ACTIVEPARTNERS[i][j] = nil
				if j == 1 then
					ACTIVEPARTNERS[i][2] = nil
				else
					ACTIVEPARTNERS[i][1] = nil
				end
				-- Let Client know that the partner has been removed TODO
				net.Start("PartnerData")
					net.WriteTable(ACTIVEPARTNERS)
				net.Broadcast()

				net.Start("TargetPartnerRemove")
					net.WriteBit(true)
				net.Send(ply)
				-- Discord
				-- if (ply:Team() == 3) then
				-- 	changeVoice(ply, "700487069201465404") -- Go back to Lobby when spectating
				-- else 
				-- 	changeVoice(ply, "700487069201465404") -- Team 1 (Seeker Channel)
				-- end
			end
		end
	end
end
