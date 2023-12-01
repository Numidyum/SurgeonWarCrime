
NTSPU = {} -- Neurotrauma Surgery Plus
NTSPU.Name="Surgery Plus Ultra"
NTSPU.Version = "A1.2.7"
NTSPU.VersionNum = 01020400
NTSPU.MinNTVersion = "A1.7.12"
NTSPU.MinNTVersionNum = 01071200
NTSPU.Path = table.pack(...)[1]
Timer.Wait(function() if NTC ~= nil and NTC.RegisterExpansion ~= nil then NTC.RegisterExpansion(NTSPU) end end,1)

-- server-side code (also run in singleplayer)
if (Game.IsMultiplayer and SERVER) or not Game.IsMultiplayer then
    Timer.Wait(function()
        if NTC == nil then
            print("Error loading NT Surgery Plus: It appears Neurotrauma isn't loaded!")
            return
        end

        dofile(NTSPU.Path.."/Lua/Scripts/humanupdate.lua")
        dofile(NTSPU.Path.."/Lua/Scripts/items.lua")

        NTC.AddPreHumanUpdateHook(NTSPU.PreUpdateHuman)
        NTC.AddHumanUpdateHook(NTSPU.PostUpdateHuman)
    end,1)

end


TagsToAdd = {"id_medic", "id_medical", "id_medicaldoctor", "med"}

-- Version and expansion display
Timer.Wait(function() Timer.Wait(function()
    local runstring = "\n/// Running NT Surgery Access Fix V "..Version.." ///\n"

    local linelength = string.len(runstring)+4
    local i = 0
    while i < linelength do runstring=runstring.."-" i=i+1 end

    print(runstring)
end,1) end,1)

function upgradeIDCard (instance, ptable)
    item = instance.item
    if item.HasTag("jobid:surgeon") then
        updated = false

		-- Has to be added before to preserve the job identification
        if not item.HasTag("jobid:medicaldoctor") then
            item.Tags = "jobid:medicaldoctor," .. item.Tags 
            updated = true
        end
		
		for i in TagsToAdd do
			if not item.HasTag(i) then
				item.AddTag(i)
				updated = true
			end
		end

        if updated and SERVER then
			Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(item.SerializableProperties[Identifier("Tags")], item))
        end
    end
end

-- jobid:surgeon
--id_medicaldoctor or jobid:medicaldoctor or id_medic
Hook.Patch("Barotrauma.Items.Components.IdCard", "OnItemLoaded", upgradeIDCard, Hook.HookMethodType.After)

Hook.Patch("Barotrauma.Items.Components.IdCard", "Initialize", upgradeIDCard, Hook.HookMethodType.After)