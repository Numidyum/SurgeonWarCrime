
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