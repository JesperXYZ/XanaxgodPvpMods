local _, XPM = ...
local Main = XPM.Main

local Module = Main:NewModule("MuteArenaDialog", "AceHook-3.0", "AceEvent-3.0")

function Module:OnEnable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:OnDisable()
    self:CheckConditions()
    Main:ReinitializeOptionsMenu()
end

function Module:GetDescription()
    return "This module mutes NPC dialog upon entering an arena and subsequently unmutes it upon leaving. This only affects the audio, not the text bubble."
end

function Module:GetName()
    return "Mute Arena Dialog"
end

function Module:GetOptions(myOptionsTable, db)
    self.db = db
    local defaults = {}
    for key, value in pairs(defaults) do
        if self.db[key] == nil then
            self.db[key] = value
        end
    end

    local counter = CreateCounter(5)

    local MuteArenaDialogImage =
    "|TInterface\\Addons\\XanaxgodPvpMods\\media\\moduleImages\\MuteArenaDialog:282:494:3:-1|t"

    myOptionsTable.args.empty7513 = {
        order = counter(),
        type = "description",
        name = " ",
        width = "full"
    }
    myOptionsTable.args.art98 = {
        order = counter(),
        type = "description",
        name = "" .. MuteArenaDialogImage,
        width = "full"
    }

    return myOptionsTable
end

function Module:SetupUI()
    if self:IsEnabled() then
        self:RegisterEvent("GROUP_ROSTER_UPDATE", "MuteDialog")
        self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "MuteDialog")
    end
end

function Module:MuteDialog()
    local currentValue
    if self:IsPlayerInPvPZone() then
        currentValue = GetCVar("Sound_EnableDialog")
        if currentValue == "1" then
            SetCVar("Sound_EnableDialog", 0)
        end
    else
        currentValue = GetCVar("Sound_EnableDialog")
        if currentValue == "0" then
            SetCVar("Sound_EnableDialog", 1)
        end
    end
end

function Module:RefreshUI()
    if self:IsEnabled() then
        self:Disable()
        self:Enable()
    end
end

function Module:CheckConditions()
    self:SetupUI()
end

function Module:IsPlayerInPvPZone()
    local zoneType = select(2, IsInInstance())
    -- Check if the player is in a PvP instance.
    if zoneType == "arena" or zoneType == "pvp" then
        return true
    else
        return false
    end
end

function Module:IsAvailableForCurrentVersion()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        return true -- retail
    elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
        return false -- cata
    elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        return false -- vanilla
    end
end
